Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35289 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756565AbZFYOgi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2009 10:36:38 -0400
Message-ID: <4A438B76.9070906@iki.fi>
Date: Thu, 25 Jun 2009 17:36:38 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Patrick Boettcher <patrick.boettcher@desy.de>,
	Albert Comerma <albert.comerma@gmail.com>,
	linux-media@vger.kernel.org
Subject: Yuan EC372S: dib7000p_i2c_enumeration failed
Content-Type: multipart/mixed;
 boundary="------------090307030109000001000801"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090307030109000001000801
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

moikka!
I just got USB-ExpressCard converter and tested one of my old sticks. 
Here is result. Any idea?

dib0700: stk7700P2_frontend_attach: dib7000p_i2c_enumeration failed. 
Cannot continue

regards
Antti
-- 
http://palosaari.fi/

--------------090307030109000001000801
Content-Type: text/plain;
 name="Yuan_EC372S.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Yuan_EC372S.txt"

Jun 25 17:30:56 localhost kernel: usb 1-5: new high speed USB device using ehci_hcd and address 7
Jun 25 17:30:56 localhost kernel: usb 1-5: New USB device found, idVendor=1164, idProduct=1edc
Jun 25 17:30:56 localhost kernel: usb 1-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Jun 25 17:30:56 localhost kernel: usb 1-5: Product: STK7700D
Jun 25 17:30:56 localhost kernel: usb 1-5: Manufacturer: YUANRD
Jun 25 17:30:56 localhost kernel: usb 1-5: SerialNumber: 0000000001
Jun 25 17:30:56 localhost kernel: usb 1-5: configuration #1 chosen from 1 choice
Jun 25 17:30:56 localhost kernel: dib0700: loaded with support for 9 different device-types
Jun 25 17:30:56 localhost kernel: dvb-usb: found a 'Yuan EC372S' in cold state, will try to load a firmware
Jun 25 17:30:56 localhost kernel: usb 1-5: firmware: requesting dvb-usb-dib0700-1.20.fw
Jun 25 17:30:56 localhost kernel: dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
Jun 25 17:30:59 localhost kernel: dib0700: firmware started successfully.
Jun 25 17:30:59 localhost kernel: dvb-usb: found a 'Yuan EC372S' in warm state.
Jun 25 17:30:59 localhost kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
Jun 25 17:30:59 localhost kernel: DVB: registering new adapter (Yuan EC372S)
Jun 25 17:30:59 localhost kernel: dib0700: stk7700P2_frontend_attach: dib7000p_i2c_enumeration failed.  Cannot continue
Jun 25 17:30:59 localhost kernel:
Jun 25 17:30:59 localhost kernel: dvb-usb: no frontend was attached by 'Yuan EC372S'
Jun 25 17:30:59 localhost kernel: input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:0b.1/usb1/1-5/input/input9
Jun 25 17:30:59 localhost kernel: dvb-usb: schedule remote query interval to 50 msecs.
Jun 25 17:30:59 localhost kernel: dvb-usb: Yuan EC372S successfully initialized and connected.
Jun 25 17:30:59 localhost kernel: usbcore: registered new interface driver dvb_usb_dib0700
^C
[root@localhost ~]# uname -a
Linux localhost 2.6.29.5-191.fc11.x86_64 #1 SMP Tue Jun 16 23:23:21 EDT 2009 x86_64 x86_64 x86_64 GNU/Linux


--------------090307030109000001000801--
