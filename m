Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58864 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751653AbeACK5J (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Jan 2018 05:57:09 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Edgar Thier <info@edgarthier.net>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] uvcvideo: Apply flags from device to actual properties
Date: Wed, 03 Jan 2018 12:57:30 +0200
Message-ID: <24839161.SxonQjYASC@avalon>
In-Reply-To: <c95024db-c6f8-f346-07f7-d99acf05cd00@edgarthier.net>
References: <ca483e75-4519-2bc3-eb11-db647fc60860@edgarthier.net> <4142585.lFnxXeD9HU@avalon> <c95024db-c6f8-f346-07f7-d99acf05cd00@edgarthier.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Edgar,

On Wednesday, 3 January 2018 08:07:44 EET Edgar Thier wrote:
> Hi Emmanuel,

If we pick names randomly I'll call you David :-)

> >>> +	int flags = 0;
> >>> +
> >>> +	data = kmalloc(2, GFP_KERNEL);
> > 
> > Isn't 1 byte enough ?
> 
> To quote from Kieran further up this thread:
> 
> >> kmalloc seems a bit of an overhead for 2 bytes (only one of which is
> >> used). Can this use local stack storage?
> >> 
> >> (Laurent, looks like you originally wrote the code that did that, was
> >> there a reason for the kmalloc for 2 bytes?)
> > 
> > Aha - OK, Just spoke with Laurent and - yes this is needed, as we can't
> > DMA to the stack  - I hadn't realised the 'data' was being DMA'd ..

I don't dispute the fact that we need to kmalloc the memory, but I think we 
only need to kmalloc one byte, not two. The existing 2 bytes allocation comes 
from the size of the GET_LEN reply. Now that you only issue a GET_INFO here, 
one byte is enough.

> >> All these are small issues. Let me try to address them, I'll send you an
> >> updated patch shortly.
> 
> I'll be waiting.

-- 
Regards,

Laurent Pinchart
