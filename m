Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49716 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702Ab3ABVP7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Jan 2013 16:15:59 -0500
Message-ID: <50E4A368.6040705@iki.fi>
Date: Wed, 02 Jan 2013 23:15:20 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	saschasommer@freenet.de,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 2/5] em28xx: respect the message size constraints for
 i2c transfers
References: <1355682211-13604-1-git-send-email-fschaefer.oss@googlemail.com> <1355682211-13604-3-git-send-email-fschaefer.oss@googlemail.com> <20121222220746.64611c08@redhat.com> <50D70DF4.2000408@googlemail.com> <20121223124624.0122504c@redhat.com> <50D837EE.6040207@googlemail.com> <50E48A89.1040901@iki.fi> <50E4A2DA.2000400@googlemail.com>
In-Reply-To: <50E4A2DA.2000400@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/02/2013 11:12 PM, Frank Schäfer wrote:
> Hi Antti,
>
> Am 02.01.2013 20:29, schrieb Antti Palosaari:
>> On 12/24/2012 01:09 PM, Frank Schäfer wrote:
>>> Am 23.12.2012 15:46, schrieb Mauro Carvalho Chehab:
>>>> Em Sun, 23 Dec 2012 14:58:12 +0100
>>>> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>>>>
>>>>> Am 23.12.2012 01:07, schrieb Mauro Carvalho Chehab:
>>>>>> Em Sun, 16 Dec 2012 19:23:28 +0100
>>>>>> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>>>
>>>>>> Those devices are limited, and just like other devices (cx231xx
>>>>>> for example),
>>>>>> the I2C bus need to split long messages, otherwise the I2C devices
>>>>>> will
>>>>>> fail.
>>>>> I2C adapters are supposed to fail with -EOPNOTSUPP if the message
>>>>> length
>>>>> exceeds their capabilities.
>>>>> Drivers must be able to handle this error, otherwise they have to
>>>>> be fixed.
>>>> Currently, afaikt, no V4L2 I2C client knows how to handle it.
>>>
>>> Maybe. Fortunately, it seems to cause no trouble.
>>>
>>>>    Ok, returning
>>>> -EOPNOTSUPP if the I2C data came from userspace makes sense.
>>>>
>>>>>> Btw, there was already a long discussion with regards to splitting
>>>>>> long
>>>>>> I2C messages at the I2C bus or at the I2C adapters. The decision was
>>>>>> to do it at the I2C bus logic, as it is simpler than making a code
>>>>>> at each I2C client for them to properly handle -EOPNOTSUPP and
>>>>>> implement
>>>>>> a fallback logic to reduce the transfer window until reach what's
>>>>>> supported by the device.
>>>>> While letting the i2c bus layer split messages sounds like the right
>>>>> thing to do, it is hard to realize that in practice.
>>>>> The reason is, that the needed algorithm depends on the
>>>>> capabilities and
>>>>> behavior of the i2c adapter _and_ the connected i2c client.
>>>>> The three main parameters are:
>>>>> - message size limits
>>>>> - client register width
>>>>> - automatic register index incrementation
>>>>>
>>>>> I don't know what has been discussed in past,
>>>> You'll need to dig into the ML archives. This is a recurrent theme,
>>>> and,
>>>> we have implementations doing I2C split at bus (most cases) and a few
>>>> ones doing it at the client side.
>>>
>>> Yeah, I also have a working implementation of i2c block read/write
>>> emulation in my experimental code. ;)
>>>
>>>>> but I talked to Jean
>>>>> Delvare about the message size constraints a few weeks ago.
>>>>> He told me that it doesn't make sense to try to handle this at the i2c
>>>>> subsystem level. The parameters can be different for reading and
>>>>> writing, adapter and client and things are getting complicated
>>>>> quickly.
>>>> Jean's opinion is to push it to I2C clients (and we actually do it on a
>>>> few cases), but as I explained before, there are several drivers where
>>>> this is better done at the I2C bus driver, as the I2C implementation
>>>> allows doing it easily at bus level by playing with I2C STOP bits/I2C
>>>> start bits.
>>>>
>>>> We simply have too much I2C clients, and -EOPNOTSUPP error code doesn't
>>>> tell the max size of the I2C messages. Adding a complex split logic
>>>> for every driver is not a common practice, as just a few I2C bus bridge
>>>> drivers suffer from very strict limits.
>>>
>>> Yes, and even with those who have such a strict limit, it is usually not
>>> exceeded because the clients are too 'simple'. ;)
>>>
>>>> Also, clients that split I2C messages don't actually handle
>>>> -EOPNOTSUPP.
>>>> Instead, they have an init parameter telling the maximum size of the
>>>> I2C messages accepted by the bus.
>>>>
>>>> The logic there is complex, and may require an additional logic at the
>>>> bus side, in order to warrant that no I2C stop/start bits will be sent
>>>> in the middle of a message, or otherwise the device will fail[1].
>>>>
>>>> So, it is generally simpler and more effective to just do it at the bus
>>>> side.
>>>
>>> Maybe. I have no opinion yet.
>>> My feeling is, that this should be handled by the i2c subsystem as much
>>> as possible, but
>>> a) it's complex due to the described reasons
>>> b) I have no complete concept yet
>>> c) the i2c people seem to be not very interested
>>> d) there is lots of other stuff with a higher priority on my TODO list
>>
>> Maybe you already have seen, but I did some initial stuff year or two
>> ago for implementing that but left it unimplemented as there was so
>> much stuff to check and discuss in order to agree correct solution.
>>
>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg38840.html
>>
>> There is regmap which maybe could do stuff like that, I am not sure as
>> I never tested it. At least it could do some stuff top of I2C bus.
>
> Yes, I've read this discussion, but didn't have time to take a deeper
> look into the regmap stuff yet.
>
> For the em28xx driver itself, there is no real need for i2c block
> read/write emulation at the moment. We could save only a few lines.
> I'm also burried with lots of other stuff at the moment which has a
> higher priority for me.
>
> Please note that the whole discussion has nothing to do with this patch.
> It just removes code which isn't and has never been working.
>
>>
>> Also I heavily disagree you what goes to I2C subsystem integration.
>> That is clearly stuff which resides top of I2C bus and it is *not bus
>> dependent*. There is many other buses too having similar splitting
>> logic like SPI?
>>
>
> I don't understand you. In which points do we disagree ??

"My feeling is, that this should be handled by the i2c subsystem as much 
as possible"

Antti


-- 
http://palosaari.fi/
