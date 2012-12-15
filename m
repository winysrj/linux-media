Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44890 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430Ab2LORQj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Dec 2012 12:16:39 -0500
Message-ID: <50CCB057.9060704@iki.fi>
Date: Sat, 15 Dec 2012 19:16:07 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH 5/5] em28xx: fix+improve+unify i2c error handling, debug
 messages and code comments
References: <1355502533-25636-1-git-send-email-fschaefer.oss@googlemail.com> <1355502533-25636-6-git-send-email-fschaefer.oss@googlemail.com> <50CB5BF8.5070201@iki.fi> <50CC7499.8020507@googlemail.com> <50CC7F4E.5060803@iki.fi> <50CCA493.4070309@googlemail.com>
In-Reply-To: <50CCA493.4070309@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/15/2012 06:25 PM, Frank Schäfer wrote:
> Am 15.12.2012 14:46, schrieb Antti Palosaari:
>> On 12/15/2012 03:01 PM, Frank Schäfer wrote:
>>> Am 14.12.2012 18:03, schrieb Antti Palosaari:
>>>> On 12/14/2012 06:28 PM, Frank Schäfer wrote:
>>>>> - check i2c slave address range (only 7 bit addresses supported)
>>>>> - do not pass USB specific error codes to userspace/i2c-subsystem
>>>>> - unify the returned error codes and make them compliant with
>>>>>      the i2c subsystem spec
>>>>> - check number of actually transferred bytes (via USB) everywehere
>>>>> - fix/improve debug messages
>>>>> - improve code comments
>>>>>
>>>>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>>>>
>>>>
>>>>> @@ -244,16 +294,20 @@ static int em28xx_i2c_xfer(struct i2c_adapter
>>>>> *i2c_adap,
>>>>>             dprintk2(2, "%s %s addr=%x len=%d:",
>>>>>                  (msgs[i].flags & I2C_M_RD) ? "read" : "write",
>>>>>                  i == num - 1 ? "stop" : "nonstop", addr, msgs[i].len);
>>>>> +        if (addr > 0xff) {
>>>>> +            dprintk2(2, " ERROR: 10 bit addresses not supported\n");
>>>>> +            return -EOPNOTSUPP;
>>>>> +        }
>>>>
>>>> There is own flag for 10bit I2C address. Use it (and likely not
>>>> compare at all addr validly like that). This kind of address
>>>> validation check is quite unnecessary - and after all if it is wanted
>>>> then correct place is somewhere in I2C routines.
>>>
>>> Well, to be 100% sure and strict, we should check both, the flag and the
>>> actual address.
>>> We support 7 bit addresses only, no matter which i2c algo is used. So
>>> doing the address check in each i2c routine seems to be unnecessary code
>>> duplication to me ?
>>
>> I will repeat me, I see it overkill to check address correctness. And
>> as I said, that one is general validly could be done easily in I2C
>> core - so why the hell you wish make it just only for em28xx ?
>>
>> I am quite sure if that kind of address validness are saw important
>> they are already implemented by I2C core.
>>
>> Make patch for I2C which does that address validation against client
>> 10BIT flag and sent it to the mailing list for discussion.
>
> The I2C core doesn't know about the capabilities of the adapter.
> Hence it doesn't know if ten bit addresses will work (the same as with
> the message size constraints).
> All it does ist to check the client for I2C_CLIENT_TEN && addr > 0x7f
> once, when it is instanciated with a call to i2c_new_device().
> But we don't use this function in em28xx and the same applies to many
> other drivers as well.
> Apart from that, the client address and flags can change anytime later
> (e.g. when probing devices).

yes, it does not need to know if adapter supports 10 bit or not, or how 
many bytes adapter could send at once. It is up to adapter to check those.

But it could check if client tries to send using invalid address (client 
says it is 7BIT, but address is 10BIT), just situation you are adding to 
em28xx adapter.

If you are worried flags and address could change during operation, I2C 
core could check it too. Every driver I have seen are using I2C routines 
to send messages, and if there is check lets say eg. inside 
i2c_transfer() then it benefits all the others than em28xx. That is NOT 
em28xx *only* issue, it is common for all of our drivers. As it is 
common, adding check for each driver sounds wrong. General check should 
be done in general level, and hw specific issues are for driver.


> But if you hate the check, I can kick it out.
> The risk that it will cause any problems in practice is small.

Mostly, I am trying to explain you are trying to add that check to wrong 
place. Need of whole check is another issue.

regards
Antti

-- 
http://palosaari.fi/
