Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp19.orange.fr ([80.12.242.1]:36155 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569AbZINHd4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 03:33:56 -0400
Message-ID: <4AADF1E4.80705@gmail.com>
Date: Mon, 14 Sep 2009 09:33:56 +0200
From: Morvan Le Meut <mlemeut@gmail.com>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: (Saa7134) Re: ADS-Tech Instant TV PCI, no remote	support,	giving
 up.
References: <4AA53C05.10203@gmail.com> <4AA61508.9040506@gmail.com>	 <op.uzxmzlj86dn9rq@crni> <4AA62C38.3050208@gmail.com>	 <4AA63434.1010709@gmail.com> <4AA683BD.6070601@gmail.com>	 <4AA695EE.70800@gmail.com> <4AA767F2.50702@gmail.com>	 <op.uzzfgyvj3xmt7q@crni> <4AA77240.2040504@gmail.com>	 <4AA77683.7010201@gmail.com> <4AA7C266.3000509@gmail.com>	 <op.uzzz96se6dn9rq@crni> <4AA7E166.7030906@gmail.com>	 <4AA81785.5000806@gmail.com> <4AA8BB20.4040701@gmail.com>	 <4AA919CA.20701@gmail.com> <4AAA0247.8020004@gmail.com>	 <4AAB586D.6080906@gmail.com> <1252815352.3259.41.camel@pc07.localdom.local>	 <4AAD6B4B.5030204@gmail.com> <1252881711.4318.46.camel@pc07.localdom.local>
In-Reply-To: <1252881711.4318.46.camel@pc07.localdom.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So, if i understand correctly,  i should change "in" to 0xBF to get the 
missing bit.
( and if it work, i will be able to use ir_codes_adstech_dvb_t_pci 
instead of rolling my own keymap )

Thanks.

hermann pitton a écrit :
> Hi,
>
> Am Sonntag, den 13.09.2009, 23:59 +0200 schrieb Morvan Le Meut:
>   
>> just out of curiosity ( and because google showed me a new trick to try 
>> ), i tried to load the module with gpio_tracking=1.
>> this gave me a new thing in dmesg :
>>  gpio: mode=0x0000000 in=0x000007f out=0x0000000 [pre-init]
>> Am i correct by thinkig that the in=0x000007f part is the mask ? If it 
>> is that then i am a problem : i did specify it as 0xff. Did i miss 
>> something ?
>>     
>
> it does not cover the IR gpio settings, but what happens in the card
> entry at saa7134-cards.c.
>
> "mode" is the gpio mask defined there, if any. You have nothing set
> there.
> "in" is the actual configuration of the gpio pins. This can reflect
> changes made to them, for example from using an other cards entry
> previously, which can change some pins or changes in different modes on
> them, which are not yet reset. By default it shows the manufacturers
> gpio configuration. 0x7f can mean that the first seven pins (0-6) are
> used for the gpio remote. That would be your mask keycode then.
>
> "out" is what the driver writes to the gpios of that card.
> In this mode only pins are changed, which are high in the mask,
> this is called masked writes. In your case nothing happens.
>
> See my next mail for a simple example of changing the single gpio21 pin
> to 0 in Television mode.
>
> Cheers,
> Hermann
>   



