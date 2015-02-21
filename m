Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:50867 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750770AbbBUKW1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2015 05:22:27 -0500
Message-ID: <54E85C48.6070907@xs4all.nl>
Date: Sat, 21 Feb 2015 11:22:00 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Florian Echtler <floe@butterbrot.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: laurent.pinchart@ideasonboard.com, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v3][RFC] add raw video stream support for Samsung SUR40
References: <1423063842-6902-1-git-send-email-floe@butterbrot.org> <54DB4295.1080307@butterbrot.org> <54E1D71C.2000003@xs4all.nl> <54E7AB1E.3000401@butterbrot.org>
In-Reply-To: <54E7AB1E.3000401@butterbrot.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/20/2015 10:46 PM, Florian Echtler wrote:
> On 16.02.2015 12:40, Hans Verkuil wrote:
>> On 02/11/2015 12:52 PM, Florian Echtler wrote:
>>> does anyone have any suggestions why USERPTR still fails with dma-sg?
>>>
>>> Could I just disable the corresponding capability for the moment so that
>>> the patch could perhaps be merged, and investigate this separately?
>>
>> I prefer to dig into this a little bit more, as I don't really understand
>> it. Set the videobuf2-core debug level to 1 and see what the warnings are.
>>
>> Since 'buf.qbuf' fails in v4l2-compliance, it's something in the VIDIOC_QBUF
>> sequence that returns an error, so you need to pinpoint that.
> OK, I don't currently have access to the hardware, but I will try this
> as soon as possible.
> 
>> If push comes to shove I can also merge the patch without USERPTR support,
>> but I really prefer not to do that.
> How long until the next merge window closes?

Probably about 6 weeks from now, but is good to err on the safe side and make
a decision in 4 weeks.

Regards,

	Hans

