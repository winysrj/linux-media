Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33774 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726038AbeK1G1Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Nov 2018 01:27:25 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wARJOYTb065073
        for <linux-media@vger.kernel.org>; Tue, 27 Nov 2018 14:28:28 -0500
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2p18fuhufp-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-media@vger.kernel.org>; Tue, 27 Nov 2018 14:28:28 -0500
Received: from localhost
        by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-media@vger.kernel.org> from <eajames@linux.vnet.ibm.com>;
        Tue, 27 Nov 2018 19:28:27 -0000
Subject: Re: [PATCH v5 0/2] media: platform: Add Aspeed Video Engine Driver
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Eddie James <eajames@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        robh+dt@kernel.org, andrew@aj.id.au, linux-aspeed@lists.ozlabs.org,
        devicetree@vger.kernel.org, mark.rutland@arm.com
References: <1542056431-18146-1-git-send-email-eajames@linux.ibm.com>
 <9b21fb44-2248-7921-2205-4a3f43d22d4b@xs4all.nl>
From: Eddie James <eajames@linux.vnet.ibm.com>
Date: Tue, 27 Nov 2018 13:28:15 -0600
MIME-Version: 1.0
In-Reply-To: <9b21fb44-2248-7921-2205-4a3f43d22d4b@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Message-Id: <b3474816-832c-4553-f625-cad97d9bbe87@linux.vnet.ibm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 11/15/2018 03:20 AM, Hans Verkuil wrote:
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

Thanks, I have made some changes for v6.

>
>> v4l-utils HEAD dd3ff81f58c4e1e6f33765dc61ad33c48ae6bb07
>>
>> v4l2-compliance SHA: not available, 32 bits
> <snip>
>
>> Control ioctls (Input 0):
>> 	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>> 	test VIDIOC_QUERYCTRL: OK
>> 	test VIDIOC_G/S_CTRL: OK
>> 	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>> 		fail: v4l2-test-controls.cpp(823): failed to find event for control 'Chroma Subsampling'
> That's weird. It's not clear to me why this fails.
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
> When developing new drivers you should use the master branch of
> https://git.linuxtv.org/media_tree.git/

Our 4.18 tree has quite a few chip-specific patches that I need that are 
not upstreamed yet, so it's not possible for me to use that.

Thanks,
Eddie

>
> The v4l-utils repo is kept in sync with the latest code from that master branch.
>
> Regards,
>
> 	Hans
>
>> Changes since v4:
>>   - Set real min and max resolution in enum_dv_timings
>>   - Add check for vb2_is_busy before settings the timings
>>   - Set max frame rate to the actual max rather than max + 1
>>   - Correct the input status to 0.
>>   - Rework resolution change to only set the relevant h/w regs during startup or
>>     when set_timings is called.
>>
>> Changes since v3:
>>   - Switch update reg function to use u32 clear rather than unsigned long mask
>>   - Add timing information from host VGA signal
>>   - Fix binding documentation mispelling
>>   - Fix upper case hex values
>>   - Add wait_prepare and wait_finish
>>   - Set buffer state to queued (rather than error) if streaming fails to start
>>   - Switch engine busy print statement to error
>>   - Removed a couple unecessary type assignments in v4l2 ioctls
>>   - Added query_dv_timings, fixed get_dv_timings
>>   - Corrected source change event to fire if and only if size actually changes
>>   - Locked open and release
>>
>> Changes since v2:
>>   - Switch to streaming interface. This involved a lot of changes.
>>   - Rework memory allocation due to using videobuf2 buffers, but also only
>>     allocate the necessary size of source buffer rather than the max size
>>
>> Changes since v1:
>>   - Removed le32_to_cpu calls for JPEG header data
>>   - Reworked v4l2 ioctls to be compliant.
>>   - Added JPEG controls
>>   - Updated devicetree docs according to Rob's suggestions.
>>   - Added myself to MAINTAINERS
>>
>> Eddie James (2):
>>    dt-bindings: media: Add Aspeed Video Engine binding documentation
>>    media: platform: Add Aspeed Video Engine driver
>>
>>   .../devicetree/bindings/media/aspeed-video.txt     |   26 +
>>   MAINTAINERS                                        |    8 +
>>   drivers/media/platform/Kconfig                     |    9 +
>>   drivers/media/platform/Makefile                    |    1 +
>>   drivers/media/platform/aspeed-video.c              | 1711 ++++++++++++++++++++
>>   5 files changed, 1755 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/media/aspeed-video.txt
>>   create mode 100644 drivers/media/platform/aspeed-video.c
>>
