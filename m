Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1JhMuK-000461-MA
	for linux-dvb@linuxtv.org; Thu, 03 Apr 2008 12:43:01 +0200
Date: Thu, 3 Apr 2008 12:42:17 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Nicolas Will <nico@youplala.net>
In-Reply-To: <874a271ecbbd66baae17d5acf725ef16@localhost>
Message-ID: <Pine.LNX.4.64.0804031239270.32323@pub6.ifh.de>
References: <754a11be0803311238p3fbd4a01p2b336609476261e6@mail.gmail.com>
	<874a271ecbbd66baae17d5acf725ef16@localhost>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb]
	=?utf-8?q?Nova-T_500_disconnects_-_solved=3F_-_YES!?=
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

Hi,

I was following the discussion silently, because I wanted to see the 
information which lead me to the solution. Indeed I was wondering, that 
there was no change recently in the dib0700-module - so it must have been 
something else, but what.

Glad to see there is now a solution - I never could have found this one.

Sorry for not replying earlier, but I really had nothing to say.

Patrick.


On Thu, 3 Apr 2008, Nicolas Will wrote:

>
> Guys,
>
> I have tried the ehci patch manually on the Ubuntu 2.6.24-13 source, and
> indeed it fixed the disconnects.
>
> The fix is now in the 2.6.24-14 binaries, and works just as well.
>
> My Ubuntu Hardy has now resumed normal activities and Gutsy stability
> levels, so far.
>
> I can only recommend that users of other distros should check for kernel
> updates, bug their developers to include the fix, or do it themselves.
>
> Nico
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
