Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [195.156.147.13] (helo=kirsi1.rokki.sonera.fi)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lwgt@iki.fi>) id 1K0vn2-0005A9-0f
	for linux-dvb@linuxtv.org; Tue, 27 May 2008 11:48:20 +0200
Received: from [127.0.0.1] (84.249.53.62) by kirsi1.rokki.sonera.fi (8.5.014)
	id 483BB449000249E1 for linux-dvb@linuxtv.org;
	Tue, 27 May 2008 12:48:16 +0300
Message-ID: <483BD8DC.6090707@iki.fi>
Date: Tue, 27 May 2008 12:48:12 +0300
From: Lauri Tischler <lwgt@iki.fi>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
References: <20080329024154.GA23883@localhost>	<47EDCE27.4050101@optusnet.com.au>
	<47EE1056.9050804@iki.fi>	<47EE3C5E.8080001@optusnet.com.au>	<20080402023911.GA27360@tull.net>
	<47F4087D.2050202@optusnet.com.au>
In-Reply-To: <47F4087D.2050202@optusnet.com.au>
Subject: Re: [linux-dvb] Afatech 9015
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

ausgnome wrote:

> lsusb -v
> Bus 001 Device 005: ID 15a4:9016 
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   idVendor           0x15a4
>   idProduct          0x9016
>   bcdDevice            2.00
>   iManufacturer           1 Afatech
>   iProduct                2 DVB-T 2
>   iSerial                 3 010101010600001

My Fuj:tech DTV PRO has same ID 15a4:9016 but
odd manufacturer MSI

Bus 006 Device 007: ID 15a4:9016
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x15a4
   idProduct          0x9016
   bcdDevice            2.00
   iManufacturer           1 MSI
   iProduct                2 MSI K-VOX
   iSerial                 3 010101010600001

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
