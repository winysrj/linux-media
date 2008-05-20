Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from joan.kewl.org ([212.161.35.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darron@kewl.org>) id 1JySWq-0002BD-Vl
	for linux-dvb@linuxtv.org; Tue, 20 May 2008 16:09:25 +0200
From: Darron Broad <darron@kewl.org>
To: Igor <goga777@bk.ru>
In-reply-to: <E1JyRpw-0001jr-00.goga777-bk-ru@f121.mail.ru> 
References: <E1JyRpw-0001jr-00.goga777-bk-ru@f121.mail.ru>
Date: Tue, 20 May 2008 15:09:20 +0100
Message-ID: <25670.1211292560@kewl.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb]
	=?koi8-r?b?bmV3IGZpcm13YXJlIGZvciBIVlItMTEwMC8xMzAw?=
	=?koi8-r?b?LzMwMDAvNDAwMCAmIE5vdmEtVC9TLVBDSS9IRF9TMg==?=
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

In message <E1JyRpw-0001jr-00.goga777-bk-ru@f121.mail.ru>, Igor wrote:
>Hi

lo

>http://www.hauppauge.co.uk/pages/support/support_driversonly.html
>here you can find the updated firmware version for  HVR-1100/1300/3000/4000 & Nova-T/S-PCI/HD_S2
>Version 2.122.26109 (1.39Mb)

to extract for the cx24116 try this:

(FW version 1.22.82.0, previously 1.20.79.0)

dd if=hcw88bda.sys of=dvb-fe-cx24116.fw skip=75504 bs=1 count=32501

What difference it makes is unknown.

cya

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
