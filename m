Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339Ab0A2RK5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2010 12:10:57 -0500
Message-ID: <4B63169C.70700@redhat.com>
Date: Fri, 29 Jan 2010 15:10:52 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "Andrea.Amorosi76@gmail.com" <Andrea.Amorosi76@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: How can I add IR remote to this new device (DIKOM DK300)?
References: <4B51132A.1000606@gmail.com> <4B5D912F.6000609@redhat.com> <4B5F6914.4080502@gmail.com> <4B5F6BB9.4000203@redhat.com> <4B61E759.5000707@gmail.com>
In-Reply-To: <4B61E759.5000707@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andrea.Amorosi76@gmail.com wrote:
> Mauro Carvalho Chehab ha scritto:
>> Andrea.Amorosi76@gmail.com wrote:
>>  
>>   
>>> So since it is necessary to create a new entry, is there any rules to
>>> follow to choose it?
>>>     
>>
>> Just use the existing entry as an example. You'll need to put your
>> card name at the entry, and add a new #define at em28xx.h.
>>
>> Cheers,
>> Mauro
>>
>>   
> Ok!
> As far as the auto detection issue is concerned, can I add the EEPROM ID
> and hash so that to use such data to detect the DIKOM device?
> I've seen that the same numbers are not present for other devices, so I
> think adding them should not create problems with other devices, but I'm
> not sure regard that.

Yes, but the code will need to be changed a little bit, since the eeprom id
detection happens only for some specific usb id's.

Cheers,
Mauro
