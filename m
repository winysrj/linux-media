Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:12510 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab2GWKXb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 06:23:31 -0400
Received: from eusync3.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M7L00E5KZJXR130@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jul 2012 11:23:58 +0100 (BST)
Received: from [106.116.147.32] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M7L00F2PZJ45M90@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jul 2012 11:23:28 +0100 (BST)
Message-id: <500D2595.7060009@samsung.com>
Date: Mon, 23 Jul 2012 12:21:09 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: javier Martin <javier.martin@vista-silicon.com>,
	linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, s.hauer@pengutronix.de,
	p.zabel@pengutronix.de
Subject: Re: [PATCH v6] media: coda: Add driver for Coda video codec.
References: <1342782515-24992-1-git-send-email-javier.martin@vista-silicon.com>
 <CACKLOr312a=KTrm9=N48=SHN5Z=0yTPceopG9MJBu8he_3yjrw@mail.gmail.com>
 <CACKLOr1RF2PLECz7Y9kFRnFqnCMfHQOcCTT0TgdFvNyFVynCpg@mail.gmail.com>
 <201207231214.15835.hverkuil@xs4all.nl>
In-reply-to: <201207231214.15835.hverkuil@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/23/2012 12:14 PM, Hans Verkuil wrote:
> On Mon July 23 2012 12:00:30 javier Martin wrote:
>> On 23 July 2012 11:45, javier Martin <javier.martin@vista-silicon.com> wrote:
>>> Sorry, I had a problem with my buildroot environment. This is the
>>> v4l2-compliance output with the most recent version:
>>>
>>> # v4l2-compliance -d /dev/video2
>>> Driver Info:
>>>         Driver name   : coda
>>>         Card type     : coda
>>>         Bus info      : coda
>>>         Driver version: 0.0.0
>>>         Capabilities  : 0x84000003
>>>                 Video Capture
>>>                 Video Output
>>>                 Streaming
>>>                 Device Capabilities
>>>         Device Caps   : 0x04000003
>>>                 Video Capture
>>>                 Video Output
>>>                 Streaming
>>>
>>> Compliance test for device /dev/video2 (not using libv4l2):
>>>
>>> Required ioctls:
>>>                 fail: v4l2-compliance.cpp(270): (vcap.version >> 16) < 3
>>>         test VIDIOC_QUERYCAP: FAIL
>>>
>>
>> This was related to a memset() that I did in QUERYCAP.
>>
>> Now the output is cleaner.
> 
> Ah, much better.
> 
>>
>> # v4l2-compliance -d /dev/video2
>> Driver Info:
>>         Driver name   : coda
>>         Card type     : coda
>>         Bus info      : coda
>>         Driver version: 3.5.0
>>         Capabilities  : 0x84000003
>>                 Video Capture
>>                 Video Output
>>                 Streaming
>>                 Device Capabilities
>>         Device Caps   : 0x04000003
>>                 Video Capture
>>                 Video Output
>>                 Streaming
>>
>> Compliance test for device /dev/video2 (not using libv4l2):
>>
>> Required ioctls:
>>         test VIDIOC_QUERYCAP: OK
>>
>> Allow for multiple opens:
>>         test second video open: OK
>>         test VIDIOC_QUERYCAP: OK
>>         test VIDIOC_G/S_PRIORITY: OK
>>
>> Debug ioctls:
>>         test VIDIOC_DBG_G_CHIP_IDENT: Not Supported
>>         test VIDIOC_DBG_G/S_REGISTER: Not Supported
>>         test VIDIOC_LOG_STATUS: Not Supported
>>
>> Input ioctls:
>>         test VIDIOC_G/S_TUNER: Not Supported
>>         test VIDIOC_G/S_FREQUENCY: Not Supported
>>         test VIDIOC_S_HW_FREQ_SEEK: Not Supported
>>         test VIDIOC_ENUMAUDIO: Not Supported
>>         test VIDIOC_G/S/ENUMINPUT: Not Supported
>>         test VIDIOC_G/S_AUDIO: Not Supported
>>         Inputs: 0 Audio Inputs: 0 Tuners: 0
>>
>> Output ioctls:
>>         test VIDIOC_G/S_MODULATOR: Not Supported
>>         test VIDIOC_G/S_FREQUENCY: Not Supported
>>         test VIDIOC_ENUMAUDOUT: Not Supported
>>         test VIDIOC_G/S/ENUMOUTPUT: Not Supported
>>         test VIDIOC_G/S_AUDOUT: Not Supported
>>         Outputs: 0 Audio Outputs: 0 Modulators: 0
>>
>> Control ioctls:
>>         test VIDIOC_QUERYCTRL/MENU: OK
>>         test VIDIOC_G/S_CTRL: OK
>>                 fail: v4l2-test-controls.cpp(565): try_ext_ctrls did
>> not check the read-only flag
> 
> Hmm, what's the reason for this one I wonder. Can you run with '-v2' and see
> for which control this fails?

This might be related to calling video_register_device() with null
ctrl_handler or not setting V4L2_FL_USES_V4L2_FH flags at struct video_device.

--

Regards,
Sylwester



