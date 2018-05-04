Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46932 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751811AbeEDRF2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 13:05:28 -0400
Date: Sat, 5 May 2018 01:05:00 +0800
From: kbuild test robot <lkp@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org
Subject: [linuxtv-media:master 167/207]
 drivers/video/fbdev/omap2/omapfb/omapfb-main.c:2396:44: sparse: call with no
 type!
Message-ID: <201805050155.wUWNEk6e%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   53dcd70eb710607b2d4085ca91a433cd9feb7b41
commit: 771f7be87ff921e9a3d744febd606af39a150e14 [167/207] media: omapfb: omapfb_dss.h: add stubs to build with COMPILE_TEST && DRM_OMAP
reproduce:
        # apt-get install sparse
        git checkout 771f7be87ff921e9a3d744febd606af39a150e14
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/video/fbdev/omap2/omapfb/omapfb-main.c:1461:32: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/omapfb-main.c:1461:32: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/omapfb-main.c:1924:25: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/omapfb-main.c:1924:25: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/omapfb-main.c:2396:15: sparse: undefined identifier 'omapdss_find_mgr_from_display'
   drivers/video/fbdev/omap2/omapfb/omapfb-main.c:2430:20: sparse: undefined identifier 'omapdss_get_default_display_name'
>> drivers/video/fbdev/omap2/omapfb/omapfb-main.c:2396:44: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/omapfb-main.c:2430:52: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/omapfb-main.c: In function 'omapfb_init_connections':
   drivers/video/fbdev/omap2/omapfb/omapfb-main.c:2396:8: error: implicit declaration of function 'omapdss_find_mgr_from_display'; did you mean 'omapfb_init_display'? [-Werror=implicit-function-declaration]
     mgr = omapdss_find_mgr_from_display(def_dssdev);
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
           omapfb_init_display
   drivers/video/fbdev/omap2/omapfb/omapfb-main.c:2396:6: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     mgr = omapdss_find_mgr_from_display(def_dssdev);
         ^
   drivers/video/fbdev/omap2/omapfb/omapfb-main.c: In function 'omapfb_find_default_display':
   drivers/video/fbdev/omap2/omapfb/omapfb-main.c:2430:13: error: implicit declaration of function 'omapdss_get_default_display_name'; did you mean 'omapfb_find_default_display'? [-Werror=implicit-function-declaration]
     def_name = omapdss_get_default_display_name();
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                omapfb_find_default_display
   drivers/video/fbdev/omap2/omapfb/omapfb-main.c:2430:11: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     def_name = omapdss_get_default_display_name();
              ^
   cc1: some warnings being treated as errors
--
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:45:13: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:66:9: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:67:14: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:88:14: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:91:13: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:115:14: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:210:14: sparse: undefined identifier 'omapdss_of_find_source_for_first_ep'
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:225:13: sparse: undefined identifier 'omapdss_register_output'
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:243:9: sparse: undefined identifier 'omapdss_unregister_output'
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:245:9: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:246:13: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:249:9: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:250:13: sparse: undefined identifier 'omapdss_device_is_connected'
>> drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:45:40: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:66:9: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:67:41: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:88:41: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:91:38: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:115:39: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:210:49: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:225:36: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:243:34: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:245:9: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:246:38: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:249:9: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:250:40: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c: In function 'opa362_connect':
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:45:6: error: implicit declaration of function 'omapdss_device_is_connected' [-Werror=implicit-function-declaration]
     if (omapdss_device_is_connected(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c: In function 'opa362_enable':
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:91:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
     if (omapdss_device_is_enabled(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~
         movable_node_is_enabled
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c: In function 'opa362_probe':
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:210:7: error: implicit declaration of function 'omapdss_of_find_source_for_first_ep' [-Werror=implicit-function-declaration]
     in = omapdss_of_find_source_for_first_ep(node);
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:210:5: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     in = omapdss_of_find_source_for_first_ep(node);
        ^
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:225:6: error: implicit declaration of function 'omapdss_register_output'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
     r = omapdss_register_output(dssdev);
         ^~~~~~~~~~~~~~~~~~~~~~~
         omap_dispc_register_isr
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c: In function 'opa362_remove':
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:243:2: error: implicit declaration of function 'omapdss_unregister_output'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
     omapdss_unregister_output(&ddata->dssdev);
     ^~~~~~~~~~~~~~~~~~~~~~~~~
     omap_dispc_unregister_isr
   cc1: some warnings being treated as errors
--
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:39:13: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:58:9: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:59:14: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:78:14: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:81:13: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:105:14: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:184:14: sparse: undefined identifier 'omapdss_of_find_source_for_first_ep'
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:233:13: sparse: undefined identifier 'omapdss_register_output'
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:252:9: sparse: undefined identifier 'omapdss_unregister_output'
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:254:9: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:255:13: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:258:9: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:259:13: sparse: undefined identifier 'omapdss_device_is_connected'
>> drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:39:40: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:58:9: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:59:41: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:78:41: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:81:38: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:105:39: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:184:49: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:233:36: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:252:34: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:254:9: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:255:38: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:258:9: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:259:40: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c: In function 'tfp410_connect':
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:39:6: error: implicit declaration of function 'omapdss_device_is_connected' [-Werror=implicit-function-declaration]
     if (omapdss_device_is_connected(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c: In function 'tfp410_enable':
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:81:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
     if (omapdss_device_is_enabled(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~
         movable_node_is_enabled
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c: In function 'tfp410_probe_of':
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:184:7: error: implicit declaration of function 'omapdss_of_find_source_for_first_ep' [-Werror=implicit-function-declaration]
     in = omapdss_of_find_source_for_first_ep(node);
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:184:5: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     in = omapdss_of_find_source_for_first_ep(node);
        ^
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c: In function 'tfp410_probe':
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:233:6: error: implicit declaration of function 'omapdss_register_output'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
     r = omapdss_register_output(dssdev);
         ^~~~~~~~~~~~~~~~~~~~~~~
         omap_dispc_register_isr
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c: In function 'tfp410_remove':
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:252:2: error: implicit declaration of function 'omapdss_unregister_output'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
     omapdss_unregister_output(&ddata->dssdev);
     ^~~~~~~~~~~~~~~~~~~~~~~~~
     omap_dispc_unregister_isr
   cc1: some warnings being treated as errors
--
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tpd12s015.c:208:14: sparse: undefined identifier 'omapdss_of_find_source_for_first_ep'
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tpd12s015.c:272:13: sparse: undefined identifier 'omapdss_register_output'
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tpd12s015.c:291:9: sparse: undefined identifier 'omapdss_unregister_output'
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tpd12s015.c:293:9: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tpd12s015.c:294:13: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tpd12s015.c:297:9: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tpd12s015.c:298:13: sparse: undefined identifier 'omapdss_device_is_connected'
>> drivers/video/fbdev/omap2/omapfb/displays/encoder-tpd12s015.c:208:49: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tpd12s015.c:272:36: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tpd12s015.c:291:34: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tpd12s015.c:293:9: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tpd12s015.c:294:38: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tpd12s015.c:297:9: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tpd12s015.c:298:40: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tpd12s015.c: In function 'tpd_probe_of':
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tpd12s015.c:208:7: error: implicit declaration of function 'omapdss_of_find_source_for_first_ep' [-Werror=implicit-function-declaration]
     in = omapdss_of_find_source_for_first_ep(node);
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tpd12s015.c:208:5: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     in = omapdss_of_find_source_for_first_ep(node);
        ^
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tpd12s015.c: In function 'tpd_probe':
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tpd12s015.c:272:6: error: implicit declaration of function 'omapdss_register_output'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
     r = omapdss_register_output(dssdev);
         ^~~~~~~~~~~~~~~~~~~~~~~
         omap_dispc_register_isr
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tpd12s015.c: In function 'tpd_remove':
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tpd12s015.c:291:2: error: implicit declaration of function 'omapdss_unregister_output'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
     omapdss_unregister_output(&ddata->dssdev);
     ^~~~~~~~~~~~~~~~~~~~~~~~~
     omap_dispc_unregister_isr
   In file included from arch/x86/include/asm/bug.h:83:0,
                    from include/linux/bug.h:5,
                    from include/linux/thread_info.h:12,
                    from arch/x86/include/asm/preempt.h:7,
                    from include/linux/preempt.h:81,
                    from include/linux/spinlock.h:51,
                    from include/linux/wait.h:9,
                    from include/linux/completion.h:12,
                    from drivers/video/fbdev/omap2/omapfb/displays/encoder-tpd12s015.c:12:
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tpd12s015.c:293:10: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
     WARN_ON(omapdss_device_is_enabled(dssdev));
             ^
   include/asm-generic/bug.h:112:25: note: in definition of macro 'WARN_ON'
     int __ret_warn_on = !!(condition);    46-                         ^~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tpd12s015.c:297:10: error: implicit declaration of function 'omapdss_device_is_connected' [-Werror=implicit-function-declaration]
     WARN_ON(omapdss_device_is_connected(dssdev));
             ^
   include/asm-generic/bug.h:112:25: note: in definition of macro 'WARN_ON'
     int __ret_warn_on = !!(condition);    52-                         ^~~~~~~~~
   cc1: some warnings being treated as errors
--
   drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:59:13: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:74:14: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:86:14: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:89:13: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:108:14: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:185:13: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:194:21: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:232:27: sparse: undefined identifier 'omapdss_default_get_resolution'
   drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:246:14: sparse: undefined identifier 'omapdss_of_find_source_for_first_ep'
   drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:297:13: sparse: undefined identifier 'omapdss_register_display'
   drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:319:9: sparse: undefined identifier 'omapdss_unregister_display'
>> drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:59:40: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:74:41: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:86:41: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:89:38: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:108:39: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:246:49: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:297:37: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:319:35: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c: In function 'dvic_connect':
   drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:59:6: error: implicit declaration of function 'omapdss_device_is_connected' [-Werror=implicit-function-declaration]
     if (omapdss_device_is_connected(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c: In function 'dvic_enable':
   drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:89:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
     if (omapdss_device_is_enabled(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~
         movable_node_is_enabled
   drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c: At top level:
   drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:232:20: error: 'omapdss_default_get_resolution' undeclared here (not in a function); did you mean 'omapdss_get_version'?
     .get_resolution = omapdss_default_get_resolution,
                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                       omapdss_get_version
   drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c: In function 'dvic_probe_of':
   drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:246:7: error: implicit declaration of function 'omapdss_of_find_source_for_first_ep' [-Werror=implicit-function-declaration]
     in = omapdss_of_find_source_for_first_ep(node);
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:246:5: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     in = omapdss_of_find_source_for_first_ep(node);
        ^
   drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c: In function 'dvic_probe':
   drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:297:6: error: implicit declaration of function 'omapdss_register_display'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
     r = omapdss_register_display(dssdev);
         ^~~~~~~~~~~~~~~~~~~~~~~~
         omap_dispc_register_isr
   drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c: In function 'dvic_remove':
   drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c:319:2: error: implicit declaration of function 'omapdss_unregister_display'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
     omapdss_unregister_display(&ddata->dssdev);
     ^~~~~~~~~~~~~~~~~~~~~~~~~~
     omap_dispc_unregister_isr
   cc1: some warnings being treated as errors
--
   drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:60:13: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:77:14: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:91:14: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:94:13: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:115:14: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:200:35: sparse: undefined identifier 'omapdss_default_get_resolution'
   drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:222:14: sparse: undefined identifier 'omapdss_of_find_source_for_first_ep'
   drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:269:13: sparse: undefined identifier 'omapdss_register_display'
   drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:287:9: sparse: undefined identifier 'omapdss_unregister_display'
>> drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:60:40: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:77:41: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:91:41: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:94:38: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:115:39: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:222:49: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:269:37: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:287:35: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c: In function 'hdmic_connect':
   drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:60:6: error: implicit declaration of function 'omapdss_device_is_connected' [-Werror=implicit-function-declaration]
     if (omapdss_device_is_connected(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c: In function 'hdmic_enable':
   drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:94:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
     if (omapdss_device_is_enabled(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~
         movable_node_is_enabled
   drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c: At top level:
   drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:200:21: error: 'omapdss_default_get_resolution' undeclared here (not in a function); did you mean 'omapdss_get_version'?
     .get_resolution  = omapdss_default_get_resolution,
                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                        omapdss_get_version
   drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c: In function 'hdmic_probe_of':
   drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:222:7: error: implicit declaration of function 'omapdss_of_find_source_for_first_ep' [-Werror=implicit-function-declaration]
     in = omapdss_of_find_source_for_first_ep(node);
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:222:5: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     in = omapdss_of_find_source_for_first_ep(node);
        ^
   drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c: In function 'hdmic_probe':
   drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:269:6: error: implicit declaration of function 'omapdss_register_display'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
     r = omapdss_register_display(dssdev);
         ^~~~~~~~~~~~~~~~~~~~~~~~
         omap_dispc_register_isr
   drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c: In function 'hdmic_remove':
   drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:287:2: error: implicit declaration of function 'omapdss_unregister_display'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
     omapdss_unregister_display(&ddata->dssdev);
     ^~~~~~~~~~~~~~~~~~~~~~~~~~
     omap_dispc_unregister_isr
   cc1: some warnings being treated as errors
--
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:57:13: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:74:14: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:88:14: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:91:13: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:119:14: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:183:35: sparse: undefined identifier 'omapdss_default_get_resolution'
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:197:14: sparse: undefined identifier 'omap_dss_find_output'
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:219:14: sparse: undefined identifier 'omapdss_of_find_source_for_first_ep'
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:264:13: sparse: undefined identifier 'omapdss_register_display'
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:282:9: sparse: undefined identifier 'omapdss_unregister_display'
>> drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:57:40: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:74:41: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:88:41: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:91:38: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:119:39: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:197:34: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:219:49: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:264:37: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:282:35: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c: In function 'tvc_connect':
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:57:6: error: implicit declaration of function 'omapdss_device_is_connected' [-Werror=implicit-function-declaration]
     if (omapdss_device_is_connected(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c: In function 'tvc_enable':
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:91:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
     if (omapdss_device_is_enabled(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~
         movable_node_is_enabled
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c: At top level:
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:183:21: error: 'omapdss_default_get_resolution' undeclared here (not in a function); did you mean 'omapdss_get_version'?
     .get_resolution  = omapdss_default_get_resolution,
                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                        omapdss_get_version
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c: In function 'tvc_probe_pdata':
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:197:7: error: implicit declaration of function 'omap_dss_find_output'; did you mean 'omap_dss_get_overlay'? [-Werror=implicit-function-declaration]
     in = omap_dss_find_output(pdata->source);
          ^~~~~~~~~~~~~~~~~~~~
          omap_dss_get_overlay
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:197:5: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     in = omap_dss_find_output(pdata->source);
        ^
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c: In function 'tvc_probe_of':
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:219:7: error: implicit declaration of function 'omapdss_of_find_source_for_first_ep' [-Werror=implicit-function-declaration]
     in = omapdss_of_find_source_for_first_ep(node);
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:219:5: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     in = omapdss_of_find_source_for_first_ep(node);
        ^
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c: In function 'tvc_probe':
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:264:6: error: implicit declaration of function 'omapdss_register_display'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
     r = omapdss_register_display(dssdev);
         ^~~~~~~~~~~~~~~~~~~~~~~~
         omap_dispc_register_isr
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c: In function 'tvc_remove':
   drivers/video/fbdev/omap2/omapfb/displays/connector-analog-tv.c:282:2: error: implicit declaration of function 'omapdss_unregister_display'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
     omapdss_unregister_display(&ddata->dssdev);
     ^~~~~~~~~~~~~~~~~~~~~~~~~~
     omap_dispc_unregister_isr
   cc1: some warnings being treated as errors
--
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:45:13: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:60:14: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:72:14: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:75:13: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:101:14: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:154:27: sparse: undefined identifier 'omapdss_default_get_resolution'
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:167:14: sparse: undefined identifier 'omap_dss_find_output'
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:179:9: sparse: undefined identifier 'videomode_to_omap_video_timings'
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:225:9: sparse: undefined identifier 'videomode_to_omap_video_timings'
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:227:14: sparse: undefined identifier 'omapdss_of_find_source_for_first_ep'
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:277:13: sparse: undefined identifier 'omapdss_register_display'
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:297:9: sparse: undefined identifier 'omapdss_unregister_display'
>> drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:45:40: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:60:41: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:72:41: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:75:38: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:101:39: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:167:34: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:179:40: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:225:40: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:227:49: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:277:37: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:297:35: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c: In function 'panel_dpi_connect':
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:45:6: error: implicit declaration of function 'omapdss_device_is_connected' [-Werror=implicit-function-declaration]
     if (omapdss_device_is_connected(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c: In function 'panel_dpi_enable':
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:75:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
     if (omapdss_device_is_enabled(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~
         movable_node_is_enabled
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c: At top level:
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:154:20: error: 'omapdss_default_get_resolution' undeclared here (not in a function); did you mean 'omapdss_get_version'?
     .get_resolution = omapdss_default_get_resolution,
                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                       omapdss_get_version
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c: In function 'panel_dpi_probe_pdata':
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:167:7: error: implicit declaration of function 'omap_dss_find_output'; did you mean 'omap_dss_get_overlay'? [-Werror=implicit-function-declaration]
     in = omap_dss_find_output(pdata->source);
          ^~~~~~~~~~~~~~~~~~~~
          omap_dss_get_overlay
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:167:5: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     in = omap_dss_find_output(pdata->source);
        ^
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:179:2: error: implicit declaration of function 'videomode_to_omap_video_timings'; did you mean 'videomode_from_timings'? [-Werror=implicit-function-declaration]
     videomode_to_omap_video_timings(&vm, &ddata->videomode);
     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     videomode_from_timings
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c: In function 'panel_dpi_probe_of':
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:227:7: error: implicit declaration of function 'omapdss_of_find_source_for_first_ep' [-Werror=implicit-function-declaration]
     in = omapdss_of_find_source_for_first_ep(node);
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:227:5: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     in = omapdss_of_find_source_for_first_ep(node);
        ^
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c: In function 'panel_dpi_probe':
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:277:6: error: implicit declaration of function 'omapdss_register_display'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
     r = omapdss_register_display(dssdev);
         ^~~~~~~~~~~~~~~~~~~~~~~~
         omap_dispc_register_isr
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c: In function 'panel_dpi_remove':
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:297:2: error: implicit declaration of function 'omapdss_unregister_display'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
     omapdss_unregister_display(dssdev);
     ^~~~~~~~~~~~~~~~~~~~~~~~~~
     omap_dispc_unregister_isr
   cc1: some warnings being treated as errors
--
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:715:13: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:750:14: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:767:14: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:772:13: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:811:13: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:1024:16: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:1024:16: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:1119:32: sparse: undefined identifier 'omapdss_default_get_recommended_bpp'
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:1149:14: sparse: undefined identifier 'omapdss_of_find_source_for_first_ep'
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:1202:13: sparse: undefined identifier 'omapdss_register_display'
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:1293:9: sparse: undefined identifier 'omapdss_unregister_display'
>> drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:715:40: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:750:41: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:767:41: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:772:38: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:811:38: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:1149:49: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:1202:37: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:1293:35: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c: In function 'dsicm_connect':
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:715:6: error: implicit declaration of function 'omapdss_device_is_connected' [-Werror=implicit-function-declaration]
     if (omapdss_device_is_connected(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c: In function 'dsicm_enable':
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:772:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
     if (omapdss_device_is_enabled(dssdev)) {
         ^~~~~~~~~~~~~~~~~~~~~~~~~
         movable_node_is_enabled
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c: At top level:
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:1119:25: error: 'omapdss_default_get_recommended_bpp' undeclared here (not in a function)
     .get_recommended_bpp = omapdss_default_get_recommended_bpp,
                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c: In function 'dsicm_probe_of':
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:1149:7: error: implicit declaration of function 'omapdss_of_find_source_for_first_ep' [-Werror=implicit-function-declaration]
     in = omapdss_of_find_source_for_first_ep(node);
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:1149:5: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     in = omapdss_of_find_source_for_first_ep(node);
        ^
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c: In function 'dsicm_probe':
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:1202:6: error: implicit declaration of function 'omapdss_register_display'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
     r = omapdss_register_display(dssdev);
         ^~~~~~~~~~~~~~~~~~~~~~~~
         omap_dispc_register_isr
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c: In function 'dsicm_remove':
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:1293:2: error: implicit declaration of function 'omapdss_unregister_display'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
     omapdss_unregister_display(dssdev);
     ^~~~~~~~~~~~~~~~~~~~~~~~~~
     omap_dispc_unregister_isr
   cc1: some warnings being treated as errors
--
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:230:23: sparse: cast to restricted __be32
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:230:23: sparse: cast to restricted __be32
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:230:23: sparse: cast to restricted __be32
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:230:23: sparse: cast to restricted __be32
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:230:23: sparse: cast to restricted __be32
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:230:23: sparse: cast to restricted __be32
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:522:13: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:537:14: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:631:14: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:634:13: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:654:14: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:704:27: sparse: undefined identifier 'omapdss_default_get_resolution'
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:717:14: sparse: undefined identifier 'omap_dss_find_output'
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:740:21: sparse: undefined identifier 'omapdss_of_find_source_for_first_ep'
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:857:13: sparse: undefined identifier 'omapdss_register_display'
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:887:9: sparse: undefined identifier 'omapdss_unregister_display'
>> drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:522:40: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:537:41: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:631:41: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:634:38: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:654:39: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:717:34: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:740:56: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:857:37: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:887:35: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c: In function 'acx565akm_connect':
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:522:6: error: implicit declaration of function 'omapdss_device_is_connected' [-Werror=implicit-function-declaration]
     if (omapdss_device_is_connected(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c: In function 'acx565akm_enable':
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:634:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
     if (omapdss_device_is_enabled(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~
         movable_node_is_enabled
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c: At top level:
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:704:20: error: 'omapdss_default_get_resolution' undeclared here (not in a function); did you mean 'omapdss_get_version'?
     .get_resolution = omapdss_default_get_resolution,
                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                       omapdss_get_version
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c: In function 'acx565akm_probe_pdata':
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:717:7: error: implicit declaration of function 'omap_dss_find_output'; did you mean 'omap_dss_get_overlay'? [-Werror=implicit-function-declaration]
     in = omap_dss_find_output(pdata->source);
          ^~~~~~~~~~~~~~~~~~~~
          omap_dss_get_overlay
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:717:5: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     in = omap_dss_find_output(pdata->source);
        ^
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c: In function 'acx565akm_probe_of':
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:740:14: error: implicit declaration of function 'omapdss_of_find_source_for_first_ep' [-Werror=implicit-function-declaration]
     ddata->in = omapdss_of_find_source_for_first_ep(np);
                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:740:12: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     ddata->in = omapdss_of_find_source_for_first_ep(np);
               ^
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c: In function 'acx565akm_probe':
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:857:6: error: implicit declaration of function 'omapdss_register_display'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
     r = omapdss_register_display(dssdev);
         ^~~~~~~~~~~~~~~~~~~~~~~~
         omap_dispc_register_isr
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c: In function 'acx565akm_remove':
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:887:2: error: implicit declaration of function 'omapdss_unregister_display'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
     omapdss_unregister_display(dssdev);
     ^~~~~~~~~~~~~~~~~~~~~~~~~~
     omap_dispc_unregister_isr
   cc1: some warnings being treated as errors
--
   drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:126:13: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:143:14: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:155:14: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:158:13: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:185:14: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:239:27: sparse: undefined identifier 'omapdss_default_get_resolution'
   drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:259:14: sparse: undefined identifier 'omapdss_of_find_source_for_first_ep'
   drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:308:13: sparse: undefined identifier 'omapdss_register_display'
   drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:328:9: sparse: undefined identifier 'omapdss_unregister_display'
>> drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:126:40: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:143:41: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:155:41: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:158:38: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:185:39: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:259:49: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:308:37: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:328:35: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c: In function 'lb035q02_connect':
   drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:126:6: error: implicit declaration of function 'omapdss_device_is_connected' [-Werror=implicit-function-declaration]
     if (omapdss_device_is_connected(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c: In function 'lb035q02_enable':
   drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:158:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
     if (omapdss_device_is_enabled(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~
         movable_node_is_enabled
   drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c: At top level:
   drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:239:20: error: 'omapdss_default_get_resolution' undeclared here (not in a function); did you mean 'omapdss_get_version'?
     .get_resolution = omapdss_default_get_resolution,
                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                       omapdss_get_version
   drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c: In function 'lb035q02_probe_of':
   drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:259:7: error: implicit declaration of function 'omapdss_of_find_source_for_first_ep' [-Werror=implicit-function-declaration]
     in = omapdss_of_find_source_for_first_ep(node);
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:259:5: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     in = omapdss_of_find_source_for_first_ep(node);
        ^
   drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c: In function 'lb035q02_panel_spi_probe':
   drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:308:6: error: implicit declaration of function 'omapdss_register_display'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
     r = omapdss_register_display(dssdev);
         ^~~~~~~~~~~~~~~~~~~~~~~~
         omap_dispc_register_isr
   drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c: In function 'lb035q02_panel_spi_remove':
   drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:328:2: error: implicit declaration of function 'omapdss_unregister_display'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
     omapdss_unregister_display(dssdev);
     ^~~~~~~~~~~~~~~~~~~~~~~~~~
     omap_dispc_unregister_isr
   cc1: some warnings being treated as errors
--
   drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:67:13: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:82:14: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:94:14: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:97:13: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:135:14: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:196:27: sparse: undefined identifier 'omapdss_default_get_resolution'
   drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:252:14: sparse: undefined identifier 'omapdss_of_find_source_for_first_ep'
   drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:292:13: sparse: undefined identifier 'omapdss_register_display'
   drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:311:9: sparse: undefined identifier 'omapdss_unregister_display'
>> drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:67:40: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:82:41: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:94:41: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:97:38: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:135:39: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:252:49: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:292:37: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:311:35: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c: In function 'sharp_ls_connect':
   drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:67:6: error: implicit declaration of function 'omapdss_device_is_connected' [-Werror=implicit-function-declaration]
     if (omapdss_device_is_connected(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c: In function 'sharp_ls_enable':
   drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:97:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
     if (omapdss_device_is_enabled(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~
         movable_node_is_enabled
   drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c: At top level:
   drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:196:20: error: 'omapdss_default_get_resolution' undeclared here (not in a function); did you mean 'omapdss_get_version'?
     .get_resolution = omapdss_default_get_resolution,
                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                       omapdss_get_version
   drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c: In function 'sharp_ls_probe_of':
   drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:252:7: error: implicit declaration of function 'omapdss_of_find_source_for_first_ep' [-Werror=implicit-function-declaration]
     in = omapdss_of_find_source_for_first_ep(node);
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:252:5: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     in = omapdss_of_find_source_for_first_ep(node);
        ^
   drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c: In function 'sharp_ls_probe':
   drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:292:6: error: implicit declaration of function 'omapdss_register_display'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
     r = omapdss_register_display(dssdev);
         ^~~~~~~~~~~~~~~~~~~~~~~~
         omap_dispc_register_isr
   drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c: In function 'sharp_ls_remove':
   drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:311:2: error: implicit declaration of function 'omapdss_unregister_display'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
     omapdss_unregister_display(dssdev);
     ^~~~~~~~~~~~~~~~~~~~~~~~~~
     omap_dispc_unregister_isr
   cc1: some warnings being treated as errors
--
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c:175:13: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c:190:14: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c:202:14: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c:205:13: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c:311:14: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c:373:14: sparse: undefined identifier 'omapdss_of_find_source_for_first_ep'
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c:426:13: sparse: undefined identifier 'omapdss_register_display'
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c:447:9: sparse: undefined identifier 'omapdss_unregister_display'
>> drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c:175:40: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c:190:41: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c:202:41: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c:205:38: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c:311:39: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c:373:49: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c:426:37: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c:447:35: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c: In function 'td028ttec1_panel_connect':
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c:175:6: error: implicit declaration of function 'omapdss_device_is_connected' [-Werror=implicit-function-declaration]
     if (omapdss_device_is_connected(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c: In function 'td028ttec1_panel_enable':
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c:205:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
     if (omapdss_device_is_enabled(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~
         movable_node_is_enabled
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c: In function 'td028ttec1_probe_of':
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c:373:7: error: implicit declaration of function 'omapdss_of_find_source_for_first_ep' [-Werror=implicit-function-declaration]
     in = omapdss_of_find_source_for_first_ep(node);
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c:373:5: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     in = omapdss_of_find_source_for_first_ep(node);
        ^
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c: In function 'td028ttec1_panel_probe':
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c:426:6: error: implicit declaration of function 'omapdss_register_display'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
     r = omapdss_register_display(dssdev);
         ^~~~~~~~~~~~~~~~~~~~~~~~
         omap_dispc_register_isr
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c: In function 'td028ttec1_panel_remove':
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c:447:2: error: implicit declaration of function 'omapdss_unregister_display'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
     omapdss_unregister_display(dssdev);
     ^~~~~~~~~~~~~~~~~~~~~~~~~~
     omap_dispc_unregister_isr
   cc1: some warnings being treated as errors
--
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c:346:13: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c:361:14: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c:373:14: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c:376:13: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c:409:14: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c:463:27: sparse: undefined identifier 'omapdss_default_get_resolution'
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c:481:14: sparse: undefined identifier 'omapdss_of_find_source_for_first_ep'
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c:559:13: sparse: undefined identifier 'omapdss_register_display'
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c:584:9: sparse: undefined identifier 'omapdss_unregister_display'
>> drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c:346:40: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c:361:41: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c:373:41: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c:376:38: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c:409:39: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c:481:49: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c:559:37: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c:584:35: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c: In function 'tpo_td043_connect':
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c:346:6: error: implicit declaration of function 'omapdss_device_is_connected' [-Werror=implicit-function-declaration]
     if (omapdss_device_is_connected(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c: In function 'tpo_td043_enable':
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c:376:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
     if (omapdss_device_is_enabled(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~
         movable_node_is_enabled
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c: At top level:
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c:463:20: error: 'omapdss_default_get_resolution' undeclared here (not in a function); did you mean 'omapdss_get_version'?
     .get_resolution = omapdss_default_get_resolution,
                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                       omapdss_get_version
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c: In function 'tpo_td043_probe_of':
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c:481:7: error: implicit declaration of function 'omapdss_of_find_source_for_first_ep' [-Werror=implicit-function-declaration]
     in = omapdss_of_find_source_for_first_ep(node);
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c:481:5: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     in = omapdss_of_find_source_for_first_ep(node);
        ^
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c: In function 'tpo_td043_probe':
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c:559:6: error: implicit declaration of function 'omapdss_register_display'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
     r = omapdss_register_display(dssdev);
         ^~~~~~~~~~~~~~~~~~~~~~~~
         omap_dispc_register_isr
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c: In function 'tpo_td043_remove':
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td043mtea1.c:584:2: error: implicit declaration of function 'omapdss_unregister_display'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
     omapdss_unregister_display(dssdev);
     ^~~~~~~~~~~~~~~~~~~~~~~~~~
     omap_dispc_unregister_isr
   cc1: some warnings being treated as errors
--
   drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c:126:13: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c:141:14: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c:153:14: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c:156:13: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c:180:14: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c:231:27: sparse: undefined identifier 'omapdss_default_get_resolution'
   drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c:252:14: sparse: undefined identifier 'omapdss_of_find_source_for_first_ep'
   drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c:320:13: sparse: undefined identifier 'omapdss_register_display'
   drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c:342:9: sparse: undefined identifier 'omapdss_unregister_display'
>> drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c:126:40: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c:141:41: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c:153:41: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c:156:38: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c:180:39: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c:252:49: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c:320:37: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c:342:35: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c: In function 'nec_8048_connect':
   drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c:126:6: error: implicit declaration of function 'omapdss_device_is_connected' [-Werror=implicit-function-declaration]
     if (omapdss_device_is_connected(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c: In function 'nec_8048_enable':
   drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c:156:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
     if (omapdss_device_is_enabled(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~
         movable_node_is_enabled
   drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c: At top level:
   drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c:231:20: error: 'omapdss_default_get_resolution' undeclared here (not in a function); did you mean 'omapdss_get_version'?
     .get_resolution = omapdss_default_get_resolution,
                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                       omapdss_get_version
   drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c: In function 'nec_8048_probe_of':
   drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c:252:7: error: implicit declaration of function 'omapdss_of_find_source_for_first_ep' [-Werror=implicit-function-declaration]
     in = omapdss_of_find_source_for_first_ep(node);
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c:252:5: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     in = omapdss_of_find_source_for_first_ep(node);
        ^
   drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c: In function 'nec_8048_probe':
   drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c:320:6: error: implicit declaration of function 'omapdss_register_display'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
     r = omapdss_register_display(dssdev);
         ^~~~~~~~~~~~~~~~~~~~~~~~
         omap_dispc_register_isr
   drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c: In function 'nec_8048_remove':
   drivers/video/fbdev/omap2/omapfb/displays/panel-nec-nl8048hl11.c:342:2: error: implicit declaration of function 'omapdss_unregister_display'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
     omapdss_unregister_display(dssdev);
     ^~~~~~~~~~~~~~~~~~~~~~~~~~
     omap_dispc_unregister_isr
   cc1: some warnings being treated as errors
--
   drivers/video/fbdev/omap2/omapfb/dss/dss.c:552:22: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dss.c:552:22: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dss.c:553:21: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dss.c:982:16: sparse: undefined identifier 'omapdss_of_get_next_port'
   drivers/video/fbdev/omap2/omapfb/dss/dss.c:1013:26: sparse: undefined identifier 'omapdss_of_get_next_port'
   drivers/video/fbdev/omap2/omapfb/dss/dss.c:935:16: sparse: undefined identifier 'omapdss_of_get_next_port'
   drivers/video/fbdev/omap2/omapfb/dss/dss.c:966:26: sparse: undefined identifier 'omapdss_of_get_next_port'
>> drivers/video/fbdev/omap2/omapfb/dss/dss.c:935:40: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dss.c:966:50: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dss.c:982:40: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dss.c:1013:50: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dss.c:118:6: error: redefinition of 'omapdss_is_initialized'
    bool omapdss_is_initialized(void)
         ^~~~~~~~~~~~~~~~~~~~~~
   In file included from drivers/video/fbdev/omap2/omapfb/dss/dss.c:45:0:
   include/video/omapfb_dss.h:868:20: note: previous definition of 'omapdss_is_initialized' was here
    static inline bool omapdss_is_initialized(void)
                       ^~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/dss/dss.c: In function 'dss_init_ports':
   drivers/video/fbdev/omap2/omapfb/dss/dss.c:935:9: error: implicit declaration of function 'omapdss_of_get_next_port'; did you mean 'omap_dss_get_next_device'? [-Werror=implicit-function-declaration]
     port = omapdss_of_get_next_port(parent, NULL);
            ^~~~~~~~~~~~~~~~~~~~~~~~
            omap_dss_get_next_device
   drivers/video/fbdev/omap2/omapfb/dss/dss.c:935:7: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     port = omapdss_of_get_next_port(parent, NULL);
          ^
   drivers/video/fbdev/omap2/omapfb/dss/dss.c:966:10: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
       (port = omapdss_of_get_next_port(parent, port)) != NULL);
             ^
   drivers/video/fbdev/omap2/omapfb/dss/dss.c: In function 'dss_uninit_ports':
   drivers/video/fbdev/omap2/omapfb/dss/dss.c:982:7: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     port = omapdss_of_get_next_port(parent, NULL);
          ^
   drivers/video/fbdev/omap2/omapfb/dss/dss.c:1013:17: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     } while ((port = omapdss_of_get_next_port(parent, port)) != NULL);
                    ^
   cc1: some warnings being treated as errors
--
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:320:25: sparse: undefined identifier 'dss_feat_get_num_mgrs'
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:342:25: sparse: undefined identifier 'dss_feat_get_num_ovls'
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:426:25: sparse: undefined identifier 'dss_feat_get_num_mgrs'
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:448:25: sparse: undefined identifier 'dss_feat_get_num_ovls'
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:719:23: sparse: undefined identifier 'dss_feat_get_num_ovls'
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:811:25: sparse: undefined identifier 'dss_feat_get_num_ovls'
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:1065:25: sparse: undefined identifier 'dss_feat_get_num_ovls'
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:1205:25: sparse: undefined identifier 'dss_feat_get_num_ovls'
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:1276:59: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:1308:33: sparse: undefined identifier 'dss_feat_get_num_ovls'
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:1374:25: sparse: undefined identifier 'dss_feat_get_num_ovls'
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:2181:9: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:2183:19: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:2192:9: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:2194:19: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:2224:36: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:2224:36: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:2231:28: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:2231:28: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:2302:26: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:2302:26: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:2875:27: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:3560:25: sparse: undefined identifier 'dss_feat_get_num_mgrs'
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:3586:25: sparse: undefined identifier 'dss_feat_get_num_ovls'
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:3664:25: sparse: undefined identifier 'dss_feat_get_num_ovls'
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:3738:22: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:3739:21: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:3744:30: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:3744:30: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:3745:29: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:3745:29: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:289:9: sparse: context imbalance in 'mgr_fld_write' - different lock contexts for basic block
>> drivers/video/fbdev/omap2/omapfb/dss/dispc.c:320:46: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:342:46: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:426:46: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:448:46: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:719:44: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:811:46: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:1065:46: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:1205:46: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:1308:54: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:1374:46: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:3560:46: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:3586:46: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:3664:46: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c: In function 'dispc_save_context':
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:320:18: error: implicit declaration of function 'dss_feat_get_num_mgrs'; did you mean 'dss_feat_get_param_max'? [-Werror=implicit-function-declaration]
     for (i = 0; i < dss_feat_get_num_mgrs(); i++) {
                     ^~~~~~~~~~~~~~~~~~~~~
                     dss_feat_get_param_max
   drivers/video/fbdev/omap2/omapfb/dss/dispc.c:342:18: error: implicit declaration of function 'dss_feat_get_num_ovls'; did you mean 'dss_feat_get_reg_field'? [-Werror=implicit-function-declaration]
     for (i = 0; i < dss_feat_get_num_ovls(); i++) {
                     ^~~~~~~~~~~~~~~~~~~~~
                     dss_feat_get_reg_field
   cc1: some warnings being treated as errors
--
   drivers/video/fbdev/omap2/omapfb/dss/dss-of.c:178:15: sparse: undefined identifier 'omap_dss_find_output_by_port_node'
>> drivers/video/fbdev/omap2/omapfb/dss/dss-of.c:178:48: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dss-of.c: In function 'omapdss_of_find_source_for_first_ep':
   drivers/video/fbdev/omap2/omapfb/dss/dss-of.c:178:8: error: implicit declaration of function 'omap_dss_find_output_by_port_node' [-Werror=implicit-function-declaration]
     src = omap_dss_find_output_by_port_node(src_port);
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/dss/dss-of.c:178:6: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     src = omap_dss_find_output_by_port_node(src_port);
         ^
   cc1: some warnings being treated as errors
--
   drivers/video/fbdev/omap2/omapfb/dss/manager.c:43:24: sparse: undefined identifier 'dss_feat_get_num_mgrs'
>> drivers/video/fbdev/omap2/omapfb/dss/manager.c:43:45: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/manager.c: In function 'dss_init_overlay_managers':
   drivers/video/fbdev/omap2/omapfb/dss/manager.c:43:17: error: implicit declaration of function 'dss_feat_get_num_mgrs'; did you mean 'dss_feat_get_param_max'? [-Werror=implicit-function-declaration]
     num_managers = dss_feat_get_num_mgrs();
                    ^~~~~~~~~~~~~~~~~~~~~
                    dss_feat_get_param_max
   drivers/video/fbdev/omap2/omapfb/dss/manager.c: At top level:
   drivers/video/fbdev/omap2/omapfb/dss/manager.c:116:5: error: redefinition of 'omap_dss_get_num_overlay_managers'
    int omap_dss_get_num_overlay_managers(void)
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from drivers/video/fbdev/omap2/omapfb/dss/manager.c:31:0:
   include/video/omapfb_dss.h:894:19: note: previous definition of 'omap_dss_get_num_overlay_managers' was here
    static inline int omap_dss_get_num_overlay_managers(void)
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/dss/manager.c:122:30: error: redefinition of 'omap_dss_get_overlay_manager'
    struct omap_overlay_manager *omap_dss_get_overlay_manager(int num)
                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from drivers/video/fbdev/omap2/omapfb/dss/manager.c:31:0:
   include/video/omapfb_dss.h:897:44: note: previous definition of 'omap_dss_get_overlay_manager' was here
    static inline struct omap_overlay_manager *omap_dss_get_overlay_manager(int num)
                                               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors
--
   drivers/video/fbdev/omap2/omapfb/dss/manager-sysfs.c:66:26: sparse: undefined identifier 'omap_dss_find_device'
   drivers/video/fbdev/omap2/omapfb/dss/manager-sysfs.c:75:21: sparse: undefined identifier 'omapdss_device_is_connected'
   drivers/video/fbdev/omap2/omapfb/dss/manager-sysfs.c:81:21: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/dss/manager-sysfs.c:90:21: sparse: undefined identifier 'omapdss_device_is_enabled'
>> drivers/video/fbdev/omap2/omapfb/dss/manager-sysfs.c:66:46: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/manager-sysfs.c:75:48: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/manager-sysfs.c:81:46: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/manager-sysfs.c:90:46: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/manager-sysfs.c: In function 'manager_display_store':
   drivers/video/fbdev/omap2/omapfb/dss/manager-sysfs.c:66:12: error: implicit declaration of function 'omap_dss_find_device'; did you mean 'omap_dss_put_device'? [-Werror=implicit-function-declaration]
      dssdev = omap_dss_find_device((void *)buf,
               ^~~~~~~~~~~~~~~~~~~~
               omap_dss_put_device
   drivers/video/fbdev/omap2/omapfb/dss/manager-sysfs.c:66:10: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
      dssdev = omap_dss_find_device((void *)buf,
             ^
   drivers/video/fbdev/omap2/omapfb/dss/manager-sysfs.c:75:7: error: implicit declaration of function 'omapdss_device_is_connected' [-Werror=implicit-function-declaration]
      if (omapdss_device_is_connected(dssdev)) {
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/dss/manager-sysfs.c:81:7: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
      if (omapdss_device_is_enabled(dssdev)) {
          ^~~~~~~~~~~~~~~~~~~~~~~~~
          movable_node_is_enabled
   cc1: some warnings being treated as errors
--
   drivers/video/fbdev/omap2/omapfb/dss/overlay.c:60:24: sparse: undefined identifier 'dss_feat_get_num_ovls'
   drivers/video/fbdev/omap2/omapfb/dss/overlay.c:91:25: sparse: undefined identifier 'dss_feat_get_supported_color_modes'
>> drivers/video/fbdev/omap2/omapfb/dss/overlay.c:60:45: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/overlay.c:91:59: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/overlay.c:41:5: error: redefinition of 'omap_dss_get_num_overlays'
    int omap_dss_get_num_overlays(void)
        ^~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from drivers/video/fbdev/omap2/omapfb/dss/overlay.c:33:0:
   include/video/omapfb_dss.h:900:19: note: previous definition of 'omap_dss_get_num_overlays' was here
    static inline int omap_dss_get_num_overlays(void)
                      ^~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/dss/overlay.c:47:22: error: redefinition of 'omap_dss_get_overlay'
    struct omap_overlay *omap_dss_get_overlay(int num)
                         ^~~~~~~~~~~~~~~~~~~~
   In file included from drivers/video/fbdev/omap2/omapfb/dss/overlay.c:33:0:
   include/video/omapfb_dss.h:903:36: note: previous definition of 'omap_dss_get_overlay' was here
    static inline struct omap_overlay *omap_dss_get_overlay(int num)
                                       ^~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/dss/overlay.c: In function 'dss_init_overlays':
   drivers/video/fbdev/omap2/omapfb/dss/overlay.c:60:17: error: implicit declaration of function 'dss_feat_get_num_ovls'; did you mean 'dss_feat_get_reg_field'? [-Werror=implicit-function-declaration]
     num_overlays = dss_feat_get_num_ovls();
                    ^~~~~~~~~~~~~~~~~~~~~
                    dss_feat_get_reg_field
   drivers/video/fbdev/omap2/omapfb/dss/overlay.c:91:4: error: implicit declaration of function 'dss_feat_get_supported_color_modes'; did you mean 'dss_feat_get_supported_outputs'? [-Werror=implicit-function-declaration]
       dss_feat_get_supported_color_modes(ovl->id);
       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
       dss_feat_get_supported_outputs
   cc1: some warnings being treated as errors
--
   drivers/video/fbdev/omap2/omapfb/dss/apply.c:854:30: sparse: undefined identifier 'dss_feat_get_num_mgrs'
   drivers/video/fbdev/omap2/omapfb/dss/apply.c:141:30: sparse: undefined identifier 'dss_feat_get_num_ovls'
   drivers/video/fbdev/omap2/omapfb/dss/apply.c:264:30: sparse: undefined identifier 'dss_feat_get_num_mgrs'
   drivers/video/fbdev/omap2/omapfb/dss/apply.c:368:30: sparse: undefined identifier 'dss_feat_get_num_mgrs'
   drivers/video/fbdev/omap2/omapfb/dss/apply.c:892:30: sparse: undefined identifier 'dss_feat_get_num_mgrs'
   drivers/video/fbdev/omap2/omapfb/dss/apply.c:873:30: sparse: undefined identifier 'dss_feat_get_num_mgrs'
>> drivers/video/fbdev/omap2/omapfb/dss/apply.c:141:51: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/apply.c:264:51: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/apply.c:368:51: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/apply.c:854:51: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/apply.c:873:51: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/apply.c:892:51: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/apply.c: In function 'apply_init_priv':
   drivers/video/fbdev/omap2/omapfb/dss/apply.c:141:23: error: implicit declaration of function 'dss_feat_get_num_ovls'; did you mean 'dss_feat_get_reg_field'? [-Werror=implicit-function-declaration]
     const int num_ovls = dss_feat_get_num_ovls();
                          ^~~~~~~~~~~~~~~~~~~~~
                          dss_feat_get_reg_field
   drivers/video/fbdev/omap2/omapfb/dss/apply.c: In function 'need_isr':
   drivers/video/fbdev/omap2/omapfb/dss/apply.c:264:23: error: implicit declaration of function 'dss_feat_get_num_mgrs'; did you mean 'dss_feat_get_param_max'? [-Werror=implicit-function-declaration]
     const int num_mgrs = dss_feat_get_num_mgrs();
                          ^~~~~~~~~~~~~~~~~~~~~
                          dss_feat_get_param_max
   drivers/video/fbdev/omap2/omapfb/dss/apply.c: At top level:
   drivers/video/fbdev/omap2/omapfb/dss/apply.c:1598:5: error: redefinition of 'omapdss_compat_init'
    int omapdss_compat_init(void)
        ^~~~~~~~~~~~~~~~~~~
   In file included from drivers/video/fbdev/omap2/omapfb/dss/apply.c:26:0:
   include/video/omapfb_dss.h:889:19: note: previous definition of 'omapdss_compat_init' was here
    static inline int omapdss_compat_init(void)
                      ^~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/dss/apply.c:1682:6: error: redefinition of 'omapdss_compat_uninit'
    void omapdss_compat_uninit(void)
         ^~~~~~~~~~~~~~~~~~~~~
   In file included from drivers/video/fbdev/omap2/omapfb/dss/apply.c:26:0:
   include/video/omapfb_dss.h:892:20: note: previous definition of 'omapdss_compat_uninit' was here
    static inline void omapdss_compat_uninit(void) {};
                       ^~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors
--
   drivers/video/fbdev/omap2/omapfb/dss/dispc-compat.c:105:13: sparse: undefined identifier 'dss_feat_get_num_ovls'
   drivers/video/fbdev/omap2/omapfb/dss/dispc-compat.c:244:9: sparse: undefined identifier 'dss_feat_get_num_ovls'
   drivers/video/fbdev/omap2/omapfb/dss/dispc-compat.c:435:13: sparse: undefined identifier 'dss_feat_get_num_ovls'
>> drivers/video/fbdev/omap2/omapfb/dss/dispc-compat.c:105:34: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dispc-compat.c:244:9: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dispc-compat.c:435:34: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dispc-compat.c: In function 'dispc_dump_irqs':
   drivers/video/fbdev/omap2/omapfb/dss/dispc-compat.c:105:6: error: implicit declaration of function 'dss_feat_get_num_ovls'; did you mean 'dss_feat_get_reg_field'? [-Werror=implicit-function-declaration]
     if (dss_feat_get_num_ovls() > 3) {
         ^~~~~~~~~~~~~~~~~~~~~
         dss_feat_get_reg_field
   drivers/video/fbdev/omap2/omapfb/dss/dispc-compat.c: At top level:
   drivers/video/fbdev/omap2/omapfb/dss/dispc-compat.c:149:5: error: redefinition of 'omap_dispc_register_isr'
    int omap_dispc_register_isr(omap_dispc_isr_t isr, void *arg, u32 mask)
        ^~~~~~~~~~~~~~~~~~~~~~~
   In file included from drivers/video/fbdev/omap2/omapfb/dss/dispc-compat.c:29:0:
   include/video/omapfb_dss.h:871:19: note: previous definition of 'omap_dispc_register_isr' was here
    static inline int omap_dispc_register_isr(omap_dispc_isr_t isr,
                      ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/video/fbdev/omap2/omapfb/dss/dispc-compat.c:203:5: error: redefinition of 'omap_dispc_unregister_isr'
    int omap_dispc_unregister_isr(omap_dispc_isr_t isr, void *arg, u32 mask)
        ^~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from drivers/video/fbdev/omap2/omapfb/dss/dispc-compat.c:29:0:
   include/video/omapfb_dss.h:875:19: note: previous definition of 'omap_dispc_unregister_isr' was here
    static inline int omap_dispc_unregister_isr(omap_dispc_isr_t isr,
                      ^~~~~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors
--
   drivers/video/fbdev/omap2/omapfb/dss/display-sysfs.c:41:25: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/dss/display-sysfs.c:54:23: sparse: undefined identifier 'omapdss_device_is_enabled'
   drivers/video/fbdev/omap2/omapfb/dss/display-sysfs.c:57:13: sparse: undefined identifier 'omapdss_device_is_connected'
>> drivers/video/fbdev/omap2/omapfb/dss/display-sysfs.c:40:24: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/display-sysfs.c:54:48: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/display-sysfs.c:57:40: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/display-sysfs.c: In function 'display_enabled_show':
   drivers/video/fbdev/omap2/omapfb/dss/display-sysfs.c:41:4: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'movable_node_is_enabled'? [-Werror=implicit-function-declaration]
       omapdss_device_is_enabled(dssdev));
       ^~~~~~~~~~~~~~~~~~~~~~~~~
       movable_node_is_enabled
   drivers/video/fbdev/omap2/omapfb/dss/display-sysfs.c: In function 'display_enabled_store':
   drivers/video/fbdev/omap2/omapfb/dss/display-sysfs.c:57:6: error: implicit declaration of function 'omapdss_device_is_connected' [-Werror=implicit-function-declaration]
     if (omapdss_device_is_connected(dssdev) == false)
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors
--
   drivers/video/fbdev/omap2/omapfb/dss/dpi.c:267:40: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dpi.c:680:13: sparse: undefined identifier 'omapdss_output_set_device'
   drivers/video/fbdev/omap2/omapfb/dss/dpi.c:699:9: sparse: undefined identifier 'omapdss_output_unset_device'
   drivers/video/fbdev/omap2/omapfb/dss/dpi.c:732:9: sparse: undefined identifier 'omapdss_register_output'
   drivers/video/fbdev/omap2/omapfb/dss/dpi.c:740:9: sparse: undefined identifier 'omapdss_unregister_output'
   drivers/video/fbdev/omap2/omapfb/dss/dpi.c:776:9: sparse: undefined identifier 'omapdss_register_output'
   drivers/video/fbdev/omap2/omapfb/dss/dpi.c:784:9: sparse: undefined identifier 'omapdss_unregister_output'
   drivers/video/fbdev/omap2/omapfb/dss/dpi.c:860:14: sparse: undefined identifier 'omapdss_of_get_next_endpoint'
>> drivers/video/fbdev/omap2/omapfb/dss/dpi.c:680:38: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dpi.c:699:36: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dpi.c:732:32: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dpi.c:740:34: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dpi.c:776:32: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dpi.c:784:34: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dpi.c:860:42: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dpi.c: In function 'dpi_connect':
   drivers/video/fbdev/omap2/omapfb/dss/dpi.c:680:6: error: implicit declaration of function 'omapdss_output_set_device'; did you mean 'omap_dss_put_device'? [-Werror=implicit-function-declaration]
     r = omapdss_output_set_device(dssdev, dst);
         ^~~~~~~~~~~~~~~~~~~~~~~~~
         omap_dss_put_device
   drivers/video/fbdev/omap2/omapfb/dss/dpi.c: In function 'dpi_disconnect':
   drivers/video/fbdev/omap2/omapfb/dss/dpi.c:699:2: error: implicit declaration of function 'omapdss_output_unset_device'; did you mean 'omap_dss_get_next_device'? [-Werror=implicit-function-declaration]
     omapdss_output_unset_device(dssdev);
     ^~~~~~~~~~~~~~~~~~~~~~~~~~~
     omap_dss_get_next_device
   drivers/video/fbdev/omap2/omapfb/dss/dpi.c: In function 'dpi_init_output':
   drivers/video/fbdev/omap2/omapfb/dss/dpi.c:732:2: error: implicit declaration of function 'omapdss_register_output'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
     omapdss_register_output(out);
     ^~~~~~~~~~~~~~~~~~~~~~~
     omap_dispc_register_isr
   drivers/video/fbdev/omap2/omapfb/dss/dpi.c: In function 'dpi_uninit_output':
   drivers/video/fbdev/omap2/omapfb/dss/dpi.c:740:2: error: implicit declaration of function 'omapdss_unregister_output'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
     omapdss_unregister_output(out);
     ^~~~~~~~~~~~~~~~~~~~~~~~~
     omap_dispc_unregister_isr
   drivers/video/fbdev/omap2/omapfb/dss/dpi.c: In function 'dpi_init_port':
   drivers/video/fbdev/omap2/omapfb/dss/dpi.c:860:7: error: implicit declaration of function 'omapdss_of_get_next_endpoint'; did you mean 'omap_dss_get_next_device'? [-Werror=implicit-function-declaration]
     ep = omapdss_of_get_next_endpoint(port, NULL);
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
          omap_dss_get_next_device
   drivers/video/fbdev/omap2/omapfb/dss/dpi.c:860:5: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     ep = omapdss_of_get_next_endpoint(port, NULL);
        ^
   cc1: some warnings being treated as errors
--
   drivers/video/fbdev/omap2/omapfb/dss/venc.c:748:13: sparse: undefined identifier 'omapdss_output_set_device'
   drivers/video/fbdev/omap2/omapfb/dss/venc.c:767:9: sparse: undefined identifier 'omapdss_output_unset_device'
   drivers/video/fbdev/omap2/omapfb/dss/venc.c:803:9: sparse: undefined identifier 'omapdss_register_output'
   drivers/video/fbdev/omap2/omapfb/dss/venc.c:810:9: sparse: undefined identifier 'omapdss_unregister_output'
   drivers/video/fbdev/omap2/omapfb/dss/venc.c:820:14: sparse: undefined identifier 'omapdss_of_get_first_endpoint'
>> drivers/video/fbdev/omap2/omapfb/dss/venc.c:748:38: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/venc.c:767:36: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/venc.c:803:32: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/venc.c:810:34: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/venc.c:820:43: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/venc.c: In function 'venc_connect':
   drivers/video/fbdev/omap2/omapfb/dss/venc.c:748:6: error: implicit declaration of function 'omapdss_output_set_device'; did you mean 'omap_dss_put_device'? [-Werror=implicit-function-declaration]
     r = omapdss_output_set_device(dssdev, dst);
         ^~~~~~~~~~~~~~~~~~~~~~~~~
         omap_dss_put_device
   drivers/video/fbdev/omap2/omapfb/dss/venc.c: In function 'venc_disconnect':
   drivers/video/fbdev/omap2/omapfb/dss/venc.c:767:2: error: implicit declaration of function 'omapdss_output_unset_device'; did you mean 'omap_dss_get_next_device'? [-Werror=implicit-function-declaration]
     omapdss_output_unset_device(dssdev);
     ^~~~~~~~~~~~~~~~~~~~~~~~~~~
     omap_dss_get_next_device
   drivers/video/fbdev/omap2/omapfb/dss/venc.c: In function 'venc_init_output':
   drivers/video/fbdev/omap2/omapfb/dss/venc.c:803:2: error: implicit declaration of function 'omapdss_register_output'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
     omapdss_register_output(out);
     ^~~~~~~~~~~~~~~~~~~~~~~
     omap_dispc_register_isr
   drivers/video/fbdev/omap2/omapfb/dss/venc.c: In function 'venc_uninit_output':
   drivers/video/fbdev/omap2/omapfb/dss/venc.c:810:2: error: implicit declaration of function 'omapdss_unregister_output'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
     omapdss_unregister_output(out);
     ^~~~~~~~~~~~~~~~~~~~~~~~~
     omap_dispc_unregister_isr
   drivers/video/fbdev/omap2/omapfb/dss/venc.c: In function 'venc_probe_of':
   drivers/video/fbdev/omap2/omapfb/dss/venc.c:820:7: error: implicit declaration of function 'omapdss_of_get_first_endpoint'; did you mean 'omapdss_get_version'? [-Werror=implicit-function-declaration]
     ep = omapdss_of_get_first_endpoint(node);
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          omapdss_get_version
   drivers/video/fbdev/omap2/omapfb/dss/venc.c:820:5: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     ep = omapdss_of_get_first_endpoint(node);
        ^
   cc1: some warnings being treated as errors
--
   drivers/video/fbdev/omap2/omapfb/dss/sdi.c:99:39: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/sdi.c:298:13: sparse: undefined identifier 'omapdss_output_set_device'
   drivers/video/fbdev/omap2/omapfb/dss/sdi.c:317:9: sparse: undefined identifier 'omapdss_output_unset_device'
   drivers/video/fbdev/omap2/omapfb/dss/sdi.c:351:9: sparse: undefined identifier 'omapdss_register_output'
   drivers/video/fbdev/omap2/omapfb/dss/sdi.c:358:9: sparse: undefined identifier 'omapdss_unregister_output'
   drivers/video/fbdev/omap2/omapfb/dss/sdi.c:420:14: sparse: undefined identifier 'omapdss_of_get_next_endpoint'
>> drivers/video/fbdev/omap2/omapfb/dss/sdi.c:298:38: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/sdi.c:317:36: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/sdi.c:351:32: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/sdi.c:358:34: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/sdi.c:420:42: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/sdi.c: In function 'sdi_connect':
   drivers/video/fbdev/omap2/omapfb/dss/sdi.c:298:6: error: implicit declaration of function 'omapdss_output_set_device'; did you mean 'omap_dss_put_device'? [-Werror=implicit-function-declaration]
     r = omapdss_output_set_device(dssdev, dst);
         ^~~~~~~~~~~~~~~~~~~~~~~~~
         omap_dss_put_device
   drivers/video/fbdev/omap2/omapfb/dss/sdi.c: In function 'sdi_disconnect':
   drivers/video/fbdev/omap2/omapfb/dss/sdi.c:317:2: error: implicit declaration of function 'omapdss_output_unset_device'; did you mean 'omap_dss_get_next_device'? [-Werror=implicit-function-declaration]
     omapdss_output_unset_device(dssdev);
     ^~~~~~~~~~~~~~~~~~~~~~~~~~~
     omap_dss_get_next_device
   drivers/video/fbdev/omap2/omapfb/dss/sdi.c: In function 'sdi_init_output':
   drivers/video/fbdev/omap2/omapfb/dss/sdi.c:351:2: error: implicit declaration of function 'omapdss_register_output'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
     omapdss_register_output(out);
     ^~~~~~~~~~~~~~~~~~~~~~~
     omap_dispc_register_isr
   drivers/video/fbdev/omap2/omapfb/dss/sdi.c: In function 'sdi_uninit_output':
   drivers/video/fbdev/omap2/omapfb/dss/sdi.c:358:2: error: implicit declaration of function 'omapdss_unregister_output'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
     omapdss_unregister_output(out);
     ^~~~~~~~~~~~~~~~~~~~~~~~~
     omap_dispc_unregister_isr
   drivers/video/fbdev/omap2/omapfb/dss/sdi.c: In function 'sdi_init_port':
   drivers/video/fbdev/omap2/omapfb/dss/sdi.c:420:7: error: implicit declaration of function 'omapdss_of_get_next_endpoint'; did you mean 'omap_dss_get_next_device'? [-Werror=implicit-function-declaration]
     ep = omapdss_of_get_next_endpoint(port, NULL);
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
          omap_dss_get_next_device
   drivers/video/fbdev/omap2/omapfb/dss/sdi.c:420:5: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     ep = omapdss_of_get_next_endpoint(port, NULL);
        ^
   cc1: some warnings being treated as errors
--
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:437:15: sparse: undefined identifier 'omap_dss_get_output'
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:3406:51: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:3409:57: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:3412:30: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:3412:30: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:3435:30: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:3445:16: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:4491:19: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:4491:19: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:4604:23: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:4608:15: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:4616:23: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:4622:31: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:4661:23: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:4667:15: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:4675:23: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:4681:31: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:4783:19: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:4783:19: sparse: expression using sizeof(void)
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:4991:13: sparse: undefined identifier 'omapdss_output_set_device'
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:5010:9: sparse: undefined identifier 'omapdss_output_unset_device'
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:5070:9: sparse: undefined identifier 'omapdss_register_output'
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:5078:9: sparse: undefined identifier 'omapdss_unregister_output'
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:5092:14: sparse: undefined identifier 'omapdss_of_get_first_endpoint'
>> drivers/video/fbdev/omap2/omapfb/dss/dsi.c:437:34: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:4991:38: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:5010:36: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:5070:32: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:5078:34: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:5092:43: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c: In function 'dsi_get_dsidev_from_id':
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:437:8: error: implicit declaration of function 'omap_dss_get_output'; did you mean 'omap_dss_get_overlay'? [-Werror=implicit-function-declaration]
     out = omap_dss_get_output(id);
           ^~~~~~~~~~~~~~~~~~~
           omap_dss_get_overlay
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:437:6: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     out = omap_dss_get_output(id);
         ^
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c: In function 'dsi_connect':
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:4991:6: error: implicit declaration of function 'omapdss_output_set_device'; did you mean 'omap_dss_put_device'? [-Werror=implicit-function-declaration]
     r = omapdss_output_set_device(dssdev, dst);
         ^~~~~~~~~~~~~~~~~~~~~~~~~
         omap_dss_put_device
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c: In function 'dsi_disconnect':
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:5010:2: error: implicit declaration of function 'omapdss_output_unset_device'; did you mean 'omap_dss_get_next_device'? [-Werror=implicit-function-declaration]
     omapdss_output_unset_device(dssdev);
     ^~~~~~~~~~~~~~~~~~~~~~~~~~~
     omap_dss_get_next_device
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c: In function 'dsi_init_output':
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:5070:2: error: implicit declaration of function 'omapdss_register_output'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
     omapdss_register_output(out);
     ^~~~~~~~~~~~~~~~~~~~~~~
     omap_dispc_register_isr
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c: In function 'dsi_uninit_output':
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:5078:2: error: implicit declaration of function 'omapdss_unregister_output'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
     omapdss_unregister_output(out);
     ^~~~~~~~~~~~~~~~~~~~~~~~~
     omap_dispc_unregister_isr
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c: In function 'dsi_probe_of':
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:5092:7: error: implicit declaration of function 'omapdss_of_get_first_endpoint'; did you mean 'omapdss_get_version'? [-Werror=implicit-function-declaration]
     ep = omapdss_of_get_first_endpoint(node);
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          omapdss_get_version
   drivers/video/fbdev/omap2/omapfb/dss/dsi.c:5092:5: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     ep = omapdss_of_get_first_endpoint(node);
        ^
   cc1: some warnings being treated as errors
--
   drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c:441:13: sparse: undefined identifier 'omapdss_output_set_device'
   drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c:460:9: sparse: undefined identifier 'omapdss_output_unset_device'
   drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c:530:9: sparse: undefined identifier 'omapdss_register_output'
   drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c:537:9: sparse: undefined identifier 'omapdss_unregister_output'
   drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c:546:14: sparse: undefined identifier 'omapdss_of_get_first_endpoint'
>> drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c:441:38: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c:460:36: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c:530:32: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c:537:34: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c:546:43: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c: In function 'hdmi_connect':
   drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c:441:6: error: implicit declaration of function 'omapdss_output_set_device'; did you mean 'omap_dss_put_device'? [-Werror=implicit-function-declaration]
     r = omapdss_output_set_device(dssdev, dst);
         ^~~~~~~~~~~~~~~~~~~~~~~~~
         omap_dss_put_device
   drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c: In function 'hdmi_disconnect':
   drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c:460:2: error: implicit declaration of function 'omapdss_output_unset_device'; did you mean 'omap_dss_get_next_device'? [-Werror=implicit-function-declaration]
     omapdss_output_unset_device(dssdev);
     ^~~~~~~~~~~~~~~~~~~~~~~~~~~
     omap_dss_get_next_device
   drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c: In function 'hdmi_init_output':
   drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c:530:2: error: implicit declaration of function 'omapdss_register_output'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
     omapdss_register_output(out);
     ^~~~~~~~~~~~~~~~~~~~~~~
     omap_dispc_register_isr
   drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c: In function 'hdmi_uninit_output':
   drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c:537:2: error: implicit declaration of function 'omapdss_unregister_output'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
     omapdss_unregister_output(out);
     ^~~~~~~~~~~~~~~~~~~~~~~~~
     omap_dispc_unregister_isr
   drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c: In function 'hdmi_probe_of':
   drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c:546:7: error: implicit declaration of function 'omapdss_of_get_first_endpoint'; did you mean 'omapdss_get_version'? [-Werror=implicit-function-declaration]
     ep = omapdss_of_get_first_endpoint(node);
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          omapdss_get_version
   drivers/video/fbdev/omap2/omapfb/dss/hdmi4.c:546:5: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     ep = omapdss_of_get_first_endpoint(node);
        ^
   cc1: some warnings being treated as errors
--
   drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c:471:13: sparse: undefined identifier 'omapdss_output_set_device'
   drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c:490:9: sparse: undefined identifier 'omapdss_output_unset_device'
   drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c:560:9: sparse: undefined identifier 'omapdss_register_output'
   drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c:567:9: sparse: undefined identifier 'omapdss_unregister_output'
   drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c:576:14: sparse: undefined identifier 'omapdss_of_get_first_endpoint'
>> drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c:471:38: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c:490:36: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c:560:32: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c:567:34: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c:576:43: sparse: call with no type!
   drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c: In function 'hdmi_connect':
   drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c:471:6: error: implicit declaration of function 'omapdss_output_set_device'; did you mean 'omap_dss_put_device'? [-Werror=implicit-function-declaration]
     r = omapdss_output_set_device(dssdev, dst);
         ^~~~~~~~~~~~~~~~~~~~~~~~~
         omap_dss_put_device
   drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c: In function 'hdmi_disconnect':
   drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c:490:2: error: implicit declaration of function 'omapdss_output_unset_device'; did you mean 'omap_dss_get_next_device'? [-Werror=implicit-function-declaration]
     omapdss_output_unset_device(dssdev);
     ^~~~~~~~~~~~~~~~~~~~~~~~~~~
     omap_dss_get_next_device
   drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c: In function 'hdmi_init_output':
   drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c:560:2: error: implicit declaration of function 'omapdss_register_output'; did you mean 'omap_dispc_register_isr'? [-Werror=implicit-function-declaration]
     omapdss_register_output(out);
     ^~~~~~~~~~~~~~~~~~~~~~~
     omap_dispc_register_isr
   drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c: In function 'hdmi_uninit_output':
   drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c:567:2: error: implicit declaration of function 'omapdss_unregister_output'; did you mean 'omap_dispc_unregister_isr'? [-Werror=implicit-function-declaration]
     omapdss_unregister_output(out);
     ^~~~~~~~~~~~~~~~~~~~~~~~~
     omap_dispc_unregister_isr
   drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c: In function 'hdmi_probe_of':
   drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c:576:7: error: implicit declaration of function 'omapdss_of_get_first_endpoint'; did you mean 'omapdss_get_version'? [-Werror=implicit-function-declaration]
     ep = omapdss_of_get_first_endpoint(node);
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
          omapdss_get_version
   drivers/video/fbdev/omap2/omapfb/dss/hdmi5.c:576:5: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     ep = omapdss_of_get_first_endpoint(node);
        ^
   cc1: some warnings being treated as errors

vim +2396 drivers/video/fbdev/omap2/omapfb/omapfb-main.c

91ac27a68 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2010-09-23  2370  
5d89bcc34 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-08-06  2371  static int omapfb_init_connections(struct omapfb2_device *fbdev,
6b6f1edfd drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-12-04  2372  		struct omap_dss_device *def_dssdev)
5d89bcc34 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-08-06  2373  {
5d89bcc34 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-08-06  2374  	int i, r;
6b6f1edfd drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-12-04  2375  	struct omap_overlay_manager *mgr;
5d89bcc34 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-08-06  2376  
a7e71e7f9 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2013-05-08  2377  	r = def_dssdev->driver->connect(def_dssdev);
a7e71e7f9 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2013-05-08  2378  	if (r) {
a7e71e7f9 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2013-05-08  2379  		dev_err(fbdev->dev, "failed to connect default display\n");
a7e71e7f9 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2013-05-08  2380  		return r;
a7e71e7f9 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2013-05-08  2381  	}
a7e71e7f9 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2013-05-08  2382  
6b6f1edfd drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-12-04  2383  	for (i = 0; i < fbdev->num_displays; ++i) {
6b6f1edfd drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-12-04  2384  		struct omap_dss_device *dssdev = fbdev->displays[i].dssdev;
6b6f1edfd drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-12-04  2385  
a7e71e7f9 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2013-05-08  2386  		if (dssdev == def_dssdev)
be8e8e1c6 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2013-04-23  2387  			continue;
6b6f1edfd drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-12-04  2388  
a7e71e7f9 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2013-05-08  2389  		/*
a7e71e7f9 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2013-05-08  2390  		 * We don't care if the connect succeeds or not. We just want to
a7e71e7f9 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2013-05-08  2391  		 * connect as many displays as possible.
a7e71e7f9 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2013-05-08  2392  		 */
a7e71e7f9 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2013-05-08  2393  		dssdev->driver->connect(dssdev);
6b6f1edfd drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-12-04  2394  	}
6b6f1edfd drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-12-04  2395  
be8e8e1c6 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2013-04-23 @2396  	mgr = omapdss_find_mgr_from_display(def_dssdev);
6b6f1edfd drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-12-04  2397  
6b6f1edfd drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-12-04  2398  	if (!mgr) {
6b6f1edfd drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-12-04  2399  		dev_err(fbdev->dev, "no ovl manager for the default display\n");
6b6f1edfd drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-12-04  2400  		return -EINVAL;
6b6f1edfd drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-12-04  2401  	}
5d89bcc34 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-08-06  2402  
5d89bcc34 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-08-06  2403  	for (i = 0; i < fbdev->num_overlays; i++) {
5d89bcc34 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-08-06  2404  		struct omap_overlay *ovl = fbdev->overlays[i];
5d89bcc34 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-08-06  2405  
5d89bcc34 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-08-06  2406  		if (ovl->manager)
5d89bcc34 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-08-06  2407  			ovl->unset_manager(ovl);
5d89bcc34 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-08-06  2408  
5d89bcc34 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-08-06  2409  		r = ovl->set_manager(ovl, mgr);
5d89bcc34 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-08-06  2410  		if (r)
5d89bcc34 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-08-06  2411  			dev_warn(fbdev->dev,
5d89bcc34 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-08-06  2412  					"failed to connect overlay %s to manager %s\n",
5d89bcc34 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-08-06  2413  					ovl->name, mgr->name);
5d89bcc34 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-08-06  2414  	}
5d89bcc34 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-08-06  2415  
5d89bcc34 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-08-06  2416  	return 0;
5d89bcc34 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-08-06  2417  }
5d89bcc34 drivers/video/omap2/omapfb/omapfb-main.c Tomi Valkeinen 2012-08-06  2418  

:::::: The code at line 2396 was first introduced by commit
:::::: be8e8e1c62678765868c0bc7b8b5209c38af105c OMAPDSS: add helpers to get mgr or output from display

:::::: TO: Tomi Valkeinen <tomi.valkeinen@ti.com>
:::::: CC: Tomi Valkeinen <tomi.valkeinen@ti.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
