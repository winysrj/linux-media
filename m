Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mout3.freenet.de ([195.4.92.93])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ruediger.dohmhardt@freenet.de>) id 1JwN9D-0002r3-7p
	for linux-dvb@linuxtv.org; Wed, 14 May 2008 22:00:39 +0200
Message-ID: <482B44D1.1000906@freenet.de>
Date: Wed, 14 May 2008 22:00:17 +0200
From: Ruediger Dohmhardt <ruediger.dohmhardt@freenet.de>
MIME-Version: 1.0
To: "Bas v.d. Wiel" <bas@kompasmedia.nl>
References: <48295A62.50708@kompasmedia.nl> <4829FA37.8030007@freenet.de>
	<482AAD8A.80309@kompasmedia.nl>
In-Reply-To: <482AAD8A.80309@kompasmedia.nl>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TechnoTrend 2300 DVB-C, does it work?
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

Bas v.d. Wiel schrieb:
> Hi Ruediger,
> The AD-CP300 is exactly the card I own right now. I haven't been able 
> to tune this card to a single channel yet, using whatever version of 
This is strange, and as said already, my card tunes not only perfectly, 
but also fast. Channel switching is less than 2s!
> the Mantis driver, even though the card functions perfectly using 
> Windows so the hardware is OK. My assumption is that a working Mantis 
> card should be able to at least detect the channels, even if it's 
> unable to decrypt them. 
Yes! By the way, do you have just encrypted channels in Netherland?
> I'm using the right frequencies, symbol rates and QAM-settings for 
> tuning. They come straight from the working Windows side of the 
> system, but nothing is found at all. I only receive a long stream of 
> tuning failures using scan. I have time to wait for the Mantis driver 
> to mature. On the Windows side of things MediaPortal is more or less 
> ok. I just very much prefer to use Linux for my HTPC (or any of my 
> systems for that matter).
>
> But, if I understand you correctly, the TT2300 allows you to watch 
> encrypted DVB-C under Linux, right?
Right!
Obviously, you need to by the TT Premium 3.5" CI.

My first CI was from Hauppauge. Later I bought the TTs from

http://www.dvbshop.net/index.php/cat/c19_Technotrend-Zubehoer.html



One sentence about my experience with DVB-C:
Often, the true carrier frequency (fc) deviates significantly from the 
specified one.
For example:
Assume you have a channel (some people say "transponder") where fc is 
supposed to be 113MHz.
In my area (Hamburg), the true carrier frequency is approx. 112.3Mhz. 
Thus, the deviation is 700kHz.
This resulted in strong distortions, actually you couldn't bear this 
more than a minute with Linux.
The Windows driver could cope with this (after you switched channels once).
It probably uses different parameters for the PLL-locking mechanism.
However, in recent kernels (2.6.22.x) this is not problem anymore.

For the TT-2300 I used to apply a patch for (i.e.,against) it from

http://www.vdrportal.de/board/thread.php?postid=582559

I DON'T think you have a similar problem with the Twinhan card.
It is just an example for reasons, where you wonder why Windows works 
and Linux not.
I suppose the developers from, lets say Hauppauge, where aware of this 
strong frequency deviation
and designed the driver accordingly.

Below is just my scan command and the output of it.


------------------------------  Scan command:-------------------

w_scan -t1 -fc -o4 -R0 >> /tmp/channels.conf.test

----------------- Some output lines           ------------------------

w_scan version 20060902
Info: using DVB adapter auto detection.
   Found DVB-C frontend. Using adapter /dev/dvb/adapter0/frontend0
-_-_-_-_ Getting frontend capabilities-_-_-_-_
frontend Philips TDA10021 DVB-C supports
INVERSION_AUTO
QAM_AUTO not supported, trying QAM_64 and QAM_256.
FEC_AUTO
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
50500:
57500:
64500:
107500:
114500:
121500:
128500:
135500:
142500:
149500:
156500:
163500:
170500:
105000:
113000: signal ok (S6900C999M64)
121000: signal ok (S6900C999M64)
129000:
137000:



Ciao Ruediger



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
