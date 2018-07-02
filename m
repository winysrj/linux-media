Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55648 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751931AbeGBPgU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 11:36:20 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        emil.velikov@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v5 0/2] Memory-to-memory media controller topology
Date: Mon,  2 Jul 2018 12:36:04 -0300
Message-Id: <20180702153606.24876-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As discussed on IRC, memory-to-memory need to be modeled
properly in order to be supported by the media controller
framework, and thus to support the Request API.

First commit introduces a register/unregister API,
that creates/destroys all the entities and pads needed,
and links them.

The second commit uses this API to support the vim2m driver.

The series applies cleanly on v4.18-rc3.

v5:
 * Don't set major:minor to proc entity (Hans).

v4:
  * Add unique entity names (Hans)
  * Add associated interface major and minor (Hans)
  * Remove unused MEM2MEM_ENT_TYPE_MAX (Hans)	

v3:
  * Remove extra empty line.
  * Remove duplicated entity name set.
  * Reorder sink and source pads (Hans)
  * Drop unused media macros, we can add them as needed.

v2:
  * Fix compile error when MEDIA_CONTROLLER was not enabled.
  * Fix the 'proc' entity link, which was wrongly connecting
    source to source and sink to sink.

Compliance output
=================

root@(none):/# v4l2-compliance -m 0 -v
v4l2-compliance SHA: 248491682a2919a1bd421f87b33c14125b9fc1f5, 64 bits

Compliance test for device /dev/media0:

Media Driver Info:
	Driver name      : vim2m
	Model            : vim2m
	Serial           : 
	Bus info         : 
	Media version    : 4.18.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.18.0

Required ioctls:
	test MEDIA_IOC_DEVICE_INFO: OK

Allow for multiple opens:
	test second /dev/media0 open: OK
	test MEDIA_IOC_DEVICE_INFO: OK
	test for unlimited opens: OK

Media Controller ioctls:
		Entity: 0x00000001 (Name: 'vim2m-source', Function: V4L2 I/O)
		Entity: 0x00000003 (Name: 'vim2m-proc', Function: Video Scaler)
		Entity: 0x00000006 (Name: 'vim2m-sink', Function: V4L2 I/O)
		Interface: 0x0300000c (Type: V4L Video, DevPath: /dev/video2)
		Pad: 0x01000002 (vim2m-source, Source)
		Pad: 0x01000004 (vim2m-proc, Sink)
		Pad: 0x01000005 (vim2m-proc, Source)
		Pad: 0x01000007 (vim2m-sink, Sink)
		Link: 0x02000008 (vim2m-source -> vim2m-proc)
		Link: 0x0200000a (vim2m-proc -> vim2m-sink)
		Link: 0x0200000d (vim2m-source to interface /dev/video2)
		Link: 0x0200000e (vim2m-sink to interface /dev/video2)
	test MEDIA_IOC_G_TOPOLOGY: OK
	Entities: 3 Interfaces: 1 Pads: 4 Links: 4
		Entity: 0x00000001 (Name: 'vim2m-source', Type: V4L2 I/O DevPath: /dev/video2)
		Entity: 0x00000003 (Name: 'vim2m-proc', Type: Unknown legacy device node type (0001ffff))
		Entity: 0x00000006 (Name: 'vim2m-sink', Type: V4L2 I/O DevPath: /dev/video2)
		Entity Links: 0x00000001 (Name: 'vim2m-source')
		Entity Links: 0x00000003 (Name: 'vim2m-proc')
		Entity Links: 0x00000006 (Name: 'vim2m-sink')
	test MEDIA_IOC_ENUM_ENTITIES/LINKS: OK
	test MEDIA_IOC_SETUP_LINK: OK

--------------------------------------------------------------------------------
Compliance test for device /dev/video2:

Driver Info:
	Driver name      : vim2m
	Card type        : vim2m
	Bus info         : platform:vim2m
	Driver version   : 4.18.0
	Capabilities     : 0x84208000
		Video Memory-to-Memory
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps      : 0x04208000
		Video Memory-to-Memory
		Streaming
		Extended Pix Format
Media Driver Info:
	Driver name      : vim2m
	Model            : vim2m
	Serial           : 
	Bus info         : 
	Media version    : 4.18.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.18.0
Interface Info:
	ID               : 0x0300000c
	Type             : V4L Video
Entity Info:
	ID               : 0x00000001 (1)
	Name             : vim2m-source
	Function         : V4L2 I/O
	Pad 0x01000002   : Source
	  Link 0x02000008: to remote pad 0x1000005 of entity 'vim2m-proc': Data, Enabled, Immutable

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second /dev/video2 open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK
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

Control ioctls:
		info: checking v4l2_queryctrl of control 'User Controls' (0x00980001)
		info: checking v4l2_queryctrl of control 'Horizontal Flip' (0x00980914)
		info: checking v4l2_queryctrl of control 'Vertical Flip' (0x00980915)
		info: checking v4l2_queryctrl of control 'Transaction Time (msec)' (0x00981900)
		info: checking v4l2_queryctrl of control 'Buffers Per Transaction' (0x00981901)
		info: checking v4l2_queryctrl of control 'Horizontal Flip' (0x00980914)
		info: checking v4l2_queryctrl of control 'Vertical Flip' (0x00980915)
		info: checking v4l2_queryctrl of control 'Transaction Time (msec)' (0x08000000)
		info: checking v4l2_queryctrl of control 'Buffers Per Transaction' (0x08000001)
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
		info: checking control 'User Controls' (0x00980001)
		info: checking control 'Horizontal Flip' (0x00980914)
		info: checking control 'Vertical Flip' (0x00980915)
		info: checking control 'Transaction Time (msec)' (0x00981900)
		info: checking control 'Buffers Per Transaction' (0x00981901)
	test VIDIOC_G/S_CTRL: OK
		info: checking extended control 'User Controls' (0x00980001)
		info: checking extended control 'Horizontal Flip' (0x00980914)
		info: checking extended control 'Vertical Flip' (0x00980915)
		info: checking extended control 'Transaction Time (msec)' (0x00981900)
		info: checking extended control 'Buffers Per Transaction' (0x00981901)
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		info: checking control event 'User Controls' (0x00980001)
		info: checking control event 'Horizontal Flip' (0x00980914)
		info: checking control event 'Vertical Flip' (0x00980915)
		info: checking control event 'Transaction Time (msec)' (0x00981900)
		info: checking control event 'Buffers Per Transaction' (0x00981901)
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 3 Private Controls: 2

Format ioctls:
		info: found 1 formats for buftype 1
		info: found 2 formats for buftype 2
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
	test VIDIOC_G/S_PARM: OK (Not Supported)
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK
	test VIDIOC_TRY_FMT: OK
	test VIDIOC_S_FMT: OK
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
		info: test buftype Video Capture
		info: test buftype Video Output
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK

Total: 51, Succeeded: 51, Failed: 0, Warnings: 0

Ezequiel Garcia (1):
  media: add helpers for memory-to-memory media controller

Hans Verkuil (1):
  vim2m: add media device

 drivers/media/platform/vim2m.c         |  41 +++++-
 drivers/media/v4l2-core/v4l2-dev.c     |  13 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c | 188 +++++++++++++++++++++++++
 include/media/v4l2-mem2mem.h           |  19 +++
 4 files changed, 252 insertions(+), 9 deletions(-)

-- 
2.18.0.rc2
