Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm15.bullet.mail.ukl.yahoo.com ([217.146.183.189]:33391 "HELO
	nm15.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759166Ab2EEDcZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 May 2012 23:32:25 -0400
Message-ID: <4FA49DB4.9080206@yahoo.co.uk>
Date: Sat, 05 May 2012 04:25:40 +0100
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>,
	will.cooke@canonical.com, Greg KH <greg@kroah.com>
Subject: Re: GSoC 2012 Linux-Media!
References: <4FA291F5.3000103@iki.fi>
In-Reply-To: <4FA291F5.3000103@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

I promised to put you in touch with some more knowledgeable people, so here they 
are. Will made a few comments during our discussions (inserted verbatim below - 
may or may not be relevant)... Please feel free to respond to Mr Cooke and/or 
write to him and Greg.

Hin-Tak

Will Cooke wrote:
 > The hacks with USB stick are entirely reliant on the chips inside the stick.  In
 > this case, the demod (Realtek RTL2832U)has the ability to pass through to the
 > USB bus raw 8-bit sampled RF called I/Q
 > (http://zone.ni.com/devzone/cda/tut/p/id/4805).
 >
 > Once you have this raw I/Q data you can demodulate the signals and process them
 > in software.  So it's possible to build an FM radio, an AM radio, a DAB radio,
 > Ham radio, Packet radio, slow scan TV, basically anything which modulates a sine
 > wave within the frequency range of the tuner inside the DVB stick.  Not all DVB
 > tuners are created equal.  Some will be limited to n hundred MHz, some have a
 > range as low as 50 or 60 MHz up to a few GHz.
 >
 > Chips that have this functionality AND are built in to DVB USB sticks AND cost
 > less than 20 Dollars are few and far between.  So it's pretty rare to find a
 > compatible USB stick, and not every USB stick can pull off this neat trick.
 >
 > There is probably scope to run a project around a single targeted DVB USB stick,
 > but hardware support would be limited.  GNU Radio is a good tool to build the
 > remodulators.  As an example real world application, how about building one of
 > these sticks in to a laptop and integrating it with the audio stack.  Now my
 > laptop comes with a TV tuner, an FM tuner, a DAB tuner, and so on.
 >
 > I hope that helps set the scene a little bit more.   Let me know if you need any
 > more help.
 >
 > Cheers, Will

Will Cooke wrote:
 > Hi Till!
 >
 > I am familiar with what a USB-DVB stick is, how it works, the inside of a DVB
 > transport stream, and so on, but... I'm in no way an expert, and I'm in no way a
 > developer!
 >
 > Depending on what sort of mentoring you had in mind, I would be happy to get
 > involved.
 >
 > Can you let me know a little more about the project and what kind of input you
 > need from me.
 >
 > Cheers, Will



Antti Palosaari wrote:
> Moikka!
>
> As I have mentioned many people already, I have got Google Summer of Code
> project for the Linux-Media! It means I can do three months full time work
> starting from the week 21 (21.05.2012). Originally I applied "Open firmware for
> ath9k_htc" -project as that was listed but I added own topic for Linux-Media
> related stuff and it was accepted.
>
> It is rather much time I can spend and fix all those problems I have seen during
> recent years. Schedule is first to fix all DVB USB problems and then move to
> enhancing DVB CORE / frontend. I planned only general digital television stuff
> since it is what I know best. But if there is some time I can likely do some
> other general fixes.
>
> Here is short description.
> http://www.google-melange.com/gsoc/project/google/gsoc2012/crope/10001
>
> I will open another thread just discussing what are the most important things
> and how those should be fixed "correctly".
>
> And there is no blog yet, but sometime ago I created LinuxTV page for Google+.
> Lets use it:
> https://plus.google.com/u/0/111350562770777789175/posts
>
> And my mentor is Hin-Tak Leung.
>
> regards
> Antti
