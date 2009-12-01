Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 27.mail-out.ovh.net ([91.121.30.210])
	by mail.linuxtv.org with smtp (Exim 4.69)
	(envelope-from <luca@ventoso.org>) id 1NFNb3-0007Hd-FG
	for linux-dvb@linuxtv.org; Tue, 01 Dec 2009 08:56:29 +0100
Received: from [127.0.0.1] (localhost.localdomain [127.0.0.1])
	by ventoso.org (Postfix) with ESMTP id C3E4FC4A822
	for <linux-dvb@linuxtv.org>; Tue,  1 Dec 2009 08:56:16 +0100 (CET)
Message-ID: <4B14CC1E.7030102@ventoso.org>
Date: Tue, 01 Dec 2009 08:56:14 +0100
From: Luca Olivetti <luca@ventoso.org>
MIME-Version: 1.0
To: Linux DVB <linux-dvb@linuxtv.org>
Subject: [linux-dvb] siano firmware and behaviour after resuming power
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

[Since linux-media silently discards my email --leaving through the 
stray viagra message anyway, yay-- I'm trying the old list and I hope 
that someone sees it. What bother me most is the need to unplug and 
replug the device when I power off the pc]

I just got a dvb-t usb stick from dealextreme.
The dealextreme lottery gave me a siano sms1xxx based device, usb id
187f:0201.
In the latest mercurial repository, this device requires the firmware
dvb_nova_12mhz_b0.inp but it's nowhere to be found.
I found some forum posting suggesting to use
http://www.steventoth.net/linux/sms1xxx/sms1xxx-hcw-55xxx-dvbt-01.fw
(renaming it to the name required by the driver), and I did and it worked.
Then, out of curiosity, I also tried the 03 revision
http://www.steventoth.net/linux/sms1xxx/sms1xxx-hcw-55xxx-dvbt-03.fw and
it also worked.
Since these firmwares are for hauppauge devices, I wonder if using them
will have some undesirable side-effect or there's no problem.


Oh, when I turn off the pc the stick is attached to (a vdr machine), it
still supplies 5v to the usb ports, and when I turn it on again the
stick fails. I have to unplug and replug it to make it work.
These are the messages in syslog:

Nov  1 13:57:19 vdr.ventoso.local kernel: smscore_detect_mode: line:
755: MSG_SMS_GET_VERSION_EX_REQ failed first try
Nov  1 13:57:24 vdr.ventoso.local kernel: smscore_set_device_mode: line:
829: mode detect failed -62
Nov  1 13:57:24 vdr.ventoso.local kernel: smsusb_init_device: line: 387:
smscore_start_device(...) failed
Nov  1 13:57:24 vdr.ventoso.local kernel: smsusb_onresponse: line: 120:
error, urb status -2, 0 bytes
Nov  1 13:57:24 vdr.ventoso.local last message repeated 9 times
Nov  1 13:57:24 vdr.ventoso.local kernel: sms_ir_exit:
Nov  1 13:57:24 vdr.ventoso.local kernel: smsusb: probe of 3-2:1.0
failed with error -62
Nov  1 13:57:24 vdr.ventoso.local kernel: usbcore: registered new driver
smsusb


I tried to unload the modules before switching off, followed by a usb 
reset, but without great success.

Bye
-- 
Luca






_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
