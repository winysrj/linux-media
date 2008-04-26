Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.ax.ru ([80.247.32.138] helo=rfn.ru)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <huge@ax.ru>) id 1JphEp-00014o-U9
	for linux-dvb@linuxtv.org; Sat, 26 Apr 2008 12:02:42 +0200
Received: from [194.46.227.1] (HELO hugex2.itwise.net)
	by rfn.ru (CommuniGate Pro SMTP 4.2.8)
	with ESMTP id 81397574 for linux-dvb@linuxtv.org;
	Sat, 26 Apr 2008 14:01:55 +0400
Message-ID: <4812EF9D.2030000@ax.ru>
Date: Sat, 26 Apr 2008 10:02:21 +0100
From: Pavel Smirnov <huge@ax.ru>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] hvr4000-dvb firmware loading issue
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

Experiencing issue with Hauppauge HVR4000 not loading firmware even 
though it was doing this on another system using same firmware file and 
same version of HVR source :(

Background:
    HVR4000 card
Kernel:
    2.6.24.5 vanilla
Source from:
    hvr4000-dvb

modprobe cx88_dvb
loads ok, expected messages appear in the syslog

md5sum /lib/firmware/dvb-fe-cx24116.fw
2f0d3966e8ef44ac971cfa98d536aaaf  /lib/firmware/dvb-fe-cx24116.fw

when doing dvbscan I'm getting this:

==> /var/log/messages <==
Apr 26 10:35:59 boxer kernel: cx24116: cx24116_initfe()
Apr 26 10:35:59 boxer kernel: cx24116: cx24116_set_tone(1)
Apr 26 10:35:59 boxer kernel: cx24116: cx24116_cmd_execute()
Apr 26 10:35:59 boxer kernel: cx24116: cx24116_firmware_ondemand()
Apr 26 10:35:59 boxer kernel: cx24116: cx24116: read reg 0x20, value 0x00
Apr 26 10:35:59 boxer kernel: cx24116: cx24116_cmd_execute: 0x00 == 0x22
Apr 26 10:35:59 boxer kernel: cx24116: cx24116: cx24116_writereg: write 
reg 0x00, value 0x22
Apr 26 10:35:59 boxer kernel: cx24116: cx24116_cmd_execute: 0x01 == 0x00
Apr 26 10:35:59 boxer kernel: cx24116: cx24116: cx24116_writereg: write 
reg 0x01, value 0x00
Apr 26 10:35:59 boxer kernel: cx24116: cx24116: cx24116_writereg: write 
reg 0x1f, value 0x01
Apr 26 10:35:59 boxer kernel: cx24116: cx24116: read reg 0x1f, value 0x01
Apr 26 10:36:00 boxer last message repeated 63 times
Apr 26 10:36:00 boxer kernel: cx24116_cmd_execute() Firmware not responding




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
