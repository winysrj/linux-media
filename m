Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mk-outboundfilter-6.mail.uk.tiscali.com ([212.74.114.14])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@glidos.net>) id 1KYiAo-0006Ih-O9
	for linux-dvb@linuxtv.org; Thu, 28 Aug 2008 16:08:32 +0200
Message-ID: <48B6B0FE.9030109@glidos.net>
Date: Thu, 28 Aug 2008 15:06:54 +0100
From: Paul Gardiner <lists@glidos.net>
MIME-Version: 1.0
To: Jarod Wilson <jarod@wilsonet.com>
References: <48B5D5CF.3060401@glidos.net>
	<48B6083B.5000803@linuxtv.org>	<48B64690.4060205@glidos.net>	<37219a840808280556q2ee85291o7ad1afb75a7ed6f6@mail.gmail.com>	<48B6ADB3.5010003@glidos.net>
	<1219932031.5654.3.camel@xavier.wilsonet.com>
In-Reply-To: <1219932031.5654.3.camel@xavier.wilsonet.com>
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

Jarod Wilson wrote:
>>> It might be no change at all.  I'd look it up in the code, but I don't
>>> even know what the usb ID's of your device are, offhand -- what are
>>> they?  (do "lsusb -n | grep 2040" )
>> I get no output from that.
> 
> Casual observer butting in here... Mike, why would lsusb output be at
> all relevant if its a PCI card? :)

I think Mike's right on this. The card is PCI, but it provides a
USB hub to then support the two tuner devices, as far as I know.

Cheers,
	Paul.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
