Return-path: <mchehab@localhost>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:62127 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab1GFUff (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2011 16:35:35 -0400
Received: by wwg11 with SMTP id 11so3499598wwg.1
        for <linux-media@vger.kernel.org>; Wed, 06 Jul 2011 13:35:33 -0700 (PDT)
Subject: RE: [DVB] TT S-1500b tuning issue
From: Malcolm Priestley <tvboxspy@gmail.com>
To: 'Linux Media Mailing List' <linux-media@vger.kernel.org>
Cc: 'Oliver Endriss' <o.endriss@gmx.de>,
	=?ISO-8859-1?Q?S=E9bastien?= "RAILLARD (COEXSI)" <sr@coexsi.fr>
In-Reply-To: <007201cc3bd0$a1b4aa70$e51dff50$@coexsi.fr>
References: <00a301cc365e$b6d415c0$247c4140$@coexsi.fr>
	 <201107040043.00393@orion.escape-edv.de>
	 <007201cc3bd0$a1b4aa70$e51dff50$@coexsi.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jul 2011 21:35:24 +0100
Message-ID: <1309984524.6358.18.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On Wed, 2011-07-06 at 13:34 +0200, Sébastien RAILLARD (COEXSI) wrote:
> 
> > -----Original Message-----
> > From: Oliver Endriss [mailto:o.endriss@gmx.de]
> > Sent: lundi 4 juillet 2011 00:43
> > To: Linux Media Mailing List
> > Cc: Sébastien RAILLARD (COEXSI); Malcolm Priestley
> > Subject: Re: [DVB] TT S-1500b tuning issue
> > 
> > On Wednesday 29 June 2011 15:16:10 Sébastien RAILLARD wrote:
> > > Dear all,
> > >
> > > We have found what seems to be a tuning issue in the driver for the
> > > ALPS BSBE1-D01A used in the new TT-S-1500b card from Technotrend.
> > > On some transponders, like ASTRA 19.2E 11817-V-27500, the card can
> > > work very well (no lock issues) for hours.
> > >
> > > On some other transponders, like ASTRA 19.2E 11567-V-22000, the card
> > > nearly never manage to get the lock: it's looking like the signal
> > > isn't good enough.
> > 
> > Afaics the problem is caused by the tuning loop
> >     for (tm = -6; tm < 7;)
> > in stv0288_set_frontend().
> > 
> > I doubt that this code works reliably.
> > Apparently it never obtains a lock within the given delay (30us).
It's actually quite slow caused by any delay in the I2C bus. I doubt
given the age many controllers run at the 400kHz spec, if barely 100kHz.

> > 
> > Could you please try the attached patch?
> > It disables the loop and tries to tune to the center frequency.
> > 
> 
> Ok, I've tested this patch with ASTRA 19.2 #24 transponder that wasn't
> always working: it seems to work.
> I think it would be great to test it for few days more to be sure.

Unfortunately, this patch does not work well at all.

All that is happening is that the carrier offset is getting forced to 0,
after it has been updated by the lock control register losing a 'good'
lock.

The value is typically around ~f800+.

Perhaps the loop should be knocked down slightly to -9. The loop was
probably intended for 22000 symbol rate.

tvboxspy

