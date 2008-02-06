Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1JMqP7-0007kX-Tq
	for linux-dvb@linuxtv.org; Wed, 06 Feb 2008 20:57:57 +0100
Received: from [11.11.11.138] (user-54458eb9.lns1-c13.telh.dsl.pol.co.uk
	[84.69.142.185])
	by mail.youplala.net (Postfix) with ESMTP id 58EE2D88110
	for <linux-dvb@linuxtv.org>; Wed,  6 Feb 2008 20:56:58 +0100 (CET)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <1202326173.20362.23.camel@youkaida>
References: <47A98F3D.9070306@raceme.org> <1202326173.20362.23.camel@youkaida>
Date: Wed, 06 Feb 2008 19:56:57 +0000
Message-Id: <1202327817.20362.28.camel@youkaida>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Nova-T 500 issues - losing one tuner
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


On Wed, 2008-02-06 at 19:29 +0000, Nicolas Will wrote:
> Well...
> 
> You can now laugh at me, the supposedly problem-free user...
> 
> I managed to get my nova-t-500 to lose a tuner too!
> 
> MythTV was recording on tuner 1.
> 
> I was channel surfing on tuner 2.
> 
> After flipping through a few channels, I got a black screen.
> 
> I looked at the logs. MythTV is complaining that the file it uses to
> watch TV (in fact you never watch the stream from the card, MythTV
> records the channel in a file, then plays that file) is invalid.
> 
> You bet it is invalid, it's mostly not there, or with a size of zero.
> 
> I guess that the tuner became non-responsive and thus outputs nothing.
> 
> Getting out of "LiveTV" and coming back does not fix it. Trying to go
> to
> another channel serves no purpose, MythTV must be desperately trying
> to
> get any sort of response from the tuner before sending it any new
> command.
> 
> That was a long "me too", but a "me too" all the same.
> 
> Dang !
> 
> Oh, my reception quality that used to be ugly has been fixed. I am now
> a
> user of a 26dB gain masthead amplifier. My signal strength took a 25%
> improvement, BER and UNC are zero on all channels. Still using the
> internal LNA, though; I haven't tried doing without it.


Ah...

It looks like only ITV4 is problematic, even if the other channels on
the multiplex are fine.

Maybe a different problem, but the tuner is really lost until a reboot
all the same.

I have tried without the LNA, same difference. but it's an opportunity
to measure signal and BER without it...

Anybody know about any ITV4 problem on the UK-Durris transmitter?

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
