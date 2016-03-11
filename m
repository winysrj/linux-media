Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:45416 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934358AbcCKIA1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2016 03:00:27 -0500
Subject: Re: [RFC PATCH v0] Add tw5864 driver
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
References: <1451785302-3173-1-git-send-email-andrey.utkin@corp.bluecherry.net>
 <56938969.30104@xs4all.nl>
 <CAM_ZknVgTETBNXu+8N6eJa=cf_Mmj=+tA=ocKB9SJL5rkSyijQ@mail.gmail.com>
 <56B866D9.5070606@xs4all.nl> <20160309162924.6e6ebddf@zver>
Cc: Linux Media <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kernel-mentors@selenic.com" <kernel-mentors@selenic.com>,
	devel@driverdev.osuosl.org,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Andrey Utkin <andrey_utkin@fastmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56E27B12.1000803@xs4all.nl>
Date: Fri, 11 Mar 2016 09:00:18 +0100
MIME-Version: 1.0
In-Reply-To: <20160309162924.6e6ebddf@zver>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/09/2016 03:29 PM, Andrey Utkin wrote:
> Hi Hans!
> 
> Some improvements took place on the driver, including cleaner
> v4l2-compliance tests passing. But there's a single test failure I
> don't understand.
> 
> In the code of v4l2-compliance, it seems like an API
> call CREATE_BUFS is supposed to fail with EINVAL. But in case of my
> driver, which simply uses vb2_ioctl_create_bufs(), the call returns 0.
> 
> Please review the below report.
> 
> The report is produced by fresh v4l-utils from git:
> v4l-utils-1.10.0-59-g1388c0a
> 
> The actual code which was tested is at tag release/tw5864/1.10 of
> https://github.com/bluecherrydvr/linux.git , see
> drivers/staging/media/tw5864 . If we sort this out, I am considering
> resubmit the driver for merging upstream.

The reason is likely to be the tw5864_queue_setup function which has not been
updated to handle CREATE_BUFS support correctly. It should look like this:

static int tw5864_queue_setup(struct vb2_queue *q,
			      unsigned int *num_buffers,
			      unsigned int *num_planes, unsigned int sizes[],
			      void *alloc_ctxs[])
{
	struct tw5864_input *dev = vb2_get_drv_priv(q);

	if (q->num_buffers + *num_buffers < 12)
		*num_buffers = 12 - q->num_buffers;

	alloc_ctxs[0] = dev->alloc_ctx;
	if (*num_planes)
		return sizes[0] < H264_VLC_BUF_SIZE ? -EINVAL : 0;

	sizes[0] = H264_VLC_BUF_SIZE;
	*num_planes = 1;

	return 0;
}

> 
> There's also another issue with v4l2-compliance. At some moment the
> driver receives S_PARM command with timeperframe 0/0, by which reason I
> added special handling, but I guess there's something out of my
> knowledge which caused this and which should be fixed.

A timeperframe value of 0/0 is valid and the driver is supposed to replace it
with the default timeperframe. Which is why v4l2-compliance tests for this
corner case.

Regards,

	Hans

> 
> 
>  # v4l2-compliance -d /dev/video6 -s
> Driver Info:
>         Driver name   : tw5864
>         Card type     : TW5864 Encoder 2
>         Bus info      : PCI:0000:06:05.0
>         Driver version: 4.5.0
>         Capabilities  : 0x85200001
>                 Video Capture
>                 Read/Write
>                 Streaming
>                 Extended Pix Format
>                 Device Capabilities
>         Device Caps   : 0x05200001
>                 Video Capture
>                 Read/Write
>                 Streaming
>                 Extended Pix Format
> 
> Compliance test for device /dev/video6 (not using libv4l2):
> 
> Required ioctls:
>         test VIDIOC_QUERYCAP: OK
> 
> Allow for multiple opens:
>         test second video open: OK
>         test VIDIOC_QUERYCAP: OK
>         test VIDIOC_G/S_PRIORITY: OK
> 
> Debug ioctls:
>         test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
>         test VIDIOC_LOG_STATUS: OK
> 
> Input ioctls:
>         test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>         test VIDIOC_ENUMAUDIO: OK (Not Supported)
>         test VIDIOC_G/S/ENUMINPUT: OK
>         test VIDIOC_G/S_AUDIO: OK (Not Supported)
>         Inputs: 1 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
>         test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>         test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>         Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Input/Output configuration ioctls:
>         test VIDIOC_ENUM/G/S/QUERY_STD: OK
>         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>         test VIDIOC_G/S_EDID: OK (Not Supported)
> 
> Test input 0:
> 
>         Control ioctls:
>                 test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>                 test VIDIOC_QUERYCTRL: OK
>                 test VIDIOC_G/S_CTRL: OK
>                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
>                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>                 Standard Controls: 11 Private Controls: 0
> 
>         Format ioctls:
>                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>                 test VIDIOC_G/S_PARM: OK
>                 test VIDIOC_G_FBUF: OK (Not Supported)
>                 test VIDIOC_G_FMT: OK
>                 test VIDIOC_TRY_FMT: OK
>                 test VIDIOC_S_FMT: OK
>                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>                 test Cropping: OK (Not Supported)
>                 test Composing: OK (Not Supported)
>                 test Scaling: OK (Not Supported)
> 
>         Codec ioctls:
>                 test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>                 test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>                 test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
>         Buffer ioctls:
>                 test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>                 test VIDIOC_EXPBUF: OK
> 
> Test input 0:
> 
> Streaming ioctls:
>         test read/write: OK
>                 fail: v4l2-test-buffers.cpp(959): ret != EINVAL
>         test MMAP: FAIL
>         test USERPTR: OK (Not Supported)
>         test DMABUF: Cannot test, specify --expbuf-device
> 
> 
> Total: 45, Succeeded: 44, Failed: 1, Warnings: 0
> [ERR]
> 14:14:15root@tw ~
>  # gdb v4l2-compliance 
> GNU gdb (Ubuntu 7.10-1ubuntu3) 7.10
> Copyright (C) 2015 Free Software Foundation, Inc.
> License GPLv3+: GNU GPL version 3 or later
> <http://gnu.org/licenses/gpl.html> This is free software: you are free
> to change and redistribute it. There is NO WARRANTY, to the extent
> permitted by law.  Type "show copying" and "show warranty" for details.
> This GDB was configured as "i686-linux-gnu".
> Type "show configuration" for configuration details.
> For bug reporting instructions, please see:
> <http://www.gnu.org/software/gdb/bugs/>.
> Find the GDB manual and other documentation resources online at:
> <http://www.gnu.org/software/gdb/documentation/>.
> For help, type "help".
> Type "apropos word" to search for commands related to "word"...
> Reading symbols from v4l2-compliance...done.
> (gdb) break v4l2-test-buffers.cpp:959
> Breakpoint 1 at 0x8071469: file v4l2-test-buffers.cpp, line 959.
> (gdb) run  -d /dev/video6 -s
> Starting program: /usr/local/bin/v4l2-compliance -d /dev/video6 -s
> [Thread debugging using libthread_db enabled]
> Using host libthread_db library "/lib/i386-linux-gnu/libthread_db.so.1".
> Driver Info:
>         Driver name   : tw5864
>         Card type     : TW5864 Encoder 2
>         Bus info      : PCI:0000:06:05.0
>         Driver version: 4.5.0
>         Capabilities  : 0x85200001
>                 Video Capture
>                 Read/Write
>                 Streaming
>                 Extended Pix Format
>                 Device Capabilities
>         Device Caps   : 0x05200001
>                 Video Capture
>                 Read/Write
>                 Streaming
>                 Extended Pix Format
> 
> Compliance test for device /dev/video6 (not using libv4l2):
> 
> Required ioctls:
>         test VIDIOC_QUERYCAP: OK
> 
> Allow for multiple opens:
>         test second video open: OK
>         test VIDIOC_QUERYCAP: OK
>         test VIDIOC_G/S_PRIORITY: OK
> 
> Debug ioctls:
>         test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
>         test VIDIOC_LOG_STATUS: OK
> 
> Input ioctls:
>         test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>         test VIDIOC_ENUMAUDIO: OK (Not Supported)
>         test VIDIOC_G/S/ENUMINPUT: OK
>         test VIDIOC_G/S_AUDIO: OK (Not Supported)
>         Inputs: 1 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
>         test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>         test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>         Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Input/Output configuration ioctls:
>         test VIDIOC_ENUM/G/S/QUERY_STD: OK
>         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>         test VIDIOC_G/S_EDID: OK (Not Supported)
> 
> Test input 0:
> 
>         Control ioctls:
>                 test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>                 test VIDIOC_QUERYCTRL: OK
>                 test VIDIOC_G/S_CTRL: OK
>                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
>                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>                 Standard Controls: 11 Private Controls: 0
> 
>         Format ioctls:
>                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>                 test VIDIOC_G/S_PARM: OK
>                 test VIDIOC_G_FBUF: OK (Not Supported)
>                 test VIDIOC_G_FMT: OK
>                 test VIDIOC_TRY_FMT: OK
>                 test VIDIOC_S_FMT: OK
>                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>                 test Cropping: OK (Not Supported)
>                 test Composing: OK (Not Supported)
>                 test Scaling: OK (Not Supported)
> 
>         Codec ioctls:
>                 test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>                 test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>                 test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
>         Buffer ioctls:
>                 test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>                 test VIDIOC_EXPBUF: OK
> 
> Test input 0:
> 
> Streaming ioctls:
>         test read/write: OK
> 
> Breakpoint 1, testMmap (node=0xbfffd1e4, frame_count=60) at v4l2-test-buffers.cpp:959
> 959                                     fail_on_test(ret != EINVAL);
> (gdb) print ret
> $1 = 0
> (gdb)
> 

