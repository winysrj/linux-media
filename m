Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:38652 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751193AbeEEP1Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 5 May 2018 11:27:16 -0400
Date: Sat, 05 May 2018 23:26:26 +0800
From: kbuild test robot <lkp@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [linuxtv-media:master] BUILD REGRESSION
 8d718e5376c602dfd41b599dcc2a7b1be07c7b6b
Message-ID: <5aedcd22.jgrcf6N8h5x6iArh%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree/branch: git://linuxtv.org/media_tree.git  master
branch HEAD: 8d718e5376c602dfd41b599dcc2a7b1be07c7b6b  media: frontends: fix ops get_algo()'s return type

Regressions in current branch:

drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:183:21: error: 'omapdss_default_get_resolution' undeclared here (not in a function); did you mean 'omapdss_get_version'?
drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:197:7: error: implicit declaration of function 'omap_dss_find_output'; did you mean 'omap_dss_get_overlay'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:219:7: error: implicit declaration of function 'omapdss_of_find_source_for_first_ep' [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:264:6: error: implicit declaration of function 'omapdss_register_display'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:282:2: error: implicit declaration of function 'omapdss_unregister_display'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:57:6: error: implicit declaration of function 'omapdss_device_is_connected' [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:91:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:232:20: error: 'omapdss_default_get_resolution' undeclared here (not in a function); did you mean 'omapdss_get_version'?
drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:246:7: error: implicit declaration of function 'omapdss_of_find_source_for_first_ep' [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:297:6: error: implicit declaration of function 'omapdss_register_display'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:319:2: error: implicit declaration of function 'omapdss_unregister_display'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:59:6: error: implicit declaration of function 'omapdss_device_is_connected' [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:89:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:200:21: error: 'omapdss_default_get_resolution' undeclared here (not in a function); did you mean 'omapdss_get_version'?
drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:222:7: error: implicit declaration of function 'omapdss_of_find_source_for_first_ep' [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:269:6: error: implicit declaration of function 'omapdss_register_display'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:287:2: error: implicit declaration of function 'omapdss_unregister_display'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:60:6: error: implicit declaration of function 'omapdss_device_is_connected' [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:94:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:210:7: error: implicit declaration of function 'omapdss_of_find_source_for_first_ep' [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:225:6: error: implicit declaration of function 'omapdss_register_output'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:243:2: error: implicit declaration of function 'omapdss_unregister_output'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:45:6: error: implicit declaration of function 'omapdss_device_is_connected' [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:91:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:184:7: error: implicit declaration of function 'omapdss_of_find_source_for_first_ep' [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:233:6: error: implicit declaration of function 'omapdss_register_output'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:252:2: error: implicit declaration of function 'omapdss_unregister_output'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:39:6: error: implicit declaration of function 'omapdss_device_is_connected' [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:81:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/encoder-tpd12s015.c:208:7: error: implicit declaration of function 'omapdss_of_find_source_for_first_ep' [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/encoder-tpd12s015.c:272:6: error: implicit declaration of function 'omapdss_register_output'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/encoder-tpd12s015.c:291:2: error: implicit declaration of function 'omapdss_unregister_output'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/encoder-tpd12s015.c:293:10: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/encoder-tpd12s015.c:297:10: error: implicit declaration of function 'omapdss_device_is_connected' [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:154:20: error: 'omapdss_default_get_resolution' undeclared here (not in a function); did you mean 'omapdss_get_version'?
drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:167:7: error: implicit declaration of function 'omap_dss_find_output'; did you mean 'omap_dss_get_overlay'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:179:2: error: implicit declaration of function 'videomode_to_omap_video_timings'; did you mean 'videomode_from_timings'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:227:7: error: implicit declaration of function 'omapdss_of_find_source_for_first_ep' [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:277:6: error: implicit declaration of function 'omapdss_register_display'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:297:2: error: implicit declaration of function 'omapdss_unregister_display'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:45:6: error: implicit declaration of function 'omapdss_device_is_connected' [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:75:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:1119:25: error: 'omapdss_default_get_recommended_bpp' undeclared here (not in a function)
drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:1149:7: error: implicit declaration of function 'omapdss_of_find_source_for_first_ep' [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:1202:6: error: implicit declaration of function 'omapdss_register_display'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:1293:2: error: implicit declaration of function 'omapdss_unregister_display'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:715:6: error: implicit declaration of function 'omapdss_device_is_connected' [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:772:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:126:6: error: implicit declaration of function 'omapdss_device_is_connected' [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:158:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:239:20: error: 'omapdss_default_get_resolution' undeclared here (not in a function); did you mean 'omapdss_get_version'?
drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:259:7: error: implicit declaration of function 'omapdss_of_find_source_for_first_ep' [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:308:6: error: implicit declaration of function 'omapdss_register_display'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:328:2: error: implicit declaration of function 'omapdss_unregister_display'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c:126:6: error: implicit declaration of function 'omapdss_device_is_connected' [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c:156:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c:231:20: error: 'omapdss_default_get_resolution' undeclared here (not in a function); did you mean 'omapdss_get_version'?
drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c:252:7: error: implicit declaration of function 'omapdss_of_find_source_for_first_ep' [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c:320:6: error: implicit declaration of function 'omapdss_register_display'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c:342:2: error: implicit declaration of function 'omapdss_unregister_display'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:196:20: error: 'omapdss_default_get_resolution' undeclared here (not in a function); did you mean 'omapdss_get_version'?
drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:252:7: error: implicit declaration of function 'omapdss_of_find_source_for_first_ep' [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:292:6: error: implicit declaration of function 'omapdss_register_display'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:311:2: error: implicit declaration of function 'omapdss_unregister_display'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:67:6: error: implicit declaration of function 'omapdss_device_is_connected' [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:97:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:522:6: error: implicit declaration of function 'omapdss_device_is_connected' [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:634:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:704:20: error: 'omapdss_default_get_resolution' undeclared here (not in a function); did you mean 'omapdss_get_version'?
drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:717:7: error: implicit declaration of function 'omap_dss_find_output'; did you mean 'omap_dss_get_overlay'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:740:14: error: implicit declaration of function 'omapdss_of_find_source_for_first_ep' [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:857:6: error: implicit declaration of function 'omapdss_register_display'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:887:2: error: implicit declaration of function 'omapdss_unregister_display'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c:175:6: error: implicit declaration of function 'omapdss_device_is_connected' [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c:205:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c:373:7: error: implicit declaration of function 'omapdss_of_find_source_for_first_ep' [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c:426:6: error: implicit declaration of function 'omapdss_register_display'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c:447:2: error: implicit declaration of function 'omapdss_unregister_display'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c:346:6: error: implicit declaration of function 'omapdss_device_is_connected' [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c:376:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c:463:20: error: 'omapdss_default_get_resolution' undeclared here (not in a function); did you mean 'omapdss_get_version'?
drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c:481:7: error: implicit declaration of function 'omapdss_of_find_source_for_first_ep' [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c:559:6: error: implicit declaration of function 'omapdss_register_display'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c:584:2: error: implicit declaration of function 'omapdss_unregister_display'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev//omap2/omapfb/dss/apply.c:141:23: error: implicit declaration of function 'dss_feat_get_num_ovls'; did you mean 'dss_feat_get_reg_field'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/apply.c:141:23: error: implicit declaration of function 'dss_feat_get_num_ovls'; did you mean 'dss_feat_get_reg_field'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/apply.c:1598:5: error: redefinition of 'omapdss_compat_init'
drivers/video/fbdev/omap2/omapfb/dss/apply.c:1682:6: error: redefinition of 'omapdss_compat_uninit'
drivers/video/fbdev//omap2/omapfb/dss/apply.c:264:23: error: implicit declaration of function 'dss_feat_get_num_mgrs'; did you mean 'dss_feat_get_param_max'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/apply.c:264:23: error: implicit declaration of function 'dss_feat_get_num_mgrs'; did you mean 'dss_feat_get_param_max'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/core.c:59:22: error: redefinition of 'omapdss_get_version'
drivers/video/fbdev/omap2/omapfb/dss/dispc.c:320:18: error: implicit declaration of function 'dss_feat_get_num_mgrs'; did you mean 'dss_feat_get_param_max'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/dispc.c:342:18: error: implicit declaration of function 'dss_feat_get_num_ovls'; did you mean 'dss_feat_get_reg_field'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/dispc-compat.c:105:6: error: implicit declaration of function 'dss_feat_get_num_ovls'; did you mean 'dss_feat_get_reg_field'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/dispc-compat.c:149:5: error: redefinition of 'omap_dispc_register_isr'
drivers/video/fbdev/omap2/omapfb/dss/dispc-compat.c:203:5: error: redefinition of 'omap_dispc_unregister_isr'
drivers/video/fbdev/omap2/omapfb/dss/display.c:186:25: error: redefinition of 'omap_dss_get_device'
drivers/video/fbdev/omap2/omapfb/dss/display.c:200:6: error: redefinition of 'omap_dss_put_device'
drivers/video/fbdev/omap2/omapfb/dss/display.c:211:25: error: redefinition of 'omap_dss_get_next_device'
drivers/video/fbdev/omap2/omapfb/dss/display-sysfs.c:41:4: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/dpi.c:680:6: error: implicit declaration of function 'omapdss_output_set_device'; did you mean 'omap_dss_put_device'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/dpi.c:699:2: error: implicit declaration of function 'omapdss_output_unset_device'; did you mean 'omap_dss_get_next_device'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/dpi.c:732:2: error: implicit declaration of function 'omapdss_register_output'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev//omap2/omapfb/dss/dpi.c:740:2: error: implicit declaration of function 'omapdss_unregister_output'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/dpi.c:740:2: error: implicit declaration of function 'omapdss_unregister_output'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/dpi.c:860:7: error: implicit declaration of function 'omapdss_of_get_next_endpoint'; did you mean 'omap_dss_get_next_device'? [-Werror=implicit-function-declaration]
drivers/video/fbdev//omap2/omapfb/dss/dsi.c:437:8: error: implicit declaration of function 'omap_dss_get_output'; did you mean 'omap_dss_get_overlay'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/dsi.c:437:8: error: implicit declaration of function 'omap_dss_get_output'; did you mean 'omap_dss_get_overlay'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/dsi.c:4991:6: error: implicit declaration of function 'omapdss_output_set_device'; did you mean 'omap_dss_put_device'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/dsi.c:5010:2: error: implicit declaration of function 'omapdss_output_unset_device'; did you mean 'omap_dss_get_next_device'? [-Werror=implicit-function-declaration]
drivers/video/fbdev//omap2/omapfb/dss/dsi.c:5070:2: error: implicit declaration of function 'omapdss_register_output'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/dsi.c:5070:2: error: implicit declaration of function 'omapdss_register_output'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev//omap2/omapfb/dss/dsi.c:5078:2: error: implicit declaration of function 'omapdss_unregister_output'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/dsi.c:5078:2: error: implicit declaration of function 'omapdss_unregister_output'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev//omap2/omapfb/dss/dsi.c:5092:7: error: implicit declaration of function 'omapdss_of_get_first_endpoint'; did you mean 'omapdss_get_version'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/dsi.c:5092:7: error: implicit declaration of function 'omapdss_of_get_first_endpoint'; did you mean 'omapdss_get_version'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/dss.c:118:6: error: redefinition of 'omapdss_is_initialized'
drivers/video/fbdev/omap2/omapfb/dss/dss.c:935:9: error: implicit declaration of function 'omapdss_of_get_next_port'; did you mean 'omap_dss_get_next_device'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/dss-of.c:178:8: error: implicit declaration of function 'omap_dss_find_output_by_port_node' [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c:441:6: error: implicit declaration of function 'omapdss_output_set_device'; did you mean 'omap_dss_put_device'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c:460:2: error: implicit declaration of function 'omapdss_output_unset_device'; did you mean 'omap_dss_get_next_device'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c:530:2: error: implicit declaration of function 'omapdss_register_output'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c:537:2: error: implicit declaration of function 'omapdss_unregister_output'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c:546:7: error: implicit declaration of function 'omapdss_of_get_first_endpoint'; did you mean 'omapdss_get_version'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c:471:6: error: implicit declaration of function 'omapdss_output_set_device'; did you mean 'omap_dss_put_device'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c:490:2: error: implicit declaration of function 'omapdss_output_unset_device'; did you mean 'omap_dss_get_next_device'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c:560:2: error: implicit declaration of function 'omapdss_register_output'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c:567:2: error: implicit declaration of function 'omapdss_unregister_output'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c:576:7: error: implicit declaration of function 'omapdss_of_get_first_endpoint'; did you mean 'omapdss_get_version'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/manager.c:116:5: error: redefinition of 'omap_dss_get_num_overlay_managers'
drivers/video/fbdev/omap2/omapfb/dss/manager.c:122:30: error: redefinition of 'omap_dss_get_overlay_manager'
drivers/video/fbdev/omap2/omapfb/dss/manager.c:43:17: error: implicit declaration of function 'dss_feat_get_num_mgrs'; did you mean 'dss_feat_get_param_max'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/manager-sysfs.c:66:12: error: implicit declaration of function 'omap_dss_find_device'; did you mean 'omap_dss_put_device'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/manager-sysfs.c:75:7: error: implicit declaration of function 'omapdss_device_is_connected' [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/manager-sysfs.c:81:7: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
drivers/video/fbdev//omap2/omapfb/dss/overlay.c:41:5: error: redefinition of 'omap_dss_get_num_overlays'
drivers/video/fbdev/omap2/omapfb/dss/overlay.c:41:5: error: redefinition of 'omap_dss_get_num_overlays'
drivers/video/fbdev//omap2/omapfb/dss/overlay.c:47:22: error: redefinition of 'omap_dss_get_overlay'
drivers/video/fbdev/omap2/omapfb/dss/overlay.c:47:22: error: redefinition of 'omap_dss_get_overlay'
drivers/video/fbdev//omap2/omapfb/dss/overlay.c:60:17: error: implicit declaration of function 'dss_feat_get_num_ovls'; did you mean 'dss_feat_get_reg_field'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/overlay.c:60:17: error: implicit declaration of function 'dss_feat_get_num_ovls'; did you mean 'dss_feat_get_reg_field'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/overlay.c:91:4: error: implicit declaration of function 'dss_feat_get_supported_color_modes'; did you mean 'dss_feat_get_supported_outputs'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/sdi.c:298:6: error: implicit declaration of function 'omapdss_output_set_device'; did you mean 'omap_dss_put_device'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/sdi.c:317:2: error: implicit declaration of function 'omapdss_output_unset_device'; did you mean 'omap_dss_get_next_device'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/sdi.c:351:2: error: implicit declaration of function 'omapdss_register_output'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev//omap2/omapfb/dss/sdi.c:358:2: error: implicit declaration of function 'omapdss_unregister_output'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/sdi.c:358:2: error: implicit declaration of function 'omapdss_unregister_output'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev//omap2/omapfb/dss/sdi.c:420:7: error: implicit declaration of function 'omapdss_of_get_next_endpoint'; did you mean 'omap_dss_get_next_device'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/sdi.c:420:7: error: implicit declaration of function 'omapdss_of_get_next_endpoint'; did you mean 'omap_dss_get_next_device'? [-Werror=implicit-function-declaration]
drivers/video/fbdev//omap2/omapfb/dss/venc.c:748:6: error: implicit declaration of function 'omapdss_output_set_device'; did you mean 'omap_dss_put_device'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/venc.c:748:6: error: implicit declaration of function 'omapdss_output_set_device'; did you mean 'omap_dss_put_device'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/venc.c:767:2: error: implicit declaration of function 'omapdss_output_unset_device'; did you mean 'omap_dss_get_next_device'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/venc.c:803:2: error: implicit declaration of function 'omapdss_register_output'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev//omap2/omapfb/dss/venc.c:810:2: error: implicit declaration of function 'omapdss_unregister_output'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/venc.c:810:2: error: implicit declaration of function 'omapdss_unregister_output'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/dss/venc.c:820:7: error: implicit declaration of function 'omapdss_of_get_first_endpoint'; did you mean 'omapdss_get_version'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/omapfb-ioctl.c:782:9: error: implicit declaration of function 'omapdss_find_mgr_from_display' [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/omapfb-main.c:2396:8: error: implicit declaration of function 'omapdss_find_mgr_from_display'; did you mean 'omapfb_init_display'? [-Werror=implicit-function-declaration]
drivers/video/fbdev/omap2/omapfb/omapfb-main.c:2430:13: error: implicit declaration of function 'omapdss_get_default_display_name'; did you mean 'omapfb_find_default_display'? [-Werror=implicit-function-declaration]

Error ids grouped by kconfigs:

recent_errors
├── arm64-allmodconfig
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-analog-tv.c:error:implicit-declaration-of-function-omapdss_device_is_connected
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-analog-tv.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-analog-tv.c:error:implicit-declaration-of-function-omap_dss_find_output-did-you-mean-omap_dss_get_overlay
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-analog-tv.c:error:implicit-declaration-of-function-omapdss_of_find_source_for_first_ep
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-analog-tv.c:error:implicit-declaration-of-function-omapdss_register_display-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-analog-tv.c:error:implicit-declaration-of-function-omapdss_unregister_display-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-analog-tv.c:error:omapdss_default_get_resolution-undeclared-here-(not-in-a-function)-did-you-mean-omapdss_get_version
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-dvi.c:error:implicit-declaration-of-function-omapdss_device_is_connected
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-dvi.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-dvi.c:error:implicit-declaration-of-function-omapdss_of_find_source_for_first_ep
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-dvi.c:error:implicit-declaration-of-function-omapdss_register_display-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-dvi.c:error:implicit-declaration-of-function-omapdss_unregister_display-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-dvi.c:error:omapdss_default_get_resolution-undeclared-here-(not-in-a-function)-did-you-mean-omapdss_get_version
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-hdmi.c:error:implicit-declaration-of-function-omapdss_device_is_connected
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-hdmi.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-hdmi.c:error:implicit-declaration-of-function-omapdss_of_find_source_for_first_ep
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-hdmi.c:error:implicit-declaration-of-function-omapdss_register_display-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-hdmi.c:error:implicit-declaration-of-function-omapdss_unregister_display-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-hdmi.c:error:omapdss_default_get_resolution-undeclared-here-(not-in-a-function)-did-you-mean-omapdss_get_version
│   ├── drivers-video-fbdev-omap2-omapfb-displays-encoder-opa362.c:error:implicit-declaration-of-function-omapdss_device_is_connected
│   ├── drivers-video-fbdev-omap2-omapfb-displays-encoder-opa362.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-displays-encoder-opa362.c:error:implicit-declaration-of-function-omapdss_of_find_source_for_first_ep
│   ├── drivers-video-fbdev-omap2-omapfb-displays-encoder-opa362.c:error:implicit-declaration-of-function-omapdss_register_output-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-encoder-opa362.c:error:implicit-declaration-of-function-omapdss_unregister_output-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-encoder-tfp410.c:error:implicit-declaration-of-function-omapdss_device_is_connected
│   ├── drivers-video-fbdev-omap2-omapfb-displays-encoder-tfp410.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-displays-encoder-tfp410.c:error:implicit-declaration-of-function-omapdss_of_find_source_for_first_ep
│   ├── drivers-video-fbdev-omap2-omapfb-displays-encoder-tfp410.c:error:implicit-declaration-of-function-omapdss_register_output-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-encoder-tfp410.c:error:implicit-declaration-of-function-omapdss_unregister_output-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-encoder-tpd12s015.c:error:implicit-declaration-of-function-omapdss_device_is_connected
│   ├── drivers-video-fbdev-omap2-omapfb-displays-encoder-tpd12s015.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-displays-encoder-tpd12s015.c:error:implicit-declaration-of-function-omapdss_of_find_source_for_first_ep
│   ├── drivers-video-fbdev-omap2-omapfb-displays-encoder-tpd12s015.c:error:implicit-declaration-of-function-omapdss_register_output-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-encoder-tpd12s015.c:error:implicit-declaration-of-function-omapdss_unregister_output-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-dpi.c:error:implicit-declaration-of-function-omapdss_device_is_connected
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-dpi.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-dpi.c:error:implicit-declaration-of-function-omap_dss_find_output-did-you-mean-omap_dss_get_overlay
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-dpi.c:error:implicit-declaration-of-function-omapdss_of_find_source_for_first_ep
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-dpi.c:error:implicit-declaration-of-function-omapdss_register_display-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-dpi.c:error:implicit-declaration-of-function-omapdss_unregister_display-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-dpi.c:error:implicit-declaration-of-function-videomode_to_omap_video_timings-did-you-mean-videomode_from_timings
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-dpi.c:error:omapdss_default_get_resolution-undeclared-here-(not-in-a-function)-did-you-mean-omapdss_get_version
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-dsi-cm.c:error:implicit-declaration-of-function-omapdss_device_is_connected
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-dsi-cm.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-dsi-cm.c:error:implicit-declaration-of-function-omapdss_of_find_source_for_first_ep
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-dsi-cm.c:error:implicit-declaration-of-function-omapdss_register_display-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-dsi-cm.c:error:implicit-declaration-of-function-omapdss_unregister_display-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-dsi-cm.c:error:omapdss_default_get_recommended_bpp-undeclared-here-(not-in-a-function)
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-lgphilips-lb035q02.c:error:implicit-declaration-of-function-omapdss_device_is_connected
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-lgphilips-lb035q02.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-lgphilips-lb035q02.c:error:implicit-declaration-of-function-omapdss_of_find_source_for_first_ep
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-lgphilips-lb035q02.c:error:implicit-declaration-of-function-omapdss_register_display-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-lgphilips-lb035q02.c:error:implicit-declaration-of-function-omapdss_unregister_display-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-lgphilips-lb035q02.c:error:omapdss_default_get_resolution-undeclared-here-(not-in-a-function)-did-you-mean-omapdss_get_version
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-nec-nl8048hl11.c:error:implicit-declaration-of-function-omapdss_device_is_connected
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-nec-nl8048hl11.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-nec-nl8048hl11.c:error:implicit-declaration-of-function-omapdss_of_find_source_for_first_ep
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-nec-nl8048hl11.c:error:implicit-declaration-of-function-omapdss_register_display-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-nec-nl8048hl11.c:error:implicit-declaration-of-function-omapdss_unregister_display-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-nec-nl8048hl11.c:error:omapdss_default_get_resolution-undeclared-here-(not-in-a-function)-did-you-mean-omapdss_get_version
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-sharp-ls037v7dw01.c:error:implicit-declaration-of-function-omapdss_device_is_connected
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-sharp-ls037v7dw01.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-sharp-ls037v7dw01.c:error:implicit-declaration-of-function-omapdss_of_find_source_for_first_ep
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-sharp-ls037v7dw01.c:error:implicit-declaration-of-function-omapdss_register_display-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-sharp-ls037v7dw01.c:error:implicit-declaration-of-function-omapdss_unregister_display-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-sharp-ls037v7dw01.c:error:omapdss_default_get_resolution-undeclared-here-(not-in-a-function)-did-you-mean-omapdss_get_version
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-sony-acx565akm.c:error:implicit-declaration-of-function-omapdss_device_is_connected
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-sony-acx565akm.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-sony-acx565akm.c:error:implicit-declaration-of-function-omap_dss_find_output-did-you-mean-omap_dss_get_overlay
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-sony-acx565akm.c:error:implicit-declaration-of-function-omapdss_of_find_source_for_first_ep
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-sony-acx565akm.c:error:implicit-declaration-of-function-omapdss_register_display-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-sony-acx565akm.c:error:implicit-declaration-of-function-omapdss_unregister_display-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-sony-acx565akm.c:error:omapdss_default_get_resolution-undeclared-here-(not-in-a-function)-did-you-mean-omapdss_get_version
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-tpo-td028ttec1.c:error:implicit-declaration-of-function-omapdss_device_is_connected
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-tpo-td028ttec1.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-tpo-td028ttec1.c:error:implicit-declaration-of-function-omapdss_of_find_source_for_first_ep
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-tpo-td028ttec1.c:error:implicit-declaration-of-function-omapdss_register_display-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-tpo-td028ttec1.c:error:implicit-declaration-of-function-omapdss_unregister_display-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-tpo-td043mtea1.c:error:implicit-declaration-of-function-omapdss_device_is_connected
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-tpo-td043mtea1.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-tpo-td043mtea1.c:error:implicit-declaration-of-function-omapdss_of_find_source_for_first_ep
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-tpo-td043mtea1.c:error:implicit-declaration-of-function-omapdss_register_display-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-tpo-td043mtea1.c:error:implicit-declaration-of-function-omapdss_unregister_display-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-tpo-td043mtea1.c:error:omapdss_default_get_resolution-undeclared-here-(not-in-a-function)-did-you-mean-omapdss_get_version
│   ├── drivers-video-fbdev-omap2-omapfb-dss-apply.c:error:implicit-declaration-of-function-dss_feat_get_num_mgrs-did-you-mean-dss_feat_get_param_max
│   ├── drivers-video-fbdev-omap2-omapfb-dss-apply.c:error:implicit-declaration-of-function-dss_feat_get_num_ovls-did-you-mean-dss_feat_get_reg_field
│   ├── drivers-video-fbdev-omap2-omapfb-dss-apply.c:error:redefinition-of-omapdss_compat_init
│   ├── drivers-video-fbdev-omap2-omapfb-dss-apply.c:error:redefinition-of-omapdss_compat_uninit
│   ├── drivers-video-fbdev-omap2-omapfb-dss-core.c:error:redefinition-of-omapdss_get_version
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dispc.c:error:implicit-declaration-of-function-dss_feat_get_num_mgrs-did-you-mean-dss_feat_get_param_max
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dispc.c:error:implicit-declaration-of-function-dss_feat_get_num_ovls-did-you-mean-dss_feat_get_reg_field
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dispc-compat.c:error:implicit-declaration-of-function-dss_feat_get_num_ovls-did-you-mean-dss_feat_get_reg_field
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dispc-compat.c:error:redefinition-of-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dispc-compat.c:error:redefinition-of-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-dss-display.c:error:redefinition-of-omap_dss_get_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-display.c:error:redefinition-of-omap_dss_get_next_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-display.c:error:redefinition-of-omap_dss_put_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-display-sysfs.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dpi.c:error:implicit-declaration-of-function-omapdss_of_get_next_endpoint-did-you-mean-omap_dss_get_next_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dpi.c:error:implicit-declaration-of-function-omapdss_output_set_device-did-you-mean-omap_dss_put_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dpi.c:error:implicit-declaration-of-function-omapdss_output_unset_device-did-you-mean-omap_dss_get_next_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dpi.c:error:implicit-declaration-of-function-omapdss_register_output-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dpi.c:error:implicit-declaration-of-function-omapdss_unregister_output-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dsi.c:error:implicit-declaration-of-function-omap_dss_get_output-did-you-mean-omap_dss_get_overlay
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dsi.c:error:implicit-declaration-of-function-omapdss_of_get_first_endpoint-did-you-mean-omapdss_get_version
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dsi.c:error:implicit-declaration-of-function-omapdss_output_set_device-did-you-mean-omap_dss_put_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dsi.c:error:implicit-declaration-of-function-omapdss_output_unset_device-did-you-mean-omap_dss_get_next_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dsi.c:error:implicit-declaration-of-function-omapdss_register_output-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dsi.c:error:implicit-declaration-of-function-omapdss_unregister_output-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dss.c:error:implicit-declaration-of-function-omapdss_of_get_next_port-did-you-mean-omap_dss_get_next_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dss.c:error:redefinition-of-omapdss_is_initialized
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dss-of.c:error:implicit-declaration-of-function-omap_dss_find_output_by_port_node
│   ├── drivers-video-fbdev-omap2-omapfb-dss-hdmi4.c:error:implicit-declaration-of-function-omapdss_of_get_first_endpoint-did-you-mean-omapdss_get_version
│   ├── drivers-video-fbdev-omap2-omapfb-dss-hdmi4.c:error:implicit-declaration-of-function-omapdss_output_set_device-did-you-mean-omap_dss_put_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-hdmi4.c:error:implicit-declaration-of-function-omapdss_output_unset_device-did-you-mean-omap_dss_get_next_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-hdmi4.c:error:implicit-declaration-of-function-omapdss_register_output-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-dss-hdmi4.c:error:implicit-declaration-of-function-omapdss_unregister_output-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-dss-hdmi5.c:error:implicit-declaration-of-function-omapdss_of_get_first_endpoint-did-you-mean-omapdss_get_version
│   ├── drivers-video-fbdev-omap2-omapfb-dss-hdmi5.c:error:implicit-declaration-of-function-omapdss_output_set_device-did-you-mean-omap_dss_put_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-hdmi5.c:error:implicit-declaration-of-function-omapdss_output_unset_device-did-you-mean-omap_dss_get_next_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-hdmi5.c:error:implicit-declaration-of-function-omapdss_register_output-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-dss-hdmi5.c:error:implicit-declaration-of-function-omapdss_unregister_output-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-dss-manager.c:error:implicit-declaration-of-function-dss_feat_get_num_mgrs-did-you-mean-dss_feat_get_param_max
│   ├── drivers-video-fbdev-omap2-omapfb-dss-manager.c:error:redefinition-of-omap_dss_get_num_overlay_managers
│   ├── drivers-video-fbdev-omap2-omapfb-dss-manager.c:error:redefinition-of-omap_dss_get_overlay_manager
│   ├── drivers-video-fbdev-omap2-omapfb-dss-manager-sysfs.c:error:implicit-declaration-of-function-omapdss_device_is_connected
│   ├── drivers-video-fbdev-omap2-omapfb-dss-manager-sysfs.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-dss-manager-sysfs.c:error:implicit-declaration-of-function-omap_dss_find_device-did-you-mean-omap_dss_put_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-overlay.c:error:implicit-declaration-of-function-dss_feat_get_num_ovls-did-you-mean-dss_feat_get_reg_field
│   ├── drivers-video-fbdev-omap2-omapfb-dss-overlay.c:error:implicit-declaration-of-function-dss_feat_get_supported_color_modes-did-you-mean-dss_feat_get_supported_outputs
│   ├── drivers-video-fbdev-omap2-omapfb-dss-overlay.c:error:redefinition-of-omap_dss_get_num_overlays
│   ├── drivers-video-fbdev-omap2-omapfb-dss-overlay.c:error:redefinition-of-omap_dss_get_overlay
│   ├── drivers-video-fbdev-omap2-omapfb-dss-sdi.c:error:implicit-declaration-of-function-omapdss_of_get_next_endpoint-did-you-mean-omap_dss_get_next_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-sdi.c:error:implicit-declaration-of-function-omapdss_output_set_device-did-you-mean-omap_dss_put_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-sdi.c:error:implicit-declaration-of-function-omapdss_output_unset_device-did-you-mean-omap_dss_get_next_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-sdi.c:error:implicit-declaration-of-function-omapdss_register_output-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-dss-sdi.c:error:implicit-declaration-of-function-omapdss_unregister_output-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-dss-venc.c:error:implicit-declaration-of-function-omapdss_of_get_first_endpoint-did-you-mean-omapdss_get_version
│   ├── drivers-video-fbdev-omap2-omapfb-dss-venc.c:error:implicit-declaration-of-function-omapdss_output_set_device-did-you-mean-omap_dss_put_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-venc.c:error:implicit-declaration-of-function-omapdss_output_unset_device-did-you-mean-omap_dss_get_next_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-venc.c:error:implicit-declaration-of-function-omapdss_register_output-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-dss-venc.c:error:implicit-declaration-of-function-omapdss_unregister_output-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-omapfb-ioctl.c:error:implicit-declaration-of-function-omapdss_find_mgr_from_display
│   ├── drivers-video-fbdev-omap2-omapfb-omapfb-main.c:error:implicit-declaration-of-function-omapdss_find_mgr_from_display-did-you-mean-omapfb_init_display
│   └── drivers-video-fbdev-omap2-omapfb-omapfb-main.c:error:implicit-declaration-of-function-omapdss_get_default_display_name-did-you-mean-omapfb_find_default_display
├── i386-allmodconfig
│   ├── drivers-video-fbdev-omap2-omapfb-dss-apply.c:error:implicit-declaration-of-function-dss_feat_get_num_mgrs-did-you-mean-dss_feat_get_param_max
│   ├── drivers-video-fbdev-omap2-omapfb-dss-apply.c:error:implicit-declaration-of-function-dss_feat_get_num_ovls-did-you-mean-dss_feat_get_reg_field
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dpi.c:error:implicit-declaration-of-function-omapdss_unregister_output-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dsi.c:error:implicit-declaration-of-function-omap_dss_get_output-did-you-mean-omap_dss_get_overlay
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dsi.c:error:implicit-declaration-of-function-omapdss_of_get_first_endpoint-did-you-mean-omapdss_get_version
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dsi.c:error:implicit-declaration-of-function-omapdss_register_output-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dsi.c:error:implicit-declaration-of-function-omapdss_unregister_output-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-dss-overlay.c:error:implicit-declaration-of-function-dss_feat_get_num_ovls-did-you-mean-dss_feat_get_reg_field
│   ├── drivers-video-fbdev-omap2-omapfb-dss-overlay.c:error:redefinition-of-omap_dss_get_num_overlays
│   ├── drivers-video-fbdev-omap2-omapfb-dss-overlay.c:error:redefinition-of-omap_dss_get_overlay
│   ├── drivers-video-fbdev-omap2-omapfb-dss-sdi.c:error:implicit-declaration-of-function-omapdss_of_get_next_endpoint-did-you-mean-omap_dss_get_next_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-sdi.c:error:implicit-declaration-of-function-omapdss_unregister_output-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-dss-venc.c:error:implicit-declaration-of-function-omapdss_output_set_device-did-you-mean-omap_dss_put_device
│   └── drivers-video-fbdev-omap2-omapfb-dss-venc.c:error:implicit-declaration-of-function-omapdss_unregister_output-did-you-mean-omap_dispc_unregister_isr
├── ia64-allmodconfig
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-analog-tv.c:error:implicit-declaration-of-function-omapdss_device_is_connected
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-analog-tv.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-analog-tv.c:error:implicit-declaration-of-function-omap_dss_find_output-did-you-mean-omap_dss_get_overlay
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-analog-tv.c:error:implicit-declaration-of-function-omapdss_of_find_source_for_first_ep
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-analog-tv.c:error:implicit-declaration-of-function-omapdss_register_display-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-analog-tv.c:error:implicit-declaration-of-function-omapdss_unregister_display-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-analog-tv.c:error:omapdss_default_get_resolution-undeclared-here-(not-in-a-function)-did-you-mean-omapdss_get_version
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-dvi.c:error:implicit-declaration-of-function-omapdss_device_is_connected
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-dvi.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-dvi.c:error:implicit-declaration-of-function-omapdss_of_find_source_for_first_ep
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-dvi.c:error:implicit-declaration-of-function-omapdss_register_display-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-dvi.c:error:implicit-declaration-of-function-omapdss_unregister_display-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-dvi.c:error:omapdss_default_get_resolution-undeclared-here-(not-in-a-function)-did-you-mean-omapdss_get_version
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-hdmi.c:error:implicit-declaration-of-function-omapdss_device_is_connected
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-hdmi.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-hdmi.c:error:implicit-declaration-of-function-omapdss_of_find_source_for_first_ep
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-hdmi.c:error:implicit-declaration-of-function-omapdss_register_display-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-hdmi.c:error:implicit-declaration-of-function-omapdss_unregister_display-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-connector-hdmi.c:error:omapdss_default_get_resolution-undeclared-here-(not-in-a-function)-did-you-mean-omapdss_get_version
│   ├── drivers-video-fbdev-omap2-omapfb-displays-encoder-opa362.c:error:implicit-declaration-of-function-omapdss_device_is_connected
│   ├── drivers-video-fbdev-omap2-omapfb-displays-encoder-opa362.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-displays-encoder-opa362.c:error:implicit-declaration-of-function-omapdss_of_find_source_for_first_ep
│   ├── drivers-video-fbdev-omap2-omapfb-displays-encoder-opa362.c:error:implicit-declaration-of-function-omapdss_register_output-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-encoder-opa362.c:error:implicit-declaration-of-function-omapdss_unregister_output-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-encoder-tfp410.c:error:implicit-declaration-of-function-omapdss_device_is_connected
│   ├── drivers-video-fbdev-omap2-omapfb-displays-encoder-tfp410.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-displays-encoder-tfp410.c:error:implicit-declaration-of-function-omapdss_of_find_source_for_first_ep
│   ├── drivers-video-fbdev-omap2-omapfb-displays-encoder-tfp410.c:error:implicit-declaration-of-function-omapdss_register_output-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-encoder-tfp410.c:error:implicit-declaration-of-function-omapdss_unregister_output-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-encoder-tpd12s015.c:error:implicit-declaration-of-function-omapdss_device_is_connected
│   ├── drivers-video-fbdev-omap2-omapfb-displays-encoder-tpd12s015.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-displays-encoder-tpd12s015.c:error:implicit-declaration-of-function-omapdss_of_find_source_for_first_ep
│   ├── drivers-video-fbdev-omap2-omapfb-displays-encoder-tpd12s015.c:error:implicit-declaration-of-function-omapdss_register_output-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-encoder-tpd12s015.c:error:implicit-declaration-of-function-omapdss_unregister_output-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-dpi.c:error:implicit-declaration-of-function-omapdss_device_is_connected
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-dpi.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-dpi.c:error:implicit-declaration-of-function-omap_dss_find_output-did-you-mean-omap_dss_get_overlay
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-dpi.c:error:implicit-declaration-of-function-omapdss_of_find_source_for_first_ep
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-dpi.c:error:implicit-declaration-of-function-omapdss_register_display-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-dpi.c:error:implicit-declaration-of-function-omapdss_unregister_display-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-dpi.c:error:implicit-declaration-of-function-videomode_to_omap_video_timings-did-you-mean-videomode_from_timings
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-dpi.c:error:omapdss_default_get_resolution-undeclared-here-(not-in-a-function)-did-you-mean-omapdss_get_version
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-dsi-cm.c:error:implicit-declaration-of-function-omapdss_device_is_connected
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-dsi-cm.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-dsi-cm.c:error:implicit-declaration-of-function-omapdss_of_find_source_for_first_ep
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-dsi-cm.c:error:implicit-declaration-of-function-omapdss_register_display-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-dsi-cm.c:error:implicit-declaration-of-function-omapdss_unregister_display-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-dsi-cm.c:error:omapdss_default_get_recommended_bpp-undeclared-here-(not-in-a-function)
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-lgphilips-lb035q02.c:error:implicit-declaration-of-function-omapdss_device_is_connected
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-lgphilips-lb035q02.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-lgphilips-lb035q02.c:error:implicit-declaration-of-function-omapdss_of_find_source_for_first_ep
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-lgphilips-lb035q02.c:error:implicit-declaration-of-function-omapdss_register_display-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-lgphilips-lb035q02.c:error:implicit-declaration-of-function-omapdss_unregister_display-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-lgphilips-lb035q02.c:error:omapdss_default_get_resolution-undeclared-here-(not-in-a-function)-did-you-mean-omapdss_get_version
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-nec-nl8048hl11.c:error:implicit-declaration-of-function-omapdss_device_is_connected
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-nec-nl8048hl11.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-nec-nl8048hl11.c:error:implicit-declaration-of-function-omapdss_of_find_source_for_first_ep
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-nec-nl8048hl11.c:error:implicit-declaration-of-function-omapdss_register_display-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-nec-nl8048hl11.c:error:implicit-declaration-of-function-omapdss_unregister_display-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-nec-nl8048hl11.c:error:omapdss_default_get_resolution-undeclared-here-(not-in-a-function)-did-you-mean-omapdss_get_version
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-sharp-ls037v7dw01.c:error:implicit-declaration-of-function-omapdss_device_is_connected
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-sharp-ls037v7dw01.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-sharp-ls037v7dw01.c:error:implicit-declaration-of-function-omapdss_of_find_source_for_first_ep
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-sharp-ls037v7dw01.c:error:implicit-declaration-of-function-omapdss_register_display-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-sharp-ls037v7dw01.c:error:implicit-declaration-of-function-omapdss_unregister_display-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-sharp-ls037v7dw01.c:error:omapdss_default_get_resolution-undeclared-here-(not-in-a-function)-did-you-mean-omapdss_get_version
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-sony-acx565akm.c:error:implicit-declaration-of-function-omapdss_device_is_connected
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-sony-acx565akm.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-sony-acx565akm.c:error:implicit-declaration-of-function-omap_dss_find_output-did-you-mean-omap_dss_get_overlay
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-sony-acx565akm.c:error:implicit-declaration-of-function-omapdss_of_find_source_for_first_ep
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-sony-acx565akm.c:error:implicit-declaration-of-function-omapdss_register_display-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-sony-acx565akm.c:error:implicit-declaration-of-function-omapdss_unregister_display-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-sony-acx565akm.c:error:omapdss_default_get_resolution-undeclared-here-(not-in-a-function)-did-you-mean-omapdss_get_version
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-tpo-td028ttec1.c:error:implicit-declaration-of-function-omapdss_device_is_connected
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-tpo-td028ttec1.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-tpo-td028ttec1.c:error:implicit-declaration-of-function-omapdss_of_find_source_for_first_ep
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-tpo-td028ttec1.c:error:implicit-declaration-of-function-omapdss_register_display-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-tpo-td028ttec1.c:error:implicit-declaration-of-function-omapdss_unregister_display-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-tpo-td043mtea1.c:error:implicit-declaration-of-function-omapdss_device_is_connected
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-tpo-td043mtea1.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-tpo-td043mtea1.c:error:implicit-declaration-of-function-omapdss_of_find_source_for_first_ep
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-tpo-td043mtea1.c:error:implicit-declaration-of-function-omapdss_register_display-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-tpo-td043mtea1.c:error:implicit-declaration-of-function-omapdss_unregister_display-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-displays-panel-tpo-td043mtea1.c:error:omapdss_default_get_resolution-undeclared-here-(not-in-a-function)-did-you-mean-omapdss_get_version
│   ├── drivers-video-fbdev-omap2-omapfb-dss-apply.c:error:implicit-declaration-of-function-dss_feat_get_num_mgrs-did-you-mean-dss_feat_get_param_max
│   ├── drivers-video-fbdev-omap2-omapfb-dss-apply.c:error:implicit-declaration-of-function-dss_feat_get_num_ovls-did-you-mean-dss_feat_get_reg_field
│   ├── drivers-video-fbdev-omap2-omapfb-dss-apply.c:error:redefinition-of-omapdss_compat_init
│   ├── drivers-video-fbdev-omap2-omapfb-dss-apply.c:error:redefinition-of-omapdss_compat_uninit
│   ├── drivers-video-fbdev-omap2-omapfb-dss-core.c:error:redefinition-of-omapdss_get_version
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dispc.c:error:implicit-declaration-of-function-dss_feat_get_num_mgrs-did-you-mean-dss_feat_get_param_max
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dispc.c:error:implicit-declaration-of-function-dss_feat_get_num_ovls-did-you-mean-dss_feat_get_reg_field
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dispc-compat.c:error:implicit-declaration-of-function-dss_feat_get_num_ovls-did-you-mean-dss_feat_get_reg_field
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dispc-compat.c:error:redefinition-of-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dispc-compat.c:error:redefinition-of-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-dss-display.c:error:redefinition-of-omap_dss_get_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-display.c:error:redefinition-of-omap_dss_get_next_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-display.c:error:redefinition-of-omap_dss_put_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-display-sysfs.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dpi.c:error:implicit-declaration-of-function-omapdss_of_get_next_endpoint-did-you-mean-omap_dss_get_next_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dpi.c:error:implicit-declaration-of-function-omapdss_output_set_device-did-you-mean-omap_dss_put_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dpi.c:error:implicit-declaration-of-function-omapdss_output_unset_device-did-you-mean-omap_dss_get_next_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dpi.c:error:implicit-declaration-of-function-omapdss_register_output-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dpi.c:error:implicit-declaration-of-function-omapdss_unregister_output-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dsi.c:error:implicit-declaration-of-function-omap_dss_get_output-did-you-mean-omap_dss_get_overlay
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dsi.c:error:implicit-declaration-of-function-omapdss_of_get_first_endpoint-did-you-mean-omapdss_get_version
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dsi.c:error:implicit-declaration-of-function-omapdss_output_set_device-did-you-mean-omap_dss_put_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dsi.c:error:implicit-declaration-of-function-omapdss_output_unset_device-did-you-mean-omap_dss_get_next_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dsi.c:error:implicit-declaration-of-function-omapdss_register_output-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dsi.c:error:implicit-declaration-of-function-omapdss_unregister_output-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dss.c:error:implicit-declaration-of-function-omapdss_of_get_next_port-did-you-mean-omap_dss_get_next_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dss.c:error:redefinition-of-omapdss_is_initialized
│   ├── drivers-video-fbdev-omap2-omapfb-dss-dss-of.c:error:implicit-declaration-of-function-omap_dss_find_output_by_port_node
│   ├── drivers-video-fbdev-omap2-omapfb-dss-hdmi4.c:error:implicit-declaration-of-function-omapdss_of_get_first_endpoint-did-you-mean-omapdss_get_version
│   ├── drivers-video-fbdev-omap2-omapfb-dss-hdmi4.c:error:implicit-declaration-of-function-omapdss_output_set_device-did-you-mean-omap_dss_put_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-hdmi4.c:error:implicit-declaration-of-function-omapdss_output_unset_device-did-you-mean-omap_dss_get_next_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-hdmi4.c:error:implicit-declaration-of-function-omapdss_register_output-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-dss-hdmi4.c:error:implicit-declaration-of-function-omapdss_unregister_output-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-dss-hdmi5.c:error:implicit-declaration-of-function-omapdss_of_get_first_endpoint-did-you-mean-omapdss_get_version
│   ├── drivers-video-fbdev-omap2-omapfb-dss-hdmi5.c:error:implicit-declaration-of-function-omapdss_output_set_device-did-you-mean-omap_dss_put_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-hdmi5.c:error:implicit-declaration-of-function-omapdss_output_unset_device-did-you-mean-omap_dss_get_next_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-hdmi5.c:error:implicit-declaration-of-function-omapdss_register_output-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-dss-hdmi5.c:error:implicit-declaration-of-function-omapdss_unregister_output-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-dss-manager.c:error:implicit-declaration-of-function-dss_feat_get_num_mgrs-did-you-mean-dss_feat_get_param_max
│   ├── drivers-video-fbdev-omap2-omapfb-dss-manager.c:error:redefinition-of-omap_dss_get_num_overlay_managers
│   ├── drivers-video-fbdev-omap2-omapfb-dss-manager.c:error:redefinition-of-omap_dss_get_overlay_manager
│   ├── drivers-video-fbdev-omap2-omapfb-dss-manager-sysfs.c:error:implicit-declaration-of-function-omapdss_device_is_connected
│   ├── drivers-video-fbdev-omap2-omapfb-dss-manager-sysfs.c:error:implicit-declaration-of-function-omapdss_device_is_enabled-did-you-mean-movable_node_is_enabled
│   ├── drivers-video-fbdev-omap2-omapfb-dss-manager-sysfs.c:error:implicit-declaration-of-function-omap_dss_find_device-did-you-mean-omap_dss_put_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-overlay.c:error:implicit-declaration-of-function-dss_feat_get_num_ovls-did-you-mean-dss_feat_get_reg_field
│   ├── drivers-video-fbdev-omap2-omapfb-dss-overlay.c:error:implicit-declaration-of-function-dss_feat_get_supported_color_modes-did-you-mean-dss_feat_get_supported_outputs
│   ├── drivers-video-fbdev-omap2-omapfb-dss-overlay.c:error:redefinition-of-omap_dss_get_num_overlays
│   ├── drivers-video-fbdev-omap2-omapfb-dss-overlay.c:error:redefinition-of-omap_dss_get_overlay
│   ├── drivers-video-fbdev-omap2-omapfb-dss-sdi.c:error:implicit-declaration-of-function-omapdss_of_get_next_endpoint-did-you-mean-omap_dss_get_next_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-sdi.c:error:implicit-declaration-of-function-omapdss_output_set_device-did-you-mean-omap_dss_put_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-sdi.c:error:implicit-declaration-of-function-omapdss_output_unset_device-did-you-mean-omap_dss_get_next_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-sdi.c:error:implicit-declaration-of-function-omapdss_register_output-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-dss-sdi.c:error:implicit-declaration-of-function-omapdss_unregister_output-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-dss-venc.c:error:implicit-declaration-of-function-omapdss_of_get_first_endpoint-did-you-mean-omapdss_get_version
│   ├── drivers-video-fbdev-omap2-omapfb-dss-venc.c:error:implicit-declaration-of-function-omapdss_output_set_device-did-you-mean-omap_dss_put_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-venc.c:error:implicit-declaration-of-function-omapdss_output_unset_device-did-you-mean-omap_dss_get_next_device
│   ├── drivers-video-fbdev-omap2-omapfb-dss-venc.c:error:implicit-declaration-of-function-omapdss_register_output-did-you-mean-omap_dispc_register_isr
│   ├── drivers-video-fbdev-omap2-omapfb-dss-venc.c:error:implicit-declaration-of-function-omapdss_unregister_output-did-you-mean-omap_dispc_unregister_isr
│   ├── drivers-video-fbdev-omap2-omapfb-omapfb-ioctl.c:error:implicit-declaration-of-function-omapdss_find_mgr_from_display
│   ├── drivers-video-fbdev-omap2-omapfb-omapfb-main.c:error:implicit-declaration-of-function-omapdss_find_mgr_from_display-did-you-mean-omapfb_init_display
│   └── drivers-video-fbdev-omap2-omapfb-omapfb-main.c:error:implicit-declaration-of-function-omapdss_get_default_display_name-did-you-mean-omapfb_find_default_display
└── sh-allmodconfig
    ├── drivers-video-fbdev-omap2-omapfb-dss-apply.c:error:implicit-declaration-of-function-dss_feat_get_num_mgrs-did-you-mean-dss_feat_get_param_max
    ├── drivers-video-fbdev-omap2-omapfb-dss-apply.c:error:implicit-declaration-of-function-dss_feat_get_num_ovls-did-you-mean-dss_feat_get_reg_field
    ├── drivers-video-fbdev-omap2-omapfb-dss-dpi.c:error:implicit-declaration-of-function-omapdss_unregister_output-did-you-mean-omap_dispc_unregister_isr
    ├── drivers-video-fbdev-omap2-omapfb-dss-dsi.c:error:implicit-declaration-of-function-omap_dss_get_output-did-you-mean-omap_dss_get_overlay
    ├── drivers-video-fbdev-omap2-omapfb-dss-dsi.c:error:implicit-declaration-of-function-omapdss_of_get_first_endpoint-did-you-mean-omapdss_get_version
    ├── drivers-video-fbdev-omap2-omapfb-dss-dsi.c:error:implicit-declaration-of-function-omapdss_register_output-did-you-mean-omap_dispc_register_isr
    ├── drivers-video-fbdev-omap2-omapfb-dss-dsi.c:error:implicit-declaration-of-function-omapdss_unregister_output-did-you-mean-omap_dispc_unregister_isr
    ├── drivers-video-fbdev-omap2-omapfb-dss-overlay.c:error:implicit-declaration-of-function-dss_feat_get_num_ovls-did-you-mean-dss_feat_get_reg_field
    ├── drivers-video-fbdev-omap2-omapfb-dss-overlay.c:error:redefinition-of-omap_dss_get_num_overlays
    ├── drivers-video-fbdev-omap2-omapfb-dss-overlay.c:error:redefinition-of-omap_dss_get_overlay
    ├── drivers-video-fbdev-omap2-omapfb-dss-sdi.c:error:implicit-declaration-of-function-omapdss_of_get_next_endpoint-did-you-mean-omap_dss_get_next_device
    ├── drivers-video-fbdev-omap2-omapfb-dss-sdi.c:error:implicit-declaration-of-function-omapdss_unregister_output-did-you-mean-omap_dispc_unregister_isr
    ├── drivers-video-fbdev-omap2-omapfb-dss-venc.c:error:implicit-declaration-of-function-omapdss_output_set_device-did-you-mean-omap_dss_put_device
    └── drivers-video-fbdev-omap2-omapfb-dss-venc.c:error:implicit-declaration-of-function-omapdss_unregister_output-did-you-mean-omap_dispc_unregister_isr

elapsed time: 57m

configs tested: 131

alpha                               defconfig
parisc                            allnoconfig
parisc                         b180_defconfig
parisc                        c3000_defconfig
parisc                              defconfig
sh                                allnoconfig
sh                          rsk7269_defconfig
sh                  sh7785lcr_32bit_defconfig
sh                            titan_defconfig
i386                   randconfig-x014-201817
i386                   randconfig-x013-201817
i386                   randconfig-x012-201817
i386                   randconfig-x015-201817
i386                   randconfig-x016-201817
i386                   randconfig-x019-201817
i386                   randconfig-x010-201817
i386                   randconfig-x018-201817
i386                   randconfig-x017-201817
i386                   randconfig-x011-201817
microblaze                      mmu_defconfig
microblaze                    nommu_defconfig
i386                     randconfig-n0-201817
ia64                             alldefconfig
ia64                              allnoconfig
ia64                                defconfig
i386                     randconfig-i0-201817
i386                     randconfig-i1-201817
s390                              allnoconfig
s390                          debug_defconfig
x86_64                 randconfig-x013-201817
x86_64                 randconfig-x014-201817
x86_64                 randconfig-x010-201817
x86_64                 randconfig-x019-201817
x86_64                 randconfig-x015-201817
x86_64                 randconfig-x011-201817
x86_64                 randconfig-x018-201817
x86_64                 randconfig-x016-201817
x86_64                 randconfig-x017-201817
x86_64                 randconfig-x012-201817
arm                              allmodconfig
arm                                      arm5
arm                                     arm67
arm                       imx_v6_v7_defconfig
arm                          ixp4xx_defconfig
arm                        mvebu_v7_defconfig
arm                       omap2plus_defconfig
arm                                    sa1100
arm                                   samsung
arm                                        sh
arm                           tegra_defconfig
arm64                            alldefconfig
i386                   randconfig-a0-05051853
i386                   randconfig-a1-05051853
x86_64                 randconfig-s0-05052304
x86_64                 randconfig-s1-05052304
x86_64                 randconfig-s2-05052304
openrisc                    or1ksim_defconfig
um                             i386_defconfig
um                           x86_64_defconfig
i386                             alldefconfig
i386                              allnoconfig
i386                                defconfig
x86_64                              federa-25
x86_64                                   rhel
x86_64                               rhel-7.2
m68k                       m5475evb_defconfig
m68k                          multi_defconfig
m68k                           sun3_defconfig
i386                     randconfig-s0-201817
i386                     randconfig-s1-201817
x86_64                 randconfig-s3-05052302
x86_64                 randconfig-s4-05052302
x86_64                 randconfig-s5-05052302
i386                               tinyconfig
powerpc                           allnoconfig
powerpc                             defconfig
powerpc                       ppc64_defconfig
s390                        default_defconfig
x86_64                   randconfig-i0-201817
sparc                               defconfig
sparc64                           allnoconfig
sparc64                             defconfig
powerpc                     akebono_defconfig
powerpc                        cell_defconfig
x86_64                randconfig-ne0-05052108
arm                           h5000_defconfig
powerpc                      bamboo_defconfig
mips                           32r2_defconfig
mips                         64r6el_defconfig
mips                              allnoconfig
mips                      fuloong2e_defconfig
mips                                   jz4740
mips                      malta_kvm_defconfig
mips                                     txx9
x86_64                 randconfig-x006-201817
x86_64                 randconfig-x002-201817
x86_64                 randconfig-x005-201817
x86_64                 randconfig-x004-201817
x86_64                 randconfig-x009-201817
x86_64                 randconfig-x001-201817
x86_64                 randconfig-x008-201817
x86_64                 randconfig-x000-201817
x86_64                 randconfig-x007-201817
x86_64                 randconfig-x003-201817
i386                   randconfig-x075-201817
i386                   randconfig-x073-201817
i386                   randconfig-x076-201817
i386                   randconfig-x071-201817
i386                   randconfig-x079-201817
i386                   randconfig-x070-201817
i386                   randconfig-x077-201817
i386                   randconfig-x078-201817
i386                   randconfig-x074-201817
i386                   randconfig-x072-201817
x86_64                             acpi-redef
x86_64                           allyesdebian
x86_64                                nfsroot
powerpc                          alldefconfig
sh                          kfr2r09_defconfig
sh                             sh03_defconfig
i386                   randconfig-x000-201817
i386                   randconfig-x006-201817
i386                   randconfig-x008-201817
i386                   randconfig-x003-201817
i386                   randconfig-x009-201817
i386                   randconfig-x004-201817
i386                   randconfig-x005-201817
i386                   randconfig-x002-201817
i386                   randconfig-x001-201817
i386                   randconfig-x007-201817

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
