Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]
	helo=mail.wilsonet.com) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jarod@wilsonet.com>) id 1KYi3E-0005Rv-Cu
	for linux-dvb@linuxtv.org; Thu, 28 Aug 2008 16:00:42 +0200
Received: from mail.wilsonet.com (chronos.wilsonet.com [127.0.0.1])
	by mail.wilsonet.com (Postfix) with ESMTP id 454EF17B0F
	for <linux-dvb@linuxtv.org>; Thu, 28 Aug 2008 10:00:35 -0400 (EDT)
Received: from mail.wilsonet.com ([127.0.0.1])
	by mail.wilsonet.com (mail.wilsonet.com [127.0.0.1]) (amavisd-maia,
	port 10024) with ESMTP id 30812-10 for <linux-dvb@linuxtv.org>;
	Thu, 28 Aug 2008 10:00:31 -0400 (EDT)
Received: from [10.16.16.50] (lan-nat-pool-bos.redhat.com [66.187.234.200])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested) (Authenticated sender: jarod)
	by mail.wilsonet.com (Postfix) with ESMTPSA id A72BF17B0E
	for <linux-dvb@linuxtv.org>; Thu, 28 Aug 2008 10:00:31 -0400 (EDT)
From: Jarod Wilson <jarod@wilsonet.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <48B6ADB3.5010003@glidos.net>
References: <48B5D5CF.3060401@glidos.net> <48B6083B.5000803@linuxtv.org>
	<48B64690.4060205@glidos.net>
	<37219a840808280556q2ee85291o7ad1afb75a7ed6f6@mail.gmail.com>
	<48B6ADB3.5010003@glidos.net>
Date: Thu, 28 Aug 2008 10:00:31 -0400
Message-Id: <1219932031.5654.3.camel@xavier.wilsonet.com>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Looks like there's a new unsupported WinTV Nova T
 500 out there
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

On Thu, 2008-08-28 at 14:52 +0100, Paul Gardiner wrote:
> Michael Krufky wrote:
> > On Thu, Aug 28, 2008 at 2:32 AM, Paul Gardiner <lists@glidos.net> wrote:
> >> Michael Krufky wrote:
> >>> Paul Gardiner wrote:
> >>>> Just trying to get MythTV up and running, plugged in my
> >>>> newly arrived WinTV Nova T 500 and no /dev/dvb directory
> >>>> appeared. It's not the known probelmatic Diversity version,
> >>>> but it does say v2.1 on the box, and it seems to have
> >>>> different chips. :-(
> >>>>
> >>>> Just thought I'd warn people and maybe ask if anyone
> >>>> else has run into this.
> >>> What is the 5-digit model number of your PCI card?
> >> Says 99101 LF
> >>     Rev D8B5
[...]
> > It might be no change at all.  I'd look it up in the code, but I don't
> > even know what the usb ID's of your device are, offhand -- what are
> > they?  (do "lsusb -n | grep 2040" )
> 
> I get no output from that.

Casual observer butting in here... Mike, why would lsusb output be at
all relevant if its a PCI card? :)



-- 
Jarod Wilson
jarod@wilsonet.com


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
