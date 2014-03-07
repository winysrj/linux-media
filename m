Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:40858 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbaCGNXF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Mar 2014 08:23:05 -0500
Message-ID: <5319C813.5030508@ti.com>
Date: Fri, 7 Mar 2014 18:52:27 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <k.debski@samsung.com>, <linux-media@vger.kernel.org>,
	<linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2 7/7] v4l: ti-vpe: Add selection API in VPE driver
References: <1393832008-22174-1-git-send-email-archit@ti.com> <1393922965-15967-1-git-send-email-archit@ti.com> <1393922965-15967-8-git-send-email-archit@ti.com> <53159F7D.8020707@xs4all.nl> <5315B822.7010005@ti.com> <5315BA83.5080500@xs4all.nl> <5319B26B.8050900@ti.com> <5319C2A7.6090805@xs4all.nl>
In-Reply-To: <5319C2A7.6090805@xs4all.nl>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Friday 07 March 2014 06:29 PM, Hans Verkuil wrote:
>>
>> Do you think I can go ahead with posting the v3 patch set for 3.15, and
>> work on fixing the compliance issue for the -rc fixes?
>
> It's fine to upstream this in staging, but while not all compliance errors
> are fixed it can't go to drivers/media. I'm tightening the screws on that
> since v4l2-compliance is getting to be such a powerful tool for ensuring
> the driver complies.
>

But the vpe driver is already in drivers/media. How do I push these 
patches if the vpe drivers is not in staging?

<snip>

>> Multiplanar: TRY_FMT(G_FMT) != G_FMT
>>           test VIDIOC_TRY_FMT: FAIL
>>                   warn: v4l2-test-formats.cpp(834): S_FMT cannot handle
>> an invalid pixelformat.
>>                   warn: v4l2-test-formats.cpp(835): This may or may not
>> be a problem. For more information see:
>>                   warn: v4l2-test-formats.cpp(836):
>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
>>                   fail: v4l2-test-formats.cpp(420): pix_mp.reserved not
>> zeroed
>
> This is easy enough to fix.
>
>>                   fail: v4l2-test-formats.cpp(851): Video Capture
>> Multiplanar is valid, but no S_FMT was implemented
>
> For the FMT things: run with -T: that gives nice traces. You can also
> set the debug flag: echo 2 >/sys/class/video4linux/video0/debug to see all
> ioctls in more detail.

Thanks for the tip, will try this.

>
>>           test VIDIOC_S_FMT: FAIL
>>           test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>>
>> Codec ioctls:
>>           test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>>           test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>>           test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
>>
>> Buffer ioctls:
>>                   info: test buftype Video Capture Multiplanar
>>                   warn: v4l2-test-buffers.cpp(403): VIDIOC_CREATE_BUFS
>> not supported
>>                   info: test buftype Video Output Multiplanar
>>                   warn: v4l2-test-buffers.cpp(403): VIDIOC_CREATE_BUFS
>> not supported
>>           test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>>           test VIDIOC_EXPBUF: OK (Not Supported)
>>           test read/write: OK (Not Supported)
>>               Video Capture Multiplanar (polling):
>>                   Buffer: 0 Sequence: 0 Field: Top Timestamp: 113.178208s
>>                   fail: v4l2-test-buffers.cpp(222): buf.field !=
>> cur_fmt.fmt.pix.field
>
> Definitely needs to be fixed, you probably just don't set the field at all.

The VPE output is always progressive. But yes, I should still set the 
field parameter to something.

Thanks,
Archit

