Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.mbox.com.au ([203.134.146.14])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <redninja83@gmail.com>) id 1KBipa-0001pQ-1u
	for linux-dvb@linuxtv.org; Thu, 26 Jun 2008 06:11:41 +0200
Received: from localhost (nightcrawler.mbox.com.au [127.0.0.1])
	by mail.mbox.com.au (mBox Mail) with ESMTP id EE1AA2C8137
	for <linux-dvb@linuxtv.org>; Thu, 26 Jun 2008 12:13:14 +0800 (WST)
Received: from mail.mbox.com.au ([127.0.0.1])
	by localhost (nightcrawler.mbox.com.au [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id AwdjJFxv6nnr for <linux-dvb@linuxtv.org>;
	Thu, 26 Jun 2008 12:13:07 +0800 (WST)
Received: from [10.6.10.64] (203-59-59-123.dyn.iinet.net.au [203.59.59.123])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	by mail.mbox.com.au (mBox Mail) with ESMTP id B23662C8158
	for <linux-dvb@linuxtv.org>; Thu, 26 Jun 2008 12:13:07 +0800 (WST)
Message-Id: <9E287437-AC62-4247-AE68-F85BC026DBFB@gmail.com>
From: "R. Goff" <redninja83@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <465FEE18-E36D-4EA3-8A1E-D2FBC3A20758@gmail.com>
Mime-Version: 1.0 (Apple Message framework v924)
Date: Thu, 26 Jun 2008 12:10:24 +0800
References: <465FEE18-E36D-4EA3-8A1E-D2FBC3A20758@gmail.com>
Subject: Re: [linux-dvb] KWorld PlusTV Dual DVB-T PCIe (PE210)
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

I've managed to find a bit more information about this card:

1) Tuners: 2x Microtune MT2060
2) Demodulators: 2x MICRONAS DRX 3975D
3) PCI-Express x1 Bridge: MICRONAS APB 7202A

It seems as though the tuners are supported, and there is a patch to  
enable support for the demodulators, but it requires firmware which no- 
one knows where to get (http://www.linuxtv.org/pipermail/linux-dvb/2008-January/022697.html 
)

I couldn't find any information regarding support for the PCI-Express  
bridge, does anyone know anything about it?

It looks like there are several similar cards out there, the Terratec  
2400i (although this uses different tuners), and the Compro e700 are  
two that i've found.

Anyone got any ideas on where to go from here?

On 22/06/2008, at 3:02 PM, R. Goff wrote:

> Hi,
>
> I'm trying to get this card working under linux, but cant seem to find
> much information about it. Does anyone know if the chipset is
> supported? Perhaps under development drivers?
>
> The windows .INF files suggest that its using the Micronas nGene
> chipset, but I cant find much information about that, or other cards
> that might have the same chipset. lspci reports it as:
>
> 04:00.0 Multimedia video controller: Micronas Semiconductor Holding AG
> Unknown device 0720
>
> Does anyone have any information on the card or chipset? Are there any
> development drivers I can try?
>
> Cheers,
>
> --Raal
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
