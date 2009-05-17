Return-path: <linux-media-owner@vger.kernel.org>
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:40732 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752682AbZEQPHD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 May 2009 11:07:03 -0400
To: "tomlohave@gmail.com" <tomlohave@gmail.com>
cc: hermann pitton <hermann-pitton@arcor.de>,
	Anders Eriksson <aeriksson@fastmail.fm>,
	Steven Toth <stoth@linuxtv.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	linux-media@vger.kernel.org, video4linux-list@redhat.com,
	Hartmut Hackmann <hartmut.hackmann@t-online.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Fixed (Was:Re: saa7134/2.6.26 regression, noisy output)
In-reply-to: <4A10168E.70205@gmail.com>
References: <20090503075609.0A73B2C4152@tippex.mynet.homeunix.org> <1241389925.4912.32.camel@pc07.localdom.local> <20090504091049.D931B2C4147@tippex.mynet.homeunix.org> <1241438755.3759.100.camel@pc07.localdom.local> <20090504195201.6ECF52C415B@tippex.mynet.homeunix.org> <1241565988.16938.15.camel@pc07.localdom.local> <20090507130055.E49D32C4165@tippex.mynet.homeunix.org> <20090510141614.D4A9C2C416C@tippex.mynet.homeunix.org> <20090515091827.864A12C4167@tippex.mynet.homeunix.org> <1242438418.3813.15.camel@pc07.localdom.local> <4A10168E.70205@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Sun, 17 May 2009 17:06:27 +0200
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20090517150627.55ED12C4167@tippex.mynet.homeunix.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


tomlohave@gmail.com said:
> Hello list, 
> you are talking about tuner_config = 1 for the hvr 1110, right ?
No. We're talking about the switch_addr variable. This variable is not 
changeable with module parameters.

> Changing this option doesn't affect the qualitie of the signal on tv see
> http://forum.ubuntu-fr.org/viewtopic.php?pid=1472261 it 's an "old"
> discussion in french. This option, as far as i remenber, was not provided by
> me ...

> anyway with tuner debug=1 and .tuner_config=1 , i have no line with AGC  or
> LNA on dmesg

You only get this output if you enable debugging. Here's what i have (gentoo):
anders@tv /etc/modprobe.d $ grep '' saa7134 saa7134_alsa tda827x tda8290 tuner
saa7134:options saa7134 disable_ir=1 alsa=1 core_debug=1 i2c_debug=1
saa7134:#options saa7134 alsa=1
saa7134_alsa:options saa7134_alsa debug=1
tda827x:options tda827x debug=1
tda8290:options tda8290 debug=1
tuner:options tuner debug=1

If you adjust your module options similarly, you'll get more info in dmesg.

If you're ok with patching kernel source, could you try the patch I sent?

> I have somme glitchs with hvr1110 on dvb (not analogic tv) and many for  one
> particular station call M6 (and i'm not the only one user, see  previous post
> on ubuntu-fr.org, with short or long distance from tv  relay) . Bug on 310i
> means potentially bug on hvr1110 as configuration  on hvr 1110 was made from
> 310i 

I've never tried my 310i on digital (dvb-t), so I'm afraid I cannot help you 
there. I use it on analogue cable tv.

-Anders

