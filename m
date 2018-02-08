Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:47103 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750847AbeBHPOA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Feb 2018 10:14:00 -0500
Message-ID: <1518102837.4359.6.camel@pengutronix.de>
Subject: Re: [PATCH v8 0/7] TDA1997x HDMI video reciver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Tim Harvey <tharvey@gateworks.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Date: Thu, 08 Feb 2018 16:13:57 +0100
In-Reply-To: <e13db87e-761a-b0e5-3802-348c9776674a@xs4all.nl>
References: <1517948874-21681-1-git-send-email-tharvey@gateworks.com>
         <c7771c44-a9ff-0207-38f6-28bcc06ccdee@xs4all.nl>
         <CAJ+vNU1oiM0Y0rO-DHi57nVOqnw60A7pn_1=h5b46-BrY7_p2Q@mail.gmail.com>
         <605fd4a8-43ab-c566-57b6-abb1c9f8f0f8@xs4all.nl>
         <7cf38465-7a79-5d81-a995-9acfbacf5023@xs4all.nl>
         <CAJ+vNU014FJZsb44YnidE3fFiqeB6o8A7kvGinJWu7=yq3_dhA@mail.gmail.com>
         <d188a172-fc00-eb46-c6f5-833a86475390@xs4all.nl>
         <1518086816.4359.4.camel@pengutronix.de>
         <3b95357c-e44f-eed9-efd3-e2b0e4ff9eb2@xs4all.nl>
         <e13db87e-761a-b0e5-3802-348c9776674a@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2018-02-08 at 13:01 +0100, Hans Verkuil wrote:
> > These are likely to be filled correctly already. I've just added a commit
> > to v4l2-compliance to make it easier to see what function is used:
> > 
> > 	v4l2-compliance -m0 -v
> 
> Actually, can you run this using the latest v4l-utils version for the imx
> and post the output?

I have tried with v4l-utils-1.14.0-111-g542af94c on a platform with a
Toshiba TC358743 connected via MIPI CSI-2. Apart from a crash [1], I get
a few:
- missing G_INPUT on the capture devices - is that really a bug?
- cap->timeperframe.numerator == 0 || cap->timeperframe.denominator == 0,
  where there is nothing connected that could provide timing information
- missing enum_mbus_code
- check_0(reserved) errors on subdev ioctls
- node->enum_frame_interval_pad != (int)pad
- subscribe event failures
- g_ext_ctrls does not support count == 0 (which no subdev implements)

[1] https://patchwork.linuxtv.org/patch/46979/

The CSIs are currently marked as pixel formatters instead of IF bridges,
  
the vdics are marked as pixel formatters instead of deinterlacers, and
the ic_prp is marked as scaler instead of video splitter. The other
entity functions are initialized correctly.

Complete output follows:

----------8<----------
v4l2-compliance SHA   : not available

Compliance test for device /dev/media0:

Media Driver Info:
	Driver name      : imx-media
	Model            : imx-media
	Serial           : 
	Bus info         : 
	Media version    : 4.15.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.15.0

Required ioctls:
	test MEDIA_IOC_DEVICE_INFO: OK

Allow for multiple opens:
	test second /dev/media0 open: OK
	test MEDIA_IOC_DEVICE_INFO: OK
	test for unlimited opens: OK

Media Controller ioctls:
		Entity: 0x00000001 (Name: 'ipu1_vdic', Function: 0x00004002)
		Entity: 0x00000005 (Name: 'ipu2_vdic', Function: 0x00004002)
		Entity: 0x00000009 (Name: 'ipu1_ic_prp', Function: 0x00004005)
		Entity: 0x0000000d (Name: 'ipu1_ic_prpenc', Function: 0x00004005)
		Entity: 0x00000010 (Name: 'ipu1_ic_prpenc capture', Function: 0x00010001)
		Entity: 0x00000016 (Name: 'ipu1_ic_prpvf', Function: 0x00004005)
		Entity: 0x00000019 (Name: 'ipu1_ic_prpvf capture', Function: 0x00010001)
		Entity: 0x0000001f (Name: 'ipu2_ic_prp', Function: 0x00004005)
		Entity: 0x00000023 (Name: 'ipu2_ic_prpenc', Function: 0x00004005)
		Entity: 0x00000026 (Name: 'ipu2_ic_prpenc capture', Function: 0x00010001)
		Entity: 0x0000002c (Name: 'ipu2_ic_prpvf', Function: 0x00004005)
		Entity: 0x0000002f (Name: 'ipu2_ic_prpvf capture', Function: 0x00010001)
		Entity: 0x00000035 (Name: 'ipu1_csi0', Function: 0x00004002)
		Entity: 0x00000039 (Name: 'ipu1_csi0 capture', Function: 0x00010001)
		Entity: 0x0000003f (Name: 'ipu1_csi1', Function: 0x00004002)
		Entity: 0x00000043 (Name: 'ipu1_csi1 capture', Function: 0x00010001)
		Entity: 0x00000049 (Name: 'ipu2_csi0', Function: 0x00004002)
		Entity: 0x0000004d (Name: 'ipu2_csi0 capture', Function: 0x00010001)
		Entity: 0x00000053 (Name: 'ipu2_csi1', Function: 0x00004002)
		Entity: 0x00000057 (Name: 'ipu2_csi1 capture', Function: 0x00010001)
		Entity: 0x0000005d (Name: 'imx6-mipi-csi2', Function: 0x00005002)
		Entity: 0x00000063 (Name: 'tc358743 0-000f', Function: 0x00005002)
		Entity: 0x00000065 (Name: 'ipu1_csi0_mux', Function: 0x00005001)
		Entity: 0x00000069 (Name: 'ipu2_csi1_mux', Function: 0x00005001)
		Interface: 0x03000011 (Type: 0x00000200)
		Interface: 0x0300001a (Type: 0x00000200)
		Interface: 0x03000027 (Type: 0x00000200)
		Interface: 0x03000030 (Type: 0x00000200)
		Interface: 0x0300003a (Type: 0x00000200)
		Interface: 0x03000044 (Type: 0x00000200)
		Interface: 0x0300004e (Type: 0x00000200)
		Interface: 0x03000058 (Type: 0x00000200)
		Interface: 0x03000097 (Type: 0x00000203)
		Interface: 0x03000099 (Type: 0x00000203)
		Interface: 0x0300009b (Type: 0x00000203)
		Interface: 0x0300009d (Type: 0x00000203)
		Interface: 0x0300009f (Type: 0x00000203)
		Interface: 0x030000a1 (Type: 0x00000203)
		Interface: 0x030000a3 (Type: 0x00000203)
		Interface: 0x030000a5 (Type: 0x00000203)
		Interface: 0x030000a7 (Type: 0x00000203)
		Interface: 0x030000a9 (Type: 0x00000203)
		Interface: 0x030000ab (Type: 0x00000203)
		Interface: 0x030000ad (Type: 0x00000203)
		Interface: 0x030000af (Type: 0x00000203)
		Interface: 0x030000b1 (Type: 0x00000203)
		Interface: 0x030000b3 (Type: 0x00000203)
		Interface: 0x030000b5 (Type: 0x00000203)
		Pad: 0x01000002
		Pad: 0x01000003
		Pad: 0x01000004
		Pad: 0x01000006
		Pad: 0x01000007
		Pad: 0x01000008
		Pad: 0x0100000a
		Pad: 0x0100000b
		Pad: 0x0100000c
		Pad: 0x0100000e
		Pad: 0x0100000f
		Pad: 0x01000013
		Pad: 0x01000017
		Pad: 0x01000018
		Pad: 0x0100001c
		Pad: 0x01000020
		Pad: 0x01000021
		Pad: 0x01000022
		Pad: 0x01000024
		Pad: 0x01000025
		Pad: 0x01000029
		Pad: 0x0100002d
		Pad: 0x0100002e
		Pad: 0x01000032
		Pad: 0x01000036
		Pad: 0x01000037
		Pad: 0x01000038
		Pad: 0x0100003c
		Pad: 0x01000040
		Pad: 0x01000041
		Pad: 0x01000042
		Pad: 0x01000046
		Pad: 0x0100004a
		Pad: 0x0100004b
		Pad: 0x0100004c
		Pad: 0x01000050
		Pad: 0x01000054
		Pad: 0x01000055
		Pad: 0x01000056
		Pad: 0x0100005a
		Pad: 0x0100005e
		Pad: 0x0100005f
		Pad: 0x01000060
		Pad: 0x01000061
		Pad: 0x01000062
		Pad: 0x01000064
		Pad: 0x01000066
		Pad: 0x01000067
		Pad: 0x01000068
		Pad: 0x0100006a
		Pad: 0x0100006b
		Pad: 0x0100006c
		Link: 0x02000012
		Link: 0x02000014
		Link: 0x0200001b
		Link: 0x0200001d
		Link: 0x02000028
		Link: 0x0200002a
		Link: 0x02000031
		Link: 0x02000033
		Link: 0x0200003b
		Link: 0x0200003d
		Link: 0x02000045
		Link: 0x02000047
		Link: 0x0200004f
		Link: 0x02000051
		Link: 0x02000059
		Link: 0x0200005b
		Link: 0x0200006d
		Link: 0x0200006f
		Link: 0x02000071
		Link: 0x02000073
		Link: 0x02000075
		Link: 0x02000077
		Link: 0x02000079
		Link: 0x0200007b
		Link: 0x0200007d
		Link: 0x0200007f
		Link: 0x02000081
		Link: 0x02000083
		Link: 0x02000085
		Link: 0x02000087
		Link: 0x02000089
		Link: 0x0200008b
		Link: 0x0200008d
		Link: 0x0200008f
		Link: 0x02000091
		Link: 0x02000093
		Link: 0x02000095
		Link: 0x02000098
		Link: 0x0200009a
		Link: 0x0200009c
		Link: 0x0200009e
		Link: 0x020000a0
		Link: 0x020000a2
		Link: 0x020000a4
		Link: 0x020000a6
		Link: 0x020000a8
		Link: 0x020000aa
		Link: 0x020000ac
		Link: 0x020000ae
		Link: 0x020000b0
		Link: 0x020000b2
		Link: 0x020000b4
		Link: 0x020000b6
	test MEDIA_IOC_G_TOPOLOGY: OK
	Entities: 24 Interfaces: 24 Pads: 52 Links: 53
		Entity: 0x00000001 (Name: 'ipu1_vdic', Type: 0x00020000
		Entity: 0x00000005 (Name: 'ipu2_vdic', Type: 0x00020000
		Entity: 0x00000009 (Name: 'ipu1_ic_prp', Type: 0x00020000
		Entity: 0x0000000d (Name: 'ipu1_ic_prpenc', Type: 0x00020000
		Entity: 0x00000010 (Name: 'ipu1_ic_prpenc capture', Type: 0x00010001
		Entity: 0x00000016 (Name: 'ipu1_ic_prpvf', Type: 0x00020000
		Entity: 0x00000019 (Name: 'ipu1_ic_prpvf capture', Type: 0x00010001
		Entity: 0x0000001f (Name: 'ipu2_ic_prp', Type: 0x00020000
		Entity: 0x00000023 (Name: 'ipu2_ic_prpenc', Type: 0x00020000
		Entity: 0x00000026 (Name: 'ipu2_ic_prpenc capture', Type: 0x00010001
		Entity: 0x0000002c (Name: 'ipu2_ic_prpvf', Type: 0x00020000
		Entity: 0x0000002f (Name: 'ipu2_ic_prpvf capture', Type: 0x00010001
		Entity: 0x00000035 (Name: 'ipu1_csi0', Type: 0x00020000
		Entity: 0x00000039 (Name: 'ipu1_csi0 capture', Type: 0x00010001
		Entity: 0x0000003f (Name: 'ipu1_csi1', Type: 0x00020000
		Entity: 0x00000043 (Name: 'ipu1_csi1 capture', Type: 0x00010001
		Entity: 0x00000049 (Name: 'ipu2_csi0', Type: 0x00020000
		Entity: 0x0000004d (Name: 'ipu2_csi0 capture', Type: 0x00010001
		Entity: 0x00000053 (Name: 'ipu2_csi1', Type: 0x00020000
		Entity: 0x00000057 (Name: 'ipu2_csi1 capture', Type: 0x00010001
		Entity: 0x0000005d (Name: 'imx6-mipi-csi2', Type: 0x00020000
		Entity: 0x00000063 (Name: 'tc358743 0-000f', Type: 0x00020000
		Entity: 0x00000065 (Name: 'ipu1_csi0_mux', Type: 0x00020000
		Entity: 0x00000069 (Name: 'ipu2_csi1_mux', Type: 0x00020000
		Entity Links: 0x00000001 (Name: 'ipu1_vdic')
		Entity Links: 0x00000005 (Name: 'ipu2_vdic')
		Entity Links: 0x00000009 (Name: 'ipu1_ic_prp')
		Entity Links: 0x0000000d (Name: 'ipu1_ic_prpenc')
		Entity Links: 0x00000010 (Name: 'ipu1_ic_prpenc capture')
		Entity Links: 0x00000016 (Name: 'ipu1_ic_prpvf')
		Entity Links: 0x00000019 (Name: 'ipu1_ic_prpvf capture')
		Entity Links: 0x0000001f (Name: 'ipu2_ic_prp')
		Entity Links: 0x00000023 (Name: 'ipu2_ic_prpenc')
		Entity Links: 0x00000026 (Name: 'ipu2_ic_prpenc capture')
		Entity Links: 0x0000002c (Name: 'ipu2_ic_prpvf')
		Entity Links: 0x0000002f (Name: 'ipu2_ic_prpvf capture')
		Entity Links: 0x00000035 (Name: 'ipu1_csi0')
		Entity Links: 0x00000039 (Name: 'ipu1_csi0 capture')
		Entity Links: 0x0000003f (Name: 'ipu1_csi1')
		Entity Links: 0x00000043 (Name: 'ipu1_csi1 capture')
		Entity Links: 0x00000049 (Name: 'ipu2_csi0')
		Entity Links: 0x0000004d (Name: 'ipu2_csi0 capture')
		Entity Links: 0x00000053 (Name: 'ipu2_csi1')
		Entity Links: 0x00000057 (Name: 'ipu2_csi1 capture')
		Entity Links: 0x0000005d (Name: 'imx6-mipi-csi2')
		Entity Links: 0x00000063 (Name: 'tc358743 0-000f')
		Entity Links: 0x00000065 (Name: 'ipu1_csi0_mux')
		Entity Links: 0x00000069 (Name: 'ipu2_csi1_mux')
	test MEDIA_IOC_ENUM_ENTITIES/LINKS: OK
	test MEDIA_IOC_SETUP_LINK: OK

--------------------------------------------------------------------------------

Compliance test for device /dev/video4:

Driver Info:
	Driver name      : imx-media-captu
	Card type        : imx-media-capture
	Bus info         : platform:ipu1_ic_prpenc
	Driver version   : 4.15.0
	Capabilities     : 0x84200001
		Video Capture
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps      : 0x04200001
		Video Capture
		Streaming
		Extended Pix Format
Media Driver Info:
	Driver name      : imx-media
	Model            : imx-media
	Serial           : 
	Bus info         : 
	Media version    : 4.15.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.15.0
Interface Info:
	ID               : 0x03000011
	Type             : V4L Video
Entity Info:
	ID               : 0x00000010 (16)
	Name             : ipu1_ic_prpenc capture
	Function         : V4L2 I/O
	Pad 0x01000013   : Sink
	  Link 0x02000014: from remote pad 0x100000f of entity 'ipu1_ic_prpenc': Data

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second /dev/video4 open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK (Not Supported)
		fail: v4l2-test-input-output.cpp(420): G_INPUT not supported for a capture device
	test VIDIOC_G/S/ENUMINPUT: FAIL
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
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 0 Private Controls: 0

Format ioctls:
		info: found 7 formats for buftype 1
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
		warn: v4l2-test-formats.cpp(1209): S_PARM is supported for buftype 1, but not ENUM_FRAMEINTERVALS
		fail: v4l2-test-formats.cpp(1146): cap->timeperframe.numerator == 0 || cap->timeperframe.denominator == 0
	test VIDIOC_G/S_PARM: FAIL
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK
	test VIDIOC_TRY_FMT: OK
		info: Global format check succeeded for type 1
	test VIDIOC_S_FMT: OK
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
		info: test buftype Video Capture
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK

--------------------------------------------------------------------------------

Compliance test for device /dev/video5:

Driver Info:
	Driver name      : imx-media-captu
	Card type        : imx-media-capture
	Bus info         : platform:ipu1_ic_prpvf
	Driver version   : 4.15.0
	Capabilities     : 0x84200001
		Video Capture
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps      : 0x04200001
		Video Capture
		Streaming
		Extended Pix Format
Media Driver Info:
	Driver name      : imx-media
	Model            : imx-media
	Serial           : 
	Bus info         : 
	Media version    : 4.15.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.15.0
Interface Info:
	ID               : 0x0300001a
	Type             : V4L Video
Entity Info:
	ID               : 0x00000019 (25)
	Name             : ipu1_ic_prpvf capture
	Function         : V4L2 I/O
	Pad 0x0100001c   : Sink
	  Link 0x0200001d: from remote pad 0x1000018 of entity 'ipu1_ic_prpvf': Data

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second /dev/video5 open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK (Not Supported)
		fail: v4l2-test-input-output.cpp(420): G_INPUT not supported for a capture device
	test VIDIOC_G/S/ENUMINPUT: FAIL
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
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 0 Private Controls: 0

Format ioctls:
		info: found 7 formats for buftype 1
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
		warn: v4l2-test-formats.cpp(1209): S_PARM is supported for buftype 1, but not ENUM_FRAMEINTERVALS
		fail: v4l2-test-formats.cpp(1146): cap->timeperframe.numerator == 0 || cap->timeperframe.denominator == 0
	test VIDIOC_G/S_PARM: FAIL
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK
	test VIDIOC_TRY_FMT: OK
		info: Global format check succeeded for type 1
	test VIDIOC_S_FMT: OK
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
		info: test buftype Video Capture
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK

--------------------------------------------------------------------------------

Compliance test for device /dev/video6:

Driver Info:
	Driver name      : imx-media-captu
	Card type        : imx-media-capture
	Bus info         : platform:ipu2_ic_prpenc
	Driver version   : 4.15.0
	Capabilities     : 0x84200001
		Video Capture
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps      : 0x04200001
		Video Capture
		Streaming
		Extended Pix Format
Media Driver Info:
	Driver name      : imx-media
	Model            : imx-media
	Serial           : 
	Bus info         : 
	Media version    : 4.15.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.15.0
Interface Info:
	ID               : 0x03000027
	Type             : V4L Video
Entity Info:
	ID               : 0x00000026 (38)
	Name             : ipu2_ic_prpenc capture
	Function         : V4L2 I/O
	Pad 0x01000029   : Sink
	  Link 0x0200002a: from remote pad 0x1000025 of entity 'ipu2_ic_prpenc': Data

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second /dev/video6 open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK (Not Supported)
		fail: v4l2-test-input-output.cpp(420): G_INPUT not supported for a capture device
	test VIDIOC_G/S/ENUMINPUT: FAIL
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
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 0 Private Controls: 0

Format ioctls:
		info: found 7 formats for buftype 1
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
		warn: v4l2-test-formats.cpp(1209): S_PARM is supported for buftype 1, but not ENUM_FRAMEINTERVALS
		fail: v4l2-test-formats.cpp(1146): cap->timeperframe.numerator == 0 || cap->timeperframe.denominator == 0
	test VIDIOC_G/S_PARM: FAIL
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK
	test VIDIOC_TRY_FMT: OK
		info: Global format check succeeded for type 1
	test VIDIOC_S_FMT: OK
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
		info: test buftype Video Capture
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK

--------------------------------------------------------------------------------

Compliance test for device /dev/video7:

Driver Info:
	Driver name      : imx-media-captu
	Card type        : imx-media-capture
	Bus info         : platform:ipu2_ic_prpvf
	Driver version   : 4.15.0
	Capabilities     : 0x84200001
		Video Capture
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps      : 0x04200001
		Video Capture
		Streaming
		Extended Pix Format
Media Driver Info:
	Driver name      : imx-media
	Model            : imx-media
	Serial           : 
	Bus info         : 
	Media version    : 4.15.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.15.0
Interface Info:
	ID               : 0x03000030
	Type             : V4L Video
Entity Info:
	ID               : 0x0000002f (47)
	Name             : ipu2_ic_prpvf capture
	Function         : V4L2 I/O
	Pad 0x01000032   : Sink
	  Link 0x02000033: from remote pad 0x100002e of entity 'ipu2_ic_prpvf': Data

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second /dev/video7 open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK (Not Supported)
		fail: v4l2-test-input-output.cpp(420): G_INPUT not supported for a capture device
	test VIDIOC_G/S/ENUMINPUT: FAIL
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
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 0 Private Controls: 0

Format ioctls:
		info: found 7 formats for buftype 1
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
		warn: v4l2-test-formats.cpp(1209): S_PARM is supported for buftype 1, but not ENUM_FRAMEINTERVALS
		fail: v4l2-test-formats.cpp(1146): cap->timeperframe.numerator == 0 || cap->timeperframe.denominator == 0
	test VIDIOC_G/S_PARM: FAIL
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK
	test VIDIOC_TRY_FMT: OK
		info: Global format check succeeded for type 1
	test VIDIOC_S_FMT: OK
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
		info: test buftype Video Capture
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK

--------------------------------------------------------------------------------

Compliance test for device /dev/video8:

Driver Info:
	Driver name      : imx-media-captu
	Card type        : imx-media-capture
	Bus info         : platform:ipu1_csi0
	Driver version   : 4.15.0
	Capabilities     : 0x84200001
		Video Capture
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps      : 0x04200001
		Video Capture
		Streaming
		Extended Pix Format
Media Driver Info:
	Driver name      : imx-media
	Model            : imx-media
	Serial           : 
	Bus info         : 
	Media version    : 4.15.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.15.0
Interface Info:
	ID               : 0x0300003a
	Type             : V4L Video
Entity Info:
	ID               : 0x00000039 (57)
	Name             : ipu1_csi0 capture
	Function         : V4L2 I/O
	Pad 0x0100003c   : Sink
	  Link 0x0200003d: from remote pad 0x1000038 of entity 'ipu1_csi0': Data

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second /dev/video8 open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK (Not Supported)
		fail: v4l2-test-input-output.cpp(420): G_INPUT not supported for a capture device
	test VIDIOC_G/S/ENUMINPUT: FAIL
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
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 0 Private Controls: 0

Format ioctls:
		info: found 12 frameintervals for pixel format 59565955 (UYVY) and size 640x480
		info: found 12 frameintervals for pixel format 59565955 (UYVY) and size 320x480
		info: found 12 frameintervals for pixel format 59565955 (UYVY) and size 640x240
		info: found 12 frameintervals for pixel format 59565955 (UYVY) and size 320x240
		info: found 4 framesizes for pixel format 59565955 (UYVY)
		info: found 12 frameintervals for pixel format 56595559 (YUYV) and size 640x480
		info: found 12 frameintervals for pixel format 56595559 (YUYV) and size 320x480
		info: found 12 frameintervals for pixel format 56595559 (YUYV) and size 640x240
		info: found 12 frameintervals for pixel format 56595559 (YUYV) and size 320x240
		info: found 4 framesizes for pixel format 56595559 (YUYV)
		info: found 12 frameintervals for pixel format 32315559 (YU12) and size 640x480
		info: found 12 frameintervals for pixel format 32315559 (YU12) and size 320x480
		info: found 12 frameintervals for pixel format 32315559 (YU12) and size 640x240
		info: found 12 frameintervals for pixel format 32315559 (YU12) and size 320x240
		info: found 4 framesizes for pixel format 32315559 (YU12)
		info: found 12 frameintervals for pixel format 32315659 (YV12) and size 640x480
		info: found 12 frameintervals for pixel format 32315659 (YV12) and size 320x480
		info: found 12 frameintervals for pixel format 32315659 (YV12) and size 640x240
		info: found 12 frameintervals for pixel format 32315659 (YV12) and size 320x240
		info: found 4 framesizes for pixel format 32315659 (YV12)
		info: found 12 frameintervals for pixel format 50323234 (422P) and size 640x480
		info: found 12 frameintervals for pixel format 50323234 (422P) and size 320x480
		info: found 12 frameintervals for pixel format 50323234 (422P) and size 640x240
		info: found 12 frameintervals for pixel format 50323234 (422P) and size 320x240
		info: found 4 framesizes for pixel format 50323234 (422P)
		info: found 12 frameintervals for pixel format 3231564e (NV12) and size 640x480
		info: found 12 frameintervals for pixel format 3231564e (NV12) and size 320x480
		info: found 12 frameintervals for pixel format 3231564e (NV12) and size 640x240
		info: found 12 frameintervals for pixel format 3231564e (NV12) and size 320x240
		info: found 4 framesizes for pixel format 3231564e (NV12)
		info: found 12 frameintervals for pixel format 3631564e (NV16) and size 640x480
		info: found 12 frameintervals for pixel format 3631564e (NV16) and size 320x480
		info: found 12 frameintervals for pixel format 3631564e (NV16) and size 640x240
		info: found 12 frameintervals for pixel format 3631564e (NV16) and size 320x240
		info: found 4 framesizes for pixel format 3631564e (NV16)
		info: found 7 formats for buftype 1
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
	test VIDIOC_G/S_PARM: OK
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK
	test VIDIOC_TRY_FMT: OK
		info: Global format check succeeded for type 1
	test VIDIOC_S_FMT: OK
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
		info: test buftype Video Capture
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK

--------------------------------------------------------------------------------

Compliance test for device /dev/video9:

Driver Info:
	Driver name      : imx-media-captu
	Card type        : imx-media-capture
	Bus info         : platform:ipu1_csi1
	Driver version   : 4.15.0
	Capabilities     : 0x84200001
		Video Capture
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps      : 0x04200001
		Video Capture
		Streaming
		Extended Pix Format
Media Driver Info:
	Driver name      : imx-media
	Model            : imx-media
	Serial           : 
	Bus info         : 
	Media version    : 4.15.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.15.0
Interface Info:
	ID               : 0x03000044
	Type             : V4L Video
Entity Info:
	ID               : 0x00000043 (67)
	Name             : ipu1_csi1 capture
	Function         : V4L2 I/O
	Pad 0x01000046   : Sink
	  Link 0x02000047: from remote pad 0x1000042 of entity 'ipu1_csi1': Data

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second /dev/video9 open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK (Not Supported)
		fail: v4l2-test-input-output.cpp(420): G_INPUT not supported for a capture device
	test VIDIOC_G/S/ENUMINPUT: FAIL
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
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 0 Private Controls: 0

Format ioctls:
		info: found 12 frameintervals for pixel format 59565955 (UYVY) and size 640x480
		info: found 12 frameintervals for pixel format 59565955 (UYVY) and size 320x480
		info: found 12 frameintervals for pixel format 59565955 (UYVY) and size 640x240
		info: found 12 frameintervals for pixel format 59565955 (UYVY) and size 320x240
		info: found 4 framesizes for pixel format 59565955 (UYVY)
		info: found 12 frameintervals for pixel format 56595559 (YUYV) and size 640x480
		info: found 12 frameintervals for pixel format 56595559 (YUYV) and size 320x480
		info: found 12 frameintervals for pixel format 56595559 (YUYV) and size 640x240
		info: found 12 frameintervals for pixel format 56595559 (YUYV) and size 320x240
		info: found 4 framesizes for pixel format 56595559 (YUYV)
		info: found 12 frameintervals for pixel format 32315559 (YU12) and size 640x480
		info: found 12 frameintervals for pixel format 32315559 (YU12) and size 320x480
		info: found 12 frameintervals for pixel format 32315559 (YU12) and size 640x240
		info: found 12 frameintervals for pixel format 32315559 (YU12) and size 320x240
		info: found 4 framesizes for pixel format 32315559 (YU12)
		info: found 12 frameintervals for pixel format 32315659 (YV12) and size 640x480
		info: found 12 frameintervals for pixel format 32315659 (YV12) and size 320x480
		info: found 12 frameintervals for pixel format 32315659 (YV12) and size 640x240
		info: found 12 frameintervals for pixel format 32315659 (YV12) and size 320x240
		info: found 4 framesizes for pixel format 32315659 (YV12)
		info: found 12 frameintervals for pixel format 50323234 (422P) and size 640x480
		info: found 12 frameintervals for pixel format 50323234 (422P) and size 320x480
		info: found 12 frameintervals for pixel format 50323234 (422P) and size 640x240
		info: found 12 frameintervals for pixel format 50323234 (422P) and size 320x240
		info: found 4 framesizes for pixel format 50323234 (422P)
		info: found 12 frameintervals for pixel format 3231564e (NV12) and size 640x480
		info: found 12 frameintervals for pixel format 3231564e (NV12) and size 320x480
		info: found 12 frameintervals for pixel format 3231564e (NV12) and size 640x240
		info: found 12 frameintervals for pixel format 3231564e (NV12) and size 320x240
		info: found 4 framesizes for pixel format 3231564e (NV12)
		info: found 12 frameintervals for pixel format 3631564e (NV16) and size 640x480
		info: found 12 frameintervals for pixel format 3631564e (NV16) and size 320x480
		info: found 12 frameintervals for pixel format 3631564e (NV16) and size 640x240
		info: found 12 frameintervals for pixel format 3631564e (NV16) and size 320x240
		info: found 4 framesizes for pixel format 3631564e (NV16)
		info: found 7 formats for buftype 1
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
	test VIDIOC_G/S_PARM: OK
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK
	test VIDIOC_TRY_FMT: OK
		info: Global format check succeeded for type 1
	test VIDIOC_S_FMT: OK
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
		info: test buftype Video Capture
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK

--------------------------------------------------------------------------------

Compliance test for device /dev/video10:

Driver Info:
	Driver name      : imx-media-captu
	Card type        : imx-media-capture
	Bus info         : platform:ipu2_csi0
	Driver version   : 4.15.0
	Capabilities     : 0x84200001
		Video Capture
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps      : 0x04200001
		Video Capture
		Streaming
		Extended Pix Format
Media Driver Info:
	Driver name      : imx-media
	Model            : imx-media
	Serial           : 
	Bus info         : 
	Media version    : 4.15.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.15.0
Interface Info:
	ID               : 0x0300004e
	Type             : V4L Video
Entity Info:
	ID               : 0x0000004d (77)
	Name             : ipu2_csi0 capture
	Function         : V4L2 I/O
	Pad 0x01000050   : Sink
	  Link 0x02000051: from remote pad 0x100004c of entity 'ipu2_csi0': Data

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second /dev/video10 open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK (Not Supported)
		fail: v4l2-test-input-output.cpp(420): G_INPUT not supported for a capture device
	test VIDIOC_G/S/ENUMINPUT: FAIL
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
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 0 Private Controls: 0

Format ioctls:
		info: found 12 frameintervals for pixel format 59565955 (UYVY) and size 640x480
		info: found 12 frameintervals for pixel format 59565955 (UYVY) and size 320x480
		info: found 12 frameintervals for pixel format 59565955 (UYVY) and size 640x240
		info: found 12 frameintervals for pixel format 59565955 (UYVY) and size 320x240
		info: found 4 framesizes for pixel format 59565955 (UYVY)
		info: found 12 frameintervals for pixel format 56595559 (YUYV) and size 640x480
		info: found 12 frameintervals for pixel format 56595559 (YUYV) and size 320x480
		info: found 12 frameintervals for pixel format 56595559 (YUYV) and size 640x240
		info: found 12 frameintervals for pixel format 56595559 (YUYV) and size 320x240
		info: found 4 framesizes for pixel format 56595559 (YUYV)
		info: found 12 frameintervals for pixel format 32315559 (YU12) and size 640x480
		info: found 12 frameintervals for pixel format 32315559 (YU12) and size 320x480
		info: found 12 frameintervals for pixel format 32315559 (YU12) and size 640x240
		info: found 12 frameintervals for pixel format 32315559 (YU12) and size 320x240
		info: found 4 framesizes for pixel format 32315559 (YU12)
		info: found 12 frameintervals for pixel format 32315659 (YV12) and size 640x480
		info: found 12 frameintervals for pixel format 32315659 (YV12) and size 320x480
		info: found 12 frameintervals for pixel format 32315659 (YV12) and size 640x240
		info: found 12 frameintervals for pixel format 32315659 (YV12) and size 320x240
		info: found 4 framesizes for pixel format 32315659 (YV12)
		info: found 12 frameintervals for pixel format 50323234 (422P) and size 640x480
		info: found 12 frameintervals for pixel format 50323234 (422P) and size 320x480
		info: found 12 frameintervals for pixel format 50323234 (422P) and size 640x240
		info: found 12 frameintervals for pixel format 50323234 (422P) and size 320x240
		info: found 4 framesizes for pixel format 50323234 (422P)
		info: found 12 frameintervals for pixel format 3231564e (NV12) and size 640x480
		info: found 12 frameintervals for pixel format 3231564e (NV12) and size 320x480
		info: found 12 frameintervals for pixel format 3231564e (NV12) and size 640x240
		info: found 12 frameintervals for pixel format 3231564e (NV12) and size 320x240
		info: found 4 framesizes for pixel format 3231564e (NV12)
		info: found 12 frameintervals for pixel format 3631564e (NV16) and size 640x480
		info: found 12 frameintervals for pixel format 3631564e (NV16) and size 320x480
		info: found 12 frameintervals for pixel format 3631564e (NV16) and size 640x240
		info: found 12 frameintervals for pixel format 3631564e (NV16) and size 320x240
		info: found 4 framesizes for pixel format 3631564e (NV16)
		info: found 7 formats for buftype 1
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
	test VIDIOC_G/S_PARM: OK
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK
	test VIDIOC_TRY_FMT: OK
		info: Global format check succeeded for type 1
	test VIDIOC_S_FMT: OK
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
		info: test buftype Video Capture
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK

--------------------------------------------------------------------------------

Compliance test for device /dev/video11:

Driver Info:
	Driver name      : imx-media-captu
	Card type        : imx-media-capture
	Bus info         : platform:ipu2_csi1
	Driver version   : 4.15.0
	Capabilities     : 0x84200001
		Video Capture
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps      : 0x04200001
		Video Capture
		Streaming
		Extended Pix Format
Media Driver Info:
	Driver name      : imx-media
	Model            : imx-media
	Serial           : 
	Bus info         : 
	Media version    : 4.15.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.15.0
Interface Info:
	ID               : 0x03000058
	Type             : V4L Video
Entity Info:
	ID               : 0x00000057 (87)
	Name             : ipu2_csi1 capture
	Function         : V4L2 I/O
	Pad 0x0100005a   : Sink
	  Link 0x0200005b: from remote pad 0x1000056 of entity 'ipu2_csi1': Data

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second /dev/video11 open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK (Not Supported)
		fail: v4l2-test-input-output.cpp(420): G_INPUT not supported for a capture device
	test VIDIOC_G/S/ENUMINPUT: FAIL
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
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 0 Private Controls: 0

Format ioctls:
		info: found 12 frameintervals for pixel format 59565955 (UYVY) and size 640x480
		info: found 12 frameintervals for pixel format 59565955 (UYVY) and size 320x480
		info: found 12 frameintervals for pixel format 59565955 (UYVY) and size 640x240
		info: found 12 frameintervals for pixel format 59565955 (UYVY) and size 320x240
		info: found 4 framesizes for pixel format 59565955 (UYVY)
		info: found 12 frameintervals for pixel format 56595559 (YUYV) and size 640x480
		info: found 12 frameintervals for pixel format 56595559 (YUYV) and size 320x480
		info: found 12 frameintervals for pixel format 56595559 (YUYV) and size 640x240
		info: found 12 frameintervals for pixel format 56595559 (YUYV) and size 320x240
		info: found 4 framesizes for pixel format 56595559 (YUYV)
		info: found 12 frameintervals for pixel format 32315559 (YU12) and size 640x480
		info: found 12 frameintervals for pixel format 32315559 (YU12) and size 320x480
		info: found 12 frameintervals for pixel format 32315559 (YU12) and size 640x240
		info: found 12 frameintervals for pixel format 32315559 (YU12) and size 320x240
		info: found 4 framesizes for pixel format 32315559 (YU12)
		info: found 12 frameintervals for pixel format 32315659 (YV12) and size 640x480
		info: found 12 frameintervals for pixel format 32315659 (YV12) and size 320x480
		info: found 12 frameintervals for pixel format 32315659 (YV12) and size 640x240
		info: found 12 frameintervals for pixel format 32315659 (YV12) and size 320x240
		info: found 4 framesizes for pixel format 32315659 (YV12)
		info: found 12 frameintervals for pixel format 50323234 (422P) and size 640x480
		info: found 12 frameintervals for pixel format 50323234 (422P) and size 320x480
		info: found 12 frameintervals for pixel format 50323234 (422P) and size 640x240
		info: found 12 frameintervals for pixel format 50323234 (422P) and size 320x240
		info: found 4 framesizes for pixel format 50323234 (422P)
		info: found 12 frameintervals for pixel format 3231564e (NV12) and size 640x480
		info: found 12 frameintervals for pixel format 3231564e (NV12) and size 320x480
		info: found 12 frameintervals for pixel format 3231564e (NV12) and size 640x240
		info: found 12 frameintervals for pixel format 3231564e (NV12) and size 320x240
		info: found 4 framesizes for pixel format 3231564e (NV12)
		info: found 12 frameintervals for pixel format 3631564e (NV16) and size 640x480
		info: found 12 frameintervals for pixel format 3631564e (NV16) and size 320x480
		info: found 12 frameintervals for pixel format 3631564e (NV16) and size 640x240
		info: found 12 frameintervals for pixel format 3631564e (NV16) and size 320x240
		info: found 4 framesizes for pixel format 3631564e (NV16)
		info: found 7 formats for buftype 1
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
	test VIDIOC_G/S_PARM: OK
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK
	test VIDIOC_TRY_FMT: OK
		info: Global format check succeeded for type 1
	test VIDIOC_S_FMT: OK
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
		info: test buftype Video Capture
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK

--------------------------------------------------------------------------------

Compliance test for device /dev/v4l-subdev0:

Media Driver Info:
	Driver name      : imx-media
	Model            : imx-media
	Serial           : 
	Bus info         : 
	Media version    : 4.15.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.15.0
Interface Info:
	ID               : 0x03000097
	Type             : V4L Sub-Device
Entity Info:
	ID               : 0x00000001 (1)
	Name             : ipu1_vdic
	Function         : Video Pixel Formatter
	Pad 0x01000002   : Sink
	  Link 0x0200007b: from remote pad 0x1000037 of entity 'ipu1_csi0': Data
	  Link 0x02000081: from remote pad 0x1000041 of entity 'ipu1_csi1': Data
	Pad 0x01000003   : Sink
	Pad 0x01000004   : Source
	  Link 0x0200006d: to remote pad 0x100000a of entity 'ipu1_ic_prp': Data

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK

Allow for multiple opens:
	test second /dev/v4l-subdev0 open: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_LOG_STATUS: OK (Not Supported)

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

Sub-Device ioctls (Sink Pad 0):
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Sub-Device ioctls (Sink Pad 1):
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Sub-Device ioctls (Source Pad 2):
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Control ioctls:
		info: checking v4l2_queryctrl of control 'Image Processing Controls' (0x009f0001)
		info: checking v4l2_queryctrl of control 'Deinterlacing Mode' (0x009f0904)
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
		info: checking control 'Image Processing Controls' (0x009f0001)
		info: checking control 'Deinterlacing Mode' (0x009f0904)
	test VIDIOC_G/S_CTRL: OK
		info: checking extended control 'Image Processing Controls' (0x009f0001)
		info: checking extended control 'Deinterlacing Mode' (0x009f0904)
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		info: checking control event 'Image Processing Controls' (0x009f0001)
		fail: v4l2-test-controls.cpp(796): subscribe event for control 'Image Processing Controls' failed
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 2 Private Controls: 0

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
	test VIDIOC_G/S_PARM: OK (Not Supported)
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK (Not Supported)
	test VIDIOC_TRY_FMT: OK (Not Supported)
	test VIDIOC_S_FMT: OK (Not Supported)
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)
	test VIDIOC_EXPBUF: OK (Not Supported)

--------------------------------------------------------------------------------

Compliance test for device /dev/v4l-subdev1:

Media Driver Info:
	Driver name      : imx-media
	Model            : imx-media
	Serial           : 
	Bus info         : 
	Media version    : 4.15.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.15.0
Interface Info:
	ID               : 0x03000099
	Type             : V4L Sub-Device
Entity Info:
	ID               : 0x00000005 (5)
	Name             : ipu2_vdic
	Function         : Video Pixel Formatter
	Pad 0x01000006   : Sink
	  Link 0x02000087: from remote pad 0x100004b of entity 'ipu2_csi0': Data
	  Link 0x0200008d: from remote pad 0x1000055 of entity 'ipu2_csi1': Data
	Pad 0x01000007   : Sink
	Pad 0x01000008   : Source
	  Link 0x0200006f: to remote pad 0x1000020 of entity 'ipu2_ic_prp': Data

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK

Allow for multiple opens:
	test second /dev/v4l-subdev1 open: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_LOG_STATUS: OK (Not Supported)

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

Sub-Device ioctls (Sink Pad 0):
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Sub-Device ioctls (Sink Pad 1):
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Sub-Device ioctls (Source Pad 2):
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Control ioctls:
		info: checking v4l2_queryctrl of control 'Image Processing Controls' (0x009f0001)
		info: checking v4l2_queryctrl of control 'Deinterlacing Mode' (0x009f0904)
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
		info: checking control 'Image Processing Controls' (0x009f0001)
		info: checking control 'Deinterlacing Mode' (0x009f0904)
	test VIDIOC_G/S_CTRL: OK
		info: checking extended control 'Image Processing Controls' (0x009f0001)
		info: checking extended control 'Deinterlacing Mode' (0x009f0904)
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		info: checking control event 'Image Processing Controls' (0x009f0001)
		fail: v4l2-test-controls.cpp(796): subscribe event for control 'Image Processing Controls' failed
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 2 Private Controls: 0

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
	test VIDIOC_G/S_PARM: OK (Not Supported)
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK (Not Supported)
	test VIDIOC_TRY_FMT: OK (Not Supported)
	test VIDIOC_S_FMT: OK (Not Supported)
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)
	test VIDIOC_EXPBUF: OK (Not Supported)

--------------------------------------------------------------------------------

Compliance test for device /dev/v4l-subdev2:

Media Driver Info:
	Driver name      : imx-media
	Model            : imx-media
	Serial           : 
	Bus info         : 
	Media version    : 4.15.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.15.0
Interface Info:
	ID               : 0x0300009b
	Type             : V4L Sub-Device
Entity Info:
	ID               : 0x00000009 (9)
	Name             : ipu1_ic_prp
	Function         : Video Scaler
	Pad 0x0100000a   : Sink
	  Link 0x0200006d: from remote pad 0x1000004 of entity 'ipu1_vdic': Data
	  Link 0x02000079: from remote pad 0x1000037 of entity 'ipu1_csi0': Data
	  Link 0x0200007f: from remote pad 0x1000041 of entity 'ipu1_csi1': Data
	Pad 0x0100000b   : Source
	  Link 0x02000071: to remote pad 0x100000e of entity 'ipu1_ic_prpenc': Data
	Pad 0x0100000c   : Source
	  Link 0x02000073: to remote pad 0x1000017 of entity 'ipu1_ic_prpvf': Data

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK

Allow for multiple opens:
	test second /dev/v4l-subdev2 open: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_LOG_STATUS: OK (Not Supported)

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

Sub-Device ioctls (Sink Pad 0):
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Sub-Device ioctls (Source Pad 1):
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Sub-Device ioctls (Source Pad 2):
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Control ioctls:
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
		fail: v4l2-test-controls.cpp(587): g_ext_ctrls does not support count == 0
	test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 0 Private Controls: 0

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
	test VIDIOC_G/S_PARM: OK (Not Supported)
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK (Not Supported)
	test VIDIOC_TRY_FMT: OK (Not Supported)
	test VIDIOC_S_FMT: OK (Not Supported)
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)
	test VIDIOC_EXPBUF: OK (Not Supported)

--------------------------------------------------------------------------------

Compliance test for device /dev/v4l-subdev3:

Media Driver Info:
	Driver name      : imx-media
	Model            : imx-media
	Serial           : 
	Bus info         : 
	Media version    : 4.15.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.15.0
Interface Info:
	ID               : 0x0300009d
	Type             : V4L Sub-Device
Entity Info:
	ID               : 0x0000000d (13)
	Name             : ipu1_ic_prpenc
	Function         : Video Scaler
	Pad 0x0100000e   : Sink
	  Link 0x02000071: from remote pad 0x100000b of entity 'ipu1_ic_prp': Data
	Pad 0x0100000f   : Source
	  Link 0x02000014: to remote pad 0x1000013 of entity 'ipu1_ic_prpenc capture': Data

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK

Allow for multiple opens:
	test second /dev/v4l-subdev3 open: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_LOG_STATUS: OK (Not Supported)

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

Sub-Device ioctls (Sink Pad 0):
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Sub-Device ioctls (Source Pad 1):
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Control ioctls:
		info: checking v4l2_queryctrl of control 'User Controls' (0x00980001)
		info: checking v4l2_queryctrl of control 'Horizontal Flip' (0x00980914)
		info: checking v4l2_queryctrl of control 'Vertical Flip' (0x00980915)
		info: checking v4l2_queryctrl of control 'Rotate' (0x00980922)
		info: checking v4l2_queryctrl of control 'Horizontal Flip' (0x00980914)
		info: checking v4l2_queryctrl of control 'Vertical Flip' (0x00980915)
		info: checking v4l2_queryctrl of control 'Rotate' (0x00980922)
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
		info: checking control 'User Controls' (0x00980001)
		info: checking control 'Horizontal Flip' (0x00980914)
		info: checking control 'Vertical Flip' (0x00980915)
		info: checking control 'Rotate' (0x00980922)
	test VIDIOC_G/S_CTRL: OK
		info: checking extended control 'User Controls' (0x00980001)
		info: checking extended control 'Horizontal Flip' (0x00980914)
		info: checking extended control 'Vertical Flip' (0x00980915)
		info: checking extended control 'Rotate' (0x00980922)
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		info: checking control event 'User Controls' (0x00980001)
		fail: v4l2-test-controls.cpp(796): subscribe event for control 'User Controls' failed
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 4 Private Controls: 0

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
	test VIDIOC_G/S_PARM: OK (Not Supported)
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK (Not Supported)
	test VIDIOC_TRY_FMT: OK (Not Supported)
	test VIDIOC_S_FMT: OK (Not Supported)
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)
	test VIDIOC_EXPBUF: OK (Not Supported)

--------------------------------------------------------------------------------

Compliance test for device /dev/v4l-subdev4:

Media Driver Info:
	Driver name      : imx-media
	Model            : imx-media
	Serial           : 
	Bus info         : 
	Media version    : 4.15.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.15.0
Interface Info:
	ID               : 0x0300009f
	Type             : V4L Sub-Device
Entity Info:
	ID               : 0x00000016 (22)
	Name             : ipu1_ic_prpvf
	Function         : Video Scaler
	Pad 0x01000017   : Sink
	  Link 0x02000073: from remote pad 0x100000c of entity 'ipu1_ic_prp': Data
	Pad 0x01000018   : Source
	  Link 0x0200001d: to remote pad 0x100001c of entity 'ipu1_ic_prpvf capture': Data

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK

Allow for multiple opens:
	test second /dev/v4l-subdev4 open: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_LOG_STATUS: OK (Not Supported)

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

Sub-Device ioctls (Sink Pad 0):
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Sub-Device ioctls (Source Pad 1):
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Control ioctls:
		info: checking v4l2_queryctrl of control 'User Controls' (0x00980001)
		info: checking v4l2_queryctrl of control 'Horizontal Flip' (0x00980914)
		info: checking v4l2_queryctrl of control 'Vertical Flip' (0x00980915)
		info: checking v4l2_queryctrl of control 'Rotate' (0x00980922)
		info: checking v4l2_queryctrl of control 'Horizontal Flip' (0x00980914)
		info: checking v4l2_queryctrl of control 'Vertical Flip' (0x00980915)
		info: checking v4l2_queryctrl of control 'Rotate' (0x00980922)
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
		info: checking control 'User Controls' (0x00980001)
		info: checking control 'Horizontal Flip' (0x00980914)
		info: checking control 'Vertical Flip' (0x00980915)
		info: checking control 'Rotate' (0x00980922)
	test VIDIOC_G/S_CTRL: OK
		info: checking extended control 'User Controls' (0x00980001)
		info: checking extended control 'Horizontal Flip' (0x00980914)
		info: checking extended control 'Vertical Flip' (0x00980915)
		info: checking extended control 'Rotate' (0x00980922)
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		info: checking control event 'User Controls' (0x00980001)
		fail: v4l2-test-controls.cpp(796): subscribe event for control 'User Controls' failed
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 4 Private Controls: 0

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
	test VIDIOC_G/S_PARM: OK (Not Supported)
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK (Not Supported)
	test VIDIOC_TRY_FMT: OK (Not Supported)
	test VIDIOC_S_FMT: OK (Not Supported)
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)
	test VIDIOC_EXPBUF: OK (Not Supported)

--------------------------------------------------------------------------------

Compliance test for device /dev/v4l-subdev5:

Media Driver Info:
	Driver name      : imx-media
	Model            : imx-media
	Serial           : 
	Bus info         : 
	Media version    : 4.15.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.15.0
Interface Info:
	ID               : 0x030000a1
	Type             : V4L Sub-Device
Entity Info:
	ID               : 0x0000001f (31)
	Name             : ipu2_ic_prp
	Function         : Video Scaler
	Pad 0x01000020   : Sink
	  Link 0x0200006f: from remote pad 0x1000008 of entity 'ipu2_vdic': Data
	  Link 0x02000085: from remote pad 0x100004b of entity 'ipu2_csi0': Data
	  Link 0x0200008b: from remote pad 0x1000055 of entity 'ipu2_csi1': Data
	Pad 0x01000021   : Source
	  Link 0x02000075: to remote pad 0x1000024 of entity 'ipu2_ic_prpenc': Data
	Pad 0x01000022   : Source
	  Link 0x02000077: to remote pad 0x100002d of entity 'ipu2_ic_prpvf': Data

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK

Allow for multiple opens:
	test second /dev/v4l-subdev5 open: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_LOG_STATUS: OK (Not Supported)

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

Sub-Device ioctls (Sink Pad 0):
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Sub-Device ioctls (Source Pad 1):
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Sub-Device ioctls (Source Pad 2):
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Control ioctls:
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
		fail: v4l2-test-controls.cpp(587): g_ext_ctrls does not support count == 0
	test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 0 Private Controls: 0

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
	test VIDIOC_G/S_PARM: OK (Not Supported)
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK (Not Supported)
	test VIDIOC_TRY_FMT: OK (Not Supported)
	test VIDIOC_S_FMT: OK (Not Supported)
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)
	test VIDIOC_EXPBUF: OK (Not Supported)

--------------------------------------------------------------------------------

Compliance test for device /dev/v4l-subdev6:

Media Driver Info:
	Driver name      : imx-media
	Model            : imx-media
	Serial           : 
	Bus info         : 
	Media version    : 4.15.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.15.0
Interface Info:
	ID               : 0x030000a3
	Type             : V4L Sub-Device
Entity Info:
	ID               : 0x00000023 (35)
	Name             : ipu2_ic_prpenc
	Function         : Video Scaler
	Pad 0x01000024   : Sink
	  Link 0x02000075: from remote pad 0x1000021 of entity 'ipu2_ic_prp': Data
	Pad 0x01000025   : Source
	  Link 0x0200002a: to remote pad 0x1000029 of entity 'ipu2_ic_prpenc capture': Data

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK

Allow for multiple opens:
	test second /dev/v4l-subdev6 open: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_LOG_STATUS: OK (Not Supported)

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

Sub-Device ioctls (Sink Pad 0):
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Sub-Device ioctls (Source Pad 1):
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Control ioctls:
		info: checking v4l2_queryctrl of control 'User Controls' (0x00980001)
		info: checking v4l2_queryctrl of control 'Horizontal Flip' (0x00980914)
		info: checking v4l2_queryctrl of control 'Vertical Flip' (0x00980915)
		info: checking v4l2_queryctrl of control 'Rotate' (0x00980922)
		info: checking v4l2_queryctrl of control 'Horizontal Flip' (0x00980914)
		info: checking v4l2_queryctrl of control 'Vertical Flip' (0x00980915)
		info: checking v4l2_queryctrl of control 'Rotate' (0x00980922)
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
		info: checking control 'User Controls' (0x00980001)
		info: checking control 'Horizontal Flip' (0x00980914)
		info: checking control 'Vertical Flip' (0x00980915)
		info: checking control 'Rotate' (0x00980922)
	test VIDIOC_G/S_CTRL: OK
		info: checking extended control 'User Controls' (0x00980001)
		info: checking extended control 'Horizontal Flip' (0x00980914)
		info: checking extended control 'Vertical Flip' (0x00980915)
		info: checking extended control 'Rotate' (0x00980922)
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		info: checking control event 'User Controls' (0x00980001)
		fail: v4l2-test-controls.cpp(796): subscribe event for control 'User Controls' failed
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 4 Private Controls: 0

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
	test VIDIOC_G/S_PARM: OK (Not Supported)
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK (Not Supported)
	test VIDIOC_TRY_FMT: OK (Not Supported)
	test VIDIOC_S_FMT: OK (Not Supported)
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)
	test VIDIOC_EXPBUF: OK (Not Supported)

--------------------------------------------------------------------------------

Compliance test for device /dev/v4l-subdev7:

Media Driver Info:
	Driver name      : imx-media
	Model            : imx-media
	Serial           : 
	Bus info         : 
	Media version    : 4.15.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.15.0
Interface Info:
	ID               : 0x030000a5
	Type             : V4L Sub-Device
Entity Info:
	ID               : 0x0000002c (44)
	Name             : ipu2_ic_prpvf
	Function         : Video Scaler
	Pad 0x0100002d   : Sink
	  Link 0x02000077: from remote pad 0x1000022 of entity 'ipu2_ic_prp': Data
	Pad 0x0100002e   : Source
	  Link 0x02000033: to remote pad 0x1000032 of entity 'ipu2_ic_prpvf capture': Data

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK

Allow for multiple opens:
	test second /dev/v4l-subdev7 open: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_LOG_STATUS: OK (Not Supported)

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

Sub-Device ioctls (Sink Pad 0):
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Sub-Device ioctls (Source Pad 1):
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Control ioctls:
		info: checking v4l2_queryctrl of control 'User Controls' (0x00980001)
		info: checking v4l2_queryctrl of control 'Horizontal Flip' (0x00980914)
		info: checking v4l2_queryctrl of control 'Vertical Flip' (0x00980915)
		info: checking v4l2_queryctrl of control 'Rotate' (0x00980922)
		info: checking v4l2_queryctrl of control 'Horizontal Flip' (0x00980914)
		info: checking v4l2_queryctrl of control 'Vertical Flip' (0x00980915)
		info: checking v4l2_queryctrl of control 'Rotate' (0x00980922)
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
		info: checking control 'User Controls' (0x00980001)
		info: checking control 'Horizontal Flip' (0x00980914)
		info: checking control 'Vertical Flip' (0x00980915)
		info: checking control 'Rotate' (0x00980922)
	test VIDIOC_G/S_CTRL: OK
		info: checking extended control 'User Controls' (0x00980001)
		info: checking extended control 'Horizontal Flip' (0x00980914)
		info: checking extended control 'Vertical Flip' (0x00980915)
		info: checking extended control 'Rotate' (0x00980922)
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		info: checking control event 'User Controls' (0x00980001)
		fail: v4l2-test-controls.cpp(796): subscribe event for control 'User Controls' failed
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 4 Private Controls: 0

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
	test VIDIOC_G/S_PARM: OK (Not Supported)
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK (Not Supported)
	test VIDIOC_TRY_FMT: OK (Not Supported)
	test VIDIOC_S_FMT: OK (Not Supported)
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)
	test VIDIOC_EXPBUF: OK (Not Supported)

--------------------------------------------------------------------------------

Compliance test for device /dev/v4l-subdev8:

Media Driver Info:
	Driver name      : imx-media
	Model            : imx-media
	Serial           : 
	Bus info         : 
	Media version    : 4.15.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.15.0
Interface Info:
	ID               : 0x030000a7
	Type             : V4L Sub-Device
Entity Info:
	ID               : 0x00000035 (53)
	Name             : ipu1_csi0
	Function         : Video Pixel Formatter
	Pad 0x01000036   : Sink
	  Link 0x0200007d: from remote pad 0x1000068 of entity 'ipu1_csi0_mux': Data
	Pad 0x01000037   : Source
	  Link 0x02000079: to remote pad 0x100000a of entity 'ipu1_ic_prp': Data
	  Link 0x0200007b: to remote pad 0x1000002 of entity 'ipu1_vdic': Data
	Pad 0x01000038   : Source
	  Link 0x0200003d: to remote pad 0x100003c of entity 'ipu1_csi0 capture': Data

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK

Allow for multiple opens:
	test second /dev/v4l-subdev8 open: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_LOG_STATUS: OK (Not Supported)

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

Sub-Device ioctls (Sink Pad 0):
		fail: v4l2-test-subdevs.cpp(225): doioctl(node, VIDIOC_SUBDEV_ENUM_MBUS_CODE, &mbus_core_enum)
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
		fail: v4l2-test-subdevs.cpp(437): check_0(sel.reserved, sizeof(sel.reserved))
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: FAIL
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
		fail: v4l2-test-subdevs.cpp(437): check_0(sel.reserved, sizeof(sel.reserved))
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: FAIL
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Sub-Device ioctls (Source Pad 1):
		fail: v4l2-test-subdevs.cpp(225): doioctl(node, VIDIOC_SUBDEV_ENUM_MBUS_CODE, &mbus_core_enum)
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Sub-Device ioctls (Source Pad 2):
		fail: v4l2-test-subdevs.cpp(225): doioctl(node, VIDIOC_SUBDEV_ENUM_MBUS_CODE, &mbus_core_enum)
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Control ioctls:
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 0 Private Controls: 0

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
	test VIDIOC_G/S_PARM: OK (Not Supported)
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK (Not Supported)
	test VIDIOC_TRY_FMT: OK (Not Supported)
	test VIDIOC_S_FMT: OK (Not Supported)
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)
	test VIDIOC_EXPBUF: OK (Not Supported)

--------------------------------------------------------------------------------

Compliance test for device /dev/v4l-subdev9:

Media Driver Info:
	Driver name      : imx-media
	Model            : imx-media
	Serial           : 
	Bus info         : 
	Media version    : 4.15.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.15.0
Interface Info:
	ID               : 0x030000a9
	Type             : V4L Sub-Device
Entity Info:
	ID               : 0x0000003f (63)
	Name             : ipu1_csi1
	Function         : Video Pixel Formatter
	Pad 0x01000040   : Sink
	  Link 0x02000083: from remote pad 0x1000060 of entity 'imx6-mipi-csi2': Data
	Pad 0x01000041   : Source
	  Link 0x0200007f: to remote pad 0x100000a of entity 'ipu1_ic_prp': Data
	  Link 0x02000081: to remote pad 0x1000002 of entity 'ipu1_vdic': Data
	Pad 0x01000042   : Source
	  Link 0x02000047: to remote pad 0x1000046 of entity 'ipu1_csi1 capture': Data

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK

Allow for multiple opens:
	test second /dev/v4l-subdev9 open: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_LOG_STATUS: OK (Not Supported)

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

Sub-Device ioctls (Sink Pad 0):
		fail: v4l2-test-subdevs.cpp(225): doioctl(node, VIDIOC_SUBDEV_ENUM_MBUS_CODE, &mbus_core_enum)
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
		fail: v4l2-test-subdevs.cpp(437): check_0(sel.reserved, sizeof(sel.reserved))
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: FAIL
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
		fail: v4l2-test-subdevs.cpp(437): check_0(sel.reserved, sizeof(sel.reserved))
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: FAIL
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Sub-Device ioctls (Source Pad 1):
		fail: v4l2-test-subdevs.cpp(225): doioctl(node, VIDIOC_SUBDEV_ENUM_MBUS_CODE, &mbus_core_enum)
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Sub-Device ioctls (Source Pad 2):
		fail: v4l2-test-subdevs.cpp(225): doioctl(node, VIDIOC_SUBDEV_ENUM_MBUS_CODE, &mbus_core_enum)
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Control ioctls:
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 0 Private Controls: 0

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
	test VIDIOC_G/S_PARM: OK (Not Supported)
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK (Not Supported)
	test VIDIOC_TRY_FMT: OK (Not Supported)
	test VIDIOC_S_FMT: OK (Not Supported)
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)
	test VIDIOC_EXPBUF: OK (Not Supported)

--------------------------------------------------------------------------------

Compliance test for device /dev/v4l-subdev10:

Media Driver Info:
	Driver name      : imx-media
	Model            : imx-media
	Serial           : 
	Bus info         : 
	Media version    : 4.15.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.15.0
Interface Info:
	ID               : 0x030000ab
	Type             : V4L Sub-Device
Entity Info:
	ID               : 0x00000049 (73)
	Name             : ipu2_csi0
	Function         : Video Pixel Formatter
	Pad 0x0100004a   : Sink
	  Link 0x02000089: from remote pad 0x1000061 of entity 'imx6-mipi-csi2': Data
	Pad 0x0100004b   : Source
	  Link 0x02000085: to remote pad 0x1000020 of entity 'ipu2_ic_prp': Data
	  Link 0x02000087: to remote pad 0x1000006 of entity 'ipu2_vdic': Data
	Pad 0x0100004c   : Source
	  Link 0x02000051: to remote pad 0x1000050 of entity 'ipu2_csi0 capture': Data

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK

Allow for multiple opens:
	test second /dev/v4l-subdev10 open: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_LOG_STATUS: OK (Not Supported)

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

Sub-Device ioctls (Sink Pad 0):
		fail: v4l2-test-subdevs.cpp(225): doioctl(node, VIDIOC_SUBDEV_ENUM_MBUS_CODE, &mbus_core_enum)
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
		fail: v4l2-test-subdevs.cpp(437): check_0(sel.reserved, sizeof(sel.reserved))
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: FAIL
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
		fail: v4l2-test-subdevs.cpp(437): check_0(sel.reserved, sizeof(sel.reserved))
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: FAIL
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Sub-Device ioctls (Source Pad 1):
		fail: v4l2-test-subdevs.cpp(225): doioctl(node, VIDIOC_SUBDEV_ENUM_MBUS_CODE, &mbus_core_enum)
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Sub-Device ioctls (Source Pad 2):
		fail: v4l2-test-subdevs.cpp(225): doioctl(node, VIDIOC_SUBDEV_ENUM_MBUS_CODE, &mbus_core_enum)
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Control ioctls:
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 0 Private Controls: 0

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
	test VIDIOC_G/S_PARM: OK (Not Supported)
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK (Not Supported)
	test VIDIOC_TRY_FMT: OK (Not Supported)
	test VIDIOC_S_FMT: OK (Not Supported)
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)
	test VIDIOC_EXPBUF: OK (Not Supported)

--------------------------------------------------------------------------------

Compliance test for device /dev/v4l-subdev11:

Media Driver Info:
	Driver name      : imx-media
	Model            : imx-media
	Serial           : 
	Bus info         : 
	Media version    : 4.15.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.15.0
Interface Info:
	ID               : 0x030000ad
	Type             : V4L Sub-Device
Entity Info:
	ID               : 0x00000053 (83)
	Name             : ipu2_csi1
	Function         : Video Pixel Formatter
	Pad 0x01000054   : Sink
	  Link 0x0200008f: from remote pad 0x100006c of entity 'ipu2_csi1_mux': Data
	Pad 0x01000055   : Source
	  Link 0x0200008b: to remote pad 0x1000020 of entity 'ipu2_ic_prp': Data
	  Link 0x0200008d: to remote pad 0x1000006 of entity 'ipu2_vdic': Data
	Pad 0x01000056   : Source
	  Link 0x0200005b: to remote pad 0x100005a of entity 'ipu2_csi1 capture': Data

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK

Allow for multiple opens:
	test second /dev/v4l-subdev11 open: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_LOG_STATUS: OK (Not Supported)

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

Sub-Device ioctls (Sink Pad 0):
		fail: v4l2-test-subdevs.cpp(225): doioctl(node, VIDIOC_SUBDEV_ENUM_MBUS_CODE, &mbus_core_enum)
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
		fail: v4l2-test-subdevs.cpp(437): check_0(sel.reserved, sizeof(sel.reserved))
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: FAIL
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
		fail: v4l2-test-subdevs.cpp(437): check_0(sel.reserved, sizeof(sel.reserved))
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: FAIL
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Sub-Device ioctls (Source Pad 1):
		fail: v4l2-test-subdevs.cpp(225): doioctl(node, VIDIOC_SUBDEV_ENUM_MBUS_CODE, &mbus_core_enum)
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Sub-Device ioctls (Source Pad 2):
		fail: v4l2-test-subdevs.cpp(225): doioctl(node, VIDIOC_SUBDEV_ENUM_MBUS_CODE, &mbus_core_enum)
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK
		fail: v4l2-test-subdevs.cpp(268): node->enum_frame_interval_pad != (int)pad
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: FAIL

Control ioctls:
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 0 Private Controls: 0

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
	test VIDIOC_G/S_PARM: OK (Not Supported)
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK (Not Supported)
	test VIDIOC_TRY_FMT: OK (Not Supported)
	test VIDIOC_S_FMT: OK (Not Supported)
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)
	test VIDIOC_EXPBUF: OK (Not Supported)

--------------------------------------------------------------------------------

Compliance test for device /dev/v4l-subdev12:

Media Driver Info:
	Driver name      : imx-media
	Model            : imx-media
	Serial           : 
	Bus info         : 
	Media version    : 4.15.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.15.0
Interface Info:
	ID               : 0x030000af
	Type             : V4L Sub-Device
Entity Info:
	ID               : 0x0000005d (93)
	Name             : imx6-mipi-csi2
	Function         : Video Interface Bridge
	Pad 0x0100005e   : Sink
	  Link 0x02000095: from remote pad 0x1000064 of entity 'tc358743 0-000f': Data
	Pad 0x0100005f   : Source
	  Link 0x02000091: to remote pad 0x1000066 of entity 'ipu1_csi0_mux': Data
	Pad 0x01000060   : Source
	  Link 0x02000083: to remote pad 0x1000040 of entity 'ipu1_csi1': Data
	Pad 0x01000061   : Source
	  Link 0x02000089: to remote pad 0x100004a of entity 'ipu2_csi0': Data
	Pad 0x01000062   : Source
	  Link 0x02000093: to remote pad 0x100006a of entity 'ipu2_csi1_mux': Data

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK

Allow for multiple opens:
	test second /dev/v4l-subdev12 open: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_LOG_STATUS: OK (Not Supported)

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

Sub-Device ioctls (Sink Pad 0):
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Sub-Device ioctls (Source Pad 1):
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Sub-Device ioctls (Source Pad 2):
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Sub-Device ioctls (Source Pad 3):
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Sub-Device ioctls (Source Pad 4):
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Control ioctls:
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
		fail: v4l2-test-controls.cpp(587): g_ext_ctrls does not support count == 0
	test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 0 Private Controls: 0

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
	test VIDIOC_G/S_PARM: OK (Not Supported)
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK (Not Supported)
	test VIDIOC_TRY_FMT: OK (Not Supported)
	test VIDIOC_S_FMT: OK (Not Supported)
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)
	test VIDIOC_EXPBUF: OK (Not Supported)

--------------------------------------------------------------------------------

Compliance test for device /dev/v4l-subdev13:

Media Driver Info:
	Driver name      : imx-media
	Model            : imx-media
	Serial           : 
	Bus info         : 
	Media version    : 4.15.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.15.0
Interface Info:
	ID               : 0x030000b1
	Type             : V4L Sub-Device
Entity Info:
	ID               : 0x00000063 (99)
	Name             : tc358743 0-000f
	Function         : Video Interface Bridge
	Pad 0x01000064   : Source
	  Link 0x02000095: to remote pad 0x100005e of entity 'imx6-mipi-csi2': Data

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK

Allow for multiple opens:
	test second /dev/v4l-subdev13 open: OK
	test for unlimited opens: OK

Debug ioctls:
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
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK
		fail: v4l2-test-io-config.cpp(375): doioctl(node, VIDIOC_DV_TIMINGS_CAP, &timingscap) != EINVAL
		fail: v4l2-test-io-config.cpp(392): EDID check failed for source pad 0.
	test VIDIOC_DV_TIMINGS_CAP: FAIL
	test VIDIOC_G/S_EDID: OK

Sub-Device ioctls (Source Pad 0):
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(226): check_0(mbus_core_enum.reserved, sizeof(mbus_core_enum.reserved))
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: FAIL
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Control ioctls:
		info: checking v4l2_queryctrl of control 'User Controls' (0x00980001)
		info: checking v4l2_queryctrl of control 'Audio sampling rate' (0x00981980)
		info: checking v4l2_queryctrl of control 'Audio present' (0x00981981)
		info: checking v4l2_queryctrl of control 'Digital Video Controls' (0x00a00001)
		info: checking v4l2_queryctrl of control 'Power Present' (0x00a00964)
		info: checking v4l2_queryctrl of control 'Audio sampling rate' (0x08000000)
		info: checking v4l2_queryctrl of control 'Audio present' (0x08000001)
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
		info: checking control 'User Controls' (0x00980001)
		info: checking control 'Audio sampling rate' (0x00981980)
		info: checking control 'Audio present' (0x00981981)
		info: checking control 'Digital Video Controls' (0x00a00001)
		info: checking control 'Power Present' (0x00a00964)
	test VIDIOC_G/S_CTRL: OK
		info: checking extended control 'User Controls' (0x00980001)
		info: checking extended control 'Audio sampling rate' (0x00981980)
		info: checking extended control 'Audio present' (0x00981981)
		info: checking extended control 'Digital Video Controls' (0x00a00001)
		info: checking extended control 'Power Present' (0x00a00964)
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		info: checking control event 'User Controls' (0x00980001)
		info: checking control event 'Audio sampling rate' (0x00981980)
		info: checking control event 'Audio present' (0x00981981)
		info: checking control event 'Digital Video Controls' (0x00a00001)
		info: checking control event 'Power Present' (0x00a00964)
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 3 Private Controls: 2

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
	test VIDIOC_G/S_PARM: OK (Not Supported)
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK (Not Supported)
	test VIDIOC_TRY_FMT: OK (Not Supported)
	test VIDIOC_S_FMT: OK (Not Supported)
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)
	test VIDIOC_EXPBUF: OK (Not Supported)

--------------------------------------------------------------------------------

Compliance test for device /dev/v4l-subdev14:

Media Driver Info:
	Driver name      : imx-media
	Model            : imx-media
	Serial           : 
	Bus info         : 
	Media version    : 4.15.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.15.0
Interface Info:
	ID               : 0x030000b3
	Type             : V4L Sub-Device
Entity Info:
	ID               : 0x00000065 (101)
	Name             : ipu1_csi0_mux
	Function         : Video Muxer
	Pad 0x01000066   : Sink
	  Link 0x02000091: from remote pad 0x100005f of entity 'imx6-mipi-csi2': Data
	Pad 0x01000067   : Sink
	Pad 0x01000068   : Source
	  Link 0x0200007d: to remote pad 0x1000036 of entity 'ipu1_csi0': Data

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK

Allow for multiple opens:
	test second /dev/v4l-subdev14 open: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_LOG_STATUS: OK (Not Supported)

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

Sub-Device ioctls (Sink Pad 0):
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Sub-Device ioctls (Sink Pad 1):
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Sub-Device ioctls (Source Pad 2):
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Control ioctls:
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
		fail: v4l2-test-controls.cpp(587): g_ext_ctrls does not support count == 0
	test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 0 Private Controls: 0

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
	test VIDIOC_G/S_PARM: OK (Not Supported)
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK (Not Supported)
	test VIDIOC_TRY_FMT: OK (Not Supported)
	test VIDIOC_S_FMT: OK (Not Supported)
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)
	test VIDIOC_EXPBUF: OK (Not Supported)

--------------------------------------------------------------------------------

Compliance test for device /dev/v4l-subdev15:

Media Driver Info:
	Driver name      : imx-media
	Model            : imx-media
	Serial           : 
	Bus info         : 
	Media version    : 4.15.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.15.0
Interface Info:
	ID               : 0x030000b5
	Type             : V4L Sub-Device
Entity Info:
	ID               : 0x00000069 (105)
	Name             : ipu2_csi1_mux
	Function         : Video Muxer
	Pad 0x0100006a   : Sink
	  Link 0x02000093: from remote pad 0x1000062 of entity 'imx6-mipi-csi2': Data
	Pad 0x0100006b   : Sink
	Pad 0x0100006c   : Source
	  Link 0x0200008f: to remote pad 0x1000054 of entity 'ipu2_csi1': Data

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK

Allow for multiple opens:
	test second /dev/v4l-subdev15 open: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_LOG_STATUS: OK (Not Supported)

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

Sub-Device ioctls (Sink Pad 0):
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Sub-Device ioctls (Sink Pad 1):
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Sub-Device ioctls (Source Pad 2):
	test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
	test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK (Not Supported)
		fail: v4l2-test-subdevs.cpp(339): check_0(fmt.reserved, sizeof(fmt.reserved))
	test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
	test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
	test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Control ioctls:
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
		fail: v4l2-test-controls.cpp(587): g_ext_ctrls does not support count == 0
	test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 0 Private Controls: 0

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
	test VIDIOC_G/S_PARM: OK (Not Supported)
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK (Not Supported)
	test VIDIOC_TRY_FMT: OK (Not Supported)
	test VIDIOC_S_FMT: OK (Not Supported)
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)
	test VIDIOC_EXPBUF: OK (Not Supported)

Total: 1307, Succeeded: 1089, Failed: 218, Warnings: 4
---------->8----------

regards
Philipp
