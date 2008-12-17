Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]
	helo=mail.wilsonet.com) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jarod@wilsonet.com>) id 1LCoFM-0006V7-Kb
	for linux-dvb@linuxtv.org; Wed, 17 Dec 2008 05:42:58 +0100
Received: from mail.wilsonet.com (chronos.wilsonet.com [127.0.0.1])
	by mail.wilsonet.com (Postfix) with ESMTP id CA7DF17B0A
	for <linux-dvb@linuxtv.org>; Tue, 16 Dec 2008 23:42:51 -0500 (EST)
Received: from mail.wilsonet.com ([127.0.0.1])
	by mail.wilsonet.com (mail.wilsonet.com [127.0.0.1]) (amavisd-maia,
	port 10024) with ESMTP id 10572-05 for <linux-dvb@linuxtv.org>;
	Tue, 16 Dec 2008 23:42:48 -0500 (EST)
Received: from [172.31.27.12] (static-72-93-233-5.bstnma.fios.verizon.net
	[72.93.233.5])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested) (Authenticated sender: jarod)
	by mail.wilsonet.com (Postfix) with ESMTPSA id 219BA17AB2
	for <linux-dvb@linuxtv.org>; Tue, 16 Dec 2008 23:42:48 -0500 (EST)
From: Jarod Wilson <jarod@wilsonet.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <20081217002735.GF45924@dereel.lemis.com>
References: <20081217002735.GF45924@dereel.lemis.com>
Date: Tue, 16 Dec 2008 23:42:47 -0500
Message-Id: <1229488967.8328.2.camel@icarus.wilsonet.com>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Support for Afatech 9035 (Aldi Fission USB tuner)
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

On Wed, 2008-12-17 at 11:27 +1100, Greg 'groggy' Lehey wrote:
> I have a dual USB tuner from Aldi, which they call a Fission dual high
> definition DVB-T receiver.
[...]
> dmesg output (complete version is attached)
> says:
> 
> [  789.696018] usb 4-3: new high speed USB device using ehci_hcd and
> address 2
> [  789.846003] usb 4-3: configuration #1 chosen from 1 choice
> [  790.052259] usbcore: registered new interface driver hiddev
> [  790.056703] input: Afa Technologies Inc. AF9035A USB Device
> as /devices/pci0000:00/0000:00:10.3/usb4/4-3/4-3:1.1/input/input8
> [  790.057902] input,hidraw0: USB HID v1.01 Keyboard [Afa Technologies
> Inc. AF9035A USB Device] on usb-0000:00:10.3-3
> [  790.058287] usbcore: registered new interface driver usbhid
> [  790.058511] usbhid: v2.6:USB HID core driver
> 
> I've been following the instructions on the wiki, and I've got hold of
> the firmware files dvb-usb-af9015.fw and xc3028-v27.fw.  The former
> doesn't get loaded; the latter gets loaded even if the stick isn't
> present

>From your dmesg output, it appears the usbhid driver has claimed the
device, thus the dvb driver can't grab it. If I recall correctly, usbhid
is a module on ubuntu, so you should be able to tell it not to load
w/some modprobe options (which I don't remember off the top of my head).

--jarod



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
