Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:53525 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119AbZJEWYu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Oct 2009 18:24:50 -0400
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: michael <michael@panicking.kicks-ass.org>,
	Nishanth Menon <menon.nishanth@gmail.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 5 Oct 2009 17:23:21 -0500
Subject: RE: ISP OMAP3 camera support ov7690
Message-ID: <A24693684029E5489D1D202277BE89444CB3A2CB@dlee02.ent.ti.com>
References: <4AC7DAAD.2020203@panicking.kicks-ass.org>
 <4AC8B764.2030101@gmail.com> <4AC93DC9.2080809@panicking.kicks-ass.org>
In-Reply-To: <4AC93DC9.2080809@panicking.kicks-ass.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael, 

> -----Original Message-----
> From: linux-omap-owner@vger.kernel.org 
> [mailto:linux-omap-owner@vger.kernel.org] On Behalf Of michael
> Sent: Sunday, October 04, 2009 7:29 PM
> To: Nishanth Menon
> Cc: linux-omap@vger.kernel.org; linux-media@vger.kernel.org
> Subject: Re: ISP OMAP3 camera support ov7690
> 
> Hi,
> 
> cc: linux-media
> 
> Nishanth Menon wrote:
> > michael said the following on 10/03/2009 06:13 PM:
> >> I'm writing a driver to support the ov7690 camera and I have some
> >> question about the meaning of:
> >>
> >> - datalane configuration
> > CSI2 Data lanes - each CSI2 lane is a differential pair. 
> And, at least 1
> > clock and data lane is used in devices.
> 
> Sorry can you explain a little bit more. I have the camera 
> connected to the
> cam_hs and cam_vs and the data is 8Bit. I use the the isp init
> structure. The sccb bus works great and I can send 
> configuration to it,
> but I don't receive any interrupt from the ics, seems that it 
> doen't see
> the transaction:
> 
> The ISPCCDC: ###CCDC SYN_MODE=0x31704 seems ok.
> 
> 
> static struct isp_interface_config ov7690_if_config = {
>         .ccdc_par_ser           = ISP_CSIA,
>         .dataline_shift         = 0x0,
>         .hsvs_syncdetect        = ISPCTRL_SYNC_DETECT_VSFALL,

Can you try with ISPCTRL_SYNC_DETECT_VSRISE ?

>         .strobe                 = 0x0,
>         .prestrobe              = 0x0,
>         .shutter                = 0x0,
>         .wenlog                 = ISPCCDC_CFG_WENLOG_AND,
>         .wait_hs_vs             = 0x4,
>         .raw_fmt_in             = ISPCCDC_INPUT_FMT_GR_BG,
>         .u.csi.crc              = 0x0,
>         .u.csi.mode             = 0x0,
>         .u.csi.edge             = 0x0,
>         .u.csi.signalling       = 0x0,
>         .u.csi.strobe_clock_inv = 0x0,
>         .u.csi.vs_edge          = 0x0,
>         .u.csi.channel          = 0x0,
>         .u.csi.vpclk            = 0x1,
>         .u.csi.data_start       = 0x0,
>         .u.csi.data_size        = 0x0,
>         .u.csi.format           = V4L2_PIX_FMT_YUYV,
> };
> 
> and I don't know the meaning of
> 
> lanecfg.clk.pol = OV7690_CSI2_CLOCK_POLARITY;
> lanecfg.clk.pos = OV7690_CSI2_CLOCK_LANE;
> lanecfg.data[0].pol = OV7690_CSI2_DATA0_POLARITY;
> lanecfg.data[0].pos = OV7690_CSI2_DATA0_LANE;
> lanecfg.data[1].pol = OV7690_CSI2_DATA1_POLARITY;
> lanecfg.data[1].pos = OV7690_CSI2_DATA1_LANE;
> lanecfg.data[2].pol = 0;
> lanecfg.data[2].pos = 0;
> lanecfg.data[3].pol = 0;
> lanecfg.data[3].pos = 0;
> 

This is the physical connection details:

- The .pol field stands for the differntial pair polarity.
  (i.e. the order in which the negative and positive connections
  are pugged in to the CSI2 ComplexIO module)

- The .pos field is for telling in which position of the 4
  available physically you have your clock, or data lane located.

Regards,
Sergio

> >> - phyconfiguration
> > PHY - Physical timing configurations. btw, if it is camera 
> specific you
> > could get a lot of inputs from [1].
> 
> Ok I wil ask to them.
> 
> > 
> > Regards,
> > Nishanth Menon
> > 
> > Ref:
> > [1] http://vger.kernel.org/vger-lists.html#linux-media
> > --
> > To unsubscribe from this list: send the line "unsubscribe 
> linux-omap" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> Michael
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 