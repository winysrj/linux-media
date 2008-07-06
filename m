Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <laasa@gmx.de>) id 1KFTxf-0007eT-AK
	for linux-dvb@linuxtv.org; Sun, 06 Jul 2008 15:07:27 +0200
Received: from mail-in-16-z2.arcor-online.net (mail-in-16-z2.arcor-online.net
	[151.189.8.33])
	by mail-in-06.arcor-online.net (Postfix) with ESMTP id E776B31E95B
	for <linux-dvb@linuxtv.org>; Sun,  6 Jul 2008 15:07:22 +0200 (CEST)
Received: from mail-in-07.arcor-online.net (mail-in-07.arcor-online.net
	[151.189.21.47])
	by mail-in-16-z2.arcor-online.net (Postfix) with ESMTP id D340E254040
	for <linux-dvb@linuxtv.org>; Sun,  6 Jul 2008 15:07:22 +0200 (CEST)
Received: from server2.zuhause.xx (dslb-088-074-035-219.pools.arcor-ip.net
	[88.74.35.219])
	by mail-in-07.arcor-online.net (Postfix) with ESMTP id A1DC128ABA2
	for <linux-dvb@linuxtv.org>; Sun,  6 Jul 2008 15:07:22 +0200 (CEST)
Received: from [192.168.1.32] (az.zuhause.xx [192.168.1.32])
	by server2.zuhause.xx (Postfix) with ESMTP id 32D0AD6AA8
	for <linux-dvb@linuxtv.org>; Sun,  6 Jul 2008 15:07:20 +0200 (CEST)
Message-ID: <4870C35D.8060405@server>
Date: Sun, 06 Jul 2008 15:06:37 +0200
From: laasa <laasa@server>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] How to get 2 TT3650-CI working
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

First of all thanks to Dominik and Manu for the great work.

I want to get working two connected TT3650-CI. Under WinXP it will be 
running without problems on the same hardware, so the USB-ports should 
not be the problem.

Unter Linux with one connected TT3650 all is working succesfully. But 
with 2 connected TT3650 there are artefakts and dropouts on both cards 
after some seconds.
 I have try it under following conditions:

    * Ubuntu 7.10 and Ubuntu 8.04
    * actual multiproto-repository: http://jusst.de/hg/multiproto
    * patch from dominik:
      http://www.linuxtv.org/pipermail/linux-dvb/attachments/20080606/cc54743f/attachment-0001.obj
    * special in line 1075 of modul pctv452e.c to get TT3650-CI work
      (set num_device_descs *= 2*, otherwise only TT3600 works).
    * a special patched MythTV 0.21 (wich works with 2 TT3200 succesfully)

I do my tests with mythTV on 2 different PCs with the same result. One 
one PC the cards running under WinXP without any problems.

Does anybody have an idea?

Thanks in advance,
Laasa.




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
