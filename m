Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1L3VS8-0002JR-SD
	for linux-dvb@linuxtv.org; Fri, 21 Nov 2008 13:49:42 +0100
Received: from [212.12.32.49] (helo=smtp.work.de)
	by mail.work.de with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1L3VS5-00009f-CR
	for linux-dvb@linuxtv.org; Fri, 21 Nov 2008 13:49:37 +0100
Received: from [92.96.5.173] (helo=[192.168.1.10])
	by smtp.work.de with esmtpa (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1L3VS5-0005sf-3x
	for linux-dvb@linuxtv.org; Fri, 21 Nov 2008 13:49:37 +0100
Message-ID: <4926AE59.8060001@gmail.com>
Date: Fri, 21 Nov 2008 16:49:29 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] STV0900, STV0903 (BAB) frontend drivers
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

Hi all,

I am pleased to let you know that an initial version of the STV090x
driver to support the STV0900 Dual DVB-S2 and the STV0903 Single DVB-S2
Broadcast devices (BAB) (currently only the Broadcast chips are
supported, the Professional chips (AAB) will be supported only in the
Broadcast Mode alone for now).

After quite some work, the STV090x driver is available in the SAA716x
repository at

http://jusst.de/hg/saa716x

Currently the driver is heavily in flux. The initial driver is based on
the multiproto API, a V5 version will be available soon.

Have fun.

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
