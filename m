Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:31160 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbaHGOEr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Aug 2014 10:04:47 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9X007BBWFYTX20@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 07 Aug 2014 10:04:46 -0400 (EDT)
Date: Thu, 07 Aug 2014 11:04:42 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] au0828-input: Be sure that IR is enabled at polling
Message-id: <20140807110442.353469bc.m.chehab@samsung.com>
In-reply-to: <CAGoCfix4h+Fh7PsPnhbn1wWh4-nsdMe-hjJ2B_Wrba8+0G59vg@mail.gmail.com>
References: <1407419190-10031-1-git-send-email-m.chehab@samsung.com>
 <CAGoCfix4h+Fh7PsPnhbn1wWh4-nsdMe-hjJ2B_Wrba8+0G59vg@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 07 Aug 2014 10:00:31 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> On Thu, Aug 7, 2014 at 9:46 AM, Mauro Carvalho Chehab
> <m.chehab@samsung.com> wrote:
> > When the DVB code sets the frontend, it disables the IR
> > INT, probably due to some hardware bug, as there's no code
> > there at au8522 frontend that writes on register 0xe0.
> >
> > Fixing it at au8522 code is hard, as it doesn't know if the
> > IR is enabled or disabled, and just restoring the value of
> > register 0xe0 could cause other nasty effects. So, better
> > to add a hack at au0828-input polling interval to enable int,
> > if disabled.
> >
> > Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > ---
> >  drivers/media/usb/au0828/au0828-input.c | 12 ++++++++++--
> >  1 file changed, 10 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/media/usb/au0828/au0828-input.c b/drivers/media/usb/au0828/au0828-input.c
> > index 94d29c2a6fcf..b4475706dfd2 100644
> > --- a/drivers/media/usb/au0828/au0828-input.c
> > +++ b/drivers/media/usb/au0828/au0828-input.c
> > @@ -94,14 +94,19 @@ static int au8522_rc_read(struct au0828_rc *ir, u16 reg, int val,
> >  static int au8522_rc_andor(struct au0828_rc *ir, u16 reg, u8 mask, u8 value)
> >  {
> >         int rc;
> > -       char buf;
> > +       char buf, oldbuf;
> >
> >         rc = au8522_rc_read(ir, reg, -1, &buf, 1);
> >         if (rc < 0)
> >                 return rc;
> >
> > +       oldbuf = buf;
> >         buf = (buf & ~mask) | (value & mask);
> >
> > +       /* Nothing to do, just return */
> > +       if (buf == oldbuf)
> > +               return 0;
> > +
> >         return au8522_rc_write(ir, reg, buf);
> >  }
> >
> > @@ -127,8 +132,11 @@ static int au0828_get_key_au8522(struct au0828_rc *ir)
> >
> >         /* Check IR int */
> >         rc = au8522_rc_read(ir, 0xe1, -1, buf, 1);
> > -       if (rc < 0 || !(buf[0] & (1 << 4)))
> > +       if (rc < 0 || !(buf[0] & (1 << 4))) {
> > +               /* Be sure that IR is enabled */
> > +               au8522_rc_set(ir, 0xe0, 1 << 4);
> 
> Shouldn't this be a call to au8522_rc_andor()  rather than au8522_rc_set()?

Well, au8522_rc_set is defined as:

	#define au8522_rc_set(ir, reg, bit) au8522_rc_andor(ir, (reg), (bit), (bit))

Regards,
Mauro
