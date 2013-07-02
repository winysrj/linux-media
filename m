Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:60056 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754231Ab3GBUUP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Jul 2013 16:20:15 -0400
Message-ID: <51D335FD.7020707@schinagl.nl>
Date: Tue, 02 Jul 2013 22:20:13 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Bogdan Oprea <bogdaninedit@yahoo.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: drivers:media:tuners:fc2580c fix for Asus U3100Mini Plus error
 while loading driver (-19)
References: <1372660460.41879.YahooMailNeo@web162304.mail.bf1.yahoo.com> <1372661590.52145.YahooMailNeo@web162304.mail.bf1.yahoo.com> <51D1352A.2080107@schinagl.nl> <51D182CD.2040502@iki.fi> <51D1839B.1010007@schinagl.nl> <51D1E8F8.9030402@schinagl.nl> <51D1EBCF.60708@iki.fi> <51D1EE98.2060905@schinagl.nl> <51D204B0.9090809@iki.fi> <51D27B6C.5030607@schinagl.nl> <51D3301D.5070007@iki.fi>
In-Reply-To: <51D3301D.5070007@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/02/13 21:55, Antti Palosaari wrote:
> On 07/02/2013 10:04 AM, Oliver Schinagl wrote:
>> On 02-07-13 00:37, Antti Palosaari wrote:
>>> On 07/02/2013 12:03 AM, Oliver Schinagl wrote:
>>>> On 07/01/13 22:51, Antti Palosaari wrote:
>>>>> On 07/01/2013 11:39 PM, Oliver Schinagl wrote:
>>>>>> On 07/01/13 15:26, Oliver Schinagl wrote:
>>>>>>> On 01-07-13 15:23, Antti Palosaari wrote:
>>>>>>>> On 07/01/2013 10:52 AM, Oliver Schinagl wrote:
>>>>>>>>> On 01-07-13 08:53, Bogdan Oprea wrote:
>>>>>>>>>> this is a fix for this type of error
>>>>>>>>>>
>>>>>>>>>> [18384.579235] usb 6-5: dvb_usb_v2: 'Asus U3100Mini Plus' error
>>>>>>>>>> while
>>>>>>>>>> loading driver (-19)
>>>>>>>>>> [18384.580621] usb 6-5: dvb_usb_v2: 'Asus U3100Mini Plus'
>>>>>>>>>> successfully
>>>>>>>>>> deinitialized and disconnected
>>>>>>>>>>
>>>>>>>>> This isn't really a fix, I think i mentioned this on the ML ages
>>>>>>>>> ago,
>>>>>>>>
>>>>>>>> Argh, I just replied that same. Oliver, do you has that same
>>>>>>>> device? Is
>>>>>>>> it working? Could you tweak to see if I2C readings are working at
>>>>>>>> all?
>>>>>>> I have the same device, but mine works normally (though I haven't
>>>>>>> checked for ages), I will try it tonight when I'm at home and don't
>>>>>>> forget what happens with my current kernel.
>>>>>>
>>>>>> Hard to test when it 'just works (tm)' :)
>>>>>
>>>>>> The bad firmware wories me, no clue where that error is from, using:
>>>>>> 862604ab3fec0c94f4bf22b4cffd0d89  /lib/firmware/dvb-usb-af9035-02.fw
>>>>>
>>>>> It means firmware is too short or long what is calculated. I added that
>>>>> printing to notify users firmware is broken and could cause problems.
>>>> Ah, good call, it did get me to re-download it. no clue why it was
>>>> broken all of a sudden.
>>>>>
>>>>>
>>>>> I suspect it is same issue what is with MxL5007t tuners too.
>>>>> Maybe that kind of fix is needed:
>>>>> https://patchwork.kernel.org/patch/2418471/
>>>>>
>>>>> Someone should really find out whether or not these are coming with
>>>>> register read operation with REPEATED START of STOP condition. Attach
>>>>> hardware sniffer to device tuner I2C bus and look what kind of messages
>>>>> there is actually.
>>>> Well mine works fine, so hard to say. IF you have a buspirate you should
>>>> be able to intercept the i2c bus ON the device though :) Good luck
>>>> Bogdan, I wish I could help here, but lack the broken hardware.
>>>
>>> I have one AF9035 + FC0012 device having similar problems. Unfortunately
>>> I wasn't able to detect I2C bus to take capture using Bus Pirate.
>> Actually, I have the af9035b (see the picture i uploaded to the wiki)
>>>
>>> There seems to be two revisions of AF9035 chips, AF9035A and AF9035B. I
>>> suspect it is newer B version which has these problems. I also visually
>>> compared to A and B versions and I suspect pinout is different.
>>>
>>> Could you take USB sniffs from that device? Just install sniffer (like
>>> SniffUSB), tune to channel and stop immediately when there is picture.
>>> FC2580 driver does some register reads, so it should be possible to see
>>> what is correct I2C access format by looking sniffs.
>
>> Of my working version? I can try, i'll see if I have time to work with
>> sniffusb, but if I load the driver from linux, won't we already know
>> whats on the USB bus? If you speak of windows, I don't have that.
>
> I wonder if Bogdan could took the sniffs as his device has the problems.
>
> My FC0012 sniffs are useless as FC0012 windows does not any register reads.
>
> Your sniffs could be also handy, better than nothing, even likely
> produce just same logs as Bogdan (I suspect it is issue AF9035A vs AF9035B).
>
>>> Here is few good pictures from my problematic AF9035B + FC0012 device.
>>> If someone could say which are FC0012 I2C pins, I could use Pirate to
>>> check (as that device has same problem).
I don't know what the FC0012 I2C pins are, but don't we know where they 
are on the AF9035B?

I know on the FCI 2580 pin 18 is SCLK, Pin 19 is SDATA and pin 20 is VDD.

My bad camera skills made the image blurry and I don't have a microscope 
(scanner would have been cool though I suppose) but the I2C lines appear 
to enter the af9035b on the 'left' side, if you look at the numbers on 
the far left, '131' and head towards the chip, you see two via's comming 
up and going slightly diagonally up towards the chip. That's the I2C bus 
if i'm not mistaken. SCLK is the top one of the two, SDATA the lower 
one. I know it's hard to see in the image, but still quite possible :)

http://www.linuxtv.org/wiki/images/1/1b/Asus_U3100_Mini_plus_DVB-T_03.JPG

>>> http://blog.palosaari.fi/2013/05/naked-hardware-8-cabletech-urz0185.html
>>>
>>> regards
>>> Antti
>>>
>>
>
> Antti
>

