Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from holly.castlecore.com ([89.21.8.102])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@philpem.me.uk>) id 1JjMHE-0003CO-9y
	for linux-dvb@linuxtv.org; Wed, 09 Apr 2008 00:26:59 +0200
Message-ID: <47FBF156.5090703@philpem.me.uk>
Date: Tue, 08 Apr 2008 23:27:34 +0100
From: Philip Pemberton <lists@philpem.me.uk>
MIME-Version: 1.0
To: Greg Thomas <Greg@TheThomasHome.co.uk>, linux-dvb <linux-dvb@linuxtv.org>
References: <e28a31000804060623u141fc8e2hd6405809ce6fe477@mail.gmail.com>	<Pine.LNX.4.64.0804061551510.23914@pub4.ifh.de>
	<e28a31000804060840y126b7afdp67ef934724d6dda7@mail.gmail.com>
In-Reply-To: <e28a31000804060840y126b7afdp67ef934724d6dda7@mail.gmail.com>
Subject: Re: [linux-dvb] WinTV-NOVA-TD & low power muxes
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Greg Thomas wrote:
> After trying the latest drivers, I had a go under Windows; exactly the
> same set of channels. I just guess the Nova-TD isn't that sensitive. I
> may just have to look at boosting my signal, somehow :(

Disclaimer: this is the problem as I understand it, and anything I say should 
be treated as an unproven theory until proved otherwise...

The Nova-TD seems to have an odd problem. Specifically, it seems to have some 
form of wideband low-gain amplifier/buffer on each aerial input (nothing like 
the high-gain narrowband LNA amplifier on the Nova-T-500). This takes into 
account the strongest muxes, not the mux you're currently tuned to (the T500 
seems to do the latter -- which is more sensible).

What this means is that if you've got one mux that's significantly weaker than 
the others -- e.g. the one that carries FilmFour vs. the PSB mux that carries 
BBC ONE -- you'll see a reasonable signal on BBC, but a poor signal (if you 
get a lock at all) on FilmFour.

What I did was put a 6dB attenuator between my aerial and the Nova-TD. This 
weakens the signal to the point that all the muxes are in the Nova's capture 
range. It locks on, and you get a near perfect signal on all the muxes.

Of course, it might just be that the input can't handle being overloaded, or 
was designed for the two shabby WiFi-style antennae that were bundles with the 
Nova-TD (which are truly useless). Those things probably wouldn't even work if 
you were within a mile of the transmitter...

My signal's coming from Emley Moor, ~16 miles distance via a mid-high gain 
wideband aerial.

-- 
Phil.                         |  (\_/)  This is Bunny. Copy and paste Bunny
lists@philpem.me.uk           | (='.'=) into your signature to help him gain
http://www.philpem.me.uk/     | (")_(") world domination.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
