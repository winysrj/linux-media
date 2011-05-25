Return-path: <mchehab@pedra>
Received: from eline.schedom-europe.net ([193.109.184.70]:47549 "EHLO
	eline.schedom-europe.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab1EYDgU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 23:36:20 -0400
Date: Wed, 25 May 2011 05:34:54 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
To: =?UTF-8?B?U8OpYmFzdGllbg==?= RAILLARD (COEXSI) <sr@coexsi.fr>
Cc: <abraham.manu@gmail.com>, <linux-media@vger.kernel.org>
Subject: Re: STV090x FE_READ_STATUS implementation
Message-ID: <20110525053454.2b6ee63f@borg.bxl.tuxicoman.be>
In-Reply-To: <007201cc1a45$90ed05e0$b2c711a0$@coexsi.fr>
References: <20110524181817.34097929@borg.bxl.tuxicoman.be>
	<007101cc1a3a$a0a86e80$e1f94b80$@coexsi.fr>
	<20110524204514.4fc6774c@zombie>
	<007201cc1a45$90ed05e0$b2c711a0$@coexsi.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 24 May 2011 21:05:33 +0200
Sébastien RAILLARD (COEXSI) <sr@coexsi.fr> wrote:

> 
> 
> > > In my case, the STV0903 is reporting the five following states :
> > > SCVYL.
> > >
> > 
> > Indeed, after some more troubleshooting, I found out that the
> > problem is not in the STV6110 but in the STV090X code. The card I'm
> > using is a TT S2-1600.
> > 
> > The function stv090x_read_status() only reports the status when
> > locked.
> > 
> > I couldn't find the datasheet either for this one. Manu is the
> > maintainer as well. Maybe he has more input on this.
> > 
> 
> Strange, as it must be the same demodulator and code as for the
> CineS2!

I think there is some missunderstanding about the issue I'm facing.
When I have a lock, it does report all the SCVYL bits.
The problem occurs when there is no lock. For instance if you try to
tune to a transponder with an invalid symbol rate, you should get
SIGNAL and CARRIER but no SYNC.

Provided the demod would report that correctly, that'd allow me to try
other possible symbol rate and only do so when the demod detects a
carrier wave.

Since I'm probing a lot of frequencies, trying ~10 possible
symbol rates when there isn't a signal slows down the process a lot.


> 
> Not easy to get the datasheets from ST, they have never replied to my
> enquiries...
