Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:60880 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753550AbbCIOCV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 10:02:21 -0400
Message-ID: <54FDA7E5.3010004@xs4all.nl>
Date: Mon, 09 Mar 2015 15:02:13 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Florian Echtler <floe@butterbrot.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-input <linux-input@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3][RFC] add raw video stream support for Samsung SUR40
References: <1423063842-6902-1-git-send-email-floe@butterbrot.org> <54DB4295.1080307@butterbrot.org> <54E1D71C.2000003@xs4all.nl> <54E7AB1E.3000401@butterbrot.org> <54E85C48.6070907@xs4all.nl> <54F98E51.8040204@butterbrot.org> <54F993ED.2060701@xs4all.nl> <54FB5715.2090103@butterbrot.org> <54FB6636.6050308@xs4all.nl> <54FD6CAD.9030600@butterbrot.org> <54FD713D.5050401@xs4all.nl> <54FDA3EA.9080006@butterbrot.org>
In-Reply-To: <54FDA3EA.9080006@butterbrot.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/09/2015 02:45 PM, Florian Echtler wrote:
> On 09.03.2015 11:09, Hans Verkuil wrote:
>> Hi Florian,
>>
>> OK, the cause of this failure is this message:
>>
>> Mar  9 10:39:08 sur40 kernel: [ 1093.200960] sur40 2-1:1.0: error in usb_sg_wait
>>
>> So you need to print the error message here (sgr.status) so that I can see what
>> it is.
> I've amended the dev_debug call, the error returned from usb_sg_wait is
> also -22 (EINVAL).
> 
>> The error almost certainly comes from usb_submit_urb(). That function does some
>> checks on the sgl:
>>
>> I wonder it the code gets there. Perhaps a printk just before the return -EINVAL
>> might help here (also print the 'max' value).
>>
>> So you will have to debug a bit here, trying to figure out which test in the usb
>> code causes the usb_sg_wait error.
> I'll do my best to track this down. Do you think this is an error in my
> code, one in the USB subsystem, or some combination of both?

If the USB core indeed requires scatter-gather segments of specific lengths
(modulo max), then that explains the problems.

So as suggested try to see if the usb core bails out in that check and what the
'max' value is. It looks like only XHCI allows SG segments of any size, so I really
suspect that's the problem. But I also need to know the 'max' value to fully
understand the implications.

Regards,

	Hans
