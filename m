Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:60009 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab2L2AE6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Dec 2012 19:04:58 -0500
Date: Fri, 28 Dec 2012 22:04:26 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: Konstantin Dimitrov <kosio.dimitrov@gmail.com>,
	Malcolm Priestley <tvboxspy@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.9] separate Montage ts2020 from ds3000 and
 rs2000, support for new TeVii cards
Message-ID: <20121228220426.0330ce40@infradead.org>
In-Reply-To: <13048798.3Y05dB7H81@useri>
References: <1541475.yBqmJOQMfq@useri>
	<20121227193338.4e14c1d6@infradead.org>
	<13048798.3Y05dB7H81@useri>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 29 Dec 2012 01:06:29 +0300
"Igor M. Liplianin" <liplianin@me.by> escreveu:

> On 27 Ð´ÐµÐºÐ°Ð±Ñ€Ñ_ 2012 19:33:38 Mauro Carvalho Chehab wrote:
> > Hi Igor,
> Hi Mauro,
> 
> > 
> > Em Mon, 24 Dec 2012 11:23:56 +0300
> > 
> > "Igor M. Liplianin" <liplianin@me.by> escreveu:
> > > The following changes since commit 8b2aea7878f64814544d0527c659011949d52358:
> > >   [media] em28xx: prefer bulk mode on webcams (2012-12-23 17:24:30 -0200)
> > > 
> > > are available in the git repository at:
> > >   git://git.linuxtv.org/liplianin/media_tree.git ts2020_v3.9
> > > 
> > > for you to fetch changes up to 2ff52e6f487c2ee841f3df9709d1b4e4416a1b15:
> > >   ts2020: separate from m88rs2000 (2012-12-24 01:26:12 +0300)
> > > 
> > > ----------------------------------------------------------------
> > > 
> > > Igor M. Liplianin (4):
> > >       Tevii S421 and S632 support
> > >       
> > >       
> > >       m88rs2000: SNR BER implemented
> > >       ds3000: lock led procedure added
> > >       ts2020: separate from m88rs2000
> > 
> > You forgot to add your SOB and patch descriptions on the above
> > patches.
> Actually, I made it two months ago, enough to forget.

Yeah, there were too many things happening on the 4th quarter, with
delayed patch push. Also, janitors requested us to not apply patches
after -rc7. The better is to submit your work before -rc5, in order
to give enough time for review.

> So, I will add SOB, description and resend. 

Applied, thanks.

Regards,
Mauro
