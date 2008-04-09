Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out.google.com ([216.239.33.17])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dcharvey@dsl.pipex.com>) id 1JjWiN-0006GP-M3
	for linux-dvb@linuxtv.org; Wed, 09 Apr 2008 11:35:38 +0200
Received: from spaceape23.eur.corp.google.com (spaceape23.eur.corp.google.com
	[172.28.16.75]) by smtp-out.google.com with ESMTP id m399ZTGB014146
	for <linux-dvb@linuxtv.org>; Wed, 9 Apr 2008 10:35:29 +0100
Received: from [172.16.21.211] (dhcp-172-16-21-211.lon.corp.google.com
	[172.16.21.211]) (authenticated bits=0)
	by spaceape23.eur.corp.google.com with ESMTP id m399ZSun026333
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-dvb@linuxtv.org>; Wed, 9 Apr 2008 10:35:29 +0100
Message-ID: <47FC8DE0.3060202@dsl.pipex.com>
Date: Wed, 09 Apr 2008 10:35:28 +0100
From: David Harvey <dcharvey@dsl.pipex.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <mailman.99.1207695038.954.linux-dvb@linuxtv.org>
In-Reply-To: <mailman.99.1207695038.954.linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] WinTV-NOVA-TD & low power muxes (Philip Pemberton)
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

/Message: 4
Date: Tue, 08 Apr 2008 23:27:34 +0100
From: Philip Pemberton <lists@philpem.me.uk>
Subject: Re: [linux-dvb] WinTV-NOVA-TD & low power muxes
To: Greg Thomas <Greg@TheThomasHome.co.uk>, linux-dvb
	<linux-dvb@linuxtv.org>
Message-ID: <47FBF156.5090703@philpem.me.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

Greg Thomas wrote:
/

> /> After trying the latest drivers, I had a go under Windows; exactly the
> > same set of channels. I just guess the Nova-TD isn't that sensitive. I
> > may just have to look at boosting my signal, somehow  :( /
>   
/
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
wideband aerial./

-- Phil. | (\_/) This is Bunny. Copy and paste Bunny lists@philpem.me.uk 
| (='.'=) into your signature to help him gain http://www.philpem.me.uk/ 
| (")_(") world domination.



I vaguely remember someone mentioning this problem doesn't affect the TD 
card/stick under the Windows driver.  Can anyone confirm this?

Cheers,

dh

:



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
