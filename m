Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:55118 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756740Ab3EAUk3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 May 2013 16:40:29 -0400
Received: by mail-pa0-f51.google.com with SMTP id lj1so108pab.10
        for <linux-media@vger.kernel.org>; Wed, 01 May 2013 13:40:29 -0700 (PDT)
Date: Wed, 1 May 2013 13:40:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Randy Dunlap <rdunlap@infradead.org>
cc: "Yann E. MORIN" <yann.morin.1998@free.fr>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media <linux-media@vger.kernel.org>,
	linux-kbuild@vger.kernel.org
Subject: Re: linux-next: Tree for May 1 (media/usb/stk1160)
In-Reply-To: <518179BD.3010407@infradead.org>
Message-ID: <alpine.DEB.2.02.1305011337430.14366@chino.kir.corp.google.com>
References: <20130501183734.7ad1efca2d06e75432edabbd@canb.auug.org.au> <518157EB.3010700@infradead.org> <20130501192845.GA18811@free.fr> <alpine.DEB.2.02.1305011258180.8448@chino.kir.corp.google.com> <518179BD.3010407@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 1 May 2013, Randy Dunlap wrote:

> >>> When CONFIG_SND=m and CONFIG_SND_AC97_CODEC=m and
> >>> CONFIG_VIDEO_STK1160=y
> >>> CONFIG_VIDEO_STK1160_AC97=y
> >>>
> >>> drivers/built-in.o: In function `stk1160_ac97_register':
> >>> (.text+0x122706): undefined reference to `snd_card_create'
> >>> drivers/built-in.o: In function `stk1160_ac97_register':
> >>> (.text+0x1227b2): undefined reference to `snd_ac97_bus'
> >>> drivers/built-in.o: In function `stk1160_ac97_register':
> >>> (.text+0x1227cd): undefined reference to `snd_card_free'
> >>> drivers/built-in.o: In function `stk1160_ac97_register':
> >>> (.text+0x12281b): undefined reference to `snd_ac97_mixer'
> >>> drivers/built-in.o: In function `stk1160_ac97_register':
> >>> (.text+0x122832): undefined reference to `snd_card_register'
> >>> drivers/built-in.o: In function `stk1160_ac97_unregister':
> >>> (.text+0x12285e): undefined reference to `snd_card_free'
> >>>
> >>>
> >>> This kconfig fragment:
> >>> config VIDEO_STK1160_AC97
> >>> 	bool "STK1160 AC97 codec support"
> >>> 	depends on VIDEO_STK1160 && SND
> > 
> > This doesn't depend on SND, it depends on SND=y.
> > --
> 
> 
> Maybe this option *should* depend on SND=y, but that's not what the
> kconfig syntax says.  The kconfig language does not care if the variable is
> a bool or a tristate when evaluating a depends expression AFAICT (but I am
> only reading Documentation/kbuild/kconfig-language.txt, not the source code).
> 

Doing "depends on SND=y" will only allow an option to be enabled if SND is 
builtin so the snd_card_* functions above will be defined (with your 
config we have a builtin function calling a module which may or may not be 
loaded).  I think you've already addressed the snd_ac97_* functions, so 
the fix here should be relatively simple.  Yann?
