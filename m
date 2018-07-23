Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:39835 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387899AbeGWMEp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 08:04:45 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v3 00/35] Qualcomm Camera Subsystem driver - 8x96 support
Date: Mon, 23 Jul 2018 14:02:17 +0300
Message-Id: <1532343772-27382-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changelog v3:
- split patch 08 to device tree binding patch and driver patch and
  improve commit message.

--------------------------------------------------------------------------------

This patchset adds support for the Qualcomm Camera Subsystem found
on Qualcomm MSM8996 and APQ8096 SoC to the existing driver which
used to support MSM8916 and APQ8016.

The camera subsystem hardware on 8x96 is similar to 8x16 but
supports more cameras and features. More details are added in the
driver document by the last patch.

The first 3 patches are dependencies which have already been on
the mainling list but I'm adding them here for completeness.

The following 12 patches add general updates and fixes to the driver.
Then the rest add the support for the new hardware.

The driver is tested on Dragonboard 410c (APQ8016) and Dragonboard 820c
(APQ8096) with OV5645 camera sensors. media-ctl [1], yavta [2] and
GStreamer were used for testing.

[1] https://git.linuxtv.org//v4l-utils.git
[2] http://git.ideasonboard.org/yavta.git

--------------------------------------------------------------------------------

DB410c: v4l2-compliance -M /dev/media0 -v
v4l2-compliance SHA: 47593771ad61f52d3670ef35373f24f85d5da267, 64 bits

Compliance test for device /dev/media0:

Media Driver Info:
	Driver name      : qcom-camss
	Model            : Qualcomm Camera Subsystem
	Serial           : 
	Bus info         : 
	Media version    : 4.17.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.17.0

Required ioctls:
	test MEDIA_IOC_DEVICE_INFO: OK

Allow for multiple opens:
	test second /dev/media0 open: OK
	test MEDIA_IOC_DEVICE_INFO: OK
	test for unlimited opens: OK

Media Controller ioctls:
		Entity: 0x00000001 (Name: 'msm_csiphy0', Function: V4L2 I/O)
		Entity: 0x00000004 (Name: 'msm_csiphy1', Function: V4L2 I/O)
		Entity: 0x00000007 (Name: 'msm_csid0', Function: V4L2 I/O)
		Entity: 0x0000000a (Name: 'msm_csid1', Function: V4L2 I/O)
		Entity: 0x0000000d (Name: 'msm_ispif0', Function: V4L2 I/O)
		Entity: 0x00000010 (Name: 'msm_ispif1', Function: V4L2 I/O)
		Entity: 0x00000013 (Name: 'msm_vfe0_rdi0', Function: Video Pixel Formatter)
		Entity: 0x00000016 (Name: 'msm_vfe0_video0', Function: V4L2 I/O)
		Entity: 0x0000001c (Name: 'msm_vfe0_rdi1', Function: Video Pixel Formatter)
		Entity: 0x0000001f (Name: 'msm_vfe0_video1', Function: V4L2 I/O)
		Entity: 0x00000025 (Name: 'msm_vfe0_rdi2', Function: Video Pixel Formatter)
		Entity: 0x00000028 (Name: 'msm_vfe0_video2', Function: V4L2 I/O)
		Entity: 0x0000002e (Name: 'msm_vfe0_pix', Function: Video Pixel Formatter)
		Entity: 0x00000031 (Name: 'msm_vfe0_video3', Function: V4L2 I/O)
		Entity: 0x00000057 (Name: 'ov5645 4-003b', Function: Camera Sensor)
		Interface: 0x03000018 (Type: V4L Video, DevPath: /dev/video0)
		Interface: 0x03000021 (Type: V4L Video, DevPath: /dev/video1)
		Interface: 0x0300002a (Type: V4L Video, DevPath: /dev/video2)
		Interface: 0x03000033 (Type: V4L Video, DevPath: /dev/video3)
		Interface: 0x0300005b (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev0)
		Interface: 0x0300005d (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev1)
		Interface: 0x0300005f (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev2)
		Interface: 0x03000061 (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev3)
		Interface: 0x03000063 (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev4)
		Interface: 0x03000065 (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev5)
		Interface: 0x03000067 (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev6)
		Interface: 0x03000069 (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev7)
		Interface: 0x0300006b (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev8)
		Interface: 0x0300006d (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev9)
		Interface: 0x0300006f (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev10)
		Pad: 0x01000002 (msm_csiphy0, Sink)
		Pad: 0x01000003 (msm_csiphy0, Source)
		Pad: 0x01000005 (msm_csiphy1, Sink)
		Pad: 0x01000006 (msm_csiphy1, Source)
		Pad: 0x01000008 (msm_csid0, Sink)
		Pad: 0x01000009 (msm_csid0, Source)
		Pad: 0x0100000b (msm_csid1, Sink)
		Pad: 0x0100000c (msm_csid1, Source)
		Pad: 0x0100000e (msm_ispif0, Sink)
		Pad: 0x0100000f (msm_ispif0, Source)
		Pad: 0x01000011 (msm_ispif1, Sink)
		Pad: 0x01000012 (msm_ispif1, Source)
		Pad: 0x01000014 (msm_vfe0_rdi0, Sink)
		Pad: 0x01000015 (msm_vfe0_rdi0, Source)
		Pad: 0x01000017 (msm_vfe0_video0, Sink)
		Pad: 0x0100001d (msm_vfe0_rdi1, Sink)
		Pad: 0x0100001e (msm_vfe0_rdi1, Source)
		Pad: 0x01000020 (msm_vfe0_video1, Sink)
		Pad: 0x01000026 (msm_vfe0_rdi2, Sink)
		Pad: 0x01000027 (msm_vfe0_rdi2, Source)
		Pad: 0x01000029 (msm_vfe0_video2, Sink)
		Pad: 0x0100002f (msm_vfe0_pix, Sink)
		Pad: 0x01000030 (msm_vfe0_pix, Source)
		Pad: 0x01000032 (msm_vfe0_video3, Sink)
		Pad: 0x01000058 (ov5645 4-003b, Source)
		Link: 0x02000019 (msm_vfe0_video0 to interface /dev/video0)
		Link: 0x0200001a (msm_vfe0_rdi0 -> msm_vfe0_video0, Data, Enabled, Immutable)
		Link: 0x02000022 (msm_vfe0_video1 to interface /dev/video1)
		Link: 0x02000023 (msm_vfe0_rdi1 -> msm_vfe0_video1, Data, Enabled, Immutable)
		Link: 0x0200002b (msm_vfe0_video2 to interface /dev/video2)
		Link: 0x0200002c (msm_vfe0_rdi2 -> msm_vfe0_video2, Data, Enabled, Immutable)
		Link: 0x02000034 (msm_vfe0_video3 to interface /dev/video3)
		Link: 0x02000035 (msm_vfe0_pix -> msm_vfe0_video3, Data, Enabled, Immutable)
		Link: 0x02000037 (msm_csiphy0 -> msm_csid0, Data)
		Link: 0x02000039 (msm_csiphy0 -> msm_csid1, Data)
		Link: 0x0200003b (msm_csiphy1 -> msm_csid0, Data)
		Link: 0x0200003d (msm_csiphy1 -> msm_csid1, Data)
		Link: 0x0200003f (msm_csid0 -> msm_ispif0, Data)
		Link: 0x02000041 (msm_csid0 -> msm_ispif1, Data)
		Link: 0x02000043 (msm_csid1 -> msm_ispif0, Data)
		Link: 0x02000045 (msm_csid1 -> msm_ispif1, Data)
		Link: 0x02000047 (msm_ispif0 -> msm_vfe0_rdi0, Data)
		Link: 0x02000049 (msm_ispif0 -> msm_vfe0_rdi1, Data)
		Link: 0x0200004b (msm_ispif0 -> msm_vfe0_rdi2, Data)
		Link: 0x0200004d (msm_ispif0 -> msm_vfe0_pix, Data)
		Link: 0x0200004f (msm_ispif1 -> msm_vfe0_rdi0, Data)
		Link: 0x02000051 (msm_ispif1 -> msm_vfe0_rdi1, Data)
		Link: 0x02000053 (msm_ispif1 -> msm_vfe0_rdi2, Data)
		Link: 0x02000055 (msm_ispif1 -> msm_vfe0_pix, Data)
		Link: 0x02000059 (ov5645 4-003b -> msm_csiphy0, Data, Enabled, Immutable)
		Link: 0x0200005c (msm_csiphy0 to interface /dev/v4l-subdev0)
		Link: 0x0200005e (msm_csiphy1 to interface /dev/v4l-subdev1)
		Link: 0x02000060 (msm_csid0 to interface /dev/v4l-subdev2)
		Link: 0x02000062 (msm_csid1 to interface /dev/v4l-subdev3)
		Link: 0x02000064 (msm_ispif0 to interface /dev/v4l-subdev4)
		Link: 0x02000066 (msm_ispif1 to interface /dev/v4l-subdev5)
		Link: 0x02000068 (msm_vfe0_rdi0 to interface /dev/v4l-subdev6)
		Link: 0x0200006a (msm_vfe0_rdi1 to interface /dev/v4l-subdev7)
		Link: 0x0200006c (msm_vfe0_rdi2 to interface /dev/v4l-subdev8)
		Link: 0x0200006e (msm_vfe0_pix to interface /dev/v4l-subdev9)
		Link: 0x02000070 (ov5645 4-003b to interface /dev/v4l-subdev10)
	test MEDIA_IOC_G_TOPOLOGY: OK
	Entities: 15 Interfaces: 15 Pads: 25 Links: 36
		Entity: 0x00000001 (Name: 'msm_csiphy0', Type: V4L2 I/O, DevPath: /dev/v4l-subdev0)
		Entity: 0x00000004 (Name: 'msm_csiphy1', Type: V4L2 I/O, DevPath: /dev/v4l-subdev1)
		Entity: 0x00000007 (Name: 'msm_csid0', Type: V4L2 I/O, DevPath: /dev/v4l-subdev2)
		Entity: 0x0000000a (Name: 'msm_csid1', Type: V4L2 I/O, DevPath: /dev/v4l-subdev3)
		Entity: 0x0000000d (Name: 'msm_ispif0', Type: V4L2 I/O, DevPath: /dev/v4l-subdev4)
		Entity: 0x00000010 (Name: 'msm_ispif1', Type: V4L2 I/O, DevPath: /dev/v4l-subdev5)
		Entity: 0x00000013 (Name: 'msm_vfe0_rdi0', Type: Unknown V4L2 Sub-Device, DevPath: /dev/v4l-subdev6)
		Entity: 0x00000016 (Name: 'msm_vfe0_video0', Type: V4L2 I/O, DevPath: /dev/video0)
		Entity: 0x0000001c (Name: 'msm_vfe0_rdi1', Type: Unknown V4L2 Sub-Device, DevPath: /dev/v4l-subdev7)
		Entity: 0x0000001f (Name: 'msm_vfe0_video1', Type: V4L2 I/O, DevPath: /dev/video1)
		Entity: 0x00000025 (Name: 'msm_vfe0_rdi2', Type: Unknown V4L2 Sub-Device, DevPath: /dev/v4l-subdev8)
		Entity: 0x00000028 (Name: 'msm_vfe0_video2', Type: V4L2 I/O, DevPath: /dev/video2)
		Entity: 0x0000002e (Name: 'msm_vfe0_pix', Type: Unknown V4L2 Sub-Device, DevPath: /dev/v4l-subdev9)
		Entity: 0x00000031 (Name: 'msm_vfe0_video3', Type: V4L2 I/O, DevPath: /dev/video3)
		Entity: 0x00000057 (Name: 'ov5645 4-003b', Type: Camera Sensor, DevPath: /dev/v4l-subdev10)
	test MEDIA_IOC_ENUM_ENTITIES/LINKS: OK
	test MEDIA_IOC_SETUP_LINK: OK

Total: 7, Succeeded: 7, Failed: 0, Warnings: 0


--------------------------------------------------------------------------------

DB820c: v4l2-compliance -M /dev/media0 -v
v4l2-compliance SHA: 47593771ad61f52d3670ef35373f24f85d5da267, 64 bits

Compliance test for device /dev/media0:

Media Driver Info:
	Driver name      : qcom-camss
	Model            : Qualcomm Camera Subsystem
	Serial           : 
	Bus info         : 
	Media version    : 4.17.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.17.0

Required ioctls:
	test MEDIA_IOC_DEVICE_INFO: OK

Allow for multiple opens:
	test second /dev/media0 open: OK
	test MEDIA_IOC_DEVICE_INFO: OK
	test for unlimited opens: OK

Media Controller ioctls:
		Entity: 0x00000001 (Name: 'msm_csiphy0', Function: V4L2 I/O)
		Entity: 0x00000004 (Name: 'msm_csiphy1', Function: V4L2 I/O)
		Entity: 0x00000007 (Name: 'msm_csiphy2', Function: V4L2 I/O)
		Entity: 0x0000000a (Name: 'msm_csid0', Function: V4L2 I/O)
		Entity: 0x0000000d (Name: 'msm_csid1', Function: V4L2 I/O)
		Entity: 0x00000010 (Name: 'msm_csid2', Function: V4L2 I/O)
		Entity: 0x00000013 (Name: 'msm_csid3', Function: V4L2 I/O)
		Entity: 0x00000016 (Name: 'msm_ispif0', Function: V4L2 I/O)
		Entity: 0x00000019 (Name: 'msm_ispif1', Function: V4L2 I/O)
		Entity: 0x0000001c (Name: 'msm_ispif2', Function: V4L2 I/O)
		Entity: 0x0000001f (Name: 'msm_ispif3', Function: V4L2 I/O)
		Entity: 0x00000022 (Name: 'msm_vfe0_rdi0', Function: Video Pixel Formatter)
		Entity: 0x00000025 (Name: 'msm_vfe0_video0', Function: V4L2 I/O)
		Entity: 0x0000002b (Name: 'msm_vfe0_rdi1', Function: Video Pixel Formatter)
		Entity: 0x0000002e (Name: 'msm_vfe0_video1', Function: V4L2 I/O)
		Entity: 0x00000034 (Name: 'msm_vfe0_rdi2', Function: Video Pixel Formatter)
		Entity: 0x00000037 (Name: 'msm_vfe0_video2', Function: V4L2 I/O)
		Entity: 0x0000003d (Name: 'msm_vfe0_pix', Function: Video Pixel Formatter)
		Entity: 0x00000040 (Name: 'msm_vfe0_video3', Function: V4L2 I/O)
		Entity: 0x00000046 (Name: 'msm_vfe1_rdi0', Function: Video Pixel Formatter)
		Entity: 0x00000049 (Name: 'msm_vfe1_video0', Function: V4L2 I/O)
		Entity: 0x0000004f (Name: 'msm_vfe1_rdi1', Function: Video Pixel Formatter)
		Entity: 0x00000052 (Name: 'msm_vfe1_video1', Function: V4L2 I/O)
		Entity: 0x00000058 (Name: 'msm_vfe1_rdi2', Function: Video Pixel Formatter)
		Entity: 0x0000005b (Name: 'msm_vfe1_video2', Function: V4L2 I/O)
		Entity: 0x00000061 (Name: 'msm_vfe1_pix', Function: Video Pixel Formatter)
		Entity: 0x00000064 (Name: 'msm_vfe1_video3', Function: V4L2 I/O)
		Entity: 0x000000e2 (Name: 'ov5645 3-0039', Function: Camera Sensor)
		Interface: 0x03000027 (Type: V4L Video, DevPath: /dev/video0)
		Interface: 0x03000030 (Type: V4L Video, DevPath: /dev/video1)
		Interface: 0x03000039 (Type: V4L Video, DevPath: /dev/video2)
		Interface: 0x03000042 (Type: V4L Video, DevPath: /dev/video3)
		Interface: 0x0300004b (Type: V4L Video, DevPath: /dev/video4)
		Interface: 0x03000054 (Type: V4L Video, DevPath: /dev/video5)
		Interface: 0x0300005d (Type: V4L Video, DevPath: /dev/video6)
		Interface: 0x03000066 (Type: V4L Video, DevPath: /dev/video7)
		Interface: 0x030000e6 (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev0)
		Interface: 0x030000e8 (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev1)
		Interface: 0x030000ea (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev2)
		Interface: 0x030000ec (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev3)
		Interface: 0x030000ee (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev4)
		Interface: 0x030000f0 (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev5)
		Interface: 0x030000f2 (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev6)
		Interface: 0x030000f4 (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev7)
		Interface: 0x030000f6 (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev8)
		Interface: 0x030000f8 (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev9)
		Interface: 0x030000fa (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev10)
		Interface: 0x030000fc (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev11)
		Interface: 0x030000fe (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev12)
		Interface: 0x03000100 (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev13)
		Interface: 0x03000102 (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev14)
		Interface: 0x03000104 (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev15)
		Interface: 0x03000106 (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev16)
		Interface: 0x03000108 (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev17)
		Interface: 0x0300010a (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev18)
		Interface: 0x0300010c (Type: V4L Sub-Device, DevPath: /dev/v4l-subdev19)
		Pad: 0x01000002 (msm_csiphy0, Sink)
		Pad: 0x01000003 (msm_csiphy0, Source)
		Pad: 0x01000005 (msm_csiphy1, Sink)
		Pad: 0x01000006 (msm_csiphy1, Source)
		Pad: 0x01000008 (msm_csiphy2, Sink)
		Pad: 0x01000009 (msm_csiphy2, Source)
		Pad: 0x0100000b (msm_csid0, Sink)
		Pad: 0x0100000c (msm_csid0, Source)
		Pad: 0x0100000e (msm_csid1, Sink)
		Pad: 0x0100000f (msm_csid1, Source)
		Pad: 0x01000011 (msm_csid2, Sink)
		Pad: 0x01000012 (msm_csid2, Source)
		Pad: 0x01000014 (msm_csid3, Sink)
		Pad: 0x01000015 (msm_csid3, Source)
		Pad: 0x01000017 (msm_ispif0, Sink)
		Pad: 0x01000018 (msm_ispif0, Source)
		Pad: 0x0100001a (msm_ispif1, Sink)
		Pad: 0x0100001b (msm_ispif1, Source)
		Pad: 0x0100001d (msm_ispif2, Sink)
		Pad: 0x0100001e (msm_ispif2, Source)
		Pad: 0x01000020 (msm_ispif3, Sink)
		Pad: 0x01000021 (msm_ispif3, Source)
		Pad: 0x01000023 (msm_vfe0_rdi0, Sink)
		Pad: 0x01000024 (msm_vfe0_rdi0, Source)
		Pad: 0x01000026 (msm_vfe0_video0, Sink)
		Pad: 0x0100002c (msm_vfe0_rdi1, Sink)
		Pad: 0x0100002d (msm_vfe0_rdi1, Source)
		Pad: 0x0100002f (msm_vfe0_video1, Sink)
		Pad: 0x01000035 (msm_vfe0_rdi2, Sink)
		Pad: 0x01000036 (msm_vfe0_rdi2, Source)
		Pad: 0x01000038 (msm_vfe0_video2, Sink)
		Pad: 0x0100003e (msm_vfe0_pix, Sink)
		Pad: 0x0100003f (msm_vfe0_pix, Source)
		Pad: 0x01000041 (msm_vfe0_video3, Sink)
		Pad: 0x01000047 (msm_vfe1_rdi0, Sink)
		Pad: 0x01000048 (msm_vfe1_rdi0, Source)
		Pad: 0x0100004a (msm_vfe1_video0, Sink)
		Pad: 0x01000050 (msm_vfe1_rdi1, Sink)
		Pad: 0x01000051 (msm_vfe1_rdi1, Source)
		Pad: 0x01000053 (msm_vfe1_video1, Sink)
		Pad: 0x01000059 (msm_vfe1_rdi2, Sink)
		Pad: 0x0100005a (msm_vfe1_rdi2, Source)
		Pad: 0x0100005c (msm_vfe1_video2, Sink)
		Pad: 0x01000062 (msm_vfe1_pix, Sink)
		Pad: 0x01000063 (msm_vfe1_pix, Source)
		Pad: 0x01000065 (msm_vfe1_video3, Sink)
		Pad: 0x010000e3 (ov5645 3-0039, Source)
		Link: 0x02000028 (msm_vfe0_video0 to interface /dev/video0)
		Link: 0x02000029 (msm_vfe0_rdi0 -> msm_vfe0_video0, Data, Enabled, Immutable)
		Link: 0x02000031 (msm_vfe0_video1 to interface /dev/video1)
		Link: 0x02000032 (msm_vfe0_rdi1 -> msm_vfe0_video1, Data, Enabled, Immutable)
		Link: 0x0200003a (msm_vfe0_video2 to interface /dev/video2)
		Link: 0x0200003b (msm_vfe0_rdi2 -> msm_vfe0_video2, Data, Enabled, Immutable)
		Link: 0x02000043 (msm_vfe0_video3 to interface /dev/video3)
		Link: 0x02000044 (msm_vfe0_pix -> msm_vfe0_video3, Data, Enabled, Immutable)
		Link: 0x0200004c (msm_vfe1_video0 to interface /dev/video4)
		Link: 0x0200004d (msm_vfe1_rdi0 -> msm_vfe1_video0, Data, Enabled, Immutable)
		Link: 0x02000055 (msm_vfe1_video1 to interface /dev/video5)
		Link: 0x02000056 (msm_vfe1_rdi1 -> msm_vfe1_video1, Data, Enabled, Immutable)
		Link: 0x0200005e (msm_vfe1_video2 to interface /dev/video6)
		Link: 0x0200005f (msm_vfe1_rdi2 -> msm_vfe1_video2, Data, Enabled, Immutable)
		Link: 0x02000067 (msm_vfe1_video3 to interface /dev/video7)
		Link: 0x02000068 (msm_vfe1_pix -> msm_vfe1_video3, Data, Enabled, Immutable)
		Link: 0x0200006a (msm_csiphy0 -> msm_csid0, Data)
		Link: 0x0200006c (msm_csiphy0 -> msm_csid1, Data)
		Link: 0x0200006e (msm_csiphy0 -> msm_csid2, Data)
		Link: 0x02000070 (msm_csiphy0 -> msm_csid3, Data)
		Link: 0x02000072 (msm_csiphy1 -> msm_csid0, Data)
		Link: 0x02000074 (msm_csiphy1 -> msm_csid1, Data)
		Link: 0x02000076 (msm_csiphy1 -> msm_csid2, Data)
		Link: 0x02000078 (msm_csiphy1 -> msm_csid3, Data)
		Link: 0x0200007a (msm_csiphy2 -> msm_csid0, Data)
		Link: 0x0200007c (msm_csiphy2 -> msm_csid1, Data)
		Link: 0x0200007e (msm_csiphy2 -> msm_csid2, Data)
		Link: 0x02000080 (msm_csiphy2 -> msm_csid3, Data)
		Link: 0x02000082 (msm_csid0 -> msm_ispif0, Data)
		Link: 0x02000084 (msm_csid0 -> msm_ispif1, Data)
		Link: 0x02000086 (msm_csid0 -> msm_ispif2, Data)
		Link: 0x02000088 (msm_csid0 -> msm_ispif3, Data)
		Link: 0x0200008a (msm_csid1 -> msm_ispif0, Data)
		Link: 0x0200008c (msm_csid1 -> msm_ispif1, Data)
		Link: 0x0200008e (msm_csid1 -> msm_ispif2, Data)
		Link: 0x02000090 (msm_csid1 -> msm_ispif3, Data)
		Link: 0x02000092 (msm_csid2 -> msm_ispif0, Data)
		Link: 0x02000094 (msm_csid2 -> msm_ispif1, Data)
		Link: 0x02000096 (msm_csid2 -> msm_ispif2, Data)
		Link: 0x02000098 (msm_csid2 -> msm_ispif3, Data)
		Link: 0x0200009a (msm_csid3 -> msm_ispif0, Data)
		Link: 0x0200009c (msm_csid3 -> msm_ispif1, Data)
		Link: 0x0200009e (msm_csid3 -> msm_ispif2, Data)
		Link: 0x020000a0 (msm_csid3 -> msm_ispif3, Data)
		Link: 0x020000a2 (msm_ispif0 -> msm_vfe0_rdi0, Data)
		Link: 0x020000a4 (msm_ispif0 -> msm_vfe0_rdi1, Data)
		Link: 0x020000a6 (msm_ispif0 -> msm_vfe0_rdi2, Data)
		Link: 0x020000a8 (msm_ispif0 -> msm_vfe0_pix, Data)
		Link: 0x020000aa (msm_ispif0 -> msm_vfe1_rdi0, Data)
		Link: 0x020000ac (msm_ispif0 -> msm_vfe1_rdi1, Data)
		Link: 0x020000ae (msm_ispif0 -> msm_vfe1_rdi2, Data)
		Link: 0x020000b0 (msm_ispif0 -> msm_vfe1_pix, Data)
		Link: 0x020000b2 (msm_ispif1 -> msm_vfe0_rdi0, Data)
		Link: 0x020000b4 (msm_ispif1 -> msm_vfe0_rdi1, Data)
		Link: 0x020000b6 (msm_ispif1 -> msm_vfe0_rdi2, Data)
		Link: 0x020000b8 (msm_ispif1 -> msm_vfe0_pix, Data)
		Link: 0x020000ba (msm_ispif1 -> msm_vfe1_rdi0, Data)
		Link: 0x020000bc (msm_ispif1 -> msm_vfe1_rdi1, Data)
		Link: 0x020000be (msm_ispif1 -> msm_vfe1_rdi2, Data)
		Link: 0x020000c0 (msm_ispif1 -> msm_vfe1_pix, Data)
		Link: 0x020000c2 (msm_ispif2 -> msm_vfe0_rdi0, Data)
		Link: 0x020000c4 (msm_ispif2 -> msm_vfe0_rdi1, Data)
		Link: 0x020000c6 (msm_ispif2 -> msm_vfe0_rdi2, Data)
		Link: 0x020000c8 (msm_ispif2 -> msm_vfe0_pix, Data)
		Link: 0x020000ca (msm_ispif2 -> msm_vfe1_rdi0, Data)
		Link: 0x020000cc (msm_ispif2 -> msm_vfe1_rdi1, Data)
		Link: 0x020000ce (msm_ispif2 -> msm_vfe1_rdi2, Data)
		Link: 0x020000d0 (msm_ispif2 -> msm_vfe1_pix, Data)
		Link: 0x020000d2 (msm_ispif3 -> msm_vfe0_rdi0, Data)
		Link: 0x020000d4 (msm_ispif3 -> msm_vfe0_rdi1, Data)
		Link: 0x020000d6 (msm_ispif3 -> msm_vfe0_rdi2, Data)
		Link: 0x020000d8 (msm_ispif3 -> msm_vfe0_pix, Data)
		Link: 0x020000da (msm_ispif3 -> msm_vfe1_rdi0, Data)
		Link: 0x020000dc (msm_ispif3 -> msm_vfe1_rdi1, Data)
		Link: 0x020000de (msm_ispif3 -> msm_vfe1_rdi2, Data)
		Link: 0x020000e0 (msm_ispif3 -> msm_vfe1_pix, Data)
		Link: 0x020000e4 (ov5645 3-0039 -> msm_csiphy1, Data, Enabled, Immutable)
		Link: 0x020000e7 (msm_csiphy0 to interface /dev/v4l-subdev0)
		Link: 0x020000e9 (msm_csiphy1 to interface /dev/v4l-subdev1)
		Link: 0x020000eb (msm_csiphy2 to interface /dev/v4l-subdev2)
		Link: 0x020000ed (msm_csid0 to interface /dev/v4l-subdev3)
		Link: 0x020000ef (msm_csid1 to interface /dev/v4l-subdev4)
		Link: 0x020000f1 (msm_csid2 to interface /dev/v4l-subdev5)
		Link: 0x020000f3 (msm_csid3 to interface /dev/v4l-subdev6)
		Link: 0x020000f5 (msm_ispif0 to interface /dev/v4l-subdev7)
		Link: 0x020000f7 (msm_ispif1 to interface /dev/v4l-subdev8)
		Link: 0x020000f9 (msm_ispif2 to interface /dev/v4l-subdev9)
		Link: 0x020000fb (msm_ispif3 to interface /dev/v4l-subdev10)
		Link: 0x020000fd (msm_vfe0_rdi0 to interface /dev/v4l-subdev11)
		Link: 0x020000ff (msm_vfe0_rdi1 to interface /dev/v4l-subdev12)
		Link: 0x02000101 (msm_vfe0_rdi2 to interface /dev/v4l-subdev13)
		Link: 0x02000103 (msm_vfe0_pix to interface /dev/v4l-subdev14)
		Link: 0x02000105 (msm_vfe1_rdi0 to interface /dev/v4l-subdev15)
		Link: 0x02000107 (msm_vfe1_rdi1 to interface /dev/v4l-subdev16)
		Link: 0x02000109 (msm_vfe1_rdi2 to interface /dev/v4l-subdev17)
		Link: 0x0200010b (msm_vfe1_pix to interface /dev/v4l-subdev18)
		Link: 0x0200010d (ov5645 3-0039 to interface /dev/v4l-subdev19)
	test MEDIA_IOC_G_TOPOLOGY: OK
	Entities: 28 Interfaces: 28 Pads: 47 Links: 97
		Entity: 0x00000001 (Name: 'msm_csiphy0', Type: V4L2 I/O, DevPath: /dev/v4l-subdev0)
		Entity: 0x00000004 (Name: 'msm_csiphy1', Type: V4L2 I/O, DevPath: /dev/v4l-subdev1)
		Entity: 0x00000007 (Name: 'msm_csiphy2', Type: V4L2 I/O, DevPath: /dev/v4l-subdev2)
		Entity: 0x0000000a (Name: 'msm_csid0', Type: V4L2 I/O, DevPath: /dev/v4l-subdev3)
		Entity: 0x0000000d (Name: 'msm_csid1', Type: V4L2 I/O, DevPath: /dev/v4l-subdev4)
		Entity: 0x00000010 (Name: 'msm_csid2', Type: V4L2 I/O, DevPath: /dev/v4l-subdev5)
		Entity: 0x00000013 (Name: 'msm_csid3', Type: V4L2 I/O, DevPath: /dev/v4l-subdev6)
		Entity: 0x00000016 (Name: 'msm_ispif0', Type: V4L2 I/O, DevPath: /dev/v4l-subdev7)
		Entity: 0x00000019 (Name: 'msm_ispif1', Type: V4L2 I/O, DevPath: /dev/v4l-subdev8)
		Entity: 0x0000001c (Name: 'msm_ispif2', Type: V4L2 I/O, DevPath: /dev/v4l-subdev9)
		Entity: 0x0000001f (Name: 'msm_ispif3', Type: V4L2 I/O, DevPath: /dev/v4l-subdev10)
		Entity: 0x00000022 (Name: 'msm_vfe0_rdi0', Type: Unknown V4L2 Sub-Device, DevPath: /dev/v4l-subdev11)
		Entity: 0x00000025 (Name: 'msm_vfe0_video0', Type: V4L2 I/O, DevPath: /dev/video0)
		Entity: 0x0000002b (Name: 'msm_vfe0_rdi1', Type: Unknown V4L2 Sub-Device, DevPath: /dev/v4l-subdev12)
		Entity: 0x0000002e (Name: 'msm_vfe0_video1', Type: V4L2 I/O, DevPath: /dev/video1)
		Entity: 0x00000034 (Name: 'msm_vfe0_rdi2', Type: Unknown V4L2 Sub-Device, DevPath: /dev/v4l-subdev13)
		Entity: 0x00000037 (Name: 'msm_vfe0_video2', Type: V4L2 I/O, DevPath: /dev/video2)
		Entity: 0x0000003d (Name: 'msm_vfe0_pix', Type: Unknown V4L2 Sub-Device, DevPath: /dev/v4l-subdev14)
		Entity: 0x00000040 (Name: 'msm_vfe0_video3', Type: V4L2 I/O, DevPath: /dev/video3)
		Entity: 0x00000046 (Name: 'msm_vfe1_rdi0', Type: Unknown V4L2 Sub-Device, DevPath: /dev/v4l-subdev15)
		Entity: 0x00000049 (Name: 'msm_vfe1_video0', Type: V4L2 I/O, DevPath: /dev/video4)
		Entity: 0x0000004f (Name: 'msm_vfe1_rdi1', Type: Unknown V4L2 Sub-Device, DevPath: /dev/v4l-subdev16)
		Entity: 0x00000052 (Name: 'msm_vfe1_video1', Type: V4L2 I/O, DevPath: /dev/video5)
		Entity: 0x00000058 (Name: 'msm_vfe1_rdi2', Type: Unknown V4L2 Sub-Device, DevPath: /dev/v4l-subdev17)
		Entity: 0x0000005b (Name: 'msm_vfe1_video2', Type: V4L2 I/O, DevPath: /dev/video6)
		Entity: 0x00000061 (Name: 'msm_vfe1_pix', Type: Unknown V4L2 Sub-Device, DevPath: /dev/v4l-subdev18)
		Entity: 0x00000064 (Name: 'msm_vfe1_video3', Type: V4L2 I/O, DevPath: /dev/video7)
		Entity: 0x000000e2 (Name: 'ov5645 3-0039', Type: Camera Sensor, DevPath: /dev/v4l-subdev19)
	test MEDIA_IOC_ENUM_ENTITIES/LINKS: OK
	test MEDIA_IOC_SETUP_LINK: OK

Total: 7, Succeeded: 7, Failed: 0, Warnings: 0

--------------------------------------------------------------------------------

Sakari Ailus (1):
  doc-rst: Add packed Bayer raw14 pixel formats

Todor Tomov (34):
  media: v4l: Add new 2X8 10-bit grayscale media bus code
  media: v4l: Add new 10-bit packed grayscale format
  media: Rename CAMSS driver path
  media: camss: Use SPDX license headers
  media: camss: Fix OF node usage
  media: camss: csiphy: Ensure clock mux config is done before the rest
  media: dt-bindings: media: qcom,camss: Unify the clock names
  media: camss: Unify the clock names
  media: camss: csiphy: Update settle count calculation
  media: camss: csid: Configure data type and decode format properly
  media: camss: vfe: Fix to_vfe() macro member name
  media: camss: vfe: Get line pointer as container of video_out
  media: camss: vfe: Do not disable CAMIF when clearing its status
  media: dt-bindings: media: qcom,camss: Fix whitespaces
  media: dt-bindings: media: qcom,camss: Add 8996 bindings
  media: camss: Add 8x96 resources
  media: camss: Add basic runtime PM support
  media: camss: csiphy: Split to hardware dependent and independent
    parts
  media: camss: csiphy: Unify lane handling
  media: camss: csiphy: Add support for 8x96
  media: camss: csid: Add support for 8x96
  media: camss: ispif: Add support for 8x96
  media: camss: vfe: Split to hardware dependent and independent parts
  media: camss: vfe: Add support for 8x96
  media: camss: Format configuration per hardware version
  media: camss: vfe: Different format support on source pad
  media: camss: vfe: Add support for UYVY output from VFE on 8x96
  media: camss: csid: Different format support on source pad
  media: camss: csid: MIPI10 to Plain16 format conversion
  media: camss: Add support for RAW MIPI14 on 8x96
  media: camss: Add support for 10-bit grayscale formats
  media: doc: media/v4l-drivers: Update Qualcomm CAMSS driver document
    for 8x96
  media: camss: csid: Add support for events triggered by user controls
  media: v4l2-ioctl: Add format descriptions for packed Bayer raw14
    pixel formats

 .../devicetree/bindings/media/qcom,camss.txt       |  128 +-
 Documentation/media/uapi/v4l/pixfmt-rgb.rst        |    1 +
 Documentation/media/uapi/v4l/pixfmt-srggb14p.rst   |  127 ++
 Documentation/media/uapi/v4l/pixfmt-y10p.rst       |   33 +
 Documentation/media/uapi/v4l/subdev-formats.rst    |   72 +
 Documentation/media/uapi/v4l/yuv-formats.rst       |    1 +
 Documentation/media/v4l-drivers/qcom_camss.rst     |   93 +-
 .../media/v4l-drivers/qcom_camss_8x96_graph.dot    |  104 ++
 MAINTAINERS                                        |    2 +-
 drivers/media/platform/Kconfig                     |    2 +-
 drivers/media/platform/Makefile                    |    2 +-
 drivers/media/platform/qcom/camss-8x16/camss-vfe.h |  123 --
 .../platform/qcom/{camss-8x16 => camss}/Makefile   |    4 +
 .../qcom/{camss-8x16 => camss}/camss-csid.c        |  462 ++++--
 .../qcom/{camss-8x16 => camss}/camss-csid.h        |   17 +-
 .../platform/qcom/camss/camss-csiphy-2ph-1-0.c     |  177 +++
 .../platform/qcom/camss/camss-csiphy-3ph-1-0.c     |  256 ++++
 .../qcom/{camss-8x16 => camss}/camss-csiphy.c      |  356 ++---
 .../qcom/{camss-8x16 => camss}/camss-csiphy.h      |   34 +-
 .../qcom/{camss-8x16 => camss}/camss-ispif.c       |  257 +++-
 .../qcom/{camss-8x16 => camss}/camss-ispif.h       |   23 +-
 drivers/media/platform/qcom/camss/camss-vfe-4-1.c  | 1018 +++++++++++++
 drivers/media/platform/qcom/camss/camss-vfe-4-7.c  | 1140 ++++++++++++++
 .../qcom/{camss-8x16 => camss}/camss-vfe.c         | 1568 +++++---------------
 drivers/media/platform/qcom/camss/camss-vfe.h      |  183 +++
 .../qcom/{camss-8x16 => camss}/camss-video.c       |  133 +-
 .../qcom/{camss-8x16 => camss}/camss-video.h       |   12 +-
 .../platform/qcom/{camss-8x16 => camss}/camss.c    |  450 ++++--
 .../platform/qcom/{camss-8x16 => camss}/camss.h    |   43 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |    5 +
 include/uapi/linux/media-bus-format.h              |    3 +-
 include/uapi/linux/videodev2.h                     |    6 +
 32 files changed, 4935 insertions(+), 1900 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-srggb14p.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-y10p.rst
 create mode 100644 Documentation/media/v4l-drivers/qcom_camss_8x96_graph.dot
 delete mode 100644 drivers/media/platform/qcom/camss-8x16/camss-vfe.h
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/Makefile (68%)
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss-csid.c (70%)
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss-csid.h (74%)
 create mode 100644 drivers/media/platform/qcom/camss/camss-csiphy-2ph-1-0.c
 create mode 100644 drivers/media/platform/qcom/camss/camss-csiphy-3ph-1-0.c
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss-csiphy.c (71%)
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss-csiphy.h (64%)
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss-ispif.c (81%)
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss-ispif.h (68%)
 create mode 100644 drivers/media/platform/qcom/camss/camss-vfe-4-1.c
 create mode 100644 drivers/media/platform/qcom/camss/camss-vfe-4-7.c
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss-vfe.c (54%)
 create mode 100644 drivers/media/platform/qcom/camss/camss-vfe.h
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss-video.c (81%)
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss-video.h (74%)
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss.c (61%)
 rename drivers/media/platform/qcom/{camss-8x16 => camss}/camss.h (75%)

-- 
2.7.4
