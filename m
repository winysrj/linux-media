Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33484 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753642AbeF1T30 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 15:29:26 -0400
Message-ID: <92f17b984e2b140c8dbc060a3d171d7c55dbaf9d.camel@collabora.com>
Subject: Re: [PATCH v3 0/2] Memory-to-memory media controller topology
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        emil.velikov@collabora.com
Date: Thu, 28 Jun 2018 16:29:18 -0300
In-Reply-To: <db546539-99c4-1e9a-8846-d367bb44635c@xs4all.nl>
References: <20180627203545.21728-1-ezequiel@collabora.com>
         <db546539-99c4-1e9a-8846-d367bb44635c@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, 2018-06-28 at 11:19 +0200, Hans Verkuil wrote:
> On 06/27/18 22:35, Ezequiel Garcia wrote:
> > As discussed on IRC, memory-to-memory need to be modeled
> > properly in order to be supported by the media controller
> > framework, and thus to support the Request API.
> > 
> > First commit introduces a register/unregister API,
> > that creates/destroys all the entities and pads needed,
> > and links them.
> > 
> > The second commit uses this API to support the vim2m driver.
> > 
> > The series applies cleanly on v4.18-rc1.
> > 
> > Topology (media-ctl -p output)
> > ==============================
> > 
> > media-ctl -p
> > Media controller API version 4.17.0
> > 
> > Media device information
> > ------------------------
> > driver          vim2m
> > model           vim2m
> > serial          
> > bus info        
> > hw revision     0x0
> > driver version  4.17.0
> > 
> > Device topology
> > - entity 1: source (1 pad, 1 link)
> >             type Node subtype V4L flags 0
> > 	pad0: Source
> > 		-> "proc":1 [ENABLED,IMMUTABLE]
> > 
> > - entity 3: proc (2 pads, 2 links)
> >             type Node subtype Unknown flags 0
> > 	pad0: Sink
> > 		-> "sink":0 [ENABLED,IMMUTABLE]
> > 	pad1: Source
> > 		<- "source":0 [ENABLED,IMMUTABLE]
> > 
> > - entity 6: sink (1 pad, 1 link)
> >             type Node subtype V4L flags 0
> > 	pad0: Sink
> > 		<- "proc":0 [ENABLED,IMMUTABLE]
> > 
> > Compliance output
> > =================
> > 
> > v4l2-compliance -m /dev/media0 -v 
> > v4l2-compliance SHA: e2038ec6451293787b929338c2a671c732b8693d, 64
> > bits
> 
> This is an old version of v4l2-compliance. Can you update it to the
> latest
> version and run this again?
> 

With the two v4l-utils patches that I just sent:

https://patchwork.linuxtv.org/patch/50654/
https://patchwork.linuxtv.org/patch/50655/

The compliance output looks OK, I think:

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
		Entity: 0x00000001 (Name: 'source', Function: V4L2 I/O)
		Entity: 0x00000003 (Name: 'proc', Function: Video
Scaler)
		Entity: 0x00000006 (Name: 'sink', Function: V4L2 I/O)
		Interface: 0x0300000c (Type: V4L Video, DevPath:
/dev/video2)
		Pad: 0x01000002 (source, Source)
		Pad: 0x01000004 (proc, Sink)
		Pad: 0x01000005 (proc, Source)
		Pad: 0x01000007 (sink, Sink)
		Link: 0x02000008 (source -> proc)
		Link: 0x0200000a (proc -> sink)
		Link: 0x0200000d (source to interface /dev/video2)
		Link: 0x0200000e (sink to interface /dev/video2)
	test MEDIA_IOC_G_TOPOLOGY: OK
	Entities: 3 Interfaces: 1 Pads: 4 Links: 4
		Entity: 0x00000001 (Name: 'source', Type: V4L2 I/O)
		Entity: 0x00000003 (Name: 'proc', Type: Unknown legacy
device node type (0001ffff))
		Entity: 0x00000006 (Name: 'sink', Type: V4L2 I/O)
		Entity Links: 0x00000001 (Name: 'source')
		Entity Links: 0x00000003 (Name: 'proc')
		Entity Links: 0x00000006 (Name: 'sink')
	test MEDIA_IOC_ENUM_ENTITIES/LINKS: OK
	test MEDIA_IOC_SETUP_LINK: OK

---------------------------------------------------------------------
-----------
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
	Name             : source
	Function         : V4L2 I/O
	Pad 0x01000002   : Source
	  Link 0x02000008: to remote pad 0x1000005 of entity 'proc':
Data, Enabled, Immutable

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
		info: checking v4l2_queryctrl of control 'User
Controls' (0x00980001)
		info: checking v4l2_queryctrl of control 'Horizontal
Flip' (0x00980914)
		info: checking v4l2_queryctrl of control 'Vertical
Flip' (0x00980915)
		info: checking v4l2_queryctrl of control 'Transaction
Time (msec)' (0x00981900)
		info: checking v4l2_queryctrl of control 'Buffers Per
Transaction' (0x00981901)
		info: checking v4l2_queryctrl of control 'Horizontal
Flip' (0x00980914)
		info: checking v4l2_queryctrl of control 'Vertical
Flip' (0x00980915)
		info: checking v4l2_queryctrl of control 'Transaction
Time (msec)' (0x08000000)
		info: checking v4l2_queryctrl of control 'Buffers Per
Transaction' (0x08000001)
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
		info: checking control 'User Controls' (0x00980001)
		info: checking control 'Horizontal Flip' (0x00980914)
		info: checking control 'Vertical Flip' (0x00980915)
		info: checking control 'Transaction Time (msec)'
(0x00981900)
		info: checking control 'Buffers Per Transaction'
(0x00981901)
	test VIDIOC_G/S_CTRL: OK
		info: checking extended control 'User Controls'
(0x00980001)
		info: checking extended control 'Horizontal Flip'
(0x00980914)
		info: checking extended control 'Vertical Flip'
(0x00980915)
		info: checking extended control 'Transaction Time
(msec)' (0x00981900)
		info: checking extended control 'Buffers Per
Transaction' (0x00981901)
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
		info: checking control event 'User Controls'
(0x00980001)
		info: checking control event 'Horizontal Flip'
(0x00980914)
		info: checking control event 'Vertical Flip'
(0x00980915)
		info: checking control event 'Transaction Time (msec)'
(0x00981900)
		info: checking control event 'Buffers Per Transaction'
(0x00981901)
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
  
