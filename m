Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:39154 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751501AbbGTJpY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 05:45:24 -0400
Message-ID: <55ACC2F0.3090804@xs4all.nl>
Date: Mon, 20 Jul 2015 11:44:16 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
CC: Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"j.anaszewski" <j.anaszewski@samsung.com>,
	Kamil Debski <kamil@wypas.org>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH v4 1/1] V4L2: platform: Add Renesas R-Car JPEG codec driver.
References: <1435318645-20565-1-git-send-email-mikhail.ulyanov@cogentembedded.com>	<55A8C1C8.9040909@xs4all.nl> <CALi4nho_C2ffjryTREBy2V7X+W1Hpcu6SZFW8q+r+xhBagmgTw@mail.gmail.com>
In-Reply-To: <CALi4nho_C2ffjryTREBy2V7X+W1Hpcu6SZFW8q+r+xhBagmgTw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/19/2015 04:40 PM, Mikhail Ulyanov wrote:
> Hi Hans,
> 
> I've made some changes to driver(mostly minor, like  sequence v4l2_buf
> field filling and so on)to make it pass "v4l2-compliance -s" test(MMAP
> part), but suddenly get stuck with USERPTR part. First there is WARN
> about zero bytesused.
> I suppose it should be fixed in v4l2-compliance, is that correct? Or
> driver should handle it somehow(maybe drop buffers with zero bytesused
> in buf_queue)?
> Second there is possible deadlock warning... AFAIU it's false
> positive. Is that correct?

Regarding the deadlock warning: it's not a false positive and I've posted
a patch to fix this.

> 
> Here is logs.
> 
> [   19.666078] use of bytesused == 0 is deprecated and will be removed
> in the future,
> [   19.673808] use the actual size instead.

And this one is caused by one of the v4l2-compliance tests where bytesused
is explicitly set to 0. This test checks that you can set bytesused == 0
and that it will be replaced by the buffer length. However, since this is
a deprecated 'feature' it will cause this warning in the log.

I've decided to remove this test from the compliance testsuite.

While doing that I discovered that bytesused wasn't set when calling
prepare_buf for an output buffer. This was a clear v4l2-compliance bug
that I've fixed. So if you do a git pull you should get a working
compliance test.

Regards,

	Hans

> 
> 
> 
> 
> Driver Info:
>         Driver name   : rcar_jpu
>         Card type     : rcar_jpu encoder
>         Bus info      : platform:fe980000.jpu
>         Driver version: 4.1.0
>         Capabilities  : 0x84204000
>                 Video Memory-to-Memory Multiplanar
>                 Streaming
>                 Extended Pix Format
>                 Device Capabilities
>         Device Caps   : 0x04204000
>                 Video Memory-to-Memory Multiplanar
>                 Streaming
>                 Extended Pix Format
> 
> Compliance test for device /dev/video0 (not using libv4l2):
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
>         test VIDIOC_DBG_G/S_REGISTER: OK
>         test VIDIOC_LOG_STATUS: OK (Not Supported)
> 
> Input ioctls:
>         test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>         test VIDIOC_ENUMAUDIO: OK (Not Supported)
>         test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDIO: OK (Not Supported)
>         Inputs: 0 Audio Inputs: 0 Tuners: 0
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
>         test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
>         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>         test VIDIOC_G/S_EDID: OK (Not Supported)
> 
>         Control ioctls:
>                 test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>                 test VIDIOC_QUERYCTRL: OK
>                 test VIDIOC_G/S_CTRL: OK
>                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
>                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>                 Standard Controls: 2 Private Controls: 0
> 
>         Format ioctls:
>                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>                 test VIDIOC_G/S_PARM: OK (Not Supported)
>                 test VIDIOC_G_FBUF: OK (Not Supported)
>                 test VIDIOC_G_FMT: OK
>                 test VIDIOC_TRY_FMT: OK
>                 test VIDIOC_S_FMT: OK
>                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>                 test Cropping: OK (Not Supported)
>                 test Composing: OK (Not Supported)
>                 test Scaling: OK
> 
>         Codec ioctls:
>                 test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>                 test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>                 test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
>         Buffer ioctls:
>                 warn: v4l2-test-buffers.cpp(540): VIDIOC_CREATE_BUFS
> not supported
>                 warn: v4l2-test-buffers.cpp(540): VIDIOC_CREATE_BUFS
> not supported
>                 test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>                 test VIDIOC_EXPBUF: OK (Not Supported)
> 
> Test input 0:
> 
> Streaming ioctls:
>         test read/write: OK (Not Supported)
>         test MMAP: OK
>                 fail: v4l2-test-buffers.cpp(1030): buf.qbuf(node)
>                 fail: v4l2-test-buffers.cpp(1073): setupUserPtr(node, q)
>         test USERPTR: FAIL
>         test DMABUF: Cannot test, specify --expbuf-device
> 
> 
> Total: 45, Succeeded: 44, Failed: 1, Warnings: 2
> 
> 
> 
> 2015-07-17 11:50 GMT+03:00 Hans Verkuil <hverkuil@xs4all.nl>:
>> Hi Mikhail,
>>
>> On 06/26/2015 01:37 PM, Mikhail Ulyanov wrote:
>>> Here's the driver for the Renesas R-Car JPEG processing unit.
>>>
>>> The driver is implemented within the V4L2 framework as a memory-to-memory
>>> device.  It presents two video nodes to userspace, one for the encoding part,
>>> and one for the decoding part.
>>>
>>> It was found that the only working mode for encoding is no markers output, so we
>>> generate markers with software. In the current version of driver we also use
>>> software JPEG header parsing because with hardware parsing performance is lower
>>> than desired.
>>>
>>> From a userspace point of view the process is typical (S_FMT, REQBUF,
>>> optionally QUERYBUF, QBUF, STREAMON, DQBUF) for both the source and destination
>>> queues. STREAMON can return -EINVAL in case of mismatch of output and capture
>>> queues format. Also during decoding driver can return buffers if queued
>>> buffer with JPEG image contains image with inappropriate subsampling (e.g.
>>> 4:2:0 in JPEG and 4:2:2 in capture).  If JPEG image and queue format dimensions
>>> differ driver will return buffer on QBUF with VB2_BUF_STATE_ERROR flag.
>>>
>>> During encoding the available formats are: V4L2_PIX_FMT_NV12M,
>>> V4L2_PIX_FMT_NV12, V4L2_PIX_FMT_NV16, V4L2_PIX_FMT_NV16M for source and
>>> V4L2_PIX_FMT_JPEG for destination.
>>>
>>> During decoding the available formats are: V4L2_PIX_FMT_JPEG for source and
>>> V4L2_PIX_FMT_NV12M, V4L2_PIX_FMT_NV16M, V4L2_PIX_FMT_NV12, V4L2_PIX_FMT_NV16
>>> for destination.
>>>
>>> Performance of current version:
>>> 1280x800 NV12 image encoding/decoding
>>>       decoding ~122 FPS
>>>       encoding ~191 FPS
>>>
>>> Signed-off-by: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
>>> ---
>>>  Changes since v3:
>>>     - driver file renamed to rcar_jpu.c
>>>     - semiplanar formats NV12 and NV16 support
>>>     - new callbacks streamon, job_abort and stop_streaming
>>>     - extra processing error information printout irq handler
>>>     - fill in JPEG header for encoded buffer in buf_finish
>>>     - wrapped reading/writing to registers
>>>     - vb2_set_plane_payload only for necessary buffer in buf_prepare
>>>     - multiple buffers now supported
>>>     - removed format setup with parsed info; rely only on users info
>>>     - JPEG header parser redesigned
>>>     - video_device structs embedded
>>>     - video_device_alloc/release removed
>>>     - "name" filed in format description removed
>>>     - remove g_selection
>>>     - start_streaming removed
>>>
>>> Changes since v2:
>>>     - Kconfig entry reordered
>>>     - unnecessary clk_disable_unprepare(jpu->clk) removed
>>>     - ref_count fixed in jpu_resume
>>>     - enable DMABUF in src_vq->io_modes
>>>     - remove jpu_s_priority jpu_g_priority
>>>     - jpu_g_selection fixed
>>>     - timeout in jpu_reset added and hardware reset reworked
>>>     - remove unused macros
>>>     - JPEG header parsing now is software because of performance issues
>>>       based on s5p-jpeg code
>>>     - JPEG header generation redesigned:
>>>       JPEG header(s) pre-generated and memcpy'ed on encoding
>>>       we only fill the necessary fields
>>>       more "transparent" header format description
>>>     - S_FMT, G_FMT and TRY_FMT hooks redesigned
>>>       partially inspired by VSP1 driver code
>>>     - some code was reformatted
>>>     - image formats handling redesigned
>>>     - multi-planar V4L2 API now in use
>>>     - now passes v4l2-compliance tool check
>>>
>>> Cnanges since v1:
>>>     - s/g_fmt function simplified
>>>     - default format for queues added
>>>     - dumb vidioc functions added to be in compliance with standard api:
>>>         jpu_s_priority, jpu_g_priority
>>>     - standard v4l2_ctrl_subscribe_event and v4l2_event_unsubscribe
>>>       now in use by the same reason
>>>
>>>  drivers/media/platform/Kconfig    |   11 +
>>>  drivers/media/platform/Makefile   |    1 +
>>>  drivers/media/platform/rcar_jpu.c | 1753 +++++++++++++++++++++++++++++++++++++
>>>  3 files changed, 1765 insertions(+)
>>>  create mode 100644 drivers/media/platform/rcar_jpu.c
>>>
>>
>> This patch looks good. There are a few small things checkpatch gave me:
>>
>> WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
>> #82:
>> new file mode 100644
>>
>> WARNING: DT compatible string "renesas,jpu-r8a7790" appears un-documented -- check ./Documentation/devicetree/bindings/
>> #1645: FILE: drivers/media/platform/rcar_jpu.c:1559:
>> +       { .compatible = "renesas,jpu-r8a7790" }, /* H2 */
>>
>> WARNING: DT compatible string "renesas,jpu-r8a7791" appears un-documented -- check ./Documentation/devicetree/bindings/
>> #1646: FILE: drivers/media/platform/rcar_jpu.c:1560:
>> +       { .compatible = "renesas,jpu-r8a7791" }, /* M2-W */
>>
>> WARNING: DT compatible string "renesas,jpu-r8a7792" appears un-documented -- check ./Documentation/devicetree/bindings/
>> #1647: FILE: drivers/media/platform/rcar_jpu.c:1561:
>> +       { .compatible = "renesas,jpu-r8a7792" }, /* V2H */
>>
>> WARNING: DT compatible string "renesas,jpu-r8a7793" appears un-documented -- check ./Documentation/devicetree/bindings/
>> #1648: FILE: drivers/media/platform/rcar_jpu.c:1562:
>> +       { .compatible = "renesas,jpu-r8a7793" }, /* M2-N */
>>
>> So before I can commit I need a MAINTAINERS patch and DT documentation.
>>
>> I also noticed that the Kconfig patch says that the driver module is called jpu,
>> but I think that should be rcar_jpu. If you can fix that?
>>
>> I would also like to have the v4l2-compliance output for both encoder and decoder.
>>
>> Try 'v4l2-compliance -s' for the encoder. This won't work for the decoder (v4l2-compliance
>> can't generate JPEG images), so just run 'v4l2-compliance' for that one.
>>
>> Regards,
>>
>>         Hans
> 
> 
> 

