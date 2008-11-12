Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from stipula.dds.nl ([85.17.178.134])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <miki@dds.nl>) id 1L03rj-0004fK-PF
	for linux-dvb@linuxtv.org; Wed, 12 Nov 2008 01:45:52 +0100
Received: from localhost (localhost [127.0.0.1])
	by stipula.dds.nl (Postfix) with ESMTP id 8EC9B795DA8
	for <linux-dvb@linuxtv.org>; Wed, 12 Nov 2008 01:45:48 +0100 (CET)
Received: from [192.168.1.100] (cc921761-b.ensch1.ov.home.nl [82.74.124.196])
	by stipula.dds.nl (Postfix) with ESMTP id AAF6D795D9C
	for <linux-dvb@linuxtv.org>; Wed, 12 Nov 2008 01:45:45 +0100 (CET)
From: Alain Kalker <miki@dds.nl>
To: linux-dvb@linuxtv.org
In-Reply-To: <1226450381.20387.10.camel@miki-debian.ensch1.ov.home.nl>
References: <1226450381.20387.10.camel@miki-debian.ensch1.ov.home.nl>
Date: Wed, 12 Nov 2008 01:46:15 +0100
Message-Id: <1226450775.20387.15.camel@miki-debian.ensch1.ov.home.nl>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Remote HID device repeating keys problem [SOLVED]
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

Op woensdag 12-11-2008 om 01:39 uur [tijdzone +0100], schreef Alain
Kalker:
> When I was testing my patch to support the Digittrade DVB-T USB Stick
> remote, I experienced a problem with remote keys repeating until I hit a
> key on the keyboard, similar to the problem with the Nova-T-500 remote.
> My guess that it had something to do with the additional HID device the
> stick registers for the remote turned out to be right.
> 
> I created the file /etc/modprobe.d/usbhid containing:
> 
> options usbhid quirks=0x15a4:0x9016:0x4

Obvious omission: The above line only works for a generic af9015 device.
For other devices that register a HID device, you need to replace the
first 2 hex numbers:

options usbhid quirks=0x<VendorID:0x<ProductID>:0x4

Sadly, this method is documented only in the kernel source file...

Alain


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
