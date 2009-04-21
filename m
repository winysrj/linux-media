Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:60749 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbZDUE7n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2009 00:59:43 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Weng, Wending" <WWeng@rheinmetall.ca>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 21 Apr 2009 10:29:30 +0530
Subject: RE: need help for omap3 isp-camera interface
Message-ID: <19F8576C6E063C45BE387C64729E739404280C5D2C@dbde02.ent.ti.com>
References: <C01FCF206F5D8D4C89B210408D7DB39C29B6BA@mail2.oerlikon.ca>
In-Reply-To: <C01FCF206F5D8D4C89B210408D7DB39C29B6BA@mail2.oerlikon.ca>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Weng,

Thanks,
Vaibhav Hiremath
Platform Support Products
Texas Instruments Inc
Ph: +91-80-25099927

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Weng, Wending
> Sent: Tuesday, April 21, 2009 8:32 AM
> To: linux-media@vger.kernel.org
> Subject: need help for omap3 isp-camera interface
> 
> Hi All,
> 
>    I'm working on video image capture(omap3 isp) interface(PSP
> 1.0.2), and have met many difficulties. At the camera side, the 8
> bits BT656 signal are connected to cam_d[0-7], which looks OK. The
> cam_fld, cam_hs and cam_vs are also connected, At the omap3 side, I
> use saMmapLoopback.c, it runs, however, it receives only HS_VS_IRQ,
> but no any image data. I checked FLDSTAT(CCDC_SYN_MODE), it's never
> changed.


[Hiremath, Vaibhav] Depends on above description I believe you are using 8 bit interface in BT656 mode, where CAM[0-7] goes to OMAP_CAM[0-7].

You will have to check for data_shift register configuration, look into the function "omap34xxcamisp_configure_interface" where we are configuring this value. 

In PSP1.0.2 the configuration -
------------------------------
Interface - TVP[0-9] -> CAM[D2-D11]
CCDC_SYN_MODE.INMODE[12-13] = 0x2 --> YCbCr data in 8 bit mode
TVP5146 FMT1[ --> Configured to 10 bit 4:2:2 mode
ISP_CNTRL.SHIFT[6-7] = 0x2 --> 4 bit shift, CamExt[13-4] -> Cam[9-0]

With above configuration we are ignoring 2 LSB's from TVP5146 and processing 8bits (MSB's) coming from it.
 

For your configuration -
----------------------
Interface - CAM_BT[7-0] --> CAM[7-0]
CCDC_SYN_MODE.INMODE[12-13] = 0x2 --> YCbCr data in 8 bit mode
ISP_CNTRL.SHIFT[6-7] = 0x0 --> 0 bit shift, CamExt[13-0] -> Cam[13-0]

It should work.


> Right now, I don't know what to check, if you can give some
> suggestions, your help will be greatly appreciated. Thanks in
> advance.
> 
> Wending Weng
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

