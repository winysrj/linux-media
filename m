Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <harald.albrecht@gmx.net>) id 1NWQvL-00074x-76
	for linux-dvb@linuxtv.org; Sun, 17 Jan 2010 09:55:56 +0100
Received: from mail.gmx.net ([213.165.64.20])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-c) with smtp
	for <linux-dvb@linuxtv.org>
	id 1NWQvK-0004Wd-ON; Sun, 17 Jan 2010 09:55:54 +0100
Message-ID: <4B52D098.7090108@gmx.net>
Date: Sun, 17 Jan 2010 09:55:52 +0100
From: Harald Albrecht <harald.albrecht@gmx.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] PCTV (ex Pinnacle) 74e pico USB stick DVB-T: no
	frontend registered
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello,

I've run into a roadblock problem with my PCTV 74e pico USB stick for 
receiving DVB-T. My setup is as follows: the system is a Kubuntu Kaotic 
Koala 9.10 stock distribution, kept current. The Linux kernel is thus a 
2.6.31-18-generic one as distributed by Ubuntu. It contains the stock 
kernel video4linux and I also installed the non-free firmware package in 
order to have the dvb-usb-dib0700-1.20.fw firmware at hand.

With this setup, the pico was not even properly recognized (USB VID:DID 
= 2013:0246). Yesterday I pulled the most recent set of v4l-dvb files of 
the mercury repository using "hg clone http://linuxtv.org/hg/v4l-dvb". 
For reasons I yet don't understand, this file set does not include the 
complete patch from 
http://linuxtv.org/hg/v4l-dvb/rev/87039167057078a29ca91c1bcd3369977d6ca463

While dvb-usb-ids.h does already contain the PCTV vendor ID as well as 
USB_PID_PINNACLE_PCTV74E device ID, file dib0700_devices.c does not 
contain the registration. The patch from the patchset mentioned above 
does register the 74e together with 73e. The problem now is that after 
compiling everything (by switching off build of most modules in order to 
avoid kfifo problems) and installing the new modules I hit the roadblock.

Inserting the pico and doing "dmesg | grep -i dvb" yields:
[10650.021155] dvb-usb: found a 'Pinnacle PCTV 74e' in cold state, will 
try to load a firmware
[10650.021170] usb 1-4: firmware: requesting dvb-usb-dib0700-1.20.fw
[10650.041879] dvb-usb: downloading firmware from file 
'dvb-usb-dib0700-1.20.fw'
[10650.840668] dvb-usb: found a 'Pinnacle PCTV 74e' in warm state.
[10650.840870] dvb-usb: will pass the complete MPEG2 transport stream to 
the software demuxer.
[10650.841284] DVB: registering new adapter (Pinnacle PCTV 74e)
[10650.908062] dvb-usb: no frontend was attached by 'Pinnacle PCTV 74e'
[10650.908292] input: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:1d.7/usb1/1-4/input/input21
[10650.908429] dvb-usb: schedule remote query interval to 50 msecs.
[10650.908441] dvb-usb: Pinnacle PCTV 74e successfully initialized and 
connected.

It seems that the frontend registration did (silently) fail, at least 
from the perspective of dib0700_devices.c. Has anyone information 
whether the 74e shares the same frontend with the 73e?

With best regards,
-- Harald

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
