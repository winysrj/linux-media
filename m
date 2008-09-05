Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.156])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1Kbhgn-0008Pc-LD
	for linux-dvb@linuxtv.org; Fri, 05 Sep 2008 22:13:54 +0200
Received: by fg-out-1718.google.com with SMTP id e21so785183fga.25
	for <linux-dvb@linuxtv.org>; Fri, 05 Sep 2008 13:13:50 -0700 (PDT)
Message-ID: <37219a840809051313k2e48a34ay42a3afa8ea6692af@mail.gmail.com>
Date: Fri, 5 Sep 2008 16:13:50 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Rebecca Sutton Koeser" <rlskoeser@gmail.com>
In-Reply-To: <4f5573e90809051258w2b7ba178w1c1ae6b93d26c569@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <mailman.596.1220644386.834.linux-dvb@linuxtv.org>
	<4f5573e90809051258w2b7ba178w1c1ae6b93d26c569@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] ATI HDTV Wonder - unknown device ac00
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

2008/9/5 Rebecca Sutton Koeser <rlskoeser@gmail.com>:
> I hope this the right place to ask this question.
>
> I bought an ATI HDTV Wonder because I thought I read that it worked in
> Linux.  But when I followed the instructions to load the firmware and get it
> working, nothing happens.  I see the notes on the wiki page (
> http://www.linuxtv.org/wiki/index.php/ATI/AMD_HDTV_Wonder ) about alternate
> subsystem IDs that are not supported, but I'm not sure how to proceed from
> there.
>
> If someone can give me instructions on how to get more information about the
> hardware I will be glad to investigate.
>
> Here's the relevant output from lspci -v
>
> 04:02.0 Multimedia controller: ATI Technologies Inc Unknown device ac00
>     Subsystem: ATI Technologies Inc Unknown device b359
>     Flags: bus master, medium devsel, latency 32, IRQ 11
>     Memory at fdb00000 (32-bit, non-prefetchable) [size=1M]
>     Memory at fdae0000 (32-bit, prefetchable) [size=128K]
>     Capabilities: [50] Power Management version 2
>
>
> Can anyone tell me, is it likely / possible that this card will work in
> linux any time soon, or should I be looking into returning it and finding
> something more likely to work?

Rebecca,

When you read that the HDTV Wonder was supported, that would be the
cx2388x-based HDTV Wonder, which uses the NXT2004 ATSC/QAM
demodulator.

The card that you have is using ATi's own chipset, which currently
does not have a driver within the v4l/dvb linux kernel subsystems.

It is _not_ likely that the card will work under Linux anytime soon.
I'm sorry to deliver the bad news.

Regards,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
