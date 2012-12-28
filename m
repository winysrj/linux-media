Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:36190 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab2L1WG3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Dec 2012 17:06:29 -0500
Received: by mail-ee0-f49.google.com with SMTP id c4so5286176eek.8
        for <linux-media@vger.kernel.org>; Fri, 28 Dec 2012 14:06:27 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Konstantin Dimitrov <kosio.dimitrov@gmail.com>,
	Malcolm Priestley <tvboxspy@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: Re: [GIT PULL FOR v3.9] separate Montage ts2020 from ds3000 and rs2000, support for new TeVii cards
Date: Sat, 29 Dec 2012 01:06:29 +0300
Message-ID: <13048798.3Y05dB7H81@useri>
In-Reply-To: <20121227193338.4e14c1d6@infradead.org>
References: <1541475.yBqmJOQMfq@useri> <20121227193338.4e14c1d6@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27 декабря 2012 19:33:38 Mauro Carvalho Chehab wrote:
> Hi Igor,
Hi Mauro,

> 
> Em Mon, 24 Dec 2012 11:23:56 +0300
> 
> "Igor M. Liplianin" <liplianin@me.by> escreveu:
> > The following changes since commit 8b2aea7878f64814544d0527c659011949d52358:
> >   [media] em28xx: prefer bulk mode on webcams (2012-12-23 17:24:30 -0200)
> > 
> > are available in the git repository at:
> >   git://git.linuxtv.org/liplianin/media_tree.git ts2020_v3.9
> > 
> > for you to fetch changes up to 2ff52e6f487c2ee841f3df9709d1b4e4416a1b15:
> >   ts2020: separate from m88rs2000 (2012-12-24 01:26:12 +0300)
> > 
> > ----------------------------------------------------------------
> > 
> > Igor M. Liplianin (4):
> >       Tevii S421 and S632 support
> >       
> >       
> >       m88rs2000: SNR BER implemented
> >       ds3000: lock led procedure added
> >       ts2020: separate from m88rs2000
> 
> You forgot to add your SOB and patch descriptions on the above
> patches.
Actually, I made it two months ago, enough to forget.
So, I will add SOB, description and resend. 

> 
> > Konstantin Dimitrov (3):
> >       ds3000: remove ts2020 tuner related code
> >       ts2020: add ts2020 tuner driver
> >       make the other drivers take use of the new ts2020 driver
> 
> Those now looks correct. So, I'm applying them.
> 
> Regards,
> Mauro

Regards,
Igor
-- 
Igor M. Liplianin
 Microsoft Windows Free Zone - Linux used for all Computing Tasks
