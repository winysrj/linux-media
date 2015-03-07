Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:36513 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752633AbbCGU5u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Mar 2015 15:57:50 -0500
Message-ID: <54FB6636.6050308@xs4all.nl>
Date: Sat, 07 Mar 2015 21:57:26 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Florian Echtler <floe@butterbrot.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-input <linux-input@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3][RFC] add raw video stream support for Samsung SUR40
References: <1423063842-6902-1-git-send-email-floe@butterbrot.org> <54DB4295.1080307@butterbrot.org> <54E1D71C.2000003@xs4all.nl> <54E7AB1E.3000401@butterbrot.org> <54E85C48.6070907@xs4all.nl> <54F98E51.8040204@butterbrot.org> <54F993ED.2060701@xs4all.nl> <54FB5715.2090103@butterbrot.org>
In-Reply-To: <54FB5715.2090103@butterbrot.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/07/2015 08:52 PM, Florian Echtler wrote:
> On 06.03.2015 12:47, Hans Verkuil wrote:
>> On 03/06/2015 12:24 PM, Florian Echtler wrote:
>>> On 21.02.2015 11:22, Hans Verkuil wrote:
>>>> On 02/20/2015 10:46 PM, Florian Echtler wrote:
>>>>> On 16.02.2015 12:40, Hans Verkuil wrote:
>>>>>> I prefer to dig into this a little bit more, as I don't really understand
>>>>>> it. Set the videobuf2-core debug level to 1 and see what the warnings are.
>>>>>> Since 'buf.qbuf' fails in v4l2-compliance, it's something in the VIDIOC_QBUF
>>>>>> sequence that returns an error, so you need to pinpoint that.
>>>>> OK, I don't currently have access to the hardware, but I will try this
>>>>> as soon as possible.
>>> Finally got a chance to try again with videobuf2-core.debug=1. Same
>>> result on 3.19 and 4.0-rc2, after running v4l2-compliance -s from
>>> today's master (full log attached, but important part is below):
>>>
>>> I'm not familiar enough with the inner workings of videobuf2 to make any
>>> sense of it, any new insights from you guys?
>>
>> Can you do:
>> echo 2 >/sys/class/video4linux/videoX/dev_debug
>> and run again?
>> That way I see the vb2 debug messages in related to the issued ioctls.
> See attachment, this is the full syslog output from one v4l2-compliance
> run on 4.0-rc2, with video0/dev_debug=2 and core.debug=1.
> 
>> And if you can also supply the v4l2-compliance -s output, just for
>> reference?
> Also attached for completeness, the important part is:
> 
> Streaming ioctls:
> 	test read/write: OK
> 	test MMAP: OK
> 		fail: v4l2-test-buffers.cpp(280): !g_timestamp().tv_sec &&
> !g_timestamp().tv_usec

Hmm, I don't think I saw this before.

Anyway, looking at the code I think I see at least one thing that is dubious
and that needs to be changed:

In sur40_process_video() you check for buffers at the start:

	if (list_empty(&sur40->buf_list))
		return;

Replace this with:

	if (!vb2_start_streaming_called(&sur40->queue))
		return;

This will wait until start_streaming was called before it starts processing
video (and start_streaming is only called if at least 3 buffers have been
queued).

Right now the first buffer can be returned without STREAMON actually having
been called. That's certainly wrong.

Whether that is the cause of this bug I do not know, but fix this first.

If this doesn't solve it, then please do another run but this time use

echo 10 >/sys/class/video4linux/videoX/dev_debug

so I see the (D)QBUF ioctls as well. Otherwise use the same procedure as
before.

Thanks!

	Hans
