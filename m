Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpout.karoo.kcom.com ([212.50.160.34]:17710 "EHLO
	smtpout.karoo.kcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbZKSQrj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2009 11:47:39 -0500
Received: from [192.168.1.239] ([192.168.1.239])
	by zebra.wentnet.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id nAJGlaTI003615
	for <linux-media@vger.kernel.org>; Thu, 19 Nov 2009 16:47:38 GMT
Message-ID: <4B0576A7.7000103@orange.fr>
Date: Thu, 19 Nov 2009 16:47:35 +0000
From: Andy Low <andrew.low@orange.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [Fwd: Anyone got a KWorld USB DVB-T TV Stick II (VS-DVB-T 395U) to
 work properly?]
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I have just bought a KWorld USB DVB-T TV Stick II (VS-DVB-T 395U). It
works well in Windows but it will only receive 2 of the 6 local
multiplexes under linux.

I have tried it with OpenSuse 11.2 (kernel 2.6.31)  both out of the box
and with v4l from linuxtv.org/hg/~anttip/af9015.
Also with Opensuse 11.0 (kernel 2.6.25) with v4l from
linuxtv.org/hg/~anttip/af9015.

The results are always the same...

It is recognised and loads correctly according to /var/log/messages:

...kernel: usb 2-7: new high speed USB device using ehci_hcd and address 5
...kernel: usb 2-7: configuration #1 chosen from 1 choice
...kernel: dvb-usb: found a 'KWorld USB DVB-T TV Stick II (VS-DVB-T
395U)' in cold state, will try to load a firmware
...kernel: dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
...kernel: dvb-usb: found a 'KWorld USB DVB-T TV Stick II (VS-DVB-T
395U)' in warm state.
...kernel: dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
...kernel: DVB: registering new adapter (KWorld USB DVB-T TV Stick II
(VS-DVB-T 395U))
...kernel: af9013: firmware version:4.95.0
...kernel: DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
...kernel: Quantek QT1010 successfully identified.
...kernel: input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:0b.1/usb2/2-7/input/input6
...kernel: dvb-usb: schedule remote query interval to 150 msecs.
...kernel: dvb-usb: KWorld USB DVB-T TV Stick II (VS-DVB-T 395U)
successfully initialized and connected.
...kernel: usb 2-7: New USB device found, idVendor=1b80, idProduct=e39b
...kernel: usb 2-7: New USB device strings: Mfr=1, Product=2, SerialNumber=0
...kernel: usb 2-7: Product: DVB-T 2
...kernel: usb 2-7: Manufacturer: Afatech

Using AUTOSCAN in Kaffeine finds just 2 multiplexes and plays them well
with no errors.  During the search it shows good signal strength on
various other channels but doesn't get lock.  Similar behaviour using
the scan utility.  The 2 multiplexes it does find have the same
parameters (apart from frequency!) I0B8C34D34M16T2G32Y0.

Any suggestions?  Many thanks,  Andy



