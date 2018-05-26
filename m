Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:23919 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1032327AbeEZT6u (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 May 2018 15:58:50 -0400
Date: Sun, 27 May 2018 03:58:03 +0800
From: kbuild test robot <lkp@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org
Subject: [ragnatech:media-tree 167/415]
 drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:45:6: error:
 implicit declaration of function 'omapdss_device_is_connected'; did you mean
 'pci_device_is_present'?
Message-ID: <201805270358.LIq02dA3%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   git://git.ragnatech.se/linux media-tree
head:   e646e17713eeb3b6484b6d7a24ce34854123fa39
commit: 771f7be87ff921e9a3d744febd606af39a150e14 [167/415] media: omapfb: omapfb_dss.h: add stubs to build with COMPILE_TEST && DRM_OMAP
config: s390-allmodconfig (attached as .config)
compiler: s390x-linux-gnu-gcc (Debian 7.2.0-11) 7.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git checkout 771f7be87ff921e9a3d744febd606af39a150e14
        # save the attached .config to linux build tree
        make.cross ARCH=s390 

Note: the ragnatech/media-tree HEAD e646e17713eeb3b6484b6d7a24ce34854123fa39 builds fine.
      It only hurts bisectibility.

All errors (new ones prefixed by >>):

   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c: In function 'opa362_connect':
>> drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:45:6: error: implicit declaration of function 'omapdss_device_is_connected'; did you mean 'pci_device_is_present'? [-Werror=implicit-function-declaration]
     if (omapdss_device_is_connected(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
         pci_device_is_present
   drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c: In function 'opa362_enable':
>> drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c:91:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'pci_dev_msi_enabled'? [-Werror=implicit-function-declaration]
     if (omapdss_device_is_enabled(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~
         pci_dev_msi_enabled
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
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c: In function 'tfp410_connect':
>> drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:39:6: error: implicit declaration of function 'omapdss_device_is_connected'; did you mean 'pci_device_is_present'? [-Werror=implicit-function-declaration]
     if (omapdss_device_is_connected(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
         pci_device_is_present
   drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c: In function 'tfp410_enable':
>> drivers/video/fbdev/omap2/omapfb/displays/encoder-tfp410.c:81:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'pci_dev_msi_enabled'? [-Werror=implicit-function-declaration]
     if (omapdss_device_is_enabled(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~
         pci_dev_msi_enabled
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
   drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c: In function 'hdmic_connect':
>> drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:60:6: error: implicit declaration of function 'omapdss_device_is_connected'; did you mean 'pci_device_is_present'? [-Werror=implicit-function-declaration]
     if (omapdss_device_is_connected(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
         pci_device_is_present
   drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c: In function 'hdmic_enable':
>> drivers/video/fbdev/omap2/omapfb/displays/connector-hdmi.c:94:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'pci_dev_msi_enabled'? [-Werror=implicit-function-declaration]
     if (omapdss_device_is_enabled(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~
         pci_dev_msi_enabled
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
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c: In function 'panel_dpi_connect':
>> drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:45:6: error: implicit declaration of function 'omapdss_device_is_connected'; did you mean 'pci_device_is_present'? [-Werror=implicit-function-declaration]
     if (omapdss_device_is_connected(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
         pci_device_is_present
   drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c: In function 'panel_dpi_enable':
>> drivers/video/fbdev/omap2/omapfb/displays/panel-dpi.c:75:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'pci_dev_msi_enabled'? [-Werror=implicit-function-declaration]
     if (omapdss_device_is_enabled(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~
         pci_dev_msi_enabled
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
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c: In function 'dsicm_connect':
>> drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:715:6: error: implicit declaration of function 'omapdss_device_is_connected'; did you mean 'pci_device_is_present'? [-Werror=implicit-function-declaration]
     if (omapdss_device_is_connected(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
         pci_device_is_present
   drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c: In function 'dsicm_enable':
>> drivers/video/fbdev/omap2/omapfb/displays/panel-dsi-cm.c:772:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'pci_dev_msi_enabled'? [-Werror=implicit-function-declaration]
     if (omapdss_device_is_enabled(dssdev)) {
         ^~~~~~~~~~~~~~~~~~~~~~~~~
         pci_dev_msi_enabled
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
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c: In function 'acx565akm_connect':
>> drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:522:6: error: implicit declaration of function 'omapdss_device_is_connected'; did you mean 'pci_device_is_present'? [-Werror=implicit-function-declaration]
     if (omapdss_device_is_connected(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
         pci_device_is_present
   drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c: In function 'acx565akm_enable':
>> drivers/video/fbdev/omap2/omapfb/displays/panel-sony-acx565akm.c:634:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'pci_dev_msi_enabled'? [-Werror=implicit-function-declaration]
     if (omapdss_device_is_enabled(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~
         pci_dev_msi_enabled
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
   drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c: In function 'lb035q02_connect':
>> drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:126:6: error: implicit declaration of function 'omapdss_device_is_connected'; did you mean 'pci_device_is_present'? [-Werror=implicit-function-declaration]
     if (omapdss_device_is_connected(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
         pci_device_is_present
   drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c: In function 'lb035q02_enable':
>> drivers/video/fbdev/omap2/omapfb/displays/panel-lgphilips-lb035q02.c:158:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'pci_dev_msi_enabled'? [-Werror=implicit-function-declaration]
     if (omapdss_device_is_enabled(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~
         pci_dev_msi_enabled
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
   drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c: In function 'sharp_ls_connect':
>> drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:67:6: error: implicit declaration of function 'omapdss_device_is_connected'; did you mean 'pci_device_is_present'? [-Werror=implicit-function-declaration]
     if (omapdss_device_is_connected(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
         pci_device_is_present
   drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c: In function 'sharp_ls_enable':
>> drivers/video/fbdev/omap2/omapfb/displays/panel-sharp-ls037v7dw01.c:97:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'pci_dev_msi_enabled'? [-Werror=implicit-function-declaration]
     if (omapdss_device_is_enabled(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~
         pci_dev_msi_enabled
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
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c: In function 'td028ttec1_panel_connect':
>> drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c:175:6: error: implicit declaration of function 'omapdss_device_is_connected'; did you mean 'pci_device_is_present'? [-Werror=implicit-function-declaration]
     if (omapdss_device_is_connected(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
         pci_device_is_present
   drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c: In function 'td028ttec1_panel_enable':
>> drivers/video/fbdev/omap2/omapfb/displays/panel-tpo-td028ttec1.c:205:6: error: implicit declaration of function 'omapdss_device_is_enabled'; did you mean 'pci_dev_msi_enabled'? [-Werror=implicit-function-declaration]
     if (omapdss_device_is_enabled(dssdev))
         ^~~~~~~~~~~~~~~~~~~~~~~~~
         pci_dev_msi_enabled
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
..

vim +45 drivers/video/fbdev/omap2/omapfb/displays/encoder-opa362.c

f76ee892 Tomi Valkeinen 2015-12-09   35  
f76ee892 Tomi Valkeinen 2015-12-09   36  static int opa362_connect(struct omap_dss_device *dssdev,
f76ee892 Tomi Valkeinen 2015-12-09   37  		struct omap_dss_device *dst)
f76ee892 Tomi Valkeinen 2015-12-09   38  {
f76ee892 Tomi Valkeinen 2015-12-09   39  	struct panel_drv_data *ddata = to_panel_data(dssdev);
f76ee892 Tomi Valkeinen 2015-12-09   40  	struct omap_dss_device *in = ddata->in;
f76ee892 Tomi Valkeinen 2015-12-09   41  	int r;
f76ee892 Tomi Valkeinen 2015-12-09   42  
f76ee892 Tomi Valkeinen 2015-12-09   43  	dev_dbg(dssdev->dev, "connect\n");
f76ee892 Tomi Valkeinen 2015-12-09   44  
f76ee892 Tomi Valkeinen 2015-12-09  @45  	if (omapdss_device_is_connected(dssdev))
f76ee892 Tomi Valkeinen 2015-12-09   46  		return -EBUSY;
f76ee892 Tomi Valkeinen 2015-12-09   47  
f76ee892 Tomi Valkeinen 2015-12-09   48  	r = in->ops.atv->connect(in, dssdev);
f76ee892 Tomi Valkeinen 2015-12-09   49  	if (r)
f76ee892 Tomi Valkeinen 2015-12-09   50  		return r;
f76ee892 Tomi Valkeinen 2015-12-09   51  
f76ee892 Tomi Valkeinen 2015-12-09   52  	dst->src = dssdev;
f76ee892 Tomi Valkeinen 2015-12-09   53  	dssdev->dst = dst;
f76ee892 Tomi Valkeinen 2015-12-09   54  
f76ee892 Tomi Valkeinen 2015-12-09   55  	return 0;
f76ee892 Tomi Valkeinen 2015-12-09   56  }
f76ee892 Tomi Valkeinen 2015-12-09   57  
f76ee892 Tomi Valkeinen 2015-12-09   58  static void opa362_disconnect(struct omap_dss_device *dssdev,
f76ee892 Tomi Valkeinen 2015-12-09   59  		struct omap_dss_device *dst)
f76ee892 Tomi Valkeinen 2015-12-09   60  {
f76ee892 Tomi Valkeinen 2015-12-09   61  	struct panel_drv_data *ddata = to_panel_data(dssdev);
f76ee892 Tomi Valkeinen 2015-12-09   62  	struct omap_dss_device *in = ddata->in;
f76ee892 Tomi Valkeinen 2015-12-09   63  
f76ee892 Tomi Valkeinen 2015-12-09   64  	dev_dbg(dssdev->dev, "disconnect\n");
f76ee892 Tomi Valkeinen 2015-12-09   65  
f76ee892 Tomi Valkeinen 2015-12-09   66  	WARN_ON(!omapdss_device_is_connected(dssdev));
f76ee892 Tomi Valkeinen 2015-12-09   67  	if (!omapdss_device_is_connected(dssdev))
f76ee892 Tomi Valkeinen 2015-12-09   68  		return;
f76ee892 Tomi Valkeinen 2015-12-09   69  
f76ee892 Tomi Valkeinen 2015-12-09   70  	WARN_ON(dst != dssdev->dst);
f76ee892 Tomi Valkeinen 2015-12-09   71  	if (dst != dssdev->dst)
f76ee892 Tomi Valkeinen 2015-12-09   72  		return;
f76ee892 Tomi Valkeinen 2015-12-09   73  
f76ee892 Tomi Valkeinen 2015-12-09   74  	dst->src = NULL;
f76ee892 Tomi Valkeinen 2015-12-09   75  	dssdev->dst = NULL;
f76ee892 Tomi Valkeinen 2015-12-09   76  
f76ee892 Tomi Valkeinen 2015-12-09   77  	in->ops.atv->disconnect(in, &ddata->dssdev);
f76ee892 Tomi Valkeinen 2015-12-09   78  }
f76ee892 Tomi Valkeinen 2015-12-09   79  
f76ee892 Tomi Valkeinen 2015-12-09   80  static int opa362_enable(struct omap_dss_device *dssdev)
f76ee892 Tomi Valkeinen 2015-12-09   81  {
f76ee892 Tomi Valkeinen 2015-12-09   82  	struct panel_drv_data *ddata = to_panel_data(dssdev);
f76ee892 Tomi Valkeinen 2015-12-09   83  	struct omap_dss_device *in = ddata->in;
f76ee892 Tomi Valkeinen 2015-12-09   84  	int r;
f76ee892 Tomi Valkeinen 2015-12-09   85  
f76ee892 Tomi Valkeinen 2015-12-09   86  	dev_dbg(dssdev->dev, "enable\n");
f76ee892 Tomi Valkeinen 2015-12-09   87  
f76ee892 Tomi Valkeinen 2015-12-09   88  	if (!omapdss_device_is_connected(dssdev))
f76ee892 Tomi Valkeinen 2015-12-09   89  		return -ENODEV;
f76ee892 Tomi Valkeinen 2015-12-09   90  
f76ee892 Tomi Valkeinen 2015-12-09  @91  	if (omapdss_device_is_enabled(dssdev))
f76ee892 Tomi Valkeinen 2015-12-09   92  		return 0;
f76ee892 Tomi Valkeinen 2015-12-09   93  
f76ee892 Tomi Valkeinen 2015-12-09   94  	in->ops.atv->set_timings(in, &ddata->timings);
f76ee892 Tomi Valkeinen 2015-12-09   95  
f76ee892 Tomi Valkeinen 2015-12-09   96  	r = in->ops.atv->enable(in);
f76ee892 Tomi Valkeinen 2015-12-09   97  	if (r)
f76ee892 Tomi Valkeinen 2015-12-09   98  		return r;
f76ee892 Tomi Valkeinen 2015-12-09   99  
f76ee892 Tomi Valkeinen 2015-12-09  100  	if (ddata->enable_gpio)
f76ee892 Tomi Valkeinen 2015-12-09  101  		gpiod_set_value_cansleep(ddata->enable_gpio, 1);
f76ee892 Tomi Valkeinen 2015-12-09  102  
f76ee892 Tomi Valkeinen 2015-12-09  103  	dssdev->state = OMAP_DSS_DISPLAY_ACTIVE;
f76ee892 Tomi Valkeinen 2015-12-09  104  
f76ee892 Tomi Valkeinen 2015-12-09  105  	return 0;
f76ee892 Tomi Valkeinen 2015-12-09  106  }
f76ee892 Tomi Valkeinen 2015-12-09  107  

:::::: The code at line 45 was first introduced by commit
:::::: f76ee892a99e68b55402b8d4b8aeffcae2aff34d omapfb: copy omapdss & displays for omapfb

:::::: TO: Tomi Valkeinen <tomi.valkeinen@ti.com>
:::::: CC: Tomi Valkeinen <tomi.valkeinen@ti.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--liOOAslEiF7prFVr
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--liOOAslEiF7prFVr--
