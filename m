Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:37112 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbbAEPMp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Jan 2015 10:12:45 -0500
Received: by mail-oi0-f51.google.com with SMTP id h136so14540053oig.10
        for <linux-media@vger.kernel.org>; Mon, 05 Jan 2015 07:12:45 -0800 (PST)
MIME-Version: 1.0
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Mon, 5 Jan 2015 16:12:29 +0100
Message-ID: <CAL8zT=jkz=8GGrhbO+Rr=e4xBkPKU-6kXAqMzcpCX+iDLA+DZA@mail.gmail.com>
Subject: Using CSI1 on i.MX6
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Sascha Hauer <s.hauer@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

First of all, happy new year :).
Next, I am trying to use the second CSI on i.MX6 (still based on media
tree and Steve's work, "slightly" modified ;-)).
I am using the following lines in order to configure my adv7604
correctly, and running it in free run mode in order to get something
reliable :
DEVICE=4
INPUT=0
SUBDEV=3
v4l2-ctl -d$DEVICE --set-edid=pad=0,edid=hdmi -i$INPUT
v4l2-ctl -d$DEVICE
--set-fmt-video=width=1280,height=720,pixelformat=YUYV,field=none,bytesperline=2560
v4l2-ctl -d$DEVICE --set-dv-bt-timings index=4
v4l2-dbg -d$DEVICE -c subdev$SUBDEV -s 0x03 0x80
v4l2-dbg -d$DEVICE -c subdev$SUBDEV -s 0x02 0x35


And then, I launch this simple line, which gets stuck :
v4l2-ctl -d$DEVICE --stream-mmap --stream-to /data/x.raw --stream-count=1

The exact same sequence on CSI0 is working fine.
I added the dynamic debug messages and here is the configuration (from
my point of view, it seems to be ok, but I may have miss a bit here or
there) :
[  131.963122] mx6-camera-encoder: Direct CSI -> SMFC -> MEM
[  131.968568] mx6-camera-encoder: CSI channel 1 on IPU 2
[  131.973856] imx-ipuv3 2800000.ipu: ipu_idmac_get 3
[  131.973880] mx6-camera-encoder: Preview is off
[  131.978380] imx-ipuv3 2800000.ipu: CSI_SENS_CONF = 0x00000950
[  131.978410] imx-ipuv3 2800000.ipu: CSI_ACT_FRM_SIZE = 0x02CF04FF
[  131.987448] ipu_cpmem_set_image: resolution: 1280x720 stride: 2560
[  131.987467] ipu_ch_param_write_field 0 125 13
[  131.987482] ipu_ch_param_write_field 0 138 12
[  131.987495] ipu_ch_param_write_field 1 102 14
[  131.987507] ipu_ch_param_write_field 0 107 3
[  131.987520] ipu_ch_param_write_field 1 85 4
[  131.987531] ipu_ch_param_write_field 1 78 7
[  131.987544] ipu_ch_param_write_field 1 0 29
[  131.987554] ipu_ch_param_write_field 1 29 29
[  131.987568] ipu_ch_param_write_field 1 78 7
[  131.987591] ipu_ch_param_write_field 1 93 2
[  131.987997] mx6-camera-encoder: Enable CSI
[  131.992125] imx-ipuv3 2800000.ipu: ch 3 word 0 - 00000000 00000000
00000000 E0001800 000B3C9F
[  131.992146] imx-ipuv3 2800000.ipu: ch 3 word 1 - 09060000 01214000
0103C000 00027FC0 00000000
[  131.992159] ipu_ch_param_read_field 1 85 4
[  131.992173] imx-ipuv3 2800000.ipu: PFS 0x8,
[  131.992185] ipu_ch_param_read_field 0 107 3
[  131.992199] imx-ipuv3 2800000.ipu: BPP 0x3,
[  131.992209] ipu_ch_param_read_field 1 78 7
[  131.992222] imx-ipuv3 2800000.ipu: NPB 0xf
[  131.992234] ipu_ch_param_read_field 0 125 13
[  131.992248] imx-ipuv3 2800000.ipu: FW 1279,
[  131.992259] ipu_ch_param_read_field 0 138 12
[  131.992271] imx-ipuv3 2800000.ipu: FH 719,
[  131.992283] ipu_ch_param_read_field 1 0 29
[  131.992296] imx-ipuv3 2800000.ipu: EBA0 0x48300000
[  131.992307] ipu_ch_param_read_field 1 29 29
[  131.992320] imx-ipuv3 2800000.ipu: EBA1 0x48500000
[  131.992331] ipu_ch_param_read_field 1 102 14
[  131.992344] imx-ipuv3 2800000.ipu: Stride 2559
[  131.992355] ipu_ch_param_read_field 0 113 1
[  131.992367] imx-ipuv3 2800000.ipu: scan_order 0
[  131.992378] ipu_ch_param_read_field 1 128 14
[  131.992390] imx-ipuv3 2800000.ipu: uv_stride 0
[  131.992401] ipu_ch_param_read_field 0 46 22
[  131.992413] imx-ipuv3 2800000.ipu: u_offset 0x0
[  131.992425] ipu_ch_param_read_field 0 68 22
[  131.992438] imx-ipuv3 2800000.ipu: v_offset 0x0
[  131.992448] ipu_ch_param_read_field 1 116 3
[  131.992460] imx-ipuv3 2800000.ipu: Width0 0+1,
[  131.992472] ipu_ch_param_read_field 1 119 3
[  131.992485] imx-ipuv3 2800000.ipu: Width1 0+1,
[  131.992496] ipu_ch_param_read_field 1 122 3
[  131.992509] imx-ipuv3 2800000.ipu: Width2 0+1,
[  131.992519] ipu_ch_param_read_field 1 125 3
[  131.992531] imx-ipuv3 2800000.ipu: Width3 0+1,
[  131.992543] ipu_ch_param_read_field 1 128 5
[  131.992556] imx-ipuv3 2800000.ipu: Offset0 0,
[  131.992566] ipu_ch_param_read_field 1 133 5
[  131.992579] imx-ipuv3 2800000.ipu: Offset1 0,
[  131.992589] ipu_ch_param_read_field 1 138 5
[  131.992602] imx-ipuv3 2800000.ipu: Offset2 0,
[  131.992613] ipu_ch_param_read_field 1 143 5
[  131.992626] imx-ipuv3 2800000.ipu: Offset3 0
[  131.992641] imx-ipuv3 2800000.ipu: IPU_CONF =        0x00000102
[  131.992654] imx-ipuv3 2800000.ipu: IDMAC_CONF =      0x0000002F
[  131.992667] imx-ipuv3 2800000.ipu: IDMAC_CHA_EN1 =   0x00000008
[  131.992679] imx-ipuv3 2800000.ipu: IDMAC_CHA_EN2 =   0x00000000
[  131.992691] imx-ipuv3 2800000.ipu: IDMAC_CHA_PRI1 =  0x00000008
[  131.992704] imx-ipuv3 2800000.ipu: IDMAC_CHA_PRI2 =  0x00000000
[  131.992718] imx-ipuv3 2800000.ipu: IDMAC_BAND_EN1 =  0x00000000
[  131.992731] imx-ipuv3 2800000.ipu: IDMAC_BAND_EN2 =  0x00000000
[  131.992743] imx-ipuv3 2800000.ipu: IPU_CHA_DB_MODE_SEL0 =    0x00000008
[  131.992756] imx-ipuv3 2800000.ipu: IPU_CHA_DB_MODE_SEL1 =    0x00000000
[  131.992769] imx-ipuv3 2800000.ipu: IPU_FS_PROC_FLOW1 =       0x00000000
[  131.992782] imx-ipuv3 2800000.ipu: IPU_FS_PROC_FLOW2 =       0x00000000
[  131.992794] imx-ipuv3 2800000.ipu: IPU_FS_PROC_FLOW3 =       0x00000000
[  131.992806] imx-ipuv3 2800000.ipu: IPU_FS_DISP_FLOW1 =       0x00000000
[  131.992819] imx-ipuv3 2800000.ipu: IPU_INT_CTRL(0) =         10800008
[  131.992833] imx-ipuv3 2800000.ipu: IPU_INT_CTRL(1) =         00000000
[  131.992847] imx-ipuv3 2800000.ipu: IPU_INT_CTRL(2) =         00000000
[  131.992860] imx-ipuv3 2800000.ipu: IPU_INT_CTRL(3) =         00000000
[  131.992874] imx-ipuv3 2800000.ipu: IPU_INT_CTRL(4) =         00000008
[  131.992887] imx-ipuv3 2800000.ipu: IPU_INT_CTRL(5) =         00000000
[  131.992900] imx-ipuv3 2800000.ipu: IPU_INT_CTRL(6) =         00000000
[  131.992914] imx-ipuv3 2800000.ipu: IPU_INT_CTRL(7) =         00000000
[  131.992927] imx-ipuv3 2800000.ipu: IPU_INT_CTRL(8) =         00000000
[  131.992940] imx-ipuv3 2800000.ipu: IPU_INT_CTRL(9) =         00000000
[  131.992954] imx-ipuv3 2800000.ipu: IPU_INT_CTRL(10) =        00000000
[  131.992967] imx-ipuv3 2800000.ipu: IPU_INT_CTRL(11) =        00000000
[  131.992980] imx-ipuv3 2800000.ipu: IPU_INT_CTRL(12) =        00000000
[  131.992994] imx-ipuv3 2800000.ipu: IPU_INT_CTRL(13) =        00000000
[  131.993007] imx-ipuv3 2800000.ipu: IPU_INT_CTRL(14) =        00000208
[  131.993022] imx-ipuv3 2800000.ipu: CSI_SENS_CONF:     04000950
[  131.993034] imx-ipuv3 2800000.ipu: CSI_SENS_FRM_SIZE: 02cf04ff
[  131.993048] imx-ipuv3 2800000.ipu: CSI_ACT_FRM_SIZE:  02cf04ff
[  131.993060] imx-ipuv3 2800000.ipu: CSI_OUT_FRM_CTRL:  00000000
[  131.993072] imx-ipuv3 2800000.ipu: CSI_TST_CTRL:      00000000
[  131.993085] imx-ipuv3 2800000.ipu: CSI_CCIR_CODE_1:   01040030
[  131.993097] imx-ipuv3 2800000.ipu: CSI_CCIR_CODE_2:   00000000
[  131.993111] imx-ipuv3 2800000.ipu: CSI_CCIR_CODE_3:   00ff0000
[  131.993123] imx-ipuv3 2800000.ipu: CSI_MIPI_DI:       ffffffff
[  131.993135] imx-ipuv3 2800000.ipu: CSI_SKIP:          00000000
[  132.014801] ipu_ch_param_write_field 1 0 29
[  132.033993] ipu_ch_param_write_field 1 29 29
[  132.053990] ipu_ch_param_write_field 1 0 29
[  132.074017] ipu_ch_param_write_field 1 29 29
[  132.094041] ipu_ch_param_write_field 1 0 29
[  132.114021] ipu_ch_param_write_field 1 29 29
[  132.134043] ipu_ch_param_write_field 1 0 29
[  132.154051] ipu_ch_param_write_field 1 29 29
[  132.174043] ipu_ch_param_write_field 1 0 29
[  132.194116] ipu_ch_param_write_field 1 29 29
[  132.214121] ipu_ch_param_write_field 1 0 29
[  132.234107] ipu_ch_param_write_field 1 29 29
[  132.254145] ipu_ch_param_write_field 1 0 29
[  132.274177] ipu_ch_param_write_field 1 29 29
[  132.294125] ipu_ch_param_write_field 1 0 29
[  132.314167] ipu_ch_param_write_field 1 29 29
[  132.334173] ipu_ch_param_write_field 1 0 29
[  132.354157] ipu_ch_param_write_field 1 29 29
[  132.374210] ipu_ch_param_write_field 1 0 29
[  132.394206] ipu_ch_param_write_field 1 29 29
[  132.414560] ipu_ch_param_write_field 1 0 29
[  132.434242] ipu_ch_param_write_field 1 29 29

It keeps going like that...
If anyone has an idea (and I am sure some of you have ;-)) it would be
of great help.

Thanks,
JM
