Return-path: <mchehab@gaivota>
Received: from mail-fx0-f43.google.com ([209.85.161.43]:40056 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab0LRQGD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Dec 2010 11:06:03 -0500
Received: by fxm18 with SMTP id 18so1698581fxm.2
        for <linux-media@vger.kernel.org>; Sat, 18 Dec 2010 08:06:02 -0800 (PST)
Message-ID: <4D0CDBE7.30504@gmail.com>
Date: Sat, 18 Dec 2010 17:05:59 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: riverful.kim@samsung.com
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, g.liakhovetski@gmx.de,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Subject: Re: [PATCH] V4L/DVB: Add support for M5MOLS Mega Pixel camera
References: <4D01D96B.8040707@samsung.com> <4D0A985A.6010007@gmail.com> <4D0B066B.3000703@samsung.com> <4D0B9146.7050804@samsung.com>
In-Reply-To: <4D0B9146.7050804@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 12/17/2010 05:35 PM, Sylwester Nawrocki wrote:
>
> Hi HeungJun,
>
> On 12/17/2010 07:42 AM, Kim, HeungJun wrote:
>> Hi Sylwester,
>>
>> Thanks for some comments. I'll reflects this comments for the next version
>> patch. It's clear that there is a few things I missed. It's better to let's
>> talk about this rest things, as Mr. Park said.
>>
>> But, I wanna remind one thing, and know your exact thiking. about MACROs.
>>
>> I re-comments of that. look around and re-re-comments it, plz.
>>
>>>> +
>>>> +/* MACRO */
>>>> +#define e_check_w(fn, cat, byte, val, bitwidth)        do {    \
>>>> +    int ret;                        \
>>>> +    ret = (int)(fn);                    \
>>>> +    if ((ret)<   0) {                    \
>>>> +        dev_err(&client->dev, "fail i2c WRITE [%s] - "    \
>>>> +                "category:0x%02x, "        \
>>>> +                "bytes:0x%02x, "        \
>>>> +                "value:0x%02x\n",        \
>>>> +                (bitwidth),            \
>>>> +                (cat), (byte), (u32)val);    \
>>>> +        return ret;                    \
>>>> +    }                            \
>>>> +} while (0)
>>>> +
>>>> +#define e_check_r(fn, cat, byte, val, bitwidth)        do {    \
>>>> +    int ret;                        \
>>>> +    ret = (int)(fn);                    \
>>>> +    if ((ret)<   0) {                    \
>>>> +        dev_err(&client->dev, "fail i2c READ [%s] - "    \
>>>> +                "category:0x%02x, "        \
>>>> +                "bytes:0x%02x, "        \
>>>> +                "value:0x%02x\n",        \
>>>> +                (bitwidth),            \
>>>> +                (cat), (byte), (u32)(*val));    \
>>>> +        return ret;                    \
>>>> +    }                            \
>>>> +} while (0)
>>>> +
>>>> +#define REG_W_8(cat, byte, value)                    \
>>>> +    e_check_w(m5mols_write_reg(sd, M5MOLS_8BIT, cat, byte, value),    \
>>>> +            cat, byte, value, "8bit")
>>>> +#define REG_R_8(cat, byte, value)                    \
>>>> +    e_check_r(m5mols_read_reg(sd, M5MOLS_8BIT, cat, byte, value),    \
>>>> +            cat, byte, value, "8bit")
>>>> +
>>>> +#define e_check_mode(fn, mode)                do {    \
>>>> +    int ret;                        \
>>>> +    ret = (int)(fn);                    \
>>>> +    if (ret<   0) {                        \
>>>> +        dev_err(&client->dev, "Failed to %s mode\n",    \
>>>> +                (mode));            \
>>>> +        return ret;                    \
>>>> +    }                            \
>>>> +} while (0)
>>>
>>> These macros really do not look good. Moreover they all change
>>> the control flow, i.e. return a value. From Documentation/CodingStyle:
>>>
>>> "Things to avoid when using macros:
>>>
>>> 1) macros that affect control flow:
>>>
>>> #define FOO(x)                                  \
>>>          do {                                    \
>>>                  if (blah(x)<  0)                \
>>>                          return -EBUGGERED;      \
>>>          } while(0)
>>>
>>> is a _very_ bad idea.  It looks like a function call but exits the
>>> "calling" function; don't break the internal parsers of those who will
>>> read the code."
>>
>> I know about Documentation/CodingStyle and absolutely know about
>> the risks of MACRO like upper case. I even know the _very_'s meanings.
>> But, I think this case is different any other MACRO cases to be concrete
>> whether use or not. Actually, I've not even found address symbol using T32
>> debuggers cause of MACROs. I have realized danger before long time.
>>
>> I know Documentation/CodingStyle is very strong recommandation.
>> And must keep this style but, it seems to happen the specific case.
>> The specific means, not general and only used in the M5MOLS code.
>> The following is my thinking at past.
>>
>> 1. There are a lot of I2C communication is in M5MOLS driver code.
>>     The M5MOLS has 16 category, and about 50 commands in the each category.
>>     If each command need 1 line on the code, the amount to be charged I2C
>>     communication only is 800 lines. What if each command be plused 3~4
>>     error checking code? The code amount is 3200 lines at least. Moreover,
>>     No guarantiee 1 command only 1 time excuetion. So, 3200 more lines
>>     would be added at the future. (The m5mo driver you've seen and used before,
>>     is not yet inserted all controls.)
>
> Then this sensor needs careful design and function partitioning.
> Single *.c file should not exceed 1000 lines.
> I think we need a separate directory for it, like media/drivers/m5mols/.

ouch, that was supposed to be drivers/media/video/m5mols

