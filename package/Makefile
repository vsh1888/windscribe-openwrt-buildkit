include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-windscribe-bootstrap
PKG_VERSION:=0.3.1
PKG_RELEASE:=1
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-windscribe-bootstrap
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=Windscribe OpenWrt bootstrap diagnostics (not a VPN client)
  DEPENDS:=+luci-base
  PKGARCH:=all
endef

define Package/luci-app-windscribe-bootstrap/description
Safe read-only diagnostics page for preparing a future Windscribe-compatible OpenWrt client.
This package does not authenticate to Windscribe and does not create VPN tunnels.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./files/. $(PKG_BUILD_DIR)/
endef

define Build/Compile
endef

define Package/luci-app-windscribe-bootstrap/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/usr/bin/windscribe-preflight $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/usr/lib/lua/luci/controller/windscribe_bootstrap.lua $(1)/usr/lib/lua/luci/controller/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/windscribe_bootstrap
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/usr/lib/lua/luci/view/windscribe_bootstrap/index.htm $(1)/usr/lib/lua/luci/view/windscribe_bootstrap/
	$(INSTALL_DIR) $(1)/usr/share/windscribe-bootstrap
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/usr/share/windscribe-bootstrap/STATUS.txt $(1)/usr/share/windscribe-bootstrap/
endef

$(eval $(call BuildPackage,luci-app-windscribe-bootstrap))
