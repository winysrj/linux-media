Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47220 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989Ab2KFORk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Nov 2012 09:17:40 -0500
Message-ID: <50991BE3.5090308@iki.fi>
Date: Tue, 06 Nov 2012 16:17:07 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Oliver Schinagl <oliver+list@schinagl.nl>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Add chipid to fc2580.c
References: <50850116.9060806@schinagl.nl>    <20121028180713.7d852443@redhat.com> <6698470182ac3a8581c577d93cb49f8d.squirrel@webmail.kapsi.fi> <508F9CC2.5070301@schinagl.nl> <50984488.3070904@iki.fi> <5098FC0B.4040500@schinagl.nl>
In-Reply-To: <5098FC0B.4040500@schinagl.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/06/2012 02:01 PM, Oliver Schinagl wrote:
> On 05-11-12 23:58, Antti Palosaari wrote:
>> On 10/30/2012 11:24 AM, Oliver Schinagl wrote:
>>> On 29-10-12 02:09, Antti Palosaari wrote:
>>>> su 28.10.2012 22:07 Mauro Carvalho Chehab kirjoitti:
>>>>> Em Mon, 22 Oct 2012 10:17:26 +0200
>>>>> Oliver Schinagl <oliver+list@schinagl.nl> escreveu:
>>>>>
>>>>>> diff --git a/drivers/media/tuners/fc2580.c
>>>>>> b/drivers/media/tuners/fc2580.c
>>>>>> index aff39ae..102d942 100644
>>>>>> I found a fellow Asus U3100+ user (mentioned him before with the
>>>>>> firmware issue) that even when using the latest firmware, still see's
>>>>>> 0xff as the chipID.
>>>>> You missed to add a signed-off-by on your patch.
>>>>>
>>>>> Maybe it would make sense, in this case, to print some warning
>>>>> message,
>>>>> as this could be due to a bug either at the hardware or at some place
>>>>> at the driver, like the gpio config settings for this device.
>>>>>
>>>>> Anyway, Antti, your call.
>>>> I am on holiday now and dont want to look much these things at the
>>>> moment.
>>>>
>>>> Having 0x00 or 0xff as chip id is something very very stupid and not
>>>> exits
>>>> in real world. It is good indicator I2C operation was failing. Check
>>>> GPIOs, see windows sniffs, add sleep, test if other I2C reads are
>>>> working
>>>> later, etc. to find out more info and fix it properly. In worst case
>>>> it is
>>>> possible that I2C reads are not working at all...
>>> This was a random report for someone who I assisted via e-mail to get
>>> the latest git clone from antti's tree. Building, enabling debugging and
>>> getting this information alone took a week. I don't think we have the
>>> possibility to get a dump from anything. The stick has been working fine
>>> from my understanding using the 0xff tunerID. How to handle support for
>>> these 'bugged' tuners, I leave that up to you :)
>>
>> Honestly I don't want to add hack like that with this little
>> information. It must be found out if all I2C readings are failing, or
>> just the first one, or some other condition. Currently there is only
>> two register reads on that driver. Guess what happens if someone
>> enhances that driver so that one bit from certain register is
>> changed... Set register bit 7, current register value is 0x00.
>> Register value will be 0x7ff as read returns always 0xff :-(
> true, do you have some test code, that could test this? or a test module
> that prints some debug information for this specific case? I could then
> have the user in question try it out and report his findings?

Just add like 5 register reads one after another inside attach and print 
out returned values. Or add debug print to register read to see what it 
returns as read is used during tune too. Write different tuner id to 
af9035 firmware to see if it is fw issue. There is million ways to make 
tests and see what happens and make conclusions.

Antti

>
> oliver
>>
>>>
>>> AFTER your well deserved holiday. Enjoy and have a great time!
>>>
>>>>
>>>>
>>>>>>
>>>>>> --- a/drivers/media/tuners/fc2580.c
>>>>>> +++ b/drivers/media/tuners/fc2580.c
>>>>>> @@ -497,6 +497,7 @@ struct dvb_frontend *fc2580_attach(struct
>>>>>> dvb_frontend *fe,
>>>>>>           switch (chip_id) {
>>>>>>           case 0x56:
>>>>>>           case 0x5a:
>>>>>> +       case 0xff:
>>>>>>                   break;
>>>>>>           default:
>>>>>>                   goto err;
>>>>>>
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>> linux-media"
>>>>>> in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>>>>
>>>>> --
>>>>> Regards,
>>>>> Mauro
>>>>>
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe
>>>> linux-media" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>>
>>
>> regards
>> Antti
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
http://palosaari.fi/
