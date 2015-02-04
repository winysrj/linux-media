Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:49109 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933347AbbBDKWW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Feb 2015 05:22:22 -0500
Message-ID: <54D1F2CA.9020201@xs4all.nl>
Date: Wed, 04 Feb 2015 11:22:02 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Florian Echtler <floe@butterbrot.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] add raw video support for Samsung SUR40 touchscreen
References: <1420626920-9357-1-git-send-email-floe@butterbrot.org> <64652239.MTTlcOgNK2@avalon> <54BE5204.3020600@xs4all.nl> <6025823.veVKIskIW2@avalon> <54BFA989.4090405@butterbrot.org> <54BFA9D6.1040201@xs4all.nl> <54CAA786.2040908@butterbrot.org> <54D13383.7010603@butterbrot.org> <54D1D37C.20701@xs4all.nl> <54D1EF91.8070805@butterbrot.org>
In-Reply-To: <54D1EF91.8070805@butterbrot.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/04/15 11:08, Florian Echtler wrote:
> Hello Hans,
> 
> On 04.02.2015 09:08, Hans Verkuil wrote:
>> I remain very skeptical about the use of dma-contig (or dma-sg for that
>> matter). Have you tried using vmalloc and check if the USB core isn't
>> automatically using DMA transfers for that?
>>
>> Basically I would like to see proof that vmalloc is not an option before
>> allowing dma-contig (or dma-sg if you can figure out why that isn't
>> working).
>>
>> You can also make a version with vmalloc and I'll merge that, and then
>> you can look more into the DMA issues. That way the driver is merged,
>> even if it is perhaps not yet optimal, and you can address that part later.
> OK, that sounds sensible, I will try that route. When using
> videobuf2-vmalloc, what do I pass back for alloc_ctxs in queue_setup?

vmalloc doesn't need those, so you can just drop any alloc_ctx related code.

Regards,

	Hans

