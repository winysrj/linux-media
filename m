Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:36828 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab3EAR7k (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 May 2013 13:59:40 -0400
Message-ID: <518157EB.3010700@infradead.org>
Date: Wed, 01 May 2013 10:59:07 -0700
From: Randy Dunlap <rdunlap@infradead.org>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media <linux-media@vger.kernel.org>,
	linux-kbuild@vger.kernel.org
Subject: Re: linux-next: Tree for May 1 (media/usb/stk1160)
References: <20130501183734.7ad1efca2d06e75432edabbd@canb.auug.org.au>
In-Reply-To: <20130501183734.7ad1efca2d06e75432edabbd@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/01/13 01:37, Stephen Rothwell wrote:
> Hi all,
> 
> Please do not add any v3.11 destined work to your linux-next included
> branches until after v3.10-rc1 is released.
> 
> Changes since 20130430:
> 


When CONFIG_SND=m and CONFIG_SND_AC97_CODEC=m and
CONFIG_VIDEO_STK1160=y
CONFIG_VIDEO_STK1160_AC97=y

drivers/built-in.o: In function `stk1160_ac97_register':
(.text+0x122706): undefined reference to `snd_card_create'
drivers/built-in.o: In function `stk1160_ac97_register':
(.text+0x1227b2): undefined reference to `snd_ac97_bus'
drivers/built-in.o: In function `stk1160_ac97_register':
(.text+0x1227cd): undefined reference to `snd_card_free'
drivers/built-in.o: In function `stk1160_ac97_register':
(.text+0x12281b): undefined reference to `snd_ac97_mixer'
drivers/built-in.o: In function `stk1160_ac97_register':
(.text+0x122832): undefined reference to `snd_card_register'
drivers/built-in.o: In function `stk1160_ac97_unregister':
(.text+0x12285e): undefined reference to `snd_card_free'


This kconfig fragment:
config VIDEO_STK1160_AC97
	bool "STK1160 AC97 codec support"
	depends on VIDEO_STK1160 && SND
	select SND_AC97_CODEC

is unreliable (doesn't do what some people expect) when SND=m and SND_AC97_CODEC=m,
since VIDEO_STK1160_AC97 is a bool.


-- 
~Randy
