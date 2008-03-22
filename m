Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1JdCLB-0007Dk-Ef
	for linux-dvb@linuxtv.org; Sat, 22 Mar 2008 23:37:30 +0100
Date: Sat, 22 Mar 2008 23:36:46 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Alexander Simon <alexander.simon@informatik.tu-muenchen.de>
In-Reply-To: <200803031425.26937.alexander.simon@informatik.tu-muenchen.de>
Message-ID: <Pine.LNX.4.64.0803222318040.26601@pub6.ifh.de>
References: <200803031425.26937.alexander.simon@informatik.tu-muenchen.de>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Terratec Cinergy T USB XXS working
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

Hi Alexander,

I created a patch from the information you are giving. I hope it is OK. 
Can you please check the repository here:

http://linuxtv.org/hg/~pb/v4l-dvb/

and see whether the change is made correctly?

Patrick.



On Mon, 3 Mar 2008, Alexander Simon wrote:

> Hi List,
>
> lately a friend of mine got a Terratec Cinergy T USB XXS and was wondering if
> it were supported under Linux.
> After unsuccessful googling for this card (even your Wiki gives nothing), i
> started investigating on my own.
> The Windows driver loaded an dvb7700all.sys, which seemed to be for an dibcom
> 7700. After replacing USB IDs in dvb-usb/dib_0700_devices.c with the ones
> from the card, i got it working by replacing
> { USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_MYTV_T) },
> with the Cards ID in the 127f67dea087 (3.3.08) branch:
> { USB_DEVICE(USB_VID_TERRATEC, 0x0078) },
>
> So, the card is a clone of the "newest" Nova-T.
> Scanning channels in Munich and watching with Kaffeine have been tested so far
> and worked flawlessly.
>
> Could some developer please include this card into the current source?
>
> You can send me a mail for questions.
>
>
> Please note that i am talking about T USB XXS, not T USB XS or similar.
>
> Greetings, Alex
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
