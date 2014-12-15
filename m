Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:51136 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768AbaLOQCF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 11:02:05 -0500
Message-ID: <548F05EF.8080700@xs4all.nl>
Date: Mon, 15 Dec 2014 17:01:51 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Florian Echtler <floe@butterbrot.org>, linux-media@vger.kernel.org
Subject: Re: [RFC] video support for Samsung SUR40
References: <548F029C.20907@butterbrot.org>
In-Reply-To: <548F029C.20907@butterbrot.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Florian,

On 12/15/2014 04:47 PM, Florian Echtler wrote:
> Hi everyone,
> 
> I'm currently working on adding raw sensor video support for the Samsung
> SUR40 touchscreen. I've finally found some useful documentation about
> videobuf2, and added the required functions to the driver (without
> actually delivering data so far, I just wanted to try and stream empty
> frames for starters).
> 
> However, I'm running into an issue I have a hard time understanding. In
> particular, as soon as I load the kernel module, I'm getting a kernel
> oops (NULL pointer dereference) in line 354 or 355 of the attached
> source code. The reason is probably that the previous check (in line
> 350) doesn't abort - even though I didn't actually provide a buffer, so
> the list_head should be empty. As no user space program has actually
> opened the video device yet, there shouldn't be any buffers queued,
> right? (AFAICT the list is initialized properly in line 490).
> 
> I'd be quite grateful if somebody with more experience can look over the
> code and tell me what mistakes I made :-)

Why on earth is sur40_poll doing anything with video buffers? That's
all handled by vb2. As far as I can tell you can just delete everything
from '// deal with video data here' until the end of the poll function.

The probably cause of the crash here is that the input device node is
created before the 'INIT_LIST_HEAD(&sur40->buf_list);' call, and since
udevd (I think) opens new devices immediately after they are created
it is likely that sur40_poll is called before buf_list is initialized.

But, as I said, that code doesn't belong there at all, so just remove it.

Regards,

	Hans

> 
> Thanks & best regards, Florian
> 
> P.S. The SUR40 is a quite peculiar touchscreen device which does
> on-board image processing to provide touch data, but also allows to
> retrieve the raw video image. Unfortunately, it's a single USB device
> with two endpoints for the different data types, so everything (input &
> video) needs to be squeezed into one driver.
> 

