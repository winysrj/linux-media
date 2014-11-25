Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:32876 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaKYJQK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Nov 2014 04:16:10 -0500
Received: by mail-oi0-f53.google.com with SMTP id x69so119578oia.12
        for <linux-media@vger.kernel.org>; Tue, 25 Nov 2014 01:16:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1416903368.3166.3.camel@pengutronix.de>
References: <CAL8zT=hXkTFhQ-Nq_43HWeC2qDHd2DC-r0O3uZwDokBgv3QhEA@mail.gmail.com>
 <1416903368.3166.3.camel@pengutronix.de>
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Tue, 25 Nov 2014 10:15:53 +0100
Message-ID: <CAL8zT=gTUbdwcyLHO6ZJLoiDD5=qwXw-wnCj+k2c7dZBOdEXUQ@mail.gmail.com>
Subject: Re: Connecting ADV76xx to CSI via SFMC
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Thanks for answering.

2014-11-25 9:16 GMT+01:00 Philipp Zabel <p.zabel@pengutronix.de>:
> Hi Jean-Michel,
>
> Am Montag, den 24.11.2014, 16:19 +0100 schrieb Jean-Michel Hautbois:
>> Hi,
>>
>> I am working on using the CSI bus of i.MX6 with a adv7611 chip.
>> I started to work with Steve Longerbeam's tree, and here is the
>> current tree I am using :
>> https://github.com/Vodalys/linux-2.6-imx/tree/mx6-camera-staging-v2-vbx
>>
>> This is a WiP tree, and not intended to be complete right now.
>> But at least, it should be possible to get a picture.
>> I will try to be as complete and synthetic as possible...
>>
>> Right now, I am configuring the ADV7611 in "16-Bit SDR ITU-R BT.656
>> 4:2:2 Mode 0" (Table 73 in Appendix C of the Reference Manual).
>
> ITU-R BT.656 only specifies 8-bit (or 10-bit) streams, the 16-bit BT.656
> SDR/DDR modes with two values on the bus at the same time are somewhat
> nonstandard. As far as I can tell, this mode should correspond to the
> CSI's BT.1120 SDR mode (Figure 37-20 in MX6DQ Reference Manual v1), so
> I'd expect CSI_SENS_CONF to be configured as DATA_WIDTH=1 (8-bit
> components), SENS_DATA_FORMAT=1 (YUV422), SENS_PRCTL=5 (progressive
> BT.1120 SDR).

OK, so I tested in a brutal way :
diff --git a/drivers/gpu/ipu-v3/ipu-csi.c b/drivers/gpu/ipu-v3/ipu-csi.c
index 293262d..ff48819 100644
--- a/drivers/gpu/ipu-v3/ipu-csi.c
+++ b/drivers/gpu/ipu-v3/ipu-csi.c
@@ -342,10 +342,16 @@ static void fill_csi_bus_cfg(struct
ipu_csi_bus_config *csicfg,
                break;
        case V4L2_MBUS_BT656:
                csicfg->ext_vsync = 0;
-               if (V4L2_FIELD_HAS_BOTH(mbus_fmt->field))
-                       csicfg->clk_mode = IPU_CSI_CLK_MODE_CCIR656_INTERLACED;
+               if (mbus_fmt->code == V4L2_MBUS_FMT_YUYV8_2X8)
+                       if (V4L2_FIELD_HAS_BOTH(mbus_fmt->field))
+                               csicfg->clk_mode =
IPU_CSI_CLK_MODE_CCIR1120_PROGRESSIVE_SDR;
+                       else
+                               csicfg->clk_mode =
IPU_CSI_CLK_MODE_CCIR1120_INTERLACED_SDR;
                else
-                       csicfg->clk_mode = IPU_CSI_CLK_MODE_CCIR656_PROGRESSIVE;
+                       if (V4L2_FIELD_HAS_BOTH(mbus_fmt->field))
+                               csicfg->clk_mode =
IPU_CSI_CLK_MODE_CCIR656_INTERLACED;
+                       else
+                               csicfg->clk_mode =
IPU_CSI_CLK_MODE_CCIR656_PROGRESSIVE;
                break;
        case V4L2_MBUS_CSI2:


And before launching capture, I configure manually register 0x3 of
ADV7611 in order to have the SDR 4:2:2 mode I want.
It works better, but still have a little issue :
I am expecting : 0x23 0x72 0x23 0xd4 ...
I am getting : 0x23 0xc8 0x23 0x50

If I take binary values :
0x72 => 01110010b
0xc8 => 11001000b => 0x72 << 2

0xd4 => 11010100
0x50 => 01010000 => 0xd4 << 2

In my DT, I have specified :
        csi0: endpoint@0 {
            reg = <0>;
            bus-width = <16>;
            data-shift = <4>; /* Lines 19:4 used */
};

        pinctrl_ipu1_csi0: ipu1_csi0grp {
            fsl,pins = <
                MX6QDL_PAD_EIM_D27__IPU1_CSI0_DATA00 0x80000000
                MX6QDL_PAD_EIM_D26__IPU1_CSI0_DATA01 0x80000000
                MX6QDL_PAD_EIM_D30__IPU1_CSI0_DATA03 0x80000000
                MX6QDL_PAD_EIM_D31__IPU1_CSI0_DATA02 0x80000000
                MX6QDL_PAD_CSI0_DAT4__IPU1_CSI0_DATA04 0x80000000
                MX6QDL_PAD_CSI0_DAT5__IPU1_CSI0_DATA05 0x80000000
                MX6QDL_PAD_CSI0_DAT6__IPU1_CSI0_DATA06 0x80000000
                MX6QDL_PAD_CSI0_DAT7__IPU1_CSI0_DATA07 0x80000000
                MX6QDL_PAD_CSI0_DAT8__IPU1_CSI0_DATA08 0x80000000
                MX6QDL_PAD_CSI0_DAT9__IPU1_CSI0_DATA09 0x80000000
                MX6QDL_PAD_CSI0_DAT10__IPU1_CSI0_DATA10 0x80000000
                MX6QDL_PAD_CSI0_DAT11__IPU1_CSI0_DATA11 0x80000000
                MX6QDL_PAD_CSI0_DAT12__IPU1_CSI0_DATA12 0x80000000
                MX6QDL_PAD_CSI0_DAT13__IPU1_CSI0_DATA13 0x80000000
                MX6QDL_PAD_CSI0_DAT14__IPU1_CSI0_DATA14 0x80000000
                MX6QDL_PAD_CSI0_DAT15__IPU1_CSI0_DATA15 0x80000000
                MX6QDL_PAD_CSI0_DAT16__IPU1_CSI0_DATA16 0x80000000
                MX6QDL_PAD_CSI0_DAT17__IPU1_CSI0_DATA17 0x80000000
                MX6QDL_PAD_CSI0_DAT18__IPU1_CSI0_DATA18 0x80000000
                MX6QDL_PAD_CSI0_DAT19__IPU1_CSI0_DATA19 0x80000000
                /* Clock and Data only : BT.656 mode */
                MX6QDL_PAD_CSI0_PIXCLK__IPU1_CSI0_PIXCLK 0x80000000
                /*MX6QDL_PAD_CSI0_MCLK__IPU1_CSI0_HSYNC 0x80000000
                MX6QDL_PAD_CSI0_VSYNC__IPU1_CSI0_VSYNC 0x80000000
                MX6QDL_PAD_CSI0_DATA_EN__IPU1_CSI0_DATA_EN 0x80000000*/
            >;
        };

Can it be linked to the data-shift ?
Thanks again.
Regards,
JM
