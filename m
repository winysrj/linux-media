Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.mbox.com.au ([203.134.146.14])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <redninja83@gmail.com>) id 1KAJbc-0005fl-Sp
	for linux-dvb@linuxtv.org; Sun, 22 Jun 2008 09:03:22 +0200
Received: from localhost (nightcrawler.mbox.com.au [127.0.0.1])
	by mail.mbox.com.au (mBox Mail) with ESMTP id 4F1DD2C8119
	for <linux-dvb@linuxtv.org>; Sun, 22 Jun 2008 15:05:12 +0800 (WST)
Received: from mail.mbox.com.au ([127.0.0.1])
	by localhost (nightcrawler.mbox.com.au [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id tptAWfRZekDI for <linux-dvb@linuxtv.org>;
	Sun, 22 Jun 2008 15:05:04 +0800 (WST)
Received: from [10.6.10.64] (203-59-240-91.dyn.iinet.net.au [203.59.240.91])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	by mail.mbox.com.au (mBox Mail) with ESMTP id B0B6C2C80CC
	for <linux-dvb@linuxtv.org>; Sun, 22 Jun 2008 15:05:04 +0800 (WST)
Message-Id: <465FEE18-E36D-4EA3-8A1E-D2FBC3A20758@gmail.com>
From: "R. Goff" <redninja83@gmail.com>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0 (Apple Message framework v924)
Date: Sun, 22 Jun 2008 15:02:33 +0800
Subject: [linux-dvb] KWorld PlusTV Dual DVB-T PCIe (PE210)
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

Hi,

I'm trying to get this card working under linux, but cant seem to find  
much information about it. Does anyone know if the chipset is  
supported? Perhaps under development drivers?

The windows .INF files suggest that its using the Micronas nGene  
chipset, but I cant find much information about that, or other cards  
that might have the same chipset. lspci reports it as:

04:00.0 Multimedia video controller: Micronas Semiconductor Holding AG  
Unknown device 0720

Does anyone have any information on the card or chipset? Are there any  
development drivers I can try?

Cheers,

--Raal

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
