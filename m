Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]
	helo=mail.wilsonet.com) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jarod@wilsonet.com>) id 1KYiBa-0006ja-QJ
	for linux-dvb@linuxtv.org; Thu, 28 Aug 2008 16:09:20 +0200
From: Jarod Wilson <jarod@wilsonet.com>
To: Paul Gardiner <paul@laser-point.co.uk>
In-Reply-To: <48B6B084.5070504@laser-point.co.uk>
References: <48B5D5CF.3060401@glidos.net> <48B6083B.5000803@linuxtv.org>
	<48B64690.4060205@glidos.net>
	<37219a840808280556q2ee85291o7ad1afb75a7ed6f6@mail.gmail.com>
	<48B6ADB3.5010003@glidos.net>
	<1219932031.5654.3.camel@xavier.wilsonet.com>
	<48B6B084.5070504@laser-point.co.uk>
Date: Thu, 28 Aug 2008 10:09:10 -0400
Message-Id: <1219932550.5654.6.camel@xavier.wilsonet.com>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
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

On Thu, 2008-08-28 at 15:04 +0100, Paul Gardiner wrote:
> Jarod Wilson wrote:
> >>> It might be no change at all.  I'd look it up in the code, but I don't
> >>> even know what the usb ID's of your device are, offhand -- what are
> >>> they?  (do "lsusb -n | grep 2040" )
> >> I get no output from that.
> > 
> > Casual observer butting in here... Mike, why would lsusb output be at
> > all relevant if its a PCI card? :)
> 
> I think Mike's right on this. The card is PCI, but it provides a
> USB hub to then support the two tuner devices, as far as I know.

Ah, so it is!

http://www.mythtv.org/wiki/index.php/Hauppauge_WinTV_Nova-T_500_PCI

Never knew such a beast existed. I'll shut up now. :)



-- 
Jarod Wilson
jarod@wilsonet.com


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
