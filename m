Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay10.mail.uk.clara.net ([80.168.70.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <news@onastick.clara.co.uk>) id 1L4hDc-0005ou-4l
	for linux-dvb@linuxtv.org; Mon, 24 Nov 2008 20:35:37 +0100
Received: from [79.123.72.254] (port=10526 helo=mail.onasticksoftware.net)
	by relay10.mail.uk.clara.net with esmtp (Exim 4.69)
	(envelope-from <news@onastick.clara.co.uk>) id 1L4hDX-00023w-6T
	for linux-dvb@linuxtv.org; Mon, 24 Nov 2008 19:35:31 +0000
Received: from onasticksoftware.net (lapdog.onasticksoftware.net [192.168.0.3])
	by mail.onasticksoftware.net (Postfix) with ESMTP id 491418C884
	for <linux-dvb@linuxtv.org>; Mon, 24 Nov 2008 19:35:26 +0000 (GMT)
Message-ID: <u0lnYVBoGwKJFwJg@onasticksoftware.net>
Date: Mon, 24 Nov 2008 19:34:00 +0000
To: linux-dvb@linuxtv.org
From: jon bird <news@onastick.clara.co.uk>
References: <RCbI1iFQ0HKJFw8A@onasticksoftware.net>
	<492A8A43.4060001@rusch.name>
In-Reply-To: <492A8A43.4060001@rusch.name>
MIME-Version: 1.0
Subject: Re: [linux-dvb] Nova/dib0700/i2C write failed
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

In article <492A8A43.4060001@rusch.name>, Holger Rusch 
<holger@rusch.name> writes
>Hi,
>
>jon bird schrieb:
>> Just to provide a bit more info on what seems to be an ongoing issue
>> with these devices, I updated my kernel (2.6.26) dvb drivers with a
>> snapshot from here on 19/11/08 (v4l-dvb-5dc4a6b381f6), it has
>> marginally improved the behaviour but only slightly. Previously,
>> sporadic 'usb 1-4: USB disconnect, address 2' followed by 'mt2060 I2C
>> write failed' cropping up generally put the khubd into a spin with
>> repeated messages of the form:
>
>... are you sure that it is not a problem of the usb ports?
>
>I got an MB with SB700 Chipset and it seems to have the same problems as
>the SB600 with the USB ports (disconnects here and then).
>
[...]

could be although on perusing the mailing list archives this seemed to 
be a recurring problem of which various attempts have been made to 
investigate/fix but there didn't seem to be a conclusion to it all. 
Hence I just thought I'd see what the latest state of play was and 
report back anything potentially useful.....

Don't know what the USB chipset is, though it's a VIA m/board so could 
well be one of their own.

j.


-- 
== jon bird - software engineer
== <reply to address _may_ be invalid, real mail below>
== <reduce rsi, stop using the shift key>
== posted as: news 'at' onastick 'dot' clara.co.uk


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
