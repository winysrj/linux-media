Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:51728 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbbANRLr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jan 2015 12:11:47 -0500
Received: by mail-ob0-f177.google.com with SMTP id uy5so8810491obc.8
        for <linux-media@vger.kernel.org>; Wed, 14 Jan 2015 09:11:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAL8zT=hPSYBcUGZbpaqidcWvHk9TB5u30XeXjVsp_b_puB0KYg@mail.gmail.com>
References: <CAL8zT=hPSYBcUGZbpaqidcWvHk9TB5u30XeXjVsp_b_puB0KYg@mail.gmail.com>
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Wed, 14 Jan 2015 18:11:31 +0100
Message-ID: <CAL8zT=ixDG50JuLU+iWMByHvXAB5RX4rg63azBp7E4w4WWmcfw@mail.gmail.com>
Subject: Re: HDMI input on i.MX6 using IPU
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	Jean-Michel Hautbois <jhautbois@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

2015-01-08 17:53 GMT+01:00 Jean-Michel Hautbois
<jean-michel.hautbois@vodalys.com>:
> Hi,
>
> I have modified both Steve's and Philipp's code, in order to get
> something able to get frames from an ADV7611.
> Right now, I am back to Philipp's base of code, rebased on top of
> media-tree, and everything works fine, except the very last link
> between SFMC and IDMAC (using media controller).
> Here is a status.
>
> The code is here :
> https://github.com/Vodalys/linux-2.6-imx/tree/media-tree-zabel

Right now, I can go further. I added support for BT.1120 in order to
get the correct video format, and I am able to start a streaming, but
I can't get an interrupt on IDMAC.

I am starting with setting DV timings on adv7611 input, and then, I am
using 4l2-compliance in order to test streaming. It has shown several
things, most of them are corrected, sometimes in a hacky way.

Right now, I can do the following :
$> media-ctl --set-dv '"adv7611 1-004c":1 [fmt:YUYV/1280x720]' &&
media-ctl --set-v4l2 '"adv7611 1-004c":1 [fmt:YUYV/1280x720]'
$> echo -n 'module imx_ipuv3_csi +p' > /sys/kernel/debug/dynamic_debug/control
$> v4l2-compliance -v -s
Driver Info:
    Driver name   : imx-ipuv3-csi
    Card type     : imx-ipuv3-camera
    Bus info      : platform:imx-ipuv3-csi
    Driver version: 3.19.0
    Capabilities  : 0x84200001
        Video Capture
        Streaming
        Extended Pix Format
        Device Capabilities
    Device Caps   : 0x04200001
        Video Capture
        Streaming
        Extended Pix Format

Compliance test for device /dev/video0 (not using libv4l2):

Required ioctls:
    test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
    test second video open: OK
    test VIDIOC_QUERYCAP: OK
    test VIDIOC_G/S_PRIORITY: OK

Debug ioctls:
    test VIDIOC_DBG_G/S_REGISTER: OK
    test VIDIOC_LOG_STATUS: OK

Input ioctls:
    test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
    test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
    test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
    test VIDIOC_ENUMAUDIO: OK (Not Supported)
    test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
    test VIDIOC_G/S_AUDIO: OK (Not Supported)
    Inputs: 0 Audio Inputs: 0 Tuners: 0

Output ioctls:
    test VIDIOC_G/S_MODULATOR: OK (Not Supported)
    test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
    test VIDIOC_ENUMAUDOUT: OK (Not Supported)
    test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
    test VIDIOC_G/S_AUDOUT: OK (Not Supported)
    Outputs: 0 Audio Outputs: 0 Modulators: 0

Input/Output configuration ioctls:
    test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
    test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
    test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
    test VIDIOC_G/S_EDID: OK (Not Supported)

    Control ioctls:
        info: checking v4l2_queryctrl of control 'User Controls' (0x00980001)
        info: checking v4l2_queryctrl of control 'Brightness' (0x00980900)
        info: checking v4l2_queryctrl of control 'Contrast' (0x00980901)
        info: checking v4l2_queryctrl of control 'Saturation' (0x00980902)
        info: checking v4l2_queryctrl of control 'Hue' (0x00980903)
        info: checking v4l2_queryctrl of control 'Image Processing
Controls' (0x009f0001)
        info: checking v4l2_queryctrl of control 'Test Pattern' (0x009f0903)
        info: checking v4l2_queryctrl of control 'Brightness' (0x00980900)
        info: checking v4l2_queryctrl of control 'Contrast' (0x00980901)
        info: checking v4l2_queryctrl of control 'Saturation' (0x00980902)
        info: checking v4l2_queryctrl of control 'Hue' (0x00980903)
        test VIDIOC_QUERYCTRL/MENU: OK
        info: checking control 'User Controls' (0x00980001)
        info: checking control 'Brightness' (0x00980900)
        info: checking control 'Contrast' (0x00980901)
        info: checking control 'Saturation' (0x00980902)
        info: checking control 'Hue' (0x00980903)
        info: checking control 'Image Processing Controls' (0x009f0001)
        info: checking control 'Test Pattern' (0x009f0903)
        test VIDIOC_G/S_CTRL: OK
        info: checking extended control 'User Controls' (0x00980001)
        info: checking extended control 'Brightness' (0x00980900)
        info: checking extended control 'Contrast' (0x00980901)
        info: checking extended control 'Saturation' (0x00980902)
        info: checking extended control 'Hue' (0x00980903)
        info: checking extended control 'Image Processing Controls' (0x009f0001)
        info: checking extended control 'Test Pattern' (0x009f0903)
        test VIDIOC_G/S/TRY_EXT_CTRLS: OK
        info: checking control event 'User Controls' (0x00980001)
        fail: /run/media/jm/SSD_JM/Projets/vodabox3/poky/build/tmp/work/cortexa9hf-vfp-neon-poky-linux-gnueabi/v4l-utils/git-r0/git/utils/v4l2-compliance/v4l2-test-controls.cpp(721):
subscribe event for control 'User Controls' failed
        test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
        test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
        Standard Controls: 7 Private Controls: 0

    Format ioctls:
        info: found 2 framesizes for pixel format 59455247
        info: found 2 framesizes for pixel format 20303159
        info: found 2 framesizes for pixel format 20363159
        info: found 2 framesizes for pixel format 59565955
        info: found 2 framesizes for pixel format 56595559
        info: found 5 formats for buftype 1
        test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
        test VIDIOC_G/S_PARM: OK (Not Supported)
        test VIDIOC_G_FBUF: OK (Not Supported)
        test VIDIOC_G_FMT: OK
        test VIDIOC_TRY_FMT: OK
        info: Global format check succeeded for type 1
        test VIDIOC_S_FMT: OK
        test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)

    Codec ioctls:
        test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
        test VIDIOC_G_ENC_INDEX: OK (Not Supported)
        test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

    Buffer ioctls:
        info: test buftype Video Capture
        test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
        test VIDIOC_EXPBUF: OK (Not Supported)

Streaming ioctls:
    test read/write: OK (Not Supported)
        Video Capture:

It waits here.
I can still abort it using ^C and disply kernel messages :
$> dmesg
[   41.794280] imx-ipuv3-camera imx-ipuv3-camera.2: get 3 buffer(s) of
size 1843200 each.
[   41.826567] imx-ipuv3-camera imx-ipuv3-camera.2: get 3 buffer(s) of
size 1843200 each.
[   41.853863] imx-ipuv3-camera imx-ipuv3-camera.2: get 3 buffer(s) of
size 1843200 each.
[   41.853926] imx-ipuv3-camera imx-ipuv3-camera.2: get 3 buffer(s) of
size 1843200 each.
[   41.853995] imx-ipuv3-camera imx-ipuv3-camera.2: get 3 buffer(s) of
size 1843200 each.
[   41.854045] imx-ipuv3-camera imx-ipuv3-camera.2: get 3 buffer(s) of
size 1843200 each.
[   41.854123] imx-ipuv3-camera imx-ipuv3-camera.2: get 3 buffer(s) of
size 1843200 each.
[   41.854192] imx-ipuv3-camera imx-ipuv3-camera.2: get 3 buffer(s) of
size 1843200 each.
[   41.882802] imx-ipuv3-camera imx-ipuv3-camera.2: get 3 buffer(s) of
size 1843200 each.
[   41.882882] imx-ipuv3-camera imx-ipuv3-camera.2: get 1 buffer(s) of
size 1843200 each.
[   41.882966] imx-ipuv3-camera imx-ipuv3-camera.2: get 3 buffer(s) of
size 1843200 each.
[   41.883037] imx-ipuv3-camera imx-ipuv3-camera.2: get 3 buffer(s) of
size 1843200 each.
[   41.883103] imx-ipuv3-camera imx-ipuv3-camera.2: get 3 buffer(s) of
size 1843200 each.
[   41.883165] imx-ipuv3-camera imx-ipuv3-camera.2: get 1 buffer(s) of
size 1843200 each.
[   41.883239] imx-ipuv3-camera imx-ipuv3-camera.2: get 3 buffer(s) of
size 1843200 each.
[   41.883303] imx-ipuv3-camera imx-ipuv3-camera.2: get 3 buffer(s) of
size 1843200 each.
[   41.883370] imx-ipuv3-camera imx-ipuv3-camera.2: get 3 buffer(s) of
size 1843200 each.
[   41.883432] imx-ipuv3-camera imx-ipuv3-camera.2: get 1 buffer(s) of
size 1843200 each.
[   41.885321] imx-ipuv3-camera imx-ipuv3-camera.2: get 3 buffer(s) of
size 1843200 each.
[   41.915234] imx-ipuv3-camera imx-ipuv3-camera.2: get 3 buffer(s) of
size 1843200 each.
[   41.939194] imx-ipuv3-camera imx-ipuv3-camera.2: get 3 buffer(s) of
size 1843200 each.
[   41.960376] imx-ipuv3-camera imx-ipuv3-camera.2: get 1 buffer(s) of
size 3686400 each.
[   41.971627] [ipucsi_videobuf_queue]
[   41.975131] [ipucsi_videobuf_queue]
[   41.978672] [ipucsi_videobuf_queue]
[   41.982173] [ipucsi_videobuf_queue]
[   41.985673] [ipu_entity] 14 entities to parse and find IPU0 SMFC0
[   41.991789] [ipu_entity] Parsing /soc/ipu@02400000/port@0
[   41.997211] [ipu_entity] Parsing /soc/ipu@02400000/port@1
[   42.002615] [ipu_entity] Parsing IPU0 SMFC0
[   42.006822] [ipu_entity] 14 entities to parse and find IPU0 SMFC0
[   42.012921] [ipu_entity] Parsing /soc/ipu@02400000/port@0
[   42.018340] [ipu_entity] Parsing /soc/ipu@02400000/port@1
[   42.023744] [ipu_entity] Parsing IPU0 SMFC0
[   42.027978] imx-ipuv3-camera imx-ipuv3-camera.2: Selected output
entity 'IPU0 SMFC0':1, channel 0
[   42.036882] imx-ipuv3 2400000.ipu: ipu_idmac_get 0
[   42.039810] imx-ipuv3-camera imx-ipuv3-camera.2: Requested NFACK
interrupt : 305
[   42.039929] imx-ipuv3-camera imx-ipuv3-camera.2: Requested EOF
interrupt : 306
[   42.040040] imx-ipuv3-camera imx-ipuv3-camera.2: Requested NFB4EOF
interrupt : 307
[   42.040056] imx-ipuv3-camera imx-ipuv3-camera.2: width: 1280
height: 720, YUYV ([   42.040075] ipu_cpmem_set_image: resolution:
1280x720 stride: 2560
[   42.040086] ipu_ch_param_write_field 0 125 13
[   42.040096] ipu_ch_param_write_field 0 138 12
[   42.040107] ipu_ch_param_write_field 1 102 14
[   42.040117] ipu_ch_param_write_field 0 107 3
[   42.040128] ipu_ch_param_write_field 1 85 4
[   42.040136] ipu_ch_param_write_field 1 78 7
[   42.040148] ipu_ch_param_write_field 1 0 29
[   42.040157] ipu_ch_param_write_field 1 29 29
[   42.040167] [ipu_cpmem_set_burstsize] burstsize : 16
[   42.045137] ipu_ch_param_write_field 1 78 7
[   42.045149] [ipu_smfc_set_watermark] SMFC_WMC: 0x0000098A
[   42.050783] ipu_ch_param_write_field 1 93 2
[   42.050804] imx-ipuv3-camera imx-ipuv3-camera.2: smfc burstsize : 3
[   42.050816] [ipu_smfc_set_burstsize] SMFC_BS: 0x00000003
[   42.056138] imx-ipuv3-camera imx-ipuv3-camera.2: smfc map channel 0 on 0
[   42.056150] [ipu_smfc_map_channel] map channel 0 on 0
[   42.061207] [ipu_smfc_map_channel] SMFC_MAP: 0x00000100
[   42.066579] [fill_csi_bus_cfg] Format 0x00002011
[   42.071203] [fill_csi_bus_cfg] bus BT.656
[   42.075225] imx-ipuv3 2400000.ipu: CSI_SENS_CONF = 0x04000950
[   42.075238] imx-ipuv3 2400000.ipu: CSI_ACT_FRM_SIZE = 0x02CF04FF
[   42.075258] ipu_ch_param_write_field 1 29 29
[   42.075292] imx-ipuv3 2400000.ipu: IPU_CONF =     0x00000101
[   42.075304] imx-ipuv3 2400000.ipu: IDMAC_CONF =     0x0000002F
[   42.075315] imx-ipuv3 2400000.ipu: IDMAC_CHA_EN1 =     0x00000001
[   42.075325] imx-ipuv3 2400000.ipu: IDMAC_CHA_EN2 =     0x00000000
[   42.075336] imx-ipuv3 2400000.ipu: IDMAC_CHA_PRI1 =     0x00000001
[   42.075346] imx-ipuv3 2400000.ipu: IDMAC_CHA_PRI2 =     0x00000000
[   42.075357] imx-ipuv3 2400000.ipu: IDMAC_BAND_EN1 =     0x00000000
[   42.075368] imx-ipuv3 2400000.ipu: IDMAC_BAND_EN2 =     0x00000000
[   42.075378] imx-ipuv3 2400000.ipu: IPU_CHA_DB_MODE_SEL0 =     0x00000000
[   42.075388] imx-ipuv3 2400000.ipu: IPU_CHA_DB_MODE_SEL1 =     0x00000000
[   42.075398] imx-ipuv3 2400000.ipu: IPU_FS_PROC_FLOW1 =     0x00000000
[   42.075408] imx-ipuv3 2400000.ipu: IPU_FS_PROC_FLOW2 =     0x00000000
[   42.075419] imx-ipuv3 2400000.ipu: IPU_FS_PROC_FLOW3 =     0x00000000
[   42.075430] imx-ipuv3 2400000.ipu: IPU_FS_DISP_FLOW1 =     0x00000000
[   42.075442] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(0) =     10800001
[   42.075453] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(1) =     00000000
[   42.075465] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(2) =     00000001
[   42.075477] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(3) =     00000000
[   42.075488] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(4) =     00000001
[   42.075500] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(5) =     00000000
[   42.075511] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(6) =     00000000
[   42.075522] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(7) =     00000000
[   42.075534] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(8) =     00000000
[   42.075545] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(9) =     00000000
[   42.075556] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(10) =     00000000
[   42.075567] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(11) =     00000000
[   42.075579] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(12) =     00000000
[   42.075590] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(13) =     00000000
[   42.075602] imx-ipuv3 2400000.ipu: IPU_INT_CTRL(14) =     00000208
[   42.075617] imx-ipuv3 2400000.ipu: ch 0 word 0 - 00000000 00000000
00000000 E0001800 000B3C9F
[   42.075632] imx-ipuv3 2400000.ipu: ch 0 word 1 - 00000000 0120C000
0103C000 00027FC0 00000000
[   42.075642] ipu_ch_param_read_field 1 85 4
[   42.075653] imx-ipuv3 2400000.ipu: PFS 0x8,
[   42.075663] ipu_ch_param_read_field 0 107 3
[   42.075674] imx-ipuv3 2400000.ipu: BPP 0x3,
[   42.075683] ipu_ch_param_read_field 1 78 7
[   42.075694] imx-ipuv3 2400000.ipu: NPB 0xf
[   42.075704] ipu_ch_param_read_field 0 125 13
[   42.075715] imx-ipuv3 2400000.ipu: FW 1279,
[   42.075723] ipu_ch_param_read_field 0 138 12
[   42.075734] imx-ipuv3 2400000.ipu: FH 719,
[   42.075743] ipu_ch_param_read_field 1 0 29
[   42.075753] imx-ipuv3 2400000.ipu: EBA0 0x48300000
[   42.075762] ipu_ch_param_read_field 1 29 29
[   42.075773] imx-ipuv3 2400000.ipu: EBA1 0x0
[   42.075782] ipu_ch_param_read_field 1 102 14
[   42.075793] imx-ipuv3 2400000.ipu: Stride 2559
[   42.075802] ipu_ch_param_read_field 0 113 1
[   42.075813] imx-ipuv3 2400000.ipu: scan_order 0
[   42.075822] ipu_ch_param_read_field 1 128 14
[   42.075832] imx-ipuv3 2400000.ipu: uv_stride 0
[   42.075840] ipu_ch_param_read_field 0 46 22
[   42.075852] imx-ipuv3 2400000.ipu: u_offset 0x0
[   42.075862] ipu_ch_param_read_field 0 68 22
[   42.075872] imx-ipuv3 2400000.ipu: v_offset 0x0
[   42.075881] ipu_ch_param_read_field 1 116 3
[   42.075891] imx-ipuv3 2400000.ipu: Width0 0+1,
[   42.075901] ipu_ch_param_read_field 1 119 3
[   42.075911] imx-ipuv3 2400000.ipu: Width1 0+1,
[   42.075920] ipu_ch_param_read_field 1 122 3
[   42.075931] imx-ipuv3 2400000.ipu: Width2 0+1,
[   42.075939] ipu_ch_param_read_field 1 125 3
[   42.075949] imx-ipuv3 2400000.ipu: Width3 0+1,
[   42.075958] ipu_ch_param_read_field 1 128 5
[   42.075968] imx-ipuv3 2400000.ipu: Offset0 0,
[   42.075977] ipu_ch_param_read_field 1 133 5
[   42.075988] imx-ipuv3 2400000.ipu: Offset1 0,
[   42.075996] ipu_ch_param_read_field 1 138 5
[   42.076007] imx-ipuv3 2400000.ipu: Offset2 0,
[   42.076015] ipu_ch_param_read_field 1 143 5
[   42.076026] imx-ipuv3 2400000.ipu: Offset3 0
[   42.076039] imx-ipuv3 2400000.ipu: CSI_SENS_CONF:     04000950
[   42.076050] imx-ipuv3 2400000.ipu: CSI_SENS_FRM_SIZE: 02cf04ff
[   42.076061] imx-ipuv3 2400000.ipu: CSI_ACT_FRM_SIZE:  02cf04ff
[   42.076071] imx-ipuv3 2400000.ipu: CSI_OUT_FRM_CTRL:  00000000
[   42.076081] imx-ipuv3 2400000.ipu: CSI_TST_CTRL:      00000000
[   42.076091] imx-ipuv3 2400000.ipu: CSI_CCIR_CODE_1:   01040030
[   42.076101] imx-ipuv3 2400000.ipu: CSI_CCIR_CODE_2:   00000000
[   42.076111] imx-ipuv3 2400000.ipu: CSI_CCIR_CODE_3:   00ff0000
[   42.076121] imx-ipuv3 2400000.ipu: CSI_MIPI_DI:       ffffffff
[   42.076132] imx-ipuv3 2400000.ipu: CSI_SKIP:          00000000

The only thing I can see in the registers dump, is that the base
adress for double buffering is set only for the first one.
But I don't know if it explains why there is not the first interrupt,
as there is an address for the first buffer...

Thanks for any advice,
JM
