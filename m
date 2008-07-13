Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mu-out-0910.google.com ([209.85.134.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <oberstel@gmail.com>) id 1KI8W7-0004Gn-9i
	for linux-dvb@linuxtv.org; Sun, 13 Jul 2008 22:50:00 +0200
Received: by mu-out-0910.google.com with SMTP id w8so1550667mue.1
	for <linux-dvb@linuxtv.org>; Sun, 13 Jul 2008 13:49:55 -0700 (PDT)
Message-Id: <4A2CCDB3-57B0-4121-A94D-59F985FCDE2B@oberste-berghaus.de>
From: Leif Oberste-Berghaus <leif@oberste-berghaus.de>
To: linux-dvb@linuxtv.org
In-Reply-To: <4879FA31.2080803@kolumbus.fi>
Mime-Version: 1.0 (Apple Message framework v926)
Date: Sun, 13 Jul 2008 22:49:51 +0200
References: <3b52bc790807101342o12f6f879n9c68704cd6b96e22@mail.gmail.com>
	<4879FA31.2080803@kolumbus.fi>
Subject: Re: [linux-dvb] TerraTec Cinergy C DVB-C / Twinhan AD-CP400
	(VP-2040) &	mantis driver
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

Hi Marko,

thanks for you information.

Could you be so kind to point out how to configure the "aligmnent for  
DMA tranfers" and how to generate "less IRQs from DMA transfer"?

Regards,
Leif

Am 13.07.2008 um 14:50 schrieb Marko Ristola:

>
> Hi,
>
> I have Twinhan DVB-C 2033.
> I have had freezes /reboots.
>
> I did following things with the driver to stabilize things (my own  
> driver version):
> - Implement both 64byte and 188 byte alignment for DMA transfers.
> - Generate less IRQs from DMA transfers.
>
> That has helped: My AMD dualcore don't do hard reset so often and the
> saved TV programs are now usable (without my changes the dvb stream
> lost voice and VDR couldn't show them more than a few minutes).
> My version seems to use less power (Too weak power supply
> might be part of my problem though).
>
> I don't know yet though whether Manu or others are interested in my  
> patches.
> I use too new kernel version to deliver patches for Manu easilly.
>
> Regards,
> Marko Ristola

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
