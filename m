Return-path: <linux-media-owner@vger.kernel.org>
Received: from web23203.mail.ird.yahoo.com ([217.146.189.58]:31545 "HELO
	web23203.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1764227AbZLQJhj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2009 04:37:39 -0500
Message-ID: <755686.42993.qm@web23203.mail.ird.yahoo.com>
Date: Thu, 17 Dec 2009 09:37:37 +0000 (GMT)
From: Newsy Paper <newspaperman_germany@yahoo.com>
Subject: Re: Anyone capable of fixing inverted spectrum issue on tt s2-3200?
To: Manu Abraham <abraham.manu@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1a297b360912160510x5e8f1094se95560e6584e0337@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ok this modification does change something as I have no signal on all dvb-s2 transponders that don't use inverted spectrum. I'm still looking for a transponder that has this inverted spectrum still enabled, so I'll give feedback as soon as I find one.

regards

Newspaperman
--- Manu Abraham <abraham.manu@gmail.com> schrieb am Mi, 16.12.2009:

> Von: Manu Abraham <abraham.manu@gmail.com>
> Betreff: Re: Anyone capable of fixing inverted spectrum issue on tt s2-3200?
> An: "Newsy Paper" <newspaperman_germany@yahoo.com>
> CC: linux-media@vger.kernel.org
> Datum: Mittwoch, 16. Dezember 2009, 14:10
> On Wed, Dec 16, 2009 at 4:15 PM,
> Newsy Paper
> <newspaperman_germany@yahoo.com>
> wrote:
> > Hi,
> >
> > as the problem with the ORF HD transponder on Astra is
> now figured out and ORF switched inversion off again, we
> know know where the bug in the driver is. I don't know if
> the problem also occours on dvb-s(1) transponders but I'll
> try to figure that out.
> >
> > Is anyone able to fix that dvb-s2 problem? Perhaps it
> would also solve the problem with some transponders on 1°
> west?
> >
> 
> 
> To verify whether an inversion will solve the issue:
> 
> Please try changing
> 
> line: #1313 .inversion = IQ_SWAP_ON, /* 1 */  to
> IQ_SWAP_OFF
> 
> in
> 
> http://linuxtv.org/hg/v4l-dvb/file/79fc32bba0a0/linux/drivers/media/dvb/ttpci/budget-ci.c
> 
> and check whether that solves your inversion issue. Please
> report your findings.
> 
> 
> Regards,
> Manu
> 

__________________________________________________
Do You Yahoo!?
Sie sind Spam leid? Yahoo! Mail verfügt über einen herausragenden Schutz gegen Massenmails. 
http://mail.yahoo.com 
