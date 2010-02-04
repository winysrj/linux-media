Return-path: <linux-media-owner@vger.kernel.org>
Received: from joe.mail.tiscali.it ([213.205.33.54]:55469 "EHLO
	joe.mail.tiscali.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758111Ab0BDTQt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Feb 2010 14:16:49 -0500
Message-ID: <4B6B1CDD.9010204@gmail.com>
Date: Thu, 04 Feb 2010 20:15:41 +0100
From: "Andrea.Amorosi76@gmail.com" <Andrea.Amorosi76@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: How can I add IR remote to this new device (DIKOM DK300)?
References: <4B51132A.1000606@gmail.com> <4B5D912F.6000609@redhat.com> <4B5F6914.4080502@gmail.com> <4B5F6BB9.4000203@redhat.com> <4B61E759.5000707@gmail.com> <4B63169C.70700@redhat.com>
In-Reply-To: <4B63169C.70700@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab ha scritto:
> Andrea.Amorosi76@gmail.com wrote:
>   
>> Mauro Carvalho Chehab ha scritto:
>>     
>>> Andrea.Amorosi76@gmail.com wrote:
>>>  
>>>   
>>>       
>>>> So since it is necessary to create a new entry, is there any rules to
>>>> follow to choose it?
>>>>     
>>>>         
>>> Just use the existing entry as an example. You'll need to put your
>>> card name at the entry, and add a new #define at em28xx.h.
>>>
>>> Cheers,
>>> Mauro
>>>
>>>   
>>>       
>> Ok!
>> As far as the auto detection issue is concerned, can I add the EEPROM ID
>> and hash so that to use such data to detect the DIKOM device?
>> I've seen that the same numbers are not present for other devices, so I
>> think adding them should not create problems with other devices, but I'm
>> not sure regard that.
>>     
>
> Yes, but the code will need to be changed a little bit, since the eeprom id
> detection happens only for some specific usb id's.
>
> Cheers,
> Mauro
>
>   
Hi Mauro,
since I was not able to have my remote controller working (maybe it does 
not work at all), I've send a new version of the patch which should 
solve all the issue you pointed by creating a new entry and using the 
eeprom id to detect the card.
That patch still does not appear in patchwork.
Can you have a look at it, please?
I've send it yesterday with this object "[PATCH] em28xx: add Dikom DK300 
hybrid USB tuner" which is clearer than this mail one.
Thank you,
Andrea
