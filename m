Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:60832 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752774AbbCOQ0s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 12:26:48 -0400
Message-ID: <5505B2C0.6090309@xs4all.nl>
Date: Sun, 15 Mar 2015 17:26:40 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Florian Echtler <floe@butterbrot.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-input <linux-input@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3][RFC] add raw video stream support for Samsung SUR40
References: <1423063842-6902-1-git-send-email-floe@butterbrot.org> <54DB4295.1080307@butterbrot.org> <54E1D71C.2000003@xs4all.nl> <54E7AB1E.3000401@butterbrot.org> <54E85C48.6070907@xs4all.nl> <54F98E51.8040204@butterbrot.org> <54F993ED.2060701@xs4all.nl> <54FB5715.2090103@butterbrot.org> <54FB6636.6050308@xs4all.nl> <54FD6CAD.9030600@butterbrot.org> <54FD713D.5050401@xs4all.nl> <54FDA3EA.9080006@butterbrot.org> <54FDA7E5.3010004@xs4all.nl> <5501EB0B.5020806@butterbrot.org>
In-Reply-To: <5501EB0B.5020806@butterbrot.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/12/2015 08:37 PM, Florian Echtler wrote:
> Hello Hans,
> 
> On 09.03.2015 15:02, Hans Verkuil wrote:
>> On 03/09/2015 02:45 PM, Florian Echtler wrote:
>>> On 09.03.2015 11:09, Hans Verkuil wrote:
>>>> The error almost certainly comes from usb_submit_urb(). That function does some
>>>> checks on the sgl:
>>>>
>>>> I wonder it the code gets there. Perhaps a printk just before the return -EINVAL
>>>> might help here (also print the 'max' value).
>>>>
>>>> So you will have to debug a bit here, trying to figure out which test in the usb
>>>> code causes the usb_sg_wait error.
>>> I'll do my best to track this down. Do you think this is an error in my
>>> code, one in the USB subsystem, or some combination of both?
>>
>> If the USB core indeed requires scatter-gather segments of specific lengths
>> (modulo max), then that explains the problems.
>> So as suggested try to see if the usb core bails out in that check and what the
>> 'max' value is. It looks like only XHCI allows SG segments of any size, so I really
>> suspect that's the problem. But I also need to know the 'max' value to fully
>> understand the implications.
> Finally managed to confirm your suspicions on a kernel with a patched
> dev_err call at the location you mentioned:
> 
> Mar 12 20:33:51 sur40 kernel: [ 1159.509580]  (null): urb 0 length
> mismatch: length 4080, max 512
> Mar 12 20:33:51 sur40 kernel: [ 1159.509592] sur40 2-1:1.0: error -22 in
> usb_sg_wait
> 
> So the SG segments are expected in multiples of 512 bytes. I assume this
> is not something I can fix from within my driver?

No, you can't. I would use dma-sg, but disable the USERPTR support.
Also comment why USERPTR support is disabled.

This was interesting :-)

Regards,

	Hans
