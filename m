Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:61870 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440AbZDMGyL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2009 02:54:11 -0400
Received: by fxm2 with SMTP id 2so1874431fxm.37
        for <linux-media@vger.kernel.org>; Sun, 12 Apr 2009 23:54:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49E2A0E1.4020407@retrodesignfan.eu>
References: <20090411221740.GB12581@www.viadmin.org>
	 <49E2A0E1.4020407@retrodesignfan.eu>
Date: Mon, 13 Apr 2009 08:54:09 +0200
Message-ID: <d9def9db0904122354g3e6a8603mcbf69cfb96799b8d@mail.gmail.com>
Subject: Re: [linux-dvb] DVB-T USB dib0700 device recommendations?
From: Markus Rechberger <mrechberger@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 13, 2009 at 4:18 AM, Marco Borm <linux-dvb@retrodesignfan.eu> wrote:
> Hi Henrik,
>
> one of the cards in my system is the dib0700 based "'Hauppauge Nova-T 500".
> Compared with the "TerraTec Cinergy 1400" I would say that the receiver
> sensitivity is worse but the main problem I have is that the card
> consumes a loot of energy (8-13W), which is much more than the
> Terratec(5-6W).

That's a little bit weird USB itself should provide max 5V 500mA which would be
2.5 Watt; if it requires more then the device has to be self powered.

Maybe you can try to use a different USB device (eg. storage) just for
testing the
consumption. USB is supposed to require alot power (the controller).
You might try to unload the ehci/ohci driver too.

Markus

> I calculated this using measure values of the whole system captured with
> a Conrad/Voltcraft Energy Monitor 3000.
> Personally I am little bit shocked about that and wondering if this can
> be true because the dib is a USB-device, but the Voltcraft is one of the
> better measurement device.
> Maybe the VIA usb-hub controller on the board is the problem?!
>
> Would be interesting of someone has the same or other experiences with
> this card or other PCI based cards. Hauppauge ignores all my questions,
> so I can't recomment products of this manufacturer anyway.
>
>
> Greetings,
> Marco
>
> H. Langos wrote:
>> I've been trying to minimize energy consumption [...] But before running
>> out in the street and buying the first dib0700 device I'd like to know if
>> there are any devices that are
>>
>> - especially good [...]
>>
>> or
>>
>> - especially bad [...]
>>
>>
>> _______________________________________________
>> linux-dvb users mailing list
>> For V4L/DVB development, please use instead linux-media@vger.kernel.org
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>>
>
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
