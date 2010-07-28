Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808Ab0G1Pzu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 11:55:50 -0400
Message-ID: <4C505313.2010904@redhat.com>
Date: Wed, 28 Jul 2010 12:56:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Maxim Levitsky <maximlevitsky@gmail.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	linux-input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: Can I expect in-kernel decoding to work out of box?
References: <1280269990.21278.15.camel@maxim-laptop>	<1280273550.32216.4.camel@maxim-laptop>	<AANLkTi=493LW6ZBURCtyeSYPoX=xfz6n6z77Lw=a2C9D@mail.gmail.com>	<AANLkTimN1t-1a0v3S1zAXqk4MXJepKdsKP=cx9bmo=6g@mail.gmail.com>	<1280298606.6736.15.camel@maxim-laptop>	<AANLkTingNgxFLZcUszp-WDZocH+VK_+QTW8fB2PAR7XS@mail.gmail.com>	<4C502CE6.80106@redhat.com>	<1280327080.9175.58.camel@maxim-laptop> <AANLkTi=Ww9yvN5RWaXEi+cB2QaDWn34nSVGAvKxbJ2k2@mail.gmail.com>
In-Reply-To: <AANLkTi=Ww9yvN5RWaXEi+cB2QaDWn34nSVGAvKxbJ2k2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 28-07-2010 11:41, Jon Smirl escreveu:

> It's possible to build a Linux IR decoder engine that can be loaded
> with the old LIRC config files.

I think it is a good idea to have a decoder that works with such files anyway.

There are some good reasons for that, as it would allow in-kernel support for
protocols that may have some patent restrictions on a few countries that allow
patents on software.

We'll need to discuss the API requirements for such decoder, in order to load
the RC decoding code into it.

Cheers,
Mauro.
