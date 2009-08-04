Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:60451 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005AbZHDGv3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2009 02:51:29 -0400
Received: by ewy10 with SMTP id 10so89808ewy.37
        for <linux-media@vger.kernel.org>; Mon, 03 Aug 2009 23:51:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090803083012.44da22ca@tele>
References: <20090418183124.1c9160e3@free.fr>
	 <alpine.LNX.2.00.0908011635020.26881@banach.math.auburn.edu>
	 <208cbae30908020625x400f6b3era5095c8bfc5c736b@mail.gmail.com>
	 <20090803083012.44da22ca@tele>
Date: Tue, 4 Aug 2009 10:51:27 +0400
Message-ID: <208cbae30908032351y52edb16du5548ea1de26f79da@mail.gmail.com>
Subject: Re: [PATCH] to add support for certain Jeilin dual-mode cameras.
From: Alexey Klimov <klimov.linux@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	Andy Walls <awalls@radix.net>,
	Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 3, 2009 at 10:30 AM, Jean-Francois Moine<moinejf@free.fr> wrote:
> On Sun, 2 Aug 2009 17:25:29 +0400
> Alexey Klimov <klimov.linux@gmail.com> wrote:
>
>> > +       buffer = kmalloc(JEILINJ_MAX_TRANSFER, GFP_KERNEL |
>> > GFP_DMA);
>> > +       if (!buffer) {
>> > +               PDEBUG(D_ERR, "Couldn't allocate USB buffer");
>> > +               goto quit_stream;
>> > +       }
>>
>> This clean up on error path looks bad. On quit_stream you have:
>>
>> > +quit_stream:
>> > +       mutex_lock(&gspca_dev->usb_lock);
>> > +       if (gspca_dev->present)
>> > +               jlj_stop(gspca_dev);
>> > +       mutex_unlock(&gspca_dev->usb_lock);
>> > +       kfree(buffer);
>>
>> kfree() tries to free null buffer after kmalloc for buffer failed.
>> Please, check if i'm not wrong.
>
> Hi Alexey,
>
> AFAIK, kfree() checks the pointer.
>
> Cheers.

Yes, you're right. I checked the code in kfree().
Sorry for doubts.

-- 
Best regards, Klimov Alexey
