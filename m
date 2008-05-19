Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail02.syd.optusnet.com.au ([211.29.132.183])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <pjama@optusnet.com.au>) id 1JyE8a-0000zA-Aj
	for linux-dvb@linuxtv.org; Tue, 20 May 2008 00:47:26 +0200
Received: from zerver.home.pjama.net
	(c122-104-130-106.kelvn2.qld.optusnet.com.au [122.104.130.106])
	by mail02.syd.optusnet.com.au (8.13.1/8.13.1) with ESMTP id
	m4JMlCZo020371
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-dvb@linuxtv.org>; Tue, 20 May 2008 08:47:13 +1000
Received: from pjama.net (localhost [127.0.0.1])
	by zerver.home.pjama.net (8.13.8+Sun/8.13.8) with ESMTP id
	m4JMl8q9006416
	for <linux-dvb@linuxtv.org>; Tue, 20 May 2008 08:47:08 +1000 (EST)
Message-ID: <56913.192.168.200.51.1211237228.squirrel@pjama.net>
Date: Tue, 20 May 2008 08:47:08 +1000 (EST)
From: "pjama" <pjama@optusnet.com.au>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] IR for Afatech 901x
Reply-To: pjama@optusnet.com.au
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
I see there's some activity from Antti in the af9015-mxl500x-copy-fw area
for remotes.

I got, compiled and installed the latest (although there's a NEW one just
4 minutes old) code 737994f33e83 to see if there's any action for my IR
remote bundled with my DigitalNow TinyTwin USB stick. I'm running
mythbuntu 8.04

I'm not even sure if I'm on the right track here but entries like the
following in dmesg got me excited!
input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:02.1/usb2/2-2/input/input7
dvb-usb: schedule remote query interval to 150 msecs.
dvb-usb: DigitalNow TinyTwin DVB-T Receiver successfully initialized and
connected.

I'm not having ANY luck extracting any life out of IR though:

# sudo irrecord -d /devices/pci0000:00/0000:00:02.1/usb2/2-2/input/input7
test.conf
irrecord -  application for recording IR-codes for usage with lirc
Copyright (C) 1998,1999 Christoph Bartelmus(lirc@bartelmus.de)
irrecord: could not get file information for
/devices/pci0000:00/0000:00:02.1/usb2/2-2/input/input7
irrecord: default_init(): No such file or directory
irrecord: could not init hardware (lircd running ? --> close it, check
permissions)

Same story with /dev/input/event7, I've turned lirc off and irw just
refuses  to connect.

Is there anything I should try or anything I can test?

Thanks
Peter


-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
