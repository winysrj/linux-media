Return-Path: linux-dvb-bounces+mchehab=redhat.com@linuxtv.org
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <oliver@schinagl.nl>) id 1RfFSu-0007V3-Oq
	for linux-dvb@linuxtv.org; Mon, 26 Dec 2011 19:40:30 +0100
Received: from 7of9.schinagl.nl ([88.159.158.68])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-3) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1RfFSu-000175-F5; Mon, 26 Dec 2011 19:40:04 +0100
Received: from [10.2.0.137] (unknown [10.2.0.137])
	by 7of9.schinagl.nl (Postfix) with ESMTPA id 1D69120E35
	for <linux-dvb@linuxtv.org>; Mon, 26 Dec 2011 19:40:45 +0100 (CET)
Message-ID: <4EF8BF82.2050609@schinagl.nl>
Date: Mon, 26 Dec 2011 19:40:02 +0100
From: Oliver Schinagl <oliver@schinagl.nl>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] saa7146 based TT1500 dvb-t doesn't find channels
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
Errors-To: linux-dvb-bounces+mchehab=redhat.com@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi!

I'm using a TT1500-dvbt card, using the saa7146 budget_ci driver. On my 
tv-pc I have 2 partitions with gentoo and latest mythbuntu. Under gentoo 
everything works-ish. Under mythbuntu however, I cannot get it to find 
any channels using scan, dvbscan or w_scan. I copied the firmware for 
the tda10046h from the gentoo partition, thinking that may make the 
difference, but but even though binary different, they both report 
revision 29 (and it still doesn't work). w_scan does mention my tuner 
etc and even says 'signal ok' on certain frequencies, but eventually 
ends with 0 services found. I'm dumbfounded at to why I cannot get it to 
work, when the only difference is the OS.

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
