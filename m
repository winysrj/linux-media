Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:46816 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727454AbeKPVYH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Nov 2018 16:24:07 -0500
Subject: Re: [PATCH v5 0/2] media: platform: Add Aspeed Video Engine Driver
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Eddie James <eajames@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        robh+dt@kernel.org, andrew@aj.id.au, linux-aspeed@lists.ozlabs.org,
        devicetree@vger.kernel.org, mark.rutland@arm.com,
        Eddie James <eajames@linux.vnet.ibm.com>
References: <1542056431-18146-1-git-send-email-eajames@linux.ibm.com>
 <9b21fb44-2248-7921-2205-4a3f43d22d4b@xs4all.nl>
Message-ID: <e4244292-e051-7f9e-ae11-6d995700aa39@xs4all.nl>
Date: Fri, 16 Nov 2018 12:12:07 +0100
MIME-Version: 1.0
In-Reply-To: <9b21fb44-2248-7921-2205-4a3f43d22d4b@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/15/2018 10:20 AM, Hans Verkuil wrote:
> On 11/12/2018 10:00 PM, Eddie James wrote:
>> From: Eddie James <eajames@linux.vnet.ibm.com>
>>
>> The Video Engine (VE) embedded in the Aspeed AST2400 and AST2500 SOCs
>> can capture and compress video data from digital or analog sources. With
>> the Aspeed chip acting as a service processor, the Video Engine can
>> capture the host processor graphics output.
>>
>> This series adds a V4L2 driver for the VE, providing the usual V4L2 streaming
>> interface by way of videobuf2. Each frame, the driver triggers the hardware to
>> capture the host graphics output and compress it to JPEG format.
> 
> I reviewed the driver, and there is still confusion about active timings and
> detected timings. You are really close, but it is still not right.
> 
> The timings returned by G_DV_TIMINGS should never change, unless by calling
> S_DV_TIMINGS. The format returned by G_FMT should never change, unless by
> calling S_DV_TIMINGS (which implicitly changes the format) or S_FMT.
> 
> Timings changes from the video or calling QUERY_DV_TIMINGS should have NO
> effect on the timings/format returned by G_DV_TIMINGS/G_FMT.
> 
> Obviously, if the video timings change, then streaming will halt and an event
> is issued so userspace can take action.
> 
>>
>> v4l-utils HEAD dd3ff81f58c4e1e6f33765dc61ad33c48ae6bb07
>>
>> v4l2-compliance SHA: not available, 32 bits
> 
> <snip>
> 
>> Control ioctls (Input 0):
>> 	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>> 	test VIDIOC_QUERYCTRL: OK
>> 	test VIDIOC_G/S_CTRL: OK
>> 	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>> 		fail: v4l2-test-controls.cpp(823): failed to find event for control 'Chroma Subsampling'
> 
> That's weird. It's not clear to me why this fails.

Ah, this is caused by a bug in our tree. It's fixed by this patch:

https://patchwork.linuxtv.org/patch/52790/

Regards,

	Hans

> 
>> 	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
>> 	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>> 	Standard Controls: 3 Private Controls: 0
>>
>> Format ioctls (Input 0):
>> 	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>> 	test VIDIOC_G/S_PARM: OK
>> 	test VIDIOC_G_FBUF: OK (Not Supported)
>> 	test VIDIOC_G_FMT: OK
>> 	test VIDIOC_TRY_FMT: OK
>> 	test VIDIOC_S_FMT: OK
>> 	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>> 	test Cropping: OK (Not Supported)
>> 	test Composing: OK (Not Supported)
>> 	test Scaling: OK (Not Supported)
>>
>> Codec ioctls (Input 0):
>> 	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>> 	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>> 	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
>>
>> Buffer ioctls (Input 0):
>> 		fail: v4l2-test-buffers.cpp(422): dmabuf_valid ^ !!(caps & V4L2_BUF_CAP_SUPPORTS_DMABUF)
> 
> I updated v4l2-compliance, as this test was a bit too strict.
> 
>> 	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL
>> 	test VIDIOC_EXPBUF: OK (Not Supported)
>>
>> Test input 0:
>>
>> Streaming ioctls:
>> 	test read/write: OK
>> 	test blocking wait: OK
>> 	test MMAP: OK                                     
>> 	test USERPTR: OK (Not Supported)
>> 		fail: v4l2-test-buffers.cpp(1102): exp_q.reqbufs(expbuf_node, q.g_buffers())
>> 		fail: v4l2-test-buffers.cpp(1192): setupDmaBuf(expbuf_node, node, q, exp_q)
> 
> You need to add:
> 
> 	.vidioc_expbuf = vb2_ioctl_expbuf,
> 
> to aspeed_video_ioctl_ops.
> 
>> 	test DMABUF: FAIL
>>
>> Total: 48, Succeeded: 45, Failed: 3, Warnings: 0
>>
>> The apparent rate of change to the v4l2/vb2 API makes it difficult to pass
>> these tests. None of the failing tests even ran last time I submitted my
>> series. And V4L2_BUF_CAP_SUPPORTS_DMABUF is undefined in 4.19.
> 
> When developing new drivers you should use the master branch of
> https://git.linuxtv.org/media_tree.git/
> 
> The v4l-utils repo is kept in sync with the latest code from that master branch.
> 
> Regards,
> 
> 	Hans
> 
>>
>> Changes since v4:
>>  - Set real min and max resolution in enum_dv_timings
>>  - Add check for vb2_is_busy before settings the timings
>>  - Set max frame rate to the actual max rather than max + 1
>>  - Correct the input status to 0.
>>  - Rework resolution change to only set the relevant h/w regs during startup or
>>    when set_timings is called.
>>
>> Changes since v3:
>>  - Switch update reg function to use u32 clear rather than unsigned long mask
>>  - Add timing information from host VGA signal
>>  - Fix binding documentation mispelling
>>  - Fix upper case hex values
>>  - Add wait_prepare and wait_finish
>>  - Set buffer state to queued (rather than error) if streaming fails to start
>>  - Switch engine busy print statement to error
>>  - Removed a couple unecessary type assignments in v4l2 ioctls
>>  - Added query_dv_timings, fixed get_dv_timings
>>  - Corrected source change event to fire if and only if size actually changes
>>  - Locked open and release
>>
>> Changes since v2:
>>  - Switch to streaming interface. This involved a lot of changes.
>>  - Rework memory allocation due to using videobuf2 buffers, but also only
>>    allocate the necessary size of source buffer rather than the max size
>>
>> Changes since v1:
>>  - Removed le32_to_cpu calls for JPEG header data
>>  - Reworked v4l2 ioctls to be compliant.
>>  - Added JPEG controls
>>  - Updated devicetree docs according to Rob's suggestions.
>>  - Added myself to MAINTAINERS
>>
>> Eddie James (2):
>>   dt-bindings: media: Add Aspeed Video Engine binding documentation
>>   media: platform: Add Aspeed Video Engine driver
>>
>>  .../devicetree/bindings/media/aspeed-video.txt     |   26 +
>>  MAINTAINERS                                        |    8 +
>>  drivers/media/platform/Kconfig                     |    9 +
>>  drivers/media/platform/Makefile                    |    1 +
>>  drivers/media/platform/aspeed-video.c              | 1711 ++++++++++++++++++++
>>  5 files changed, 1755 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/aspeed-video.txt
>>  create mode 100644 drivers/media/platform/aspeed-video.c
>>
> 
