Return-path: <mchehab@localhost>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:45028 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab1GFLeQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2011 07:34:16 -0400
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "'Oliver Endriss'" <o.endriss@gmx.de>,
	"'Linux Media Mailing List'" <linux-media@vger.kernel.org>
Cc: "'Malcolm Priestley'" <tvboxspy@gmail.com>
References: <00a301cc365e$b6d415c0$247c4140$@coexsi.fr> <201107040043.00393@orion.escape-edv.de>
In-Reply-To: <201107040043.00393@orion.escape-edv.de>
Subject: RE: [DVB] TT S-1500b tuning issue
Date: Wed, 6 Jul 2011 13:34:12 +0200
Message-ID: <007201cc3bd0$a1b4aa70$e51dff50$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Language: fr
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>



> -----Original Message-----
> From: Oliver Endriss [mailto:o.endriss@gmx.de]
> Sent: lundi 4 juillet 2011 00:43
> To: Linux Media Mailing List
> Cc: Sébastien RAILLARD (COEXSI); Malcolm Priestley
> Subject: Re: [DVB] TT S-1500b tuning issue
> 
> On Wednesday 29 June 2011 15:16:10 Sébastien RAILLARD wrote:
> > Dear all,
> >
> > We have found what seems to be a tuning issue in the driver for the
> > ALPS BSBE1-D01A used in the new TT-S-1500b card from Technotrend.
> > On some transponders, like ASTRA 19.2E 11817-V-27500, the card can
> > work very well (no lock issues) for hours.
> >
> > On some other transponders, like ASTRA 19.2E 11567-V-22000, the card
> > nearly never manage to get the lock: it's looking like the signal
> > isn't good enough.
> 
> Afaics the problem is caused by the tuning loop
>     for (tm = -6; tm < 7;)
> in stv0288_set_frontend().
> 
> I doubt that this code works reliably.
> Apparently it never obtains a lock within the given delay (30us).
> 
> Could you please try the attached patch?
> It disables the loop and tries to tune to the center frequency.
> 

Ok, I've tested this patch with ASTRA 19.2 #24 transponder that wasn't
always working: it seems to work.
I think it would be great to test it for few days more to be sure.

> CU
> Oliver
> 
> --
> ----------------------------------------------------------------
> VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
> 4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
> Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
> ----------------------------------------------------------------

