Return-path: <mchehab@pedra>
Received: from eline.schedom-europe.net ([193.109.184.70]:45418 "EHLO
	eline.schedom-europe.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197Ab1EXSp3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 14:45:29 -0400
Date: Tue, 24 May 2011 20:45:14 +0200
From: Guy Martin <gmsoft@tuxicoman.be>
To: =?UTF-8?B?U8OpYmFzdGllbg==?= RAILLARD (COEXSI) <sr@coexsi.fr>
Cc: <abraham.manu@gmail.com>, <linux-media@vger.kernel.org>
Subject: Re: STV090x FE_READ_STATUS implementation
Message-ID: <20110524204514.4fc6774c@zombie>
In-Reply-To: <007101cc1a3a$a0a86e80$e1f94b80$@coexsi.fr>
References: <20110524181817.34097929@borg.bxl.tuxicoman.be>
	<007101cc1a3a$a0a86e80$e1f94b80$@coexsi.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 24 May 2011 19:47:17 +0200
Sébastien RAILLARD (COEXSI) <sr@coexsi.fr> wrote:

> > Does the STV6110 supports reporting of signal, carrier, viterbi and
> > sync ?
> > 
> 
> I've done some tests with the CineS2, that is using the STV6110A as
> the tuner and the STV0903 as the demodulator.
> 
> The values you are searching for don't come from the tuner, but the
> demodulator.
> 
> In my case, the STV0903 is reporting the five following states :
> SCVYL.
> 

Indeed, after some more troubleshooting, I found out that the problem
is not in the STV6110 but in the STV090X code. The card I'm using is a
TT S2-1600.

The function stv090x_read_status() only reports the status when locked.

I couldn't find the datasheet either for this one. Manu is the
maintainer as well. Maybe he has more input on this.

In the meantime, I'll give a closer look at the code see if I can figure
out a way to fix that.


Thanks,
  Guy
