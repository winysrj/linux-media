Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:43391 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbaCGLup (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Mar 2014 06:50:45 -0500
Message-ID: <5319B26B.8050900@ti.com>
Date: Fri, 7 Mar 2014 17:20:03 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <k.debski@samsung.com>, <linux-media@vger.kernel.org>,
	<linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2 7/7] v4l: ti-vpe: Add selection API in VPE driver
References: <1393832008-22174-1-git-send-email-archit@ti.com> <1393922965-15967-1-git-send-email-archit@ti.com> <1393922965-15967-8-git-send-email-archit@ti.com> <53159F7D.8020707@xs4all.nl> <5315B822.7010005@ti.com> <5315BA83.5080500@xs4all.nl>
In-Reply-To: <5315BA83.5080500@xs4all.nl>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tuesday 04 March 2014 05:05 PM, Hans Verkuil wrote:
> On 03/04/14 12:25, Archit Taneja wrote:
>> I had a minor question about the selection API:
>>
>> Are the V4L2_SET_TGT_CROP/COMPOSE_DEFAULT and the corresponding
>> 'BOUNDS' targets supposed to be used with VIDIOC_S_SELECTION? If so,
>> what's the expect behaviour?
>
> No, those are read only in practice. So only used with G_SELECTION, never
> with S_SELECTION.

<snip>

I tried the v4l2-compliance thing. It's awesome! And a bit annoying too 
when it comes to fixing little things needed for compliance :). But it's 
required, and I hope to fix these eventually.

After a few small fixes in the driver, I get the results as below. I am 
debugging the cause of try_fmt and s_fmt failures. I'm not sure why the 
streaming test fails with MMAP, the logs of my driver show that a 
successful mem2mem transaction happened.

I tried this on the 'vb2-part1' branch as you suggested.

Do you think I can go ahead with posting the v3 patch set for 3.15, and 
work on fixing the compliance issue for the -rc fixes?

Thanks,
Archit

# ./utils/v4l2-compliance/v4l2-compliance  -v --streaming=10
root@localhost:~/source_trees/v4l-utils# Driver Info:
         Driver name   : vpe
         Card type     : vpe
         Bus info      : platform:vpe
         Driver version: 3.14.0
         Capabilities  : 0x84004000
                 Video Memory-to-Memory Multiplanar
                 Streaming
                 Device Capabilities
         Device Caps   : 0x04004000
                 Video Memory-to-Memory Multiplanar
                 Streaming

Compliance test for device /dev/video0 (not using libv4l2):

Required ioctls:
         test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
         test second video open: OK
         test VIDIOC_QUERYCAP: OK
         test VIDIOC_G/S_PRIORITY: OK

Debug ioctls:
         test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
         test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
         test VIDIOC_G/S_TUNER: OK (Not Supported)
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

Control ioctls:
                 info: checking v4l2_queryctrl of control 'User 
Controls' (0x00980001)
                 info: checking v4l2_queryctrl of control 'Buffers Per 
Transaction' (0x00981950)
                 info: checking v4l2_queryctrl of control 'Buffers Per 
Transaction' (0x08000000)
         test VIDIOC_QUERYCTRL/MENU: OK
                 info: checking control 'User Controls' (0x00980001)
                 info: checking control 'Buffers Per Transaction' 
(0x00981950)
         test VIDIOC_G/S_CTRL: OK
                 info: checking extended control 'User Controls' 
(0x00980001)
                 info: checking extended control 'Buffers Per 
Transaction' (0x00981950)
         test VIDIOC_G/S/TRY_EXT_CTRLS: OK
                 info: checking control event 'User Controls' (0x00980001)
                 info: checking control event 'Buffers Per Transaction' 
(0x00981950)
         test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
         test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
         Standard Controls: 1 Private Controls: 1

Input/Output configuration ioctls:
         test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)

Format ioctls:
                 info: found 8 formats for buftype 9
                 info: found 4 formats for buftype 10
         test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
         test VIDIOC_G/S_PARM: OK (Not Supported)
         test VIDIOC_G_FBUF: OK (Not Supported)
         test VIDIOC_G_FMT: OK
                 fail: v4l2-test-formats.cpp(614): Video Capture 
Multiplanar: TRY_FMT(G_FMT) != G_FMT
         test VIDIOC_TRY_FMT: FAIL
                 warn: v4l2-test-formats.cpp(834): S_FMT cannot handle 
an invalid pixelformat.
                 warn: v4l2-test-formats.cpp(835): This may or may not 
be a problem. For more information see:
                 warn: v4l2-test-formats.cpp(836): 
http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
                 fail: v4l2-test-formats.cpp(420): pix_mp.reserved not 
zeroed
                 fail: v4l2-test-formats.cpp(851): Video Capture 
Multiplanar is valid, but no S_FMT was implemented
         test VIDIOC_S_FMT: FAIL
         test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)

Codec ioctls:
         test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
         test VIDIOC_G_ENC_INDEX: OK (Not Supported)
         test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
                 info: test buftype Video Capture Multiplanar
                 warn: v4l2-test-buffers.cpp(403): VIDIOC_CREATE_BUFS 
not supported
                 info: test buftype Video Output Multiplanar
                 warn: v4l2-test-buffers.cpp(403): VIDIOC_CREATE_BUFS 
not supported
         test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
         test VIDIOC_EXPBUF: OK (Not Supported)
         test read/write: OK (Not Supported)
             Video Capture Multiplanar (polling):
                 Buffer: 0 Sequence: 0 Field: Top Timestamp: 113.178208s
                 fail: v4l2-test-buffers.cpp(222): buf.field != 
cur_fmt.fmt.pix.field
                 fail: v4l2-test-buffers.cpp(630): checkQueryBuf(node, 
buf, bufs.type, bufs.memory, buf.index, Dequeued, last_seq)
                 fail: v4l2-test-buffers.cpp(1038): captureBufs(node, 
bufs, m2m_bufs, frame_count, true)
         test MMAP: FAIL
         test USERPTR: OK (Not Supported)
         test DMABUF: Cannot test, specify --expbuf-device

Total: 40, Succeeded: 37, Failed: 3, Warnings: 5

[1]+  Exit 1                  ./utils/v4l2-compliance/v4l2-compliance -v 
--streaming=10



