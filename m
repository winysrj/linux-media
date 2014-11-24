Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:43769 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbaKXPTp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Nov 2014 10:19:45 -0500
Received: by mail-oi0-f50.google.com with SMTP id a141so6676868oig.37
        for <linux-media@vger.kernel.org>; Mon, 24 Nov 2014 07:19:44 -0800 (PST)
MIME-Version: 1.0
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Mon, 24 Nov 2014 16:19:29 +0100
Message-ID: <CAL8zT=hXkTFhQ-Nq_43HWeC2qDHd2DC-r0O3uZwDokBgv3QhEA@mail.gmail.com>
Subject: Connecting ADV76xx to CSI via SFMC
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Fabio Estevam <fabio.estevam@freescale.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am working on using the CSI bus of i.MX6 with a adv7611 chip.
I started to work with Steve Longerbeam's tree, and here is the
current tree I am using :
https://github.com/Vodalys/linux-2.6-imx/tree/mx6-camera-staging-v2-vbx

This is a WiP tree, and not intended to be complete right now.
But at least, it should be possible to get a picture.
I will try to be as complete and synthetic as possible...

Right now, I am configuring the ADV7611 in "16-Bit SDR ITU-R BT.656
4:2:2 Mode 0" (Table 73 in Appendix C of the Reference Manual).
This means that I have pins [15:8] = [Y7..Y0] and [7:0]=[Cb7,Cr7..Cb0,Cr0].
On my board, thanks to a FPGA, pin 15 is connected to
MX6QDL_PAD_CSI0_DAT19__IPU1_CSI0_DATA19 and pin 0 to
MX6QDL_PAD_CSI0_DAT4__IPU1_CSI0_DATA04.

In the source code, I am asking for a  4:2:2 YUYV packed format.

Then, when starting the board, I am doing the following :
$> v4l2-ctl -d2
--set-fmt-video=width=1280,height=720,pixelformat=YUYV,field=none,bytesperline=2560
-i3
$> v4l2-ctl -d2 --set-dv-bt-timings index=4 -i3
$>   [   69.360256] adv7611 1-004c: -----Chip status-----
   [   69.365652] adv7611 1-004c: Chip power: on
   [   69.370446] adv7611 1-004c: EDID enabled port A: No, B: No, C: No, D: No
   [   69.378110] adv7611 1-004c: CEC: disabled
   [   69.382132] adv7611 1-004c: -----Signal status-----
   [   69.387722] adv7611 1-004c: Cable detected (+5V power) port A:
No, B: No, C: No, D: No
   [   69.396344] adv7611 1-004c: TMDS signal detected: false
   [   69.402245] adv7611 1-004c: TMDS signal locked: false
   [   69.408015] adv7611 1-004c: SSPD locked: true
   [   69.413047] adv7611 1-004c: STDI locked: false
   [   69.417529] adv7611 1-004c: CP locked: true
   [   69.422402] adv7611 1-004c: CP free run: on
   [   69.429013] adv7611 1-004c: Prim-mode = 0x5, video std = 0x13,
v_freq = 0x1
   [   69.436022] adv7611 1-004c: -----Video Timings-----
   [   69.441594] adv7611 1-004c: STDI: not locked
   [   69.449212] adv7611 1-004c: No video detected
   [   69.453587] adv7611 1-004c: Configured format: 1280x720p50 (1980x750)
   [   69.460066] adv7611 1-004c: horizontal: fp = 440, +sync = 40, bp = 220
   [   69.466637] adv7611 1-004c: vertical: fp = 5, +sync = 5, bp = 20
   [   69.472653] adv7611 1-004c: pixelclock: 74250000
   [   69.477300] adv7611 1-004c: flags (0x0):
   [   69.481233] adv7611 1-004c: standards (0x1): CEA
   [   69.490112] adv7604 1-0020: -----Chip status-----

I keep the ADV7611 running in Free mode, which produces a blue frame,
with Y=0x23 and Cr=0x72, Cb=0xD4.

Now, I try to capture a frame :
$> v4l2-ctl -d2 --stream-mmap --stream-to x.raw --stream-count=1

I don't get anything, and here is the dmesg :
[  187.191644] imx-ipuv3 2400000.ipu: CSI_SENS_CONF = 0x00004920
[  187.191849] imx-ipuv3 2400000.ipu: CSI_ACT_FRM_SIZE = 0x02CF04FF
[  187.200454] ipu_cpmem_set_image: resolution: 1280x720 stride: 2560
[  187.200472] ipu_ch_param_write_field 0 125 13
[  187.200486] ipu_ch_param_write_field 0 138 12
[  187.200498] ipu_ch_param_write_field 1 102 14
[  187.200510] ipu_ch_param_write_field 0 107 3
[  187.200521] ipu_ch_param_write_field 1 85 4
[  187.200532] ipu_ch_param_write_field 1 78 7
[  187.200543] ipu_ch_param_write_field 1 0 29
[  187.200554] ipu_ch_param_write_field 1 29 29
[  187.200566] ipu_ch_param_write_field 1 78 7
[  187.200586] ipu_ch_param_write_field 1 93 2
[  187.201077] mx6-camera-encoder: Enable CSI
[  187.205206] imx-ipuv3 2400000.ipu: ch 0 word 0 - 00000000 00000000
00000000 E0001800 000B3C9F
[  187.205226] imx-ipuv3 2400000.ipu: ch 0 word 1 - 09E60000 013D4000
0103C000 00027FC0 00000000
[  187.205240] ipu_ch_param_read_field 1 85 4
[  187.205254] imx-ipuv3 2400000.ipu: PFS 0x8,
[  187.205265] ipu_ch_param_read_field 0 107 3
[  187.205278] imx-ipuv3 2400000.ipu: BPP 0x3,
[  187.205289] ipu_ch_param_read_field 1 78 7
[  187.205302] imx-ipuv3 2400000.ipu: NPB 0xf
[  187.205313] ipu_ch_param_read_field 0 125 13
[  187.205326] imx-ipuv3 2400000.ipu: FW 1279,
[  187.205337] ipu_ch_param_read_field 0 138 12
[  187.205350] imx-ipuv3 2400000.ipu: FH 719,
[  187.205361] ipu_ch_param_read_field 1 0 29
[  187.205374] imx-ipuv3 2400000.ipu: EBA0 0x4f300000
[  187.205385] ipu_ch_param_read_field 1 29 29
[  187.205398] imx-ipuv3 2400000.ipu: EBA1 0x4f500000
[  187.205409] ipu_ch_param_read_field 1 102 14
[  187.205422] imx-ipuv3 2400000.ipu: Stride 2559
[  187.205433] ipu_ch_param_read_field 0 113 1
[  187.205445] imx-ipuv3 2400000.ipu: scan_order 0
[  187.205456] ipu_ch_param_read_field 1 128 14
[  187.205469] imx-ipuv3 2400000.ipu: uv_stride 0
[  187.205480] ipu_ch_param_read_field 0 46 22
[  187.205492] imx-ipuv3 2400000.ipu: u_offset 0x0
[  187.205541] ipu_ch_param_read_field 0 68 22
[  187.205557] imx-ipuv3 2400000.ipu: v_offset 0x0
[  187.205568] ipu_ch_param_read_field 1 116 3
[  187.205581] imx-ipuv3 2400000.ipu: Width0 0+1,
[  187.205592] ipu_ch_param_read_field 1 119 3
[  187.205604] imx-ipuv3 2400000.ipu: Width1 0+1,
[  187.205615] ipu_ch_param_read_field 1 122 3
[  187.205645] imx-ipuv3 2400000.ipu: Width2 0+1,
[  187.205663] ipu_ch_param_read_field 1 125 3
[  187.205683] imx-ipuv3 2400000.ipu: Width3 0+1,
[  187.205707] ipu_ch_param_read_field 1 128 5
[  187.205730] imx-ipuv3 2400000.ipu: Offset0 0,
[  187.205750] ipu_ch_param_read_field 1 133 5
[  187.205774] imx-ipuv3 2400000.ipu: Offset1 0,
[  187.205798] ipu_ch_param_read_field 1 138 5
[  187.205822] imx-ipuv3 2400000.ipu: Offset2 0,
[  187.205839] ipu_ch_param_read_field 1 143 5
[  187.205859] imx-ipuv3 2400000.ipu: Offset3 0
[  187.205883] imx-ipuv3 2400000.ipu: IPU_CONF =     0x00000101
[  187.205907] imx-ipuv3 2400000.ipu: IDMAC_CONF =     0x0000002F
[  187.205926] imx-ipuv3 2400000.ipu: IDMAC_CHA_EN1 =     0x00000001
[  187.205951] imx-ipuv3 2400000.ipu: IDMAC_CHA_EN2 =     0x00000000
[  187.205975] imx-ipuv3 2400000.ipu: IDMAC_CHA_PRI1 =     0x00000001
[  187.205997] imx-ipuv3 2400000.ipu: IDMAC_CHA_PRI2 =     0x00000000
[  187.206009] imx-ipuv3 2400000.ipu: IDMAC_BAND_EN1 =     0x00000000
[  187.206022] imx-ipuv3 2400000.ipu: IDMAC_BAND_EN2 =     0x00000000
[  187.206034] imx-ipuv3 2400000.ipu: IPU_CHA_DB_MODE_SEL0 =     0x00000001
[  187.206047] imx-ipuv3 2400000.ipu: IPU_CHA_DB_MODE_SEL1 =     0x00000000
[  187.206059] imx-ipuv3 2400000.ipu: IPU_FS_PROC_FLOW1 =     0x00000000
[  187.206071] imx-ipuv3 2400000.ipu: IPU_FS_PROC_FLOW2 =     0x00000000
[  187.206083] imx-ipuv3 2400000.ipu: IPU_FS_PROC_FLOW3 =     0x00000000
[  187.206097] imx-ipuv3 2400000.ipu: IPU_FS_DISP_FLOW1 =     0x00000000
[  187.206110] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(0) =     10800001
[  187.206122] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(1) =     00000000
[  187.206135] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(2) =     00000000
[  187.206148] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(3) =     00000000
[  187.206161] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(4) =     00000001
[  187.206174] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(5) =     00000000
[  187.206187] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(6) =     00000000
[  187.206200] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(7) =     00000000
[  187.206213] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(8) =     00000000
[  187.206226] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(9) =     00000000
[  187.206240] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(10) =     00000000
[  187.206253] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(11) =     00000000
[  187.206266] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(12) =     00000000
[  187.206279] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(13) =     00000000
[  187.206293] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(14) =     00000208
[  187.206307] imx-ipuv3 2400000.ipu: CSI_SENS_CONF:     04004920
[  187.206319] imx-ipuv3 2400000.ipu: CSI_SENS_FRM_SIZE: 02cf04ff
[  187.206332] imx-ipuv3 2400000.ipu: CSI_ACT_FRM_SIZE:  02cf04ff
[  187.206343] imx-ipuv3 2400000.ipu: CSI_OUT_FRM_CTRL:  00000000
[  187.206356] imx-ipuv3 2400000.ipu: CSI_TST_CTRL:      00000000
[  187.206369] imx-ipuv3 2400000.ipu: CSI_CCIR_CODE_1:   00040030
[  187.206381] imx-ipuv3 2400000.ipu: CSI_CCIR_CODE_2:   00000000
[  187.206393] imx-ipuv3 2400000.ipu: CSI_CCIR_CODE_3:   00ff0000
[  187.206406] imx-ipuv3 2400000.ipu: CSI_MIPI_DI:       ffffffff
[  187.206418] imx-ipuv3 2400000.ipu: CSI_SKIP:          00000000
[  188.205908] mx6-camera-encoder: encoder EOF timeout
[  188.213454] mx6-camera v4l2cap@ipu1: restarting
[  188.218089] mx6-camera-encoder: Entering encoder stop
[  189.215677] mx6-camera-encoder: wait last encode EOF timeout
[  189.223292] imx-ipuv3 2400000.ipu: ipu_idmac_put 0
[  189.223366] mx6-camera-encoder: [Encoder stop]frame seq: 0
[  189.230825] mx6-camera-encoder: [Encoder stop]frame seq: 1

Now, I am doing something different, replacing the format
V4L2_MBUS_FMT_YUYV8_1X16 by V4L2_MBUS_FMT_YUYV8_2X8.
This will tell the CSI bus to work on 8 bits and not 16 bits wide.
Keeping it like that, the ADV7611 is now outputing data in "8-Bit SDR
ITU-R BT.656 Mode 0" so, pins [15:8]=[Y7,Cb7,Cr7..Y0,Cb0,Cr0].
Of course, it is not wrking either :
[  173.032849] imx-ipuv3 2400000.ipu: CSI_SENS_CONF = 0x00000920
[  173.033069] imx-ipuv3 2400000.ipu: CSI_ACT_FRM_SIZE = 0x02CF04FF
[  173.049295] ipu_cpmem_set_image: resolution: 1280x720 stride: 2560
[  173.049334] ipu_ch_param_write_field 0 125 13
[  173.049361] ipu_ch_param_write_field 0 138 12
[  173.049385] ipu_ch_param_write_field 1 102 14
[  173.049408] ipu_ch_param_write_field 0 107 3
[  173.049430] ipu_ch_param_write_field 1 85 4
[  173.049453] ipu_ch_param_write_field 1 78 7
[  173.049476] ipu_ch_param_write_field 1 0 29
[  173.049499] ipu_ch_param_write_field 1 29 29
[  173.049522] ipu_ch_param_write_field 1 78 7
[  173.049562] ipu_ch_param_write_field 1 93 2
[  173.049748] mx6-camera-encoder: Enable CSI
[  173.053905] imx-ipuv3 2400000.ipu: ch 0 word 0 - 00000000 00000000
00000000 E0001800 000B3C9F
[  173.053941] imx-ipuv3 2400000.ipu: ch 0 word 1 - 00000000 00000000
0103C000 00027FC0 00000000
[  173.053968] ipu_ch_param_read_field 1 85 4
[  173.053994] imx-ipuv3 2400000.ipu: PFS 0x8,
[  173.054015] ipu_ch_param_read_field 0 107 3
[  173.054042] imx-ipuv3 2400000.ipu: BPP 0x3,
[  173.054065] ipu_ch_param_read_field 1 78 7
[  173.054089] imx-ipuv3 2400000.ipu: NPB 0xf
[  173.054110] ipu_ch_param_read_field 0 125 13
[  173.054136] imx-ipuv3 2400000.ipu: FW 1279,
[  173.054158] ipu_ch_param_read_field 0 138 12
[  173.054183] imx-ipuv3 2400000.ipu: FH 719,
[  173.054204] ipu_ch_param_read_field 1 0 29
[  173.054228] imx-ipuv3 2400000.ipu: EBA0 0x0
[  173.054250] ipu_ch_param_read_field 1 29 29
[  173.054275] imx-ipuv3 2400000.ipu: EBA1 0x0
[  173.054295] ipu_ch_param_read_field 1 102 14
[  173.054320] imx-ipuv3 2400000.ipu: Stride 2559
[  173.054341] ipu_ch_param_read_field 0 113 1
[  173.054365] imx-ipuv3 2400000.ipu: scan_order 0
[  173.054386] ipu_ch_param_read_field 1 128 14
[  173.054412] imx-ipuv3 2400000.ipu: uv_stride 0
[  173.054433] ipu_ch_param_read_field 0 46 22
[  173.054458] imx-ipuv3 2400000.ipu: u_offset 0x0
[  173.054480] ipu_ch_param_read_field 0 68 22
[  173.054505] imx-ipuv3 2400000.ipu: v_offset 0x0
[  173.054527] ipu_ch_param_read_field 1 116 3
[  173.054551] imx-ipuv3 2400000.ipu: Width0 0+1,
[  173.054574] ipu_ch_param_read_field 1 119 3
[  173.054599] imx-ipuv3 2400000.ipu: Width1 0+1,
[  173.054621] ipu_ch_param_read_field 1 122 3
[  173.054646] imx-ipuv3 2400000.ipu: Width2 0+1,
[  173.054667] ipu_ch_param_read_field 1 125 3
[  173.054692] imx-ipuv3 2400000.ipu: Width3 0+1,
[  173.054713] ipu_ch_param_read_field 1 128 5
[  173.054738] imx-ipuv3 2400000.ipu: Offset0 0,
[  173.054759] ipu_ch_param_read_field 1 133 5
[  173.054784] imx-ipuv3 2400000.ipu: Offset1 0,
[  173.054806] ipu_ch_param_read_field 1 138 5
[  173.054830] imx-ipuv3 2400000.ipu: Offset2 0,
[  173.054851] ipu_ch_param_read_field 1 143 5
[  173.054876] imx-ipuv3 2400000.ipu: Offset3 0
[  173.054905] imx-ipuv3 2400000.ipu: IPU_CONF =     0x00000101
[  173.054929] imx-ipuv3 2400000.ipu: IDMAC_CONF =     0x0000002F
[  173.054955] imx-ipuv3 2400000.ipu: IDMAC_CHA_EN1 =     0x00000001
[  173.054979] imx-ipuv3 2400000.ipu: IDMAC_CHA_EN2 =     0x00000000
[  173.055004] imx-ipuv3 2400000.ipu: IDMAC_CHA_PRI1 =     0x00000001
[  173.055028] imx-ipuv3 2400000.ipu: IDMAC_CHA_PRI2 =     0x00000000
[  173.055052] imx-ipuv3 2400000.ipu: IDMAC_BAND_EN1 =     0x00000000
[  173.055076] imx-ipuv3 2400000.ipu: IDMAC_BAND_EN2 =     0x00000000
[  173.055101] imx-ipuv3 2400000.ipu: IPU_CHA_DB_MODE_SEL0 =     0x00000001
[  173.055125] imx-ipuv3 2400000.ipu: IPU_CHA_DB_MODE_SEL1 =     0x00000000
[  173.055149] imx-ipuv3 2400000.ipu: IPU_FS_PROC_FLOW1 =     0x00000000
[  173.055173] imx-ipuv3 2400000.ipu: IPU_FS_PROC_FLOW2 =     0x00000000
[  173.055198] imx-ipuv3 2400000.ipu: IPU_FS_PROC_FLOW3 =     0x00000000
[  173.055222] imx-ipuv3 2400000.ipu: IPU_FS_DISP_FLOW1 =     0x00000000
[  173.055248] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(0) =     10800001
[  173.055274] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(1) =     00000000
[  173.055299] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(2) =     00000000
[  173.055325] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(3) =     00000000
[  173.055350] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(4) =     00000001
[  173.055375] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(5) =     00000000
[  173.055401] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(6) =     00000000
[  173.055426] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(7) =     00000000
[  173.055543] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(8) =     00000000
[  173.055574] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(9) =     00000000
[  173.055601] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(10) =     00000000
[  173.055626] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(11) =     00000000
[  173.055652] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(12) =     00000000
[  173.055678] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(13) =     00000000
[  173.055703] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(14) =     00000208
[  173.055729] imx-ipuv3 2400000.ipu: CSI_SENS_CONF:     04000920
[  173.055754] imx-ipuv3 2400000.ipu: CSI_SENS_FRM_SIZE: 02cf04ff
[  173.055778] imx-ipuv3 2400000.ipu: CSI_ACT_FRM_SIZE:  02cf04ff
[  173.055822] imx-ipuv3 2400000.ipu: CSI_OUT_FRM_CTRL:  00000000
[  173.055862] imx-ipuv3 2400000.ipu: CSI_TST_CTRL:      00000000
[  173.055901] imx-ipuv3 2400000.ipu: CSI_CCIR_CODE_1:   00040030
[  173.055947] imx-ipuv3 2400000.ipu: CSI_CCIR_CODE_2:   00000000
[  173.055987] imx-ipuv3 2400000.ipu: CSI_CCIR_CODE_3:   00ff0000
[  173.056026] imx-ipuv3 2400000.ipu: CSI_MIPI_DI:       ffffffff
[  173.056065] imx-ipuv3 2400000.ipu: CSI_SKIP:          00000000
[  174.055502] mx6-camera-encoder: encoder EOF timeout
[  174.060609] mx6-camera v4l2cap@ipu1: restarting
[  174.065171] mx6-camera-encoder: Entering encoder stop

Changing bus-width to 8 in DT is not sufficient though... and this is
the most annoying part in fact.

But, this is the interesting part, when I configure the CSI to have 8
bits wide data, but setting manually the adv7611 back to the 16 bits
mode I am able to get a frame !
=> This means CSI0_SENS_CONF is 0x04000920 but, I set register 3 of IO
map in ADV7611 to 0x80 as in the first try to say to put 16 bits on
[15:0] pins.

But this frame contains only Y component. If I put a real video as
input, I get the luminance only input, but it is clean.
$> v4l2-ctl -d2
--set-fmt-video=width=1280,height=720,pixelformat=YUYV,field=none,bytesperline=2560
-i1
Video input set to 1 (adv7611 1-004c: no signal)
$> v4l2-ctl -d2 --set-dv-bt-timings index=4
BT timings set
$> v4l2-dbg -d2 -c subdev1 -s 0x03 0x80
Register 0x00000003 set to 0x80
$> v4l2-ctl -d2 --stream-mmap --stream-to x.raw --stream-count=1
<
$> od -t x1 x.raw
0000000 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23 23
*
7020000

Any idea to make the 16 bits mode work with CSI is welcomed as I am
pretty stuck right now... :).
Thx & Regards,
JM
