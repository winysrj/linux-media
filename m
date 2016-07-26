Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:32829 "EHLO
	mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbcGZLLU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2016 07:11:20 -0400
Received: by mail-io0-f193.google.com with SMTP id y195so923918iod.0
        for <linux-media@vger.kernel.org>; Tue, 26 Jul 2016 04:11:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160725223653.62493982@recife.lan>
References: <1469471939-25393-1-git-send-email-aospan@netup.ru>
 <CAOcJUby+9gTrFUF14pvo1iMa2azD5TfGM8WgeZY1+Bh8CTYVzA@mail.gmail.com>
 <20160725162841.6e11fd2b@recife.lan> <CAOcJUbwOHCx1y50zt3Mcd39aUZpqd=mOjkQUgJaPxZzzrzzeLQ@mail.gmail.com>
 <20160725223653.62493982@recife.lan>
From: Michael Ira Krufky <mkrufky@linuxtv.org>
Date: Tue, 26 Jul 2016 07:11:18 -0400
Message-ID: <CAOcJUbxzVrYnx2==LKckORYk-VEwstX5YfjEfSnw0_7KT9zJgg@mail.gmail.com>
Subject: Re: [PATCH] [media] lgdt3306a: remove 20*50 msec unnecessary timeout
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Abylay Ospan <aospan@netup.ru>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 25, 2016 at 9:36 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Em Mon, 25 Jul 2016 15:37:14 -0400
> Michael Ira Krufky <mkrufky@linuxtv.org> escreveu:
>
>> On Mon, Jul 25, 2016 at 3:28 PM, Mauro Carvalho Chehab
>> <mchehab@osg.samsung.com> wrote:
>> > Hi Michael,
>> >
>> > Em Mon, 25 Jul 2016 14:55:51 -0400
>> > Michael Ira Krufky <mkrufky@linuxtv.org> escreveu:
>> >
>> >> On Mon, Jul 25, 2016 at 2:38 PM, Abylay Ospan <aospan@netup.ru> wrote:
>> >> > inside lgdt3306a_search we reading demod status 20 times with 50 msec sleep after each read.
>> >> > This gives us more than 1 sec of delay. Removing this delay should not affect demod functionality.
>> >> >
>> >> > Signed-off-by: Abylay Ospan <aospan@netup.ru>
>> >> > ---
>> >> >  drivers/media/dvb-frontends/lgdt3306a.c | 16 ++++------------
>> >> >  1 file changed, 4 insertions(+), 12 deletions(-)
>> >> >
>> >> > diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
>> >> > index 179c26e..dad7ad3 100644
>> >> > --- a/drivers/media/dvb-frontends/lgdt3306a.c
>> >> > +++ b/drivers/media/dvb-frontends/lgdt3306a.c
>> >> > @@ -1737,24 +1737,16 @@ static int lgdt3306a_get_tune_settings(struct dvb_frontend *fe,
>> >> >  static int lgdt3306a_search(struct dvb_frontend *fe)
>> >> >  {
>> >> >         enum fe_status status = 0;
>> >> > -       int i, ret;
>> >> > +       int ret;
>> >> >
>> >> >         /* set frontend */
>> >> >         ret = lgdt3306a_set_parameters(fe);
>> >> >         if (ret)
>> >> >                 goto error;
>> >> >
>> >> > -       /* wait frontend lock */
>> >> > -       for (i = 20; i > 0; i--) {
>> >> > -               dbg_info(": loop=%d\n", i);
>> >> > -               msleep(50);
>> >> > -               ret = lgdt3306a_read_status(fe, &status);
>> >> > -               if (ret)
>> >> > -                       goto error;
>> >> > -
>> >> > -               if (status & FE_HAS_LOCK)
>> >> > -                       break;
>> >> > -       }
>> >
>> > Could you please explain why lgdt3306a needs the above ugly hack?
>> >
>> >
>> >> > +       ret = lgdt3306a_read_status(fe, &status);
>> >> > +       if (ret)
>> >> > +               goto error;
>> >
>> >
>> >> >
>> >> >         /* check if we have a valid signal */
>> >> >         if (status & FE_HAS_LOCK)
>> >>
>> >> Your patch removes a loop that was purposefully written here to handle
>> >> conditions that are not ideal.  Are you sure this change is best for
>> >> all users?
>> >>
>> >> I would disagree with merging this patch.
>> >>
>> >> Best regards,
>> >>
>> >> Michael Ira Krufky
>>
>> Mauro,
>>
>> I cannot speak for the LG DT3306a part itself, but based on my past
>> experience I can say the following:
>>
>> To my understanding, the hardware might not report a lock on the first
>> read_status request, so the driver author chose to include a loop to
>> retry a few times before giving up.
>
> A one second wait, trying 50 times is not a "few times". It is a lot!
>
>> In real life scenarios, there are marginal signals that may take a
>> longer time to lock onto, but once locked, the demod will deliver a
>> reliable stream.
>>
>> Most applications will only issue a single tune request when trying to
>> tune to a given program. The application does not retry the tune
>> request if the driver reports no lock.
>
> I don't know a single application that would give up after a
> single status request with FE_READ_STATUS. Not even simple
> applications like the legacy dvb-tools do that. If such application
> exits, it is already broken, as it would fail with most drivers,
> as almost no drivers wait for frontend locks.
>
> Also, the frontend thread assumes that the lock will take some
> polls to happen, and it keep polling the status for some time,
> using the status return to do frequency zig-zag, on tuners that
> don't have hardware zig-zag, and to try bandwidth inversion.
>
> Please notice that some legacy DVBv3 applications might want to
> be bothered only after lock. In such case, they would be calling
> FE_GET_EVENT with the device opened in blocking mode:
>         https://linuxtv.org/downloads/v4l-dvb-apis-new/media/uapi/dvb/fe-get-event.html
>
> In such case, the frontend's kthread will keep the ioctl blocked
> until the device is locked, or will keep returning -EWOULDBLOCK
> in non-blocking mode.
>
>> Applying this patch will have the potential to cause userspace to
>> appear broken.  Some users will not be able to receive some weaker
>> channels anymore, and they will have no way to diagnose the problem
>> from within their application.
>
> This is not how it is supposed to work. An ioctl should not block
> for that long time for no reason, specially since the file
> descriptor could be opened in no blocking mode.
>
> The only possible reason to block would be on really broken hardware
> that would stop working if the status is called before a certain
> number of milliseconds. Even so, the proper implementation would be
> add some logic at the driver level to ensure that the hardware won't
> be receiving the status command when it is not ready to answer to
> it. Some drivers do that.

Your argument seems reasonable.  You can include my ack if you decide
to merge the patch.

Acked-by: Michael Ira Krufky <mkrufky@linuxtv.org>

Cheers,

Mike
