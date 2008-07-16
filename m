Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out.neti.ee ([194.126.126.37])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ed.lau@mail.ee>) id 1KJ3AD-0006Nr-R5
	for linux-dvb@linuxtv.org; Wed, 16 Jul 2008 11:19:13 +0200
Received: from localhost (localhost [127.0.0.1])
	by MXR-5.estpak.ee (Postfix) with ESMTP id EC9771DE62D
	for <linux-dvb@linuxtv.org>; Wed, 16 Jul 2008 12:19:05 +0300 (EEST)
Received: from smtp-out.neti.ee ([127.0.0.1])
	by localhost (MXR-5.estpak.ee [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id or0PPhFDPG6t for <linux-dvb@linuxtv.org>;
	Wed, 16 Jul 2008 12:19:03 +0300 (EEST)
Received: from Relayhost2.neti.ee (Relayhost2 [88.196.174.142])
	by MXR-5.estpak.ee (Postfix) with ESMTP id BF25C1DF1F3
	for <linux-dvb@linuxtv.org>; Wed, 16 Jul 2008 12:19:03 +0300 (EEST)
Message-ID: <487DBD0C.7050306@mail.ee>
Date: Wed, 16 Jul 2008 12:19:08 +0300
From: Edmund Laugasson <ed.lau@mail.ee>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <487CF58A.1040009@mail.ee>
In-Reply-To: <487CF58A.1040009@mail.ee>
Subject: Re: [linux-dvb] Gigabyte U8000-RH linux support?
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

> I would like to ask, does Gigabyte U8000-RH work under Linux? 

I added some additional log files:
/var/log/udev - http://www.scribd.com/doc/3962028/DVBT-Gigabyte-U8000RH-udev
/var/log/kern.log - http://www.scribd.com/doc/3962025/DVBT-Gigabyte-U8000RH-kernlog
/var/log/dmesg - http://www.scribd.com/doc/3962023/DVBT-Gigabyte-U8000RH-dmesg
/var/log/debug - http://www.scribd.com/doc/3962021/DVBT-Gigabyte-U8000RH-debug
and also lsusb -v output - http://www.scribd.com/doc/3962026/DVBT-Gigabyte-U8000RH-lsusb-v

There they are viewable as flash and downloadable as PDF and TXT file.

DVB-T_Gigabyte-U8000-RH_log-files.zip (75,8 KiB) were added to this letter but it seems like mailman 
does not allow more than 60 KiB, so I put those files also to the internet.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
