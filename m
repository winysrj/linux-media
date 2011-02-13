Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <josu.lazkano@gmail.com>) id 1PogtE-0006Qf-W1
	for linux-dvb@linuxtv.org; Sun, 13 Feb 2011 19:41:45 +0100
Received: from mail-iy0-f182.google.com ([209.85.210.182])
	by mail.tu-berlin.de (exim-4.74/mailfrontend-d) with esmtps
	[TLSv1:RC4-SHA:128] for <linux-dvb@linuxtv.org>
	id 1PogtE-00055Q-1H; Sun, 13 Feb 2011 19:41:44 +0100
Received: by iyb26 with SMTP id 26so4223131iyb.41
	for <linux-dvb@linuxtv.org>; Sun, 13 Feb 2011 10:41:41 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 13 Feb 2011 19:41:41 +0100
Message-ID: <AANLkTi=WT6cAwhmhggWfabWjaJHbjHoHSfLBuNdmp2Hi@mail.gmail.com>
From: Josu Lazkano <josu.lazkano@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] requesting firmware
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

Hello, I sometimes had these message on dmesg:

[   46.592313] ds3000_firmware_ondemand: Waiting for firmware upload
(dvb-fe-ds3000.fw)...
[   46.592326] cx23885 0000:02:00.0: firmware: requesting dvb-fe-ds3000.fw
[   46.675035] ds3000_firmware_ondemand: Waiting for firmware upload(2)...


The firmware is on the correct folder:

# ls -l /lib/firmware/ | grep ds3000
-rw-r--r-- 1 root root  8192 dic  6 14:54 dvb-fe-ds3000.fw

What is happening? Is this normal?

-- 
Josu Lazkano

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
