Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:47769 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753673AbZEQBki (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 May 2009 21:40:38 -0400
Subject: Re: Fixed (Was:Re: saa7134/2.6.26 regression, noisy output)
From: hermann pitton <hermann-pitton@arcor.de>
To: Anders Eriksson <aeriksson@fastmail.fm>
Cc: Steven Toth <stoth@linuxtv.org>,
	Michael Krufky <mkrufky@linuxtv.org>, tomlohave@gmail.com,
	Hartmut Hackmann <hartmut.hackmann@t-online.de>,
	video4linux-list@redhat.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
In-Reply-To: <20090516140246.70EC52C4167@tippex.mynet.homeunix.org>
References: <20090503075609.0A73B2C4152@tippex.mynet.homeunix.org>
	 <1241389925.4912.32.camel@pc07.localdom.local>
	 <20090504091049.D931B2C4147@tippex.mynet.homeunix.org>
	 <1241438755.3759.100.camel@pc07.localdom.local>
	 <20090504195201.6ECF52C415B@tippex.mynet.homeunix.org>
	 <1241565988.16938.15.camel@pc07.localdom.local>
	 <20090507130055.E49D32C4165@tippex.mynet.homeunix.org>
	 <20090510141614.D4A9C2C416C@tippex.mynet.homeunix.org>
	 <20090515091827.864A12C4167@tippex.mynet.homeunix.org>
	 <1242438418.3813.15.camel@pc07.localdom.local>
	 <20090516140246.70EC52C4167@tippex.mynet.homeunix.org>
Content-Type: text/plain
Date: Sun, 17 May 2009 03:29:21 +0200
Message-Id: <1242523761.3741.12.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Samstag, den 16.05.2009, 16:02 +0200 schrieb Anders Eriksson:
> hermann-pitton@arcor.de said:
> > thanks a lot for all your time and energy you did spend on this
> My pleasure. Especially since I start to see some progress!
> 
> > I suggest we start collecting photographs of different LNA circuits on the
> > wiki. 
> Do you want me to open up the case and take some photos of the board? Any
> particular circuit I should look for?
> 
> > For now, Tom offered his support already off list, I think we should start
> > about the question, if that early Hauppauge HVR 1110 has such an LNA type one
> > at all, since this caused to not look at it further, as it seemed to be
> > without problems.
> Well, this is a Pinnacle 310i, not a Hauppauge. At least acording to the box 
> it came in! Are we talking about two different cards here?

well, the point is that Hauppauge bought Pinnacle recently concerning
capture cards, but hat is Europe for now.

The 310i and HVR 1110 are the only cards using config one for LNA
support.

I can provide a photograph for LNA config type two on a Ausus OEM 3in1.

Don't use any brute force. On recent cards it is easy to remove the
upper tuner shielding, but on early cards, the 310i is likely such a
one, the shielding was completely soldered. Then better stay away!

Please have some patience. I have Steven and Mike in CC, but allow them
to have lots of time. Else we must start some better hacking attempts
again later.

Cheers,
Hermann






