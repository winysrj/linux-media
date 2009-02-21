Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rupert.bearstech.com ([193.84.18.54])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lhaond@bearstech.com>) id 1LagLU-0001O3-R7
	for linux-dvb@linuxtv.org; Sat, 21 Feb 2009 02:07:58 +0100
Received: from localhost (localhost [127.0.0.1])
	by rupert.bearstech.com (Postfix) with ESMTP id 64546100013
	for <linux-dvb@linuxtv.org>; Sat, 21 Feb 2009 02:07:53 +0100 (CET)
Received: from rupert.bearstech.com ([127.0.0.1])
	by localhost (rupert.bearstech.com [127.0.0.1]) (amavisd-new,
	port 10024) with LMTP id qn4v39GoSY-9 for <linux-dvb@linuxtv.org>;
	Sat, 21 Feb 2009 02:07:53 +0100 (CET)
Received: from [192.168.0.24] (beavis.scaryflop.com [82.67.15.220])
	by rupert.bearstech.com (Postfix) with ESMTP id 2F4E510000A
	for <linux-dvb@linuxtv.org>; Sat, 21 Feb 2009 02:07:53 +0100 (CET)
Message-ID: <499F53E8.6050608@bearstech.com>
Date: Sat, 21 Feb 2009 02:07:52 +0100
From: Laurent Haond <lhaond@bearstech.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Can I use AVerTV Volar Black HD (A850) with Linux ?
Reply-To: linux-media@vger.kernel.org
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
I bought an AverMedia Volar Black HD too.
I opened it, i can confirm the device contains a AF9015N1 chip and a
MXL5003S tuner.


I think there was something missing your diff Antti :
@@ -1404,7 +1405,7 @@

                .i2c_algo = &af9015_i2c_algo,

-               .num_device_descs = 7,
+               .num_device_descs = 8,
                .devices = {
                        {
                                .name = "Xtensions XD-380",

After patching af9015.c file, when i plug it, modules are loading but it
seems that the tuner did not work :

Module                  Size  Used by
mxl5005s               32388  1
af9013                 18756  1
dvb_usb_af9015         27184  0
dvb_usb                19916  1 dvb_usb_af9015
dvb_core               88676  1 dvb_usb


$ dmesg
usb 4-1: configuration #1 chosen from 1 choice
dvb-usb: found a 'AVerMedia A850' in cold state, will try to load a firmware
firmware: requesting dvb-usb-af9015.fw
dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
dvb-usb: found a 'AVerMedia A850' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
DVB: registering new adapter (AVerMedia A850)
af9013: firmware version:4.95.0
DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
MXL5005S: Attached at address 0xc6
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
DVB: registering new adapter (AVerMedia A850)
af9015: command failed:2
af9015: firmware copy to 2nd frontend failed, will disable it
dvb-usb: no frontend was attached by 'AVerMedia A850'
dvb-usb: AVerMedia A850 successfully initialized and connected.
usbcore: registered new interface driver dvb_usb_af9015

$ dvbscan /usr/share/dvb/dvb-t/fr-Lyon-Fourviere
Unable to query frontend status

$ dmesg
af9015: recv bulk message failed:-110
af9013: I2C read failed reg:d417


Anything else we can try Antti ?

Thanks


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
