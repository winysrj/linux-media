Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from sd-green-dreamhost-133.dreamhost.com ([208.97.187.133]
	helo=webmail4.sd.dreamhost.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <cl@qgenuity.com>) id 1L7f0E-0003Rc-16
	for linux-dvb@linuxtv.org; Wed, 03 Dec 2008 00:50:03 +0100
Received: from webmail.qgenuity.com (localhost [127.0.0.1])
	by webmail4.sd.dreamhost.com (Postfix) with ESMTP id C80BD302B7
	for <linux-dvb@linuxtv.org>; Tue,  2 Dec 2008 15:49:55 -0800 (PST)
Message-ID: <427d6fd3d8cc5242de113141bc51aae6.squirrel@webmail.qgenuity.com>
Date: Tue, 2 Dec 2008 15:49:55 -0800 (PST)
From: cl@qgenuity.com
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Hauppage HVR-950 on Opensuse 10.3
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

I recently tried to install an Hauppage HVR-950 on opensuse 10.3 the
system is an AMD64 with kernel 2.6.22.19 using the v4l-dvb software.

What I did:

1) Firmware:
wget
http://www.steventoth.net/linux/xc5000/HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip

unzip HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip Driver85/hcw85bda.sys
./extract_xc3028.pl
cp xc3028-v27.fw /lib/firmware

(The firmware is there in the /lib/firmware directory)

2) Downloaded drivers with hg clone http://linuxtv.org/hg/v4l-dvb

3) make & make install in v4l-dvb directory

4) Plugged usb dongle into machine

The result that I get is:

au0828: disagrees about version of symbol tveeprom_read
au0828: Unknown symbol tveeprom_read
au0828: disagrees about version of symbol tveeprom_hauppauge_analog
au0828: Unknown symbol tveeprom_hauppauge_analog
au0828: disagrees about version of symbol tveeprom_read
au0828: Unknown symbol tveeprom_read
au0828: disagrees about version of symbol tveeprom_hauppauge_analog
au0828: Unknown symbol tveeprom_hauppauge_analog
au0828: disagrees about version of symbol tveeprom_read
au0828: Unknown symbol tveeprom_read
au0828: disagrees about version of symbol tveeprom_hauppauge_analog
au0828: Unknown symbol tveeprom_hauppauge_analog

no /dev/video0 device is created and it looks as if the hardware is not
installed. What am I doing wrong?


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
