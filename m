Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp102.rog.mail.re2.yahoo.com ([206.190.36.80]:30015 "HELO
	smtp102.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750860AbZAYXfS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2009 18:35:18 -0500
Message-ID: <497CF735.9070004@rogers.com>
Date: Sun, 25 Jan 2009 18:35:17 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Trent Piepho <xyzzy@speakeasy.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Michael Krufky <mkrufky@linuxtv.org>,
	hermann pitton <hermann-pitton@arcor.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl> <200901182241.10047.hverkuil@xs4all.nl> <4973BD03.4060702@rogers.com> <200901190853.19327.hverkuil@xs4all.nl> <497CAB2F.7080700@rogers.com> <Pine.LNX.4.58.0901251322320.17971@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0901251322320.17971@shell2.speakeasy.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hermann pitton wrote:
> Am Sonntag, den 25.01.2009, 13:49 -0800 schrieb Trent Piepho:
>   
>> On Sun, 25 Jan 2009, CityK wrote:
>>     
>>> Hans Verkuil wrote:
>>>
>>> this still begs Han's question: "how do you manage to make analog TV
>>> work if the tda9887 isn't found? That's rather peculiar." I don't have
>>> an answer for that. The tuner-simple module, however, seems to be able to drive/provide that functionality sufficiently enough. 
>>>
>> The tda9887 is a simple device with just three registers.  If they are set
>> to the right value when the driver loads, which wouldn't be unexpected,
>> then it isn't necessary to actually do anything to the chip.  If you had a
>> multistandard tuner (and had access to broadcasts in multiple standards!)
>> then I expect switching standards wouldn't work without the tda9887 driver.
>> Verifying both TV and radio tuning works is probably the most realistic way
>> to check.
>>     
>
> For radio you need a tda9887 and working i2c for what i can know.
>
> Also after a cold boot the tda988x is not in a usable state for any tv
> standard yet, it needs to be set by i2c first.
>
> But for NTSC, and only NTSC, one pin can be strapped, IIRC, and then it
> works without any i2c programming needed. Guess it is a tda9885 here.
>
>   

Looks like that this is the case, as described by Trent, that is
occurring. Herman, is there any difference between the tda9885 and
tda887, as I'm pretty sure this is the tda9887 package outlined on page
52 of the tda9887 datasheet.

Alas, as being exposed to just NTSC broadcasts, not able to test on the
multistandard ;)

As for the FM radio, I know that some have mentioned the possibility for
that with this device, but I don't think anyone ever has succeeded (not
surprising given the i2c situation) and so the assumption was made,
rightly or wrongly, that it is not present. I would be amused if FM
radio support could be realised for the device.

>>>> saa7133[1]: i2c xfer: < c2 30 90 >
>>>> saa7134[3]: i2c xfer: < c2 >
>>>> saa7134[3]: i2c xfer: < c2 0b dc 9c 60 >
>>>> saa7134[3]: i2c xfer: < c2 0b dc 86 54 >
>>>>
>>>> Exactly here, when the buffers are sent the second time the tda9887
>>>> becomes the first time visible on the bus. According to Hartmut the
>>>> modification of buffer[3] from 0x60 to 0x54 is that hidden switch,
>>>> IIRC.
>>>>
>>>>         
>>> I believe Mauro is correct in regards to the tda9887 in that, within the
>>> Philips TUV1236D NIM, it is behind the Nxt2004's i2c gate.  After
>>> re-reading what Michael mentioned previously:
>>>       
>> Address 0xc2 is the PLL, not the NXT2004.  Why would the PLL control an I2C
>> gate on the nxt2004?  I think what I said before about a gpio line on the
>> PLL being used to hold the analog demod in reset when not in use is more
>> likely to be correct.
>>     
>
> That the analog demod is enabled from the pll in case of the FMD1216ME
> MK3 hybrid is what Hartmut told us.
>
> To remeber, the Pinnacle 300i hybrid with mt32xx (3250) disables the
> analog demod with tda9887 port2=0 in digital mode. That is why Gerd
> re-enables it on exit of DVB. 
>
>>> The i2c command to enable the tuner is sent to nxt200x. If there are any
>>> ATSC110 variant with a different demod (maybe a different version of nxt200x?),
>>> then the users may experience different behaviors.
>>>       
>> That command sequence is sent to the PLL, not the nxt2004, so this is 
>> wrong.  There is another command sent to the nxt2004 (which is at address
>> 0x0a) from code in saa7134-cards.c to "enables tuner" as well.
>>     



