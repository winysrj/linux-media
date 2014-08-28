Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:36390 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaH1RUv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Aug 2014 13:20:51 -0400
Received: by mail-wg0-f45.google.com with SMTP id k14so1050349wgh.4
        for <linux-media@vger.kernel.org>; Thu, 28 Aug 2014 10:20:50 -0700 (PDT)
Message-ID: <53FF64EF.1030809@gmail.com>
Date: Thu, 28 Aug 2014 18:20:47 +0100
From: Kaya Saman <kayasaman@gmail.com>
MIME-Version: 1.0
To: "P. van Gaans" <w3ird_n3rd@gmx.net>,
	Kaya Saman <SamanKaya@netscape.net>,
	linux-media@vger.kernel.org
Subject: Re: Advice on DVB-S/S2 card and CAM support
References: <53D58EDF.1090102@netscape.net> <53FEA63E.9020208@gmx.net> <53FF406B.9040001@netscape.net> <53FF583A.4080702@gmx.net>
In-Reply-To: <53FF583A.4080702@gmx.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/28/2014 05:26 PM, P. van Gaans wrote:
> On 08/28/2014 04:44 PM, Kaya Saman wrote:
>> On 08/28/2014 04:47 AM, P. van Gaans wrote:
>>> On 07/28/2014 01:44 AM, Kaya Saman wrote:
>>>> Hi,
>>>>
>>>> I'm wondering what the best solution for getting satellite working on
>>>> Linux is?
>>>>
>>>>
>>>> Currently I have a satellite box with CAM module branded by the
>>>> Satellite TV provider we are with.
>>>>
>>>>
>>>> As I am now migrating everything including TV through my HTPC
>>>> environment I would also like to link the satellite box up to the HTPC
>>>> too to take advantage of the PVR and streaming capabilities.
>>>>
>>>>
>>>> I run XBMC as my frontend so I was looking into TV Headend to take 
>>>> care
>>>> of PVR side of things.
>>>>
>>>>
>>>> My greatest issue though is what is the best solution for getting the
>>>> satellite system into the HTPC?
>>>>
>>>>
>>>> After some research my first idea was to use a satellite tuner card;
>>>> models are available for Hauppauge and other vendors so really it was
>>>> about which was going to offer best compatibility with Linux? 
>>>> (distro is
>>>> Arch Linux with 3.15 kernel)
>>>>
>>>> The model of card I was looking was from DVB-Sky:
>>>>
>>>> http://www.dvbsky.net/Products_S950C.html
>>>>
>>>> something like that, which has CAM module slot and is DVB-S/S2
>>>> compatible and claims to have drivers supported by the Linuxtv 
>>>> project.
>>>>
>>>>
>>>> Or alternately going for something like this:
>>>>
>>>> http://www.dvbsky.net/Products_T9580.html
>>>>
>>>> as it has a combined DVB-T tuner, then using a USB card reader for the
>>>> CAM "smart card".
>>>>
>>>>
>>>> Has anyone used the cards above, what are the opinions relating to 
>>>> them?
>>>> Also would they work with motorized dishes?
>>>>
>>>>
>>>> Since I'm not sure if "all" CAM's are supported as apparently our
>>>> satellite tv provider wanted to lock out other receivers so they force
>>>> people to use their own product;
>>>>
>>>> my second idea was to perhaps use a capture card with RCA inputs.
>>>>
>>>> Something like this:
>>>>
>>>> http://www.c21video.com/viewcast/osprey-210.html
>>>>
>>>> perhaps or a Hauppauge HD-PVR mk I edition:
>>>>
>>>> which according to the wiki is supported.
>>>>
>>>>
>>>> Looking forward to hearing advice.
>>>>
>>>>
>>>> Thanks.
>>>>
>>>>
>>>> Kaya
>>>> -- 
>>>> To unsubscribe from this list: send the line "unsubscribe
>>>> linux-media" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>>> Hi Kaya,
>>
>> Hi,
>>
>> many thanks for the response!
>>
>>>
>>> RCA inputs is probably the last thing you want. Less quality, more of
>>> a pain to set up.
>>
>> Unfortunately I need the composite inputs due to a set-top box which is
>> used to watch (non-English) sports with; and they are paid channels. The
>> box is non-HD so only RCA (Phono) or SCART output.
>>
>>>
>>> You may or may not be able to use that CAM - but even if it's
>>> supported, a CAM has downsides. It generally only supports one channel
>>> at a time - and surely not multiple channels from different
>>> frequencies (if you have more tuners). And it's more expensive, both
>>> the tuner (that needs a CI slot) and the CAM you need. Also, I'm not
>>> sure if tvheadend nowadays supports a CAM - it used not to, but
>>> support may have been added.
>>>
>>> The main downside of a phoenix-mode cardreader is that it's harder to
>>> set up, but if you can find a guide for your provider it's generally
>>> doable. It's cheaper, more flexible and allows for faster channel
>>> switching.
>>
>> I doubt the provider will have a guide as they "claim" to want to lock
>> everybody into their own set-top box - the non-HD one described above.
>>
>>>
>>> As for a tuner, I personally suggest going for a USB-tuner. You never
>>> know if you want to connect you tuner to a notebook or NAS or anything
>>> in the future, with USB you're more flexible. If you do go for PCI-e,
>>> Tevii appears to have some supported products that are also available.
>>>
>>> If you go for USB, support is somewhat problematic (problematic
>>> because many supported tuners are no longer available in stores),
>>> you'll have to see what's locally available. (perhaps also check
>>> second-hand) Be careful, some devices have various revisions. Always
>>> check http://linuxtv.org/wiki/index.php/Hardware_Device_Information
>>
>> I did go this route eventually (since writing my initial post) :-)
>> currently - though this was supposed to be my "last resort" route.
>>
>> I grabbed a Hauppauge WinTV PVR-1900 EU version.
>>
>> According to these guides:
>>
>> http://www.linuxtv.org/wiki/index.php/Pvrusb2
>>
>> http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-1950
>>
>> http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-1900
>>
>> It is supported.
>>
>> I will need to write a separate posting for it though as I'm a little
>> stuck with it. The BER is quite high and also I can't switch to the
>> 'composite' input most of the time though on rare occasion it does work?
>>
>> The PCI/ or PCI-E card is still an option for me as it will go into a
>> rather large HTPC case which I can also use as a server for distributed
>> TV around the network.
>>
>>>
>>> Very recently, Antti reviewed a patch from nibble.max to support the
>>> DVBsky S960. (and presumably it's direct clones from Mystique) This is
>>> a pretty cheap tuner that can still be found in shops. It would appear
>>> that as soon as this patch gets merged, this device will be supported
>>> if you compile v4l-dvb yourself, and in time support will make it into
>>> the kernel.
>>>
>>> In any case, you want something with in-kernel support - something
>>> that's only supported by s2-liplianin or vendor drivers (like many
>>> dvbsky and TBS products) will only break in the long term. Only
>>> exception to this is Sundtek, but I personally have mixed feelings
>>> about closed source userspace drivers. I wouldn't recommend them
>>> personally.
>>
>> In my research I got suggested the Digital Devices line of products:
>>
>> http://www.digitaldevices.de/
>>
>> They are German so hopefully the quality will be extremely good and they
>> all seem natively supported.
>>
>>>
>>> Good luck,
>>
>> Many thanks.
>>
>>>
>>> P. van Gaans
>>
>> Kaya
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
>
>
> Hi Kaya,

Hi P. van Gaans,

sorry for the confusion!

>
> "I doubt the provider will have a guide as they "claim" to want to 
> lock everybody into their own set-top box - the non-HD one described 
> above."
>
> No, I mean a guide written by somebody on the internet on how to 
> configure a cardserver (like OScam). If your provider is well known 
> chances are somebody has already written a guide for that.

Hmm... I could try that. Basically the setup is a DigiTurk box. The 
provider has already claimed to have disabled usage on all set-top boxes 
other then their own branded ones??? I think that was to stop people 
outside of the country to use their own "better?" boxes with their 
system. Hence the reason for grabbing the HVR-1900.

>
> "I grabbed a Hauppauge WinTV PVR-1900 EU version."
>
> I don't understand. That's an analog+DVB-T hybrid device. So you'll 
> keep using the settopbox?

Sorry, no! I don't want to keep using it. However, if like I stated I 
can't use the smart card module with other DVB-S/S2 tuners then I will 
have to stick with this setup :-(

>
> Well, it's your choice - there are dozens of supported analog cards 
> for Linux. I don't think TVheadend is going to like this, because 
> while TVheadend can probably work with that card, that's usually by 
> using the analog tuner on an analog TV network and some internet feed 
> to replace the EPG. You however are using a settopbox and the 
> composite input, so I don't know how you're going to switch channels. 
> I'm sure it's technically possible, but I couldn't tell you how. So 
> good luck.

I have done this already in MythTV, and works well. Channel changes of 
course don't work however, since really the set-top box is tuned to one 
paid channel (don't ask! I don't get it myself - but that's soccer fans 
for you) which is only served by the current provider with special 
smart-card (something similar to this as example:

http://www.skysat-europe.com/Zencart/zencart4a/images/Orbit220300.jpg ).

((Not our provider or card but just using as example to illustrate the 
type of setup we have)).

So yep, really I guess if I could just get the analog input currently to 
behave hopefully I will be able to get it to work stably with MythTV or 
TVHeadend until I grab proper PCI cards and see if they work with the CI 
card; have already posted a query about that using another subject header.

Sorry if all this is really confusing! It's worse for me trying to get 
things working around a soccer fanatic :-P

>
> Best regards,

Regards

>
> P. van Gaans

Kaya

> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

