Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41325 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288Ab2DDNJu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Apr 2012 09:09:50 -0400
Message-ID: <4F7C481A.2020203@iki.fi>
Date: Wed, 04 Apr 2012 16:09:46 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: gennarone@gmail.com
CC: linux-media@vger.kernel.org, m@bues.ch, hfvogt@gmx.net,
	mchehab@redhat.com
Subject: Re: [PATCH] af9035: add several new USB IDs
References: <1333540034-14002-1-git-send-email-gennarone@gmail.com> <4F7C3787.5020602@iki.fi> <4F7C4141.40004@gmail.com>
In-Reply-To: <4F7C4141.40004@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04.04.2012 15:40, Gianluca Gennari wrote:
> Il 04/04/2012 13:59, Antti Palosaari ha scritto:
>> On 04.04.2012 14:47, Gianluca Gennari wrote:
>>> Add several new USB IDs extracted from the Windows and Linux drivers
>>> published
>>> by the manufacturers (Terratec and AVerMedia).
>>> +    [AF9035_07CA_0867] = {
>>> +        USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_0867)},
>>>        [AF9035_07CA_1867] = {
>>>            USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_1867)},
>>> +    [AF9035_07CA_3867] = {
>>> +        USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_3867)},
>>>        [AF9035_07CA_A867] = {
>>>            USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A867)},
>>> +    [AF9035_07CA_B867] = {
>>> +        USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_B867)},
>>
>> It have been common practise to use product names for USB PID
>> definitions instead of USB ID numbers. I vote to continue that practise.
>>
>> Also, I am not very sure if it is wise to add new IDs without any
>> testing. Likely those are just reference design and will work, but
>> sometimes there is also some changes done for schematic wiring.
>> Especially for Avermedia, see hacks needed some AF9015 Avermedia
>> devices. They have put invalid data to eeprom and thus hacks are needed
>> for overriding tuner IDs etc.
>> Not to mention, driver supports also dynamic IDs and even device ID is
>> missing user can load driver using dynamic ID and report it working or
>> non-working.
>>
>> Anyone else any thoughts about adding IDs without testing ?
>>
>> regards
>> Antti
>
> Regarding the USB PID definition naming, there is no problem for me.
> Actually, some product names were used in the modified versions of your
> old driver, so I converted them to the format above just for
> convenience. The only problem is that there are so many variations of
> the Avermedia sticks that it's hard to give them proper names.
>
> Some of this IDs are already tested (if we include the several
> modifications of your old driver).
>
> In particular:
> AF9035_0CCD_00AA : confirmed working on Ubuntu.it forum with the old
> driver (don't have the link);
> AF9035_07CA_0825 : confirmed working on OpenPli forum with the old
> driver (see link above);
>
> Others comes from the official Windows drivers so they should be just
> little variations of the retail products:
> AF9035_07CA_A825, AF9035_07CA_0835, AF9035_07CA_3867.
>
> This IDs are can be the more problematic:
> AF9035_15A4_1000, AF9035_15A4_1002, AF9035_15A4_1003,
> AF9035_07CA_A333, AF9035_07CA_0337, AF9035_07CA_F337
> since there is little or no information about this products.
>
> Anyway, this patch can be a reference for users willing to test the new
> driver.

I mean those definitions that goes to common file named: dvb-usb-ids.h. 
Those are named as a USB_PID_<VENDOR_NAME>_<PRODUCT_NAME>

PIDs inside af9035.c (enum af9035_id_entry) are used only for generating 
table index. Before it was used plain index numbers but that causes in 
past few times problems when people added new device IDs between then 
the table. Meaning of that enum is only keep index in order 
automatically - and it is just fine as it is short unique name as 
currently AF9035_<VID>_<PID>.

Add those IDs you know working and sent patch. Lets add more IDs when 
those are confirmed to work. And as I said I added dynamic ID support 
for that driver, so even there is no USB ID defined inside driver, it 
can be still used without compiling whole Kernel.

regards
Antti

-- 
http://palosaari.fi/
