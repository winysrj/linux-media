Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:57300 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab2L0VeK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Dec 2012 16:34:10 -0500
Date: Thu, 27 Dec 2012 19:33:38 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: Konstantin Dimitrov <kosio.dimitrov@gmail.com>,
	Malcolm Priestley <tvboxspy@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.9] separate Montage ts2020 from ds3000 and
 rs2000, support for new TeVii cards
Message-ID: <20121227193338.4e14c1d6@infradead.org>
In-Reply-To: <1541475.yBqmJOQMfq@useri>
References: <1541475.yBqmJOQMfq@useri>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Igor,

Em Mon, 24 Dec 2012 11:23:56 +0300
"Igor M. Liplianin" <liplianin@me.by> escreveu:

> The following changes since commit 8b2aea7878f64814544d0527c659011949d52358:
> 
>   [media] em28xx: prefer bulk mode on webcams (2012-12-23 17:24:30 -0200)
> 
> are available in the git repository at:
> 
>   git://git.linuxtv.org/liplianin/media_tree.git ts2020_v3.9
> 
> for you to fetch changes up to 2ff52e6f487c2ee841f3df9709d1b4e4416a1b15:
> 
>   ts2020: separate from m88rs2000 (2012-12-24 01:26:12 +0300)
> 
> ----------------------------------------------------------------
> Igor M. Liplianin (4):
>       Tevii S421 and S632 support


>       m88rs2000: SNR BER implemented
>       ds3000: lock led procedure added
>       ts2020: separate from m88rs2000

You forgot to add your SOB and patch descriptions on the above
patches.

> 
> Konstantin Dimitrov (3):
>       ds3000: remove ts2020 tuner related code
>       ts2020: add ts2020 tuner driver
>       make the other drivers take use of the new ts2020 driver

Those now looks correct. So, I'm applying them.

Regards,
Mauro
