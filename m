Return-path: <mchehab@gaivota>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35823 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab0LMTGq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Dec 2010 14:06:46 -0500
MIME-Version: 1.0
In-Reply-To: <20101213140421.GA2826@darkstar>
References: <20101212131550.GA2608@darkstar>
	<AANLkTinaNjPjNbxE+OyRsY_jJxDW-pwehTPgyAWzqfzd@mail.gmail.com>
	<20101213140421.GA2826@darkstar>
Date: Mon, 13 Dec 2010 20:06:45 +0100
Message-ID: <AANLkTin7-hSi9mhzU13ekW3ybKt6khCFnofePcw3a3tU@mail.gmail.com>
Subject: Re: [PATCH] bttv: fix mutex use before init
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Chris Clayton <chris2553@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Mon, Dec 13, 2010 at 3:04 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> On Sun, Dec 12, 2010 at 05:13:47PM +0100, Torsten Kaiser wrote:
>> On Sun, Dec 12, 2010 at 2:15 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
>> > oops happen in bttv_open while locking uninitialized mutex fh->cap.vb_lock
>> > add mutex_init before usage
>>
>> I have seen the same problem twice since I switched of the BKL in
>> 2.6.37-rc2, but only had the time today to search for the cause.
>> (It only happend on two boots out of probably more then 50, so I only
>> investigated after it happened a second time with -rc5)
>>
>> The cause was making this change to bttv_open() and radio_open() to
>> remove the BKL from them:
>> +     mutex_lock(&fh->cap.vb_lock);
>>       *fh = btv->init;
>> +     mutex_unlock(&fh->cap.vb_lock);
>>
>> This is wrong because of two things:
>> First: The fh->cap.vb_lock has not been initialised, as you noted.
>> Second: The middle line will overwrite the mutex!
>>
>> Just adding mutex_init() will not really help the second problem and
>> seems to be wrong from the point that cap.vb_lock already has a
>> mutex_init() via videobuf_queue_sg_init().
>
> Yes, you are right. I wonder if the above lock code in bttv_open and radio_open can be removed or just use btv->lock.

In bttv_open there is a comment directly above this lock/unlock
sequence that explains why cap.vb_lock was used. As that comment
sounded correct, I did not look further into changing it.
Hmmh: I'm not sure, if I understand how this locking should work. It
looks like each bttv_open() call will create a bttv_fh structure with
its own cap.vb_lock. So if there ever is more then one bttv_fh for one
btv, there is nothing that prevents concurrent access to btv->init,
because there are two different cap.vb_lock. But if there always is
only one bttv_fh, then why allocate it at all and not exclusively use
btv->init, as that one will always be there already.
Disclaimer: I only started looking into bttv-driver.c yesterday when I
was trying to find out, why I got these OOPSes. I probably missed
something there...

>> I'm not sure what the correct fix is, but I would rather suggest this:
>>
>>  * change &fh->cap.vb_lock in bttv_open() AND radio_open() to
>> &btv->init.cap.vb_lock
>>  * add a mutex_init(&btv->init.cap.vb_lock) to the setup of init in bttv_probe()
>
> I will test this when the bttv card is available for me tommorrow.

I do have a bttv card, so if you want me to test something, I could do this.
Although: the current version of the code works for me. Even after the
OOPS during bootup, I was later able to watch TV with that card.

>> > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>> > Tested-by: Chris Clayton <chris2553@googlemail.com>
>> > ---
>> >  drivers/media/video/bt8xx/bttv-driver.c |    2 ++
>> >  1 file changed, 2 insertions(+)
>> >
>> > --- linux-2.6.orig/drivers/media/video/bt8xx/bttv-driver.c      2010-11-27 11:21:30.000000000 +0800
>> > +++ linux-2.6/drivers/media/video/bt8xx/bttv-driver.c   2010-12-12 16:31:39.633333338 +0800
>> > @@ -3291,6 +3291,8 @@ static int bttv_open(struct file *file)
>> >        fh = kmalloc(sizeof(*fh), GFP_KERNEL);
>> >        if (unlikely(!fh))
>> >                return -ENOMEM;
>> > +
>> > +       mutex_init(&fh->cap.vb_lock);
>> >        file->private_data = fh;
>> >
>> >        /*
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
>> >
>
