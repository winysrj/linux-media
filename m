Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <kvijay75anand@googlemail.com>) id 1Q2tWu-0002as-FX
	for linux-dvb@linuxtv.org; Fri, 25 Mar 2011 00:01:24 +0100
Received: from mail-bw0-f54.google.com ([209.85.214.54])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-3) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1Q2tWu-0002D4-E8; Fri, 25 Mar 2011 00:01:24 +0100
Received: by bwz12 with SMTP id 12so740779bwz.41
	for <linux-dvb@linuxtv.org>; Thu, 24 Mar 2011 16:01:23 -0700 (PDT)
From: Vijay <kvijay75anand@googlemail.com>
To: linux-dvb@linuxtv.org
Date: Thu, 24 Mar 2011 18:20:32 +0100
Message-ID: <1300987232.3175.6.camel@vinux>
Mime-Version: 1.0
Subject: [linux-dvb] MSI Digi vox Trio DVB (usb) does not work on my 64bit
	linux
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

Dear linuxtv team,

The MSI Digi vox Trio DVB (usb) does not work on my 64bit linux (ubuntu
10.10)PC with kernel version 2.6.35-28-generic. It however works on a
windows machine so the device is confirmed to work. 
The lsusb shows "Bus 001 Device 006: ID eb1a:2885 eMPIA Technology,
Inc." 
Search on google gives me an impression that some of the em28xx devices
are supported. However the device I have,em2885, does not work. Is this
device supported ? If yes, how can I make it work ? If not, will it be
supported at later on.

Cheers,
Vinux  



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
