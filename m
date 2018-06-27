Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55632 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965193AbeF0Uf4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Jun 2018 16:35:56 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        emil.velikov@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v3 0/2] Memory-to-memory media controller topology
Date: Wed, 27 Jun 2018 17:35:43 -0300
Message-Id: <20180627203545.21728-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As discussed on IRC, memory-to-memory need to be modeled
properly in order to be supported by the media controller
framework, and thus to support the Request API.

First commit introduces a register/unregister API,
that creates/destroys all the entities and pads needed,
and links them.

The second commit uses this API to support the vim2m driver.

The series applies cleanly on v4.18-rc1.

Topology (media-ctl -p output)
==============================

media-ctl -p
Media controller API version 4.17.0

Media device information
------------------------
driver          vim2m
model           vim2m
serial          
bus info        
hw revision     0x0
driver version  4.17.0

Device topology
- entity 1: source (1 pad, 1 link)
            type Node subtype V4L flags 0
	pad0: Source
		-> "proc":1 [ENABLED,IMMUTABLE]

- entity 3: proc (2 pads, 2 links)
            type Node subtype Unknown flags 0
	pad0: Sink
		-> "sink":0 [ENABLED,IMMUTABLE]
	pad1: Source
		<- "source":0 [ENABLED,IMMUTABLE]

- entity 6: sink (1 pad, 1 link)
            type Node subtype V4L flags 0
	pad0: Sink
		<- "proc":0 [ENABLED,IMMUTABLE]

Compliance output
=================

v4l2-compliance -m /dev/media0 -v 
v4l2-compliance SHA: e2038ec6451293787b929338c2a671c732b8693d, 64 bits

Compliance test for device /dev/media0:

Media Driver Info:
	Driver name      : vim2m
	Model            : vim2m
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
		Entity: 0x00000001 (Name: 'source', Function: 0x00010001)
		Entity: 0x00000003 (Name: 'proc', Function: 0x00004005)
		Entity: 0x00000006 (Name: 'sink', Function: 0x00010001)
		Interface: 0x0300000c (Type: 0x00000200)
		Pad: 0x01000002
		Pad: 0x01000004
		Pad: 0x01000005
		Pad: 0x01000007
		Link: 0x02000008
		Link: 0x0200000a
		Link: 0x0200000d
		Link: 0x0200000e
	test MEDIA_IOC_G_TOPOLOGY: OK
	Entities: 3 Interfaces: 1 Pads: 4 Links: 4
		Entity: 0x00000001 (Name: 'source', Type: 0x00010001)
		Entity: 0x00000003 (Name: 'proc', Type: 0x0001ffff)
		Entity: 0x00000006 (Name: 'sink', Type: 0x00010001)
		Entity Links: 0x00000001 (Name: 'source')
		Entity Links: 0x00000003 (Name: 'proc')
		Entity Links: 0x00000006 (Name: 'sink')
	test MEDIA_IOC_ENUM_ENTITIES/LINKS: OK
	test MEDIA_IOC_SETUP_LINK: OK

--------------------------------------------------------------------------------
Compliance test for device /dev/video2:

Driver Info:
	Driver name      : vim2m
	Card type        : vim2m
	Bus info         : platform:vim2m
	Driver version   : 4.17.0
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
	Media version    : 4.17.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 4.17.0
Interface Info:
	ID               : 0x0300000c
	Type             : V4L Video
	Major            : 81
	Minor            : 7
Entity Info:
	ID               : 0x00000001 (1)
	Name             : source
	Function         : V4L2 I/O
	Pad 0x01000002   : Source
	  Link 0x02000008: to remote pad 0x1000005 of entity 'proc': Data, Enabled, Immutable

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

v3:
  * Remove extra empty line.
  * Remove duplicated entity name set.
  * Reorder sink and source pads as suggested by Hans.
  * Drop unused media macros, we can add them as needed.

v2:
  * Fix compile error when MEDIA_CONTROLLER was not enabled.
  * Fix the 'proc' entity link, which was wrongly connecting
    source to source and sink to sink.

Ezequiel Garcia (1):
  media: add helpers for memory-to-memory media controller

Hans Verkuil (1):
  vim2m: add media device

 drivers/media/platform/vim2m.c         |  41 +++++-
 drivers/media/v4l2-core/v4l2-dev.c     |  13 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c | 172 +++++++++++++++++++++++++
 include/media/v4l2-mem2mem.h           |  19 +++
 4 files changed, 236 insertions(+), 9 deletions(-)

-- 
2.18.0.rc2
