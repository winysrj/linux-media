Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:35498 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaAUU75 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jan 2014 15:59:57 -0500
Received: by mail-wi0-f179.google.com with SMTP id hr1so4880785wib.6
        for <linux-media@vger.kernel.org>; Tue, 21 Jan 2014 12:59:55 -0800 (PST)
Received: from [192.168.0.123] (host86-170-10-210.range86-170.btcentralplus.com. [86.170.10.210])
        by mx.google.com with ESMTPSA id jw4sm10055142wjc.20.2014.01.21.12.59.54
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Tue, 21 Jan 2014 12:59:54 -0800 (PST)
Message-ID: <52DEDFCB.6010802@googlemail.com>
Date: Tue, 21 Jan 2014 20:59:55 +0000
From: Robert Longbottom <rongblor@googlemail.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Conexant PCI-8604PW 4 channel BNC Video capture card (bttv)
References: <52DD977E.3000907@googlemail.com> <1c25db0a-f11f-4bc0-b544-692140799b2a@email.android.com> <7D00B0B1-8873-4CB2-903F-8B98749C75FF@googlemail.com> <20140121101950.GA13818@minime.bse> <52DECF44.1070609@googlemail.com>
In-Reply-To: <52DECF44.1070609@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21/01/2014 19:49, Robert Longbottom wrote:
> On 21/01/2014 10:19, Daniel Glöckner wrote:
>> On Tue, Jan 21, 2014 at 09:27:38AM +0000, Robert Longbottom wrote:
>>> On 20 Jan 2014, at 10:55 PM, Andy Walls <awalls@md.metrocast.net> wrote:
>>>> Robert Longbottom <rongblor@googlemail.com> wrote:
>>>>> Chips on card:
>  >
>> Can you upload high resolution pictures of both sides of the card
>> somewhere? Something where we can follow the tracks to these chips.
>> Scanning the card with 300dpi should be enough.
>
> Here are some high-res pictures of both sides of the card.  Scanned at
> 600dpi (300dpi the tracks were very close).  Good idea to scan it by the
> way, I like that, much better result than with a digital camera.
>
> http://www.flickr.com/photos/astrofraggle/12073752546/sizes/l/
> http://www.flickr.com/photos/astrofraggle/12073651306/sizes/l/
>
> (click original size at the top right for full res)
>
>
>>>>> 1x 35.46895M Crystal
>>
>> Few cards use an 8x PAL Fsc crystal. Most have an NTSC crystal
>> (28.6363 MHz) and rely on the PLL for PAL. Maybe this helps to rule
>> out some card numbers.
>
> I did have a look down the cardlist for ones with PLL_35 (?), but it
> didn't help me.  I dont think there are any with 4 inputs.  Assuming
> thats the right thing to do.

Hmm, quick followup, I've just been looking at the images more closely 
and the top two (on the image) 878A chips appear to have tracks coming 
out of the GPIO pins.

Top chip has a "few" from pins 56 to 61 (GPIO23-18) that look to go via 
the 74HCT245 to the connector on the end of the card (not sure what 
thats for though...)

2nd from top chip appears to have a "lot" of it's GPIO pins connected 
up, pins 56-61 and pins 67 to 82 so GPIO 4 - GPIO 23.  Which possibly 
come up and connect to the unmarked chip...

Doesn't get me any further in making the card work, but hopefully it 
helps you guys a bit :-)

I've tried Kodicom driver again 
(http://linuxtv.org/wiki/index.php/Kodicom_4400R) with the "master card" 
id=132 in all possible positions - 1st, 2nd, 3rd, 4th, but no success. 
I still just get the bttv: 0: timeout: drop=0 irq=643/644, 
risc=06470000, bits: VSYNC HSYNC errors in dmesg.

Rob.


