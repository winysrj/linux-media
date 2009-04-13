Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:60776 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbZDMJ10 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2009 05:27:26 -0400
Message-ID: <49E30575.4060202@retrodesignfan.eu>
Date: Mon, 13 Apr 2009 11:27:17 +0200
From: Marco Borm <linux-dvb@retrodesignfan.eu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] DVB-T USB dib0700 device recommendations?
References: <20090411221740.GB12581@www.viadmin.org>	<49E2A0E1.4020407@retrodesignfan.eu> <d9def9db0904122354g3e6a8603mcbf69cfb96799b8d@mail.gmail.com>
In-Reply-To: <d9def9db0904122354g3e6a8603mcbf69cfb96799b8d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Markus,

it seams that you don't know what the Hauppauge Nova-T 500 is:
Its not a USB device itself, its a PCI card with a VIA PCI/USB-Bridge 
Chip connected to multiple DIBcom USB chips:
http://www.bttv-gallery.de/high/bttv-gallery.html

I bought the card with the idea in mind that it uses low power USB 
technology, but that was a mistake.
Next time I will buy a real usb device and know it isn't allowed to eat 
more than 2.5W.


Greetings,
Marco

Markus Rechberger wrote:
> On Mon, Apr 13, 2009 at 4:18 AM, Marco Borm <linux-dvb@retrodesignfan.eu> wrote:
>   
>> Hi Henrik,
>>
>> one of the cards in my system is the dib0700 based "'Hauppauge Nova-T 500".
>> Compared with the "TerraTec Cinergy 1400" I would say that the receiver
>> sensitivity is worse but the main problem I have is that the card
>> consumes a loot of energy (8-13W), which is much more than the
>> Terratec(5-6W).
>>     
>
> That's a little bit weird USB itself should provide max 5V 500mA which would be
> 2.5 Watt; if it requires more then the device has to be self powered.
>
> Maybe you can try to use a different USB device (eg. storage) just for
> testing the
> consumption. USB is supposed to require alot power (the controller).
> You might try to unload the ehci/ohci driver too.
>
> Markus
>
>   
>> I calculated this using measure values of the whole system captured with
>> a Conrad/Voltcraft Energy Monitor 3000.
>> Personally I am little bit shocked about that and wondering if this can
>> be true because the dib is a USB-device, but the Voltcraft is one of the
>> better measurement device.
>> Maybe the VIA usb-hub controller on the board is the problem?!
>>
>> Would be interesting of someone has the same or other experiences with
>> this card or other PCI based cards. Hauppauge ignores all my questions,
>> so I can't recomment products of this manufacturer anyway.
>>
>>
>> Greetings,
>> Marco
>>
>> H. Langos wrote:
>>     
>>> I've been trying to minimize energy consumption [...] But before running
>>> out in the street and buying the first dib0700 device I'd like to know if
>>> there are any devices that are
>>>
>>> - especially good [...]
>>>
>>> or
>>>
>>> - especially bad [...]
>>>
>>>
>>> _______________________________________________
>>> linux-dvb users mailing list
>>> For V4L/DVB development, please use instead linux-media@vger.kernel.org
>>> linux-dvb@linuxtv.org
>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>
>>>
>>>       
>> _______________________________________________
>> linux-dvb users mailing list
>> For V4L/DVB development, please use instead linux-media@vger.kernel.org
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>>     
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>   

