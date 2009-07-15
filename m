Return-path: <linux-media-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:44934 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114AbZGOVoi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jul 2009 17:44:38 -0400
Received: by an-out-0708.google.com with SMTP id d40so7696759and.1
        for <linux-media@vger.kernel.org>; Wed, 15 Jul 2009 14:44:37 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 15 Jul 2009 17:44:37 -0400
Message-ID: <bb2708720907151444l3a93bcb3y75d227c4828ec311@mail.gmail.com>
Subject: Help bringing up a sensor driver for isp omap34xx.c
From: John Sarman <johnsarman@gmail.com>
To: sakari.ailus@nokia.com, Sameer Venkatraman <sameerv@ti.com>,
	Mohit Jalori <mjalori@ti.com>,
	Sergio Aguirre <saaguirre@ti.com>,
	Tuukka Toivonen <tuukka.o.toivonen@nokia.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
   I am having a problem deciphering what is wrong with my sensor
driver.  It seems that everything operates on the driver but that I am
getting buffer overflows.  I have fully tested the image sensor and it
is set to operate in 640x480 mode. currently it is like 648x 487 for
the dummy pixels and lines.  I have enabled all the debugging #defines
in the latest code from the gitorious repository.  I also had to edit
a few debug statements because they cause the compile to fail. Those
failures were due to the resizer rewrite and since the #defines were
commented out that code was never compiled.  Anyways here is my dmesg
after I open and select the /dev/video0.

I have been banging my head against a wall for 2 weeks now.

Thanks,

OV5620: ioctl_g_priv
OV5620: ov5620_probe
OV5620: ioctl_g_priv
OV5620: ioctl_g_priv
OV5620: ioctl_g_priv
OV5620: ioctl_g_priv
ISPCTRL: isp_get: old 0
ISPCCDC: Restoring context
ISPHIST:  Restoring context
ISPH3A:  Restoring context
ISPPREV: Restoring context
ISPRESZ: Restoring context
ISPCTRL: isp_get: new 1
OV5620: ioctl_s_power
ISPCTRL: isp_set_xclk(): cam_xclka set to 24000000 Hz
BOARD_OVERO_CAMERA: Switching Power to 1
OV5620: POWER ON
OV5620: Sensor not detected, calling ioctl_dev_init(s)
OV5620: ioctl_dev_init
ov5620:detect
ov5620 3-0030: model id detected 0x5621 mfr 0x7fa2
ov5620 3-0030: Chip version 0x02 detected
OV5620: Sensor Detected, calling configure
ov5620:configure
OV5620: ioctl_g_fmt_cap
OV5620: ioctl_s_power
OV5620: POWER OFF
BOARD_OVERO_CAMERA: Switching Power to 0
OV5620: POWER OFF
ISPCTRL: isp_set_xclk(): cam_xclka set to 0 Hz
ISPCTRL: isp_put: old 1
ISPCCDC: Saving context
ISPHIST:  Saving context
ISPH3A:  Saving context
ISPPREV: Saving context
ISPRESZ: Saving context
ISPCCDC: ISP_ERR: CCDC Module already freed
ISPRESZ: ISP_ERR : Resizer Module already freed
ISPCTRL: isp_put: new 0
ISPCTRL: isp_get: old 0
ISPCCDC: Restoring context
ISPHIST:  Restoring context
ISPH3A:  Restoring context
ISPPREV: Restoring context
ISPRESZ: Restoring context
ISPCTRL: isp_get: new 1
OV5620: ioctl_s_power
ISPCTRL: isp_set_xclk(): cam_xclka set to 24000000 Hz
BOARD_OVERO_CAMERA: Switching Power to 1
OV5620: POWER ON
OV5620: Sensor Detected, calling configure
ov5620:configure
OV5620: ioctl_s_power
BOARD_OVERO_CAMERA: Switching Power to 2
OV5620: POWER STANDBY
ISPCTRL: isp_set_xclk(): cam_xclka set to 0 Hz
OV5620: ioctl_g_fmt_cap
OV5620: ioctl_enum_fmt_cap
OV5620: ioctl_enum_fmt_cap index 0 type 1
OV5620: ioctl_enum_framesizes
OV5620: ioctl_enum_frameintervals
OV5620:frmi->index = 0
OV5620: ioctl_enum_frameintervals
OV5620: ioctl_enum_framesizes
OV5620: ioctl_enum_frameintervals
OV5620:frmi->index = 0
OV5620: ioctl_enum_frameintervals
OV5620: ioctl_enum_framesizes
OV5620: ioctl_enum_fmt_cap
OV5620: ioctl_enum_fmt_cap index 1 type 1
ISPCCDC: ISP_ERR: CCDC Module already freed
ISPRESZ: ISP_ERR : Resizer Module already freed
ISPCCDC: Module in use =1
ISPCCDC: Accepted CCDC Input (width = 640,Height = 480)
ISPCCDC: Accepted CCDC Output (width = 640,Height = 479)
ISPCCDC: ###CCDC PCR=0x0
ISPCCDC: ISP_CTRL =0x39e150
ISPCCDC: ccdc input format is CCDC_RAW
ISPCCDC: ccdc output format is CCDC_OTHERS_VP
ISPCCDC: ###ISP_CTRL in ccdc =0x39e150
ISPCCDC: ###ISP_IRQ0ENABLE in ccdc =0x0
ISPCCDC: ###ISP_IRQ0STATUS in ccdc =0x82000000
ISPCCDC: ###CCDC SYN_MODE=0x10600
ISPCCDC: ###CCDC HORZ_INFO=0x27f
ISPCCDC: ###CCDC VERT_START=0x0
ISPCCDC: ###CCDC VERT_LINES=0x1df
ISPCCDC: ###CCDC CULLING=0xffff00ff
ISPCCDC: ###CCDC HSIZE_OFF=0x500
ISPCCDC: ###CCDC SDOFST=0x0
ISPCCDC: ###CCDC SDR_ADDR=0x266000
ISPCCDC: ###CCDC CLAMP=0x10
ISPCCDC: ###CCDC COLPTN=0xbb11bb11
ISPCCDC: ###CCDC CFG=0x8000
ISPCCDC: ###CCDC VP_OUT=0x77c5000
ISPCCDC: ###CCDC_SDR_ADDR= 0x266000
ISPCCDC: ###CCDC FMTCFG=0xe000
ISPCCDC: ###CCDC FMT_HORZ=0x500
ISPCCDC: ###CCDC FMT_VERT=0x3c0
ISPCCDC: ###CCDC LSC_CONFIG=0x6608
ISPCCDC: ###CCDC LSC_INIT=0x0
ISPCCDC: ###CCDC LSC_TABLE BASE=0x1000
ISPCCDC: ###CCDC LSC TABLE OFFSET=0x60
ISPCTRL: ###ISP_CTRL=0x39e150
ISPCTRL: ###ISP_TCTRL_CTRL=0x0
ISPCTRL: ###ISP_SYSCONFIG=0x2000
ISPCTRL: ###ISP_SYSSTATUS=0x1
ISPCTRL: ###ISP_IRQ0ENABLE=0x0
ISPCTRL: ###ISP_IRQ0STATUS=0x82000000
ISPPREV: 	Configuring brightness in ISP: 0
ISPRESZ: ispresizer_config_datapath()+
ISPRESZ: ispresizer_config_ycpos()+
ISPRESZ: ispresizer_config_ycpos()-
ISPRESZ: ispresizer_config_filter_coef()+
ISPRESZ: ispresizer_config_filter_coef()-
ISPRESZ: ispresizer_enable_cbilin()+
ISPRESZ: ispresizer_enable_cbilin()-
ISPRESZ: ispresizer_config_luma_enhance()+
ISPRESZ: ispresizer_config_luma_enhance()-
ISPRESZ: ispresizer_config_datapath()-
ISPRESZ: ispresizer_config_inlineoffset()+
ISPRESZ: ispresizer_config_inlineoffset()-
ISPRESZ: ispresizer_set_inaddr()+
ISPRESZ: ispresizer_set_inaddr()-
ISPRESZ: ispresizer_config_outlineoffset()+
ISPRESZ: ispresizer_config_outlineoffset()-
ISPRESZ: ispresizer_config_ycpos()+
ISPRESZ: ispresizer_config_ycpos()-
ISPRESZ: ispresizer_config_size()-
OV5620: ioctl_g_fmt_cap
OV5620: ioctl_s_fmt_cap
OV5620: ioctl_try_fmt_cap
OV5620: ioctl_try_fmt_cap before WIDTH = 640
OV5620: ioctl_try_fmt_cap before HEIGHT = 480
OV5620: ioctl_try_fmt_cap WIDTH = 640
OV5620: ioctl_try_fmt_cap HEIGHT = 480
OV5620: ioctl_s_parm
OV5620 desired_fps = 60
OV5620: ioctl_g_fmt_cap
ISPRESZ: ispresizer_config_datapath()+
ISPRESZ: ispresizer_config_ycpos()+
ISPRESZ: ispresizer_config_ycpos()-
ISPRESZ: ispresizer_config_filter_coef()+
ISPRESZ: ispresizer_config_filter_coef()-
ISPRESZ: ispresizer_enable_cbilin()+
ISPRESZ: ispresizer_enable_cbilin()-
ISPRESZ: ispresizer_config_luma_enhance()+
ISPRESZ: ispresizer_config_luma_enhance()-
ISPRESZ: ispresizer_config_datapath()-
ISPRESZ: ispresizer_config_inlineoffset()+
ISPRESZ: ispresizer_config_inlineoffset()-
ISPRESZ: ispresizer_set_inaddr()+
ISPRESZ: ispresizer_set_inaddr()-
ISPRESZ: ispresizer_config_outlineoffset()+
ISPRESZ: ispresizer_config_outlineoffset()-
ISPRESZ: ispresizer_config_ycpos()+
ISPRESZ: ispresizer_config_ycpos()-
ISPRESZ: ispresizer_config_size()-
OV5620: ioctl_enum_fmt_cap
OV5620: ioctl_enum_fmt_cap index 0 type 1
OV5620: ioctl_enum_framesizes
OV5620: ioctl_enum_frameintervals
OV5620:frmi->index = 0
OV5620: ioctl_enum_frameintervals
OV5620: ioctl_enum_framesizes
OV5620: ioctl_enum_frameintervals
OV5620:frmi->index = 0
OV5620: ioctl_enum_frameintervals
OV5620: ioctl_enum_framesizes
OV5620: ioctl_enum_fmt_cap
OV5620: ioctl_enum_fmt_cap index 1 type 1
ISPCCDC: Module in use =1
ISPCCDC: Accepted CCDC Input (width = 640,Height = 480)
ISPCCDC: Accepted CCDC Output (width = 640,Height = 479)
ISPCCDC: ###CCDC PCR=0x0
ISPCCDC: ISP_CTRL =0x29c150
ISPCCDC: ccdc input format is CCDC_RAW
ISPCCDC: ccdc output format is CCDC_OTHERS_VP
ISPCCDC: ###ISP_CTRL in ccdc =0x29c150
ISPCCDC: ###ISP_IRQ0ENABLE in ccdc =0x0
ISPCCDC: ###ISP_IRQ0STATUS in ccdc =0x82000000
ISPCCDC: ###CCDC SYN_MODE=0x10600
ISPCCDC: ###CCDC HORZ_INFO=0x27f
ISPCCDC: ###CCDC VERT_START=0x0
ISPCCDC: ###CCDC VERT_LINES=0x1df
ISPCCDC: ###CCDC CULLING=0xffff00ff
ISPCCDC: ###CCDC HSIZE_OFF=0x500
ISPCCDC: ###CCDC SDOFST=0x0
ISPCCDC: ###CCDC SDR_ADDR=0x266000
ISPCCDC: ###CCDC CLAMP=0x10
ISPCCDC: ###CCDC COLPTN=0xbb11bb11
ISPCCDC: ###CCDC CFG=0x8000
ISPCCDC: ###CCDC VP_OUT=0x3bc2800
ISPCCDC: ###CCDC_SDR_ADDR= 0x266000
ISPCCDC: ###CCDC FMTCFG=0xe000
ISPCCDC: ###CCDC FMT_HORZ=0x280
ISPCCDC: ###CCDC FMT_VERT=0x1e0
ISPCCDC: ###CCDC LSC_CONFIG=0x6608
ISPCCDC: ###CCDC LSC_INIT=0x0
ISPCCDC: ###CCDC LSC_TABLE BASE=0x1000
ISPCCDC: ###CCDC LSC TABLE OFFSET=0x60
ISPCTRL: ###ISP_CTRL=0x29c150
ISPCTRL: ###ISP_TCTRL_CTRL=0x0
ISPCTRL: ###ISP_SYSCONFIG=0x2000
ISPCTRL: ###ISP_SYSSTATUS=0x1
ISPCTRL: ###ISP_IRQ0ENABLE=0x0
ISPCTRL: ###ISP_IRQ0STATUS=0x82000000
ISPPREV: 	Configuring brightness in ISP: 0
ISPRESZ: ispresizer_config_datapath()+
ISPRESZ: ispresizer_config_ycpos()+
ISPRESZ: ispresizer_config_ycpos()-
ISPRESZ: ispresizer_config_filter_coef()+
ISPRESZ: ispresizer_config_filter_coef()-
ISPRESZ: ispresizer_enable_cbilin()+
ISPRESZ: ispresizer_enable_cbilin()-
ISPRESZ: ispresizer_config_luma_enhance()+
ISPRESZ: ispresizer_config_luma_enhance()-
ISPRESZ: ispresizer_config_datapath()-
ISPRESZ: ispresizer_config_inlineoffset()+
ISPRESZ: ispresizer_config_inlineoffset()-
ISPRESZ: ispresizer_set_inaddr()+
ISPRESZ: ispresizer_set_inaddr()-
ISPRESZ: ispresizer_config_outlineoffset()+
ISPRESZ: ispresizer_config_outlineoffset()-
ISPRESZ: ispresizer_config_ycpos()+
ISPRESZ: ispresizer_config_ycpos()-
ISPRESZ: ispresizer_config_size()-
OV5620: ioctl_g_fmt_cap
OV5620: ioctl_s_fmt_cap
OV5620: ioctl_try_fmt_cap
OV5620: ioctl_try_fmt_cap before WIDTH = 640
OV5620: ioctl_try_fmt_cap before HEIGHT = 480
OV5620: ioctl_try_fmt_cap WIDTH = 640
OV5620: ioctl_try_fmt_cap HEIGHT = 480
OV5620: ioctl_s_parm
OV5620 desired_fps = 60
ISPRESZ: ispresizer_set_inaddr()+
ISPRESZ: ispresizer_set_inaddr()-
OV5620: ioctl_s_power
ISPCTRL: isp_set_xclk(): cam_xclka set to 24000000 Hz
BOARD_OVERO_CAMERA: Switching Power to 1
OV5620: POWER ON
OV5620: Sensor Detected, calling configure
ov5620:configure
ISPCTRL: <1>isp_buf_queue: queue 0 vb 0, mmu 000a4000
ISPCTRL: <1>isp_buf_queue: queue 1 vb 1, mmu 0013a000
ISPCTRL: <1>isp_buf_queue: queue 2 vb 2, mmu 001d0000
ISPCTRL: <1>isp_buf_queue: queue 3 vb 3, mmu 00266000
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPCTRL: HS_VS_IRQ <6>ISPCTRL: OVF_IRQ <6>ISPCTRL:
ISPH3A:     H3A disabled
ISPHIST:    histogram disabled
ISPRESZ: +ispresizer_enable()+
ISPRESZ: +ispresizer_enable()-
omap3isp omap3isp: __isp_disable_modules: can't stop ccdc
ISPCCDC: Saving context
ISPHIST:  Saving context
ISPH3A:  Saving context
ISPPREV: Saving context
ISPRESZ: Saving context
ISPCCDC: Restoring context
ISPHIST:  Restoring context
ISPH3A:  Restoring context
ISPPREV: Restoring context
ISPRESZ: Restoring context
OV5620: ioctl_s_power
BOARD_OVERO_CAMERA: Switching Power to 2
OV5620: POWER STANDBY
ISPCTRL: isp_set_xclk(): cam_xclka set to 0 Hz
OV5620: ioctl_s_power
OV5620: POWER OFF
BOARD_OVERO_CAMERA: Switching Power to 0
OV5620: POWER OFF
ISPCTRL: isp_set_xclk(): cam_xclka set to 0 Hz
ISPCTRL: isp_put: old 1
ISPCCDC: Saving context
ISPHIST:  Saving context
ISPH3A:  Saving context
ISPPREV: Saving context
ISPRESZ: Saving context
ISPCTRL: isp_put: new 0
