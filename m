Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JvHJE-0003Sp-Lr
	for linux-dvb@linuxtv.org; Sun, 11 May 2008 21:34:13 +0200
Message-ID: <48274A27.9050206@gmail.com>
Date: Sun, 11 May 2008 23:33:59 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
References: <482560EB.2000306@gmail.com>	
	<200805101717.23199@orion.escape-edv.de>	
	<200805101727.55810@orion.escape-edv.de>	
	<1210456421.7632.29.camel@palomino.walls.org>
	<48261EB5.2090604@gmail.com>	
	<1210463068.7632.102.camel@palomino.walls.org>
	<48268EB9.6060000@gmail.com>
	<1210530916.3198.72.camel@palomino.walls.org>
In-Reply-To: <1210530916.3198.72.camel@palomino.walls.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Fix the unc for the frontends tda10021	and
 stv0297
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

Andy Walls wrote:

> And if the channel experiences fades in addition to the typically
> assumed AWGN characteristic, then the FEC can work well almost all of
> the time, but still experience periods of time, during fades, that it
> does not work.


You are mixing up channel characteristics with the FEC. FEC should never
be considered as a means to fix a noisy channel beyond limits.

After all, basic RF concepts just reach to core concept that, no
amplifier is as good as a proper antenna (implying proper input source)
The concept of the amplifier can be applied to other Rf building blocks
as well, to put it short.

>>  Error correction schemes are used
>> selectively, depending upon different conditions. Sometimes it is tested
>> empirically, by the broadcaster. In this case UNC is very much helpful.
>> UNC per unit time doesn't make sense in that regard.
> 
> OK, for selecting an FEC scheme when testing over a real or simulated
> channel.  You still must take a certain amount of time before you
> declare a good FEC scheme: the time or message count to declare the UNC
> have stopped or are not going to occur (hence you're still dealing with
> a rate measurement even if the message count you need to make the
> declaration is 1).

For your rate measurement, you should use BER alone, not screw up UNC.

All the mentioned parameters against time are calculated by the
demodulator directly and not by a software driver. (In many instances
the driver does some scaling to provide standardized limits, other than
that) A driver doing such conversions to the time domain doesn't yield
anything proper, it just creates something quite and bogus from what is
used as a standard by the industry. Also reads over i2c (a slow
interface, not all devices feature High Speed interfaces) also doesn't
help to provide that sort of a conversion in the driver, the way you
mention.

I am talking about standard DVB demods:
Every demodulator provides a standard interface, whether you know it or not.

BER, Bit Error Rate (symbols per unit time)
Strength, usually a RMS value (Absolute)
SNR, Signal To Noise Ratio (Relative)
UNC, Uncorrectable symbols (Absolute)

These parameters have meanings for the users, not just Linux users but
general users on the whole. Most DVB stuff is quite standardized, most
of which you can find in ETSI specifications and or old DVB.org whitepapers.

All the resultant parameters that which an API provides, should be that
which is a standard definition, rather than defining something which is
bogus. You take anything standardized, you won't find any other
difference from the above, almost all demodulators follow the
specifications involved therein.


HTH,
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
