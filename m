Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms01.sssup.it ([193.205.80.99]:41936 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751815AbZJEAbQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Oct 2009 20:31:16 -0400
Message-ID: <4AC93DC9.2080809@panicking.kicks-ass.org>
Date: Mon, 05 Oct 2009 02:28:57 +0200
From: michael <michael@panicking.kicks-ass.org>
MIME-Version: 1.0
To: Nishanth Menon <menon.nishanth@gmail.com>
CC: linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: ISP OMAP3 camera support ov7690
References: <4AC7DAAD.2020203@panicking.kicks-ass.org> <4AC8B764.2030101@gmail.com>
In-Reply-To: <4AC8B764.2030101@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

cc: linux-media

Nishanth Menon wrote:
> michael said the following on 10/03/2009 06:13 PM:
>> I'm writing a driver to support the ov7690 camera and I have some
>> question about the meaning of:
>>
>> - datalane configuration
> CSI2 Data lanes - each CSI2 lane is a differential pair. And, at least 1
> clock and data lane is used in devices.

Sorry can you explain a little bit more. I have the camera connected to the
cam_hs and cam_vs and the data is 8Bit. I use the the isp init
structure. The sccb bus works great and I can send configuration to it,
but I don't receive any interrupt from the ics, seems that it doen't see
the transaction:

The ISPCCDC: ###CCDC SYN_MODE=0x31704 seems ok.


static struct isp_interface_config ov7690_if_config = {
        .ccdc_par_ser           = ISP_CSIA,
        .dataline_shift         = 0x0,
        .hsvs_syncdetect        = ISPCTRL_SYNC_DETECT_VSFALL,
        .strobe                 = 0x0,
        .prestrobe              = 0x0,
        .shutter                = 0x0,
        .wenlog                 = ISPCCDC_CFG_WENLOG_AND,
        .wait_hs_vs             = 0x4,
        .raw_fmt_in             = ISPCCDC_INPUT_FMT_GR_BG,
        .u.csi.crc              = 0x0,
        .u.csi.mode             = 0x0,
        .u.csi.edge             = 0x0,
        .u.csi.signalling       = 0x0,
        .u.csi.strobe_clock_inv = 0x0,
        .u.csi.vs_edge          = 0x0,
        .u.csi.channel          = 0x0,
        .u.csi.vpclk            = 0x1,
        .u.csi.data_start       = 0x0,
        .u.csi.data_size        = 0x0,
        .u.csi.format           = V4L2_PIX_FMT_YUYV,
};

and I don't know the meaning of

lanecfg.clk.pol = OV7690_CSI2_CLOCK_POLARITY;
lanecfg.clk.pos = OV7690_CSI2_CLOCK_LANE;
lanecfg.data[0].pol = OV7690_CSI2_DATA0_POLARITY;
lanecfg.data[0].pos = OV7690_CSI2_DATA0_LANE;
lanecfg.data[1].pol = OV7690_CSI2_DATA1_POLARITY;
lanecfg.data[1].pos = OV7690_CSI2_DATA1_LANE;
lanecfg.data[2].pol = 0;
lanecfg.data[2].pos = 0;
lanecfg.data[3].pol = 0;
lanecfg.data[3].pos = 0;

>> - phyconfiguration
> PHY - Physical timing configurations. btw, if it is camera specific you
> could get a lot of inputs from [1].

Ok I wil ask to them.

> 
> Regards,
> Nishanth Menon
> 
> Ref:
> [1] http://vger.kernel.org/vger-lists.html#linux-media
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Michael
