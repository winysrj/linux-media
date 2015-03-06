Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:58915 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752651AbbCFLsT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Mar 2015 06:48:19 -0500
Message-ID: <54F993ED.2060701@xs4all.nl>
Date: Fri, 06 Mar 2015 12:47:57 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Florian Echtler <floe@butterbrot.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: laurent.pinchart@ideasonboard.com, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v3][RFC] add raw video stream support for Samsung SUR40
References: <1423063842-6902-1-git-send-email-floe@butterbrot.org> <54DB4295.1080307@butterbrot.org> <54E1D71C.2000003@xs4all.nl> <54E7AB1E.3000401@butterbrot.org> <54E85C48.6070907@xs4all.nl> <54F98E51.8040204@butterbrot.org>
In-Reply-To: <54F98E51.8040204@butterbrot.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/06/2015 12:24 PM, Florian Echtler wrote:
> On 21.02.2015 11:22, Hans Verkuil wrote:
>> On 02/20/2015 10:46 PM, Florian Echtler wrote:
>>> On 16.02.2015 12:40, Hans Verkuil wrote:
>>>> On 02/11/2015 12:52 PM, Florian Echtler wrote:
>>>> I prefer to dig into this a little bit more, as I don't really understand
>>>> it. Set the videobuf2-core debug level to 1 and see what the warnings are.
>>>> Since 'buf.qbuf' fails in v4l2-compliance, it's something in the VIDIOC_QBUF
>>>> sequence that returns an error, so you need to pinpoint that.
>>> OK, I don't currently have access to the hardware, but I will try this
>>> as soon as possible.
> Finally got a chance to try again with videobuf2-core.debug=1. Same
> result on 3.19 and 4.0-rc2, after running v4l2-compliance -s from
> today's master (full log attached, but important part is below):
> 
> [11470.040067] vb2: __vb2_queue_alloc: allocated 3 buffers, 1 plane(s) each
> [11470.040136] vb2: vb2_mmap: queue is not currently set up for mmap
> [11470.040158] vb2: __qbuf_userptr: failed acquiring userspace memory
> for plane 0
> [11470.040163] vb2: __buf_prepare: buffer preparation failed: -22
> [11470.040172] vb2: __qbuf_userptr: failed acquiring userspace memory
> for plane 0
> [11470.040175] vb2: __buf_prepare: buffer preparation failed: -22
> [11470.040651] vb2: vb2_internal_qbuf: qbuf of buffer 0 succeeded
> [11470.040663] vb2: vb2_mmap: queue is not currently set up for mmap
> [11470.040676] vb2: __qbuf_userptr: failed acquiring userspace memory
> for plane 0
> [11470.040680] vb2: __buf_prepare: buffer preparation failed: -22
> [11470.040687] vb2: __qbuf_userptr: failed acquiring userspace memory
> for plane 0
> [11470.040690] vb2: __buf_prepare: buffer preparation failed: -22
> [11470.041167] vb2: vb2_internal_qbuf: qbuf of buffer 1 succeeded
> [11470.041178] vb2: vb2_mmap: queue is not currently set up for mmap
> [11470.041193] vb2: __qbuf_userptr: failed acquiring userspace memory
> for plane 0
> [11470.041196] vb2: __buf_prepare: buffer preparation failed: -22
> [11470.041203] vb2: __qbuf_userptr: failed acquiring userspace memory
> for plane 0
> [11470.041207] vb2: __buf_prepare: buffer preparation failed: -22
> [11470.041683] vb2: vb2_internal_qbuf: qbuf of buffer 2 succeeded
> [11470.051195] sur40 2-1:1.0: error in usb_sg_wait
> [11470.051250] vb2: vb2_internal_dqbuf: dqbuf of buffer 0, with state 0
> 
> I'm not familiar enough with the inner workings of videobuf2 to make any
> sense of it, any new insights from you guys?

Can you do:

echo 2 >/sys/class/video4linux/videoX/dev_debug

and run again?

That way I see the vb2 debug messages in related to the issued ioctls.

And if you can also supply the v4l2-compliance -s output, just for
reference?

Thanks,

	Hans
