Return-path: <mchehab@pedra>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:34787 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633Ab1EXTFZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 15:05:25 -0400
From: =?utf-8?Q?S=C3=A9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "'Guy Martin'" <gmsoft@tuxicoman.be>
Cc: <abraham.manu@gmail.com>, <linux-media@vger.kernel.org>
References: <20110524181817.34097929@borg.bxl.tuxicoman.be>	<007101cc1a3a$a0a86e80$e1f94b80$@coexsi.fr> <20110524204514.4fc6774c@zombie>
In-Reply-To: <20110524204514.4fc6774c@zombie>
Subject: RE: STV090x FE_READ_STATUS implementation
Date: Tue, 24 May 2011 21:05:33 +0200
Message-ID: <007201cc1a45$90ed05e0$b2c711a0$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Language: fr
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Guy Martin
> Sent: mardi 24 mai 2011 20:45
> To: Sébastien RAILLARD (COEXSI)
> Cc: abraham.manu@gmail.com; linux-media@vger.kernel.org
> Subject: Re: STV090x FE_READ_STATUS implementation
> 
> On Tue, 24 May 2011 19:47:17 +0200
> Sébastien RAILLARD (COEXSI) <sr@coexsi.fr> wrote:
> 
> > > Does the STV6110 supports reporting of signal, carrier, viterbi and
> > > sync ?
> > >
> >
> > I've done some tests with the CineS2, that is using the STV6110A as
> > the tuner and the STV0903 as the demodulator.
> >
> > The values you are searching for don't come from the tuner, but the
> > demodulator.
> >
> > In my case, the STV0903 is reporting the five following states :
> > SCVYL.
> >
> 
> Indeed, after some more troubleshooting, I found out that the problem is
> not in the STV6110 but in the STV090X code. The card I'm using is a TT
> S2-1600.
> 
> The function stv090x_read_status() only reports the status when locked.
> 
> I couldn't find the datasheet either for this one. Manu is the
> maintainer as well. Maybe he has more input on this.
> 

Strange, as it must be the same demodulator and code as for the CineS2!

Not easy to get the datasheets from ST, they have never replied to my enquiries...

> In the meantime, I'll give a closer look at the code see if I can figure
> out a way to fix that.
> 
> 
> Thanks,
>   Guy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html

