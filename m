Return-path: <mchehab@gaivota>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:23349 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab0LQQfW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Dec 2010 11:35:22 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Received: from spt2.w1.samsung.com ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LDK00IYGZEVNK60@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 17 Dec 2010 16:35:19 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LDK00NCOZEU0S@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 17 Dec 2010 16:35:19 +0000 (GMT)
Date: Fri, 17 Dec 2010 17:35:18 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH] V4L/DVB: Add support for M5MOLS Mega Pixel camera
In-reply-to: <4D0B066B.3000703@samsung.com>
To: riverful.kim@samsung.com
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, g.liakhovetski@gmx.de,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Message-id: <4D0B9146.7050804@samsung.com>
References: <4D01D96B.8040707@samsung.com> <4D0A985A.6010007@gmail.com>
 <4D0B066B.3000703@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


Hi HeungJun,

On 12/17/2010 07:42 AM, Kim, HeungJun wrote:
> Hi Sylwester,
> 
> Thanks for some comments. I'll reflects this comments for the next version
> patch. It's clear that there is a few things I missed. It's better to let's
> talk about this rest things, as Mr. Park said.
> 
> But, I wanna remind one thing, and know your exact thiking. about MACROs.
> 
> I re-comments of that. look around and re-re-comments it, plz.
> 
>>> +
>>> +/* MACRO */
>>> +#define e_check_w(fn, cat, byte, val, bitwidth)        do {    \
>>> +    int ret;                        \
>>> +    ret = (int)(fn);                    \
>>> +    if ((ret)<  0) {                    \
>>> +        dev_err(&client->dev, "fail i2c WRITE [%s] - "    \
>>> +                "category:0x%02x, "        \
>>> +                "bytes:0x%02x, "        \
>>> +                "value:0x%02x\n",        \
>>> +                (bitwidth),            \
>>> +                (cat), (byte), (u32)val);    \
>>> +        return ret;                    \
>>> +    }                            \
>>> +} while (0)
>>> +
>>> +#define e_check_r(fn, cat, byte, val, bitwidth)        do {    \
>>> +    int ret;                        \
>>> +    ret = (int)(fn);                    \
>>> +    if ((ret)<  0) {                    \
>>> +        dev_err(&client->dev, "fail i2c READ [%s] - "    \
>>> +                "category:0x%02x, "        \
>>> +                "bytes:0x%02x, "        \
>>> +                "value:0x%02x\n",        \
>>> +                (bitwidth),            \
>>> +                (cat), (byte), (u32)(*val));    \
>>> +        return ret;                    \
>>> +    }                            \
>>> +} while (0)
>>> +
>>> +#define REG_W_8(cat, byte, value)                    \
>>> +    e_check_w(m5mols_write_reg(sd, M5MOLS_8BIT, cat, byte, value),    \
>>> +            cat, byte, value, "8bit")
>>> +#define REG_R_8(cat, byte, value)                    \
>>> +    e_check_r(m5mols_read_reg(sd, M5MOLS_8BIT, cat, byte, value),    \
>>> +            cat, byte, value, "8bit")
>>> +
>>> +#define e_check_mode(fn, mode)                do {    \
>>> +    int ret;                        \
>>> +    ret = (int)(fn);                    \
>>> +    if (ret<  0) {                        \
>>> +        dev_err(&client->dev, "Failed to %s mode\n",    \
>>> +                (mode));            \
>>> +        return ret;                    \
>>> +    }                            \
>>> +} while (0)
>>
>> These macros really do not look good. Moreover they all change
>> the control flow, i.e. return a value. From Documentation/CodingStyle:
>>
>> "Things to avoid when using macros:
>>
>> 1) macros that affect control flow:
>>
>> #define FOO(x)                                  \
>>         do {                                    \
>>                 if (blah(x) < 0)                \
>>                         return -EBUGGERED;      \
>>         } while(0)
>>
>> is a _very_ bad idea.  It looks like a function call but exits the
>> "calling" function; don't break the internal parsers of those who will
>> read the code."
> 
> I know about Documentation/CodingStyle and absolutely know about 
> the risks of MACRO like upper case. I even know the _very_'s meanings.
> But, I think this case is different any other MACRO cases to be concrete
> whether use or not. Actually, I've not even found address symbol using T32
> debuggers cause of MACROs. I have realized danger before long time.
> 
> I know Documentation/CodingStyle is very strong recommandation.
> And must keep this style but, it seems to happen the specific case.
> The specific means, not general and only used in the M5MOLS code.
> The following is my thinking at past.
> 
> 1. There are a lot of I2C communication is in M5MOLS driver code.
>    The M5MOLS has 16 category, and about 50 commands in the each category.
>    If each command need 1 line on the code, the amount to be charged I2C
>    communication only is 800 lines. What if each command be plused 3~4
>    error checking code? The code amount is 3200 lines at least. Moreover,
>    No guarantiee 1 command only 1 time excuetion. So, 3200 more lines
>    would be added at the future. (The m5mo driver you've seen and used before,
>    is not yet inserted all controls.)

Then this sensor needs careful design and function partitioning.
Single *.c file should not exceed 1000 lines.
I think we need a separate directory for it, like media/drivers/m5mols/.

Hans already pointed out a few ways around macros. I just didn't want to repeat
that.

> 
>    For now, this driver supports only small function. But, If any all other
>    controls inserted this code, I can guarantee. it seems so hard to catch
>    the flow of code and operation. And, it seems to cause more problems for
>    functionalities and hiding bugs, rather than keep using CodingStyle.
> 
> 2. m5mols I2C communications, namely m5mols_read_reg/write_reg is needed
>    many arguments. It violates to do checkpatch.pl 80 characters frequently.
>    So, I inserted next lines the rest of m5mols_read_reg(), it effects more
>    line added, consequently it looks like upper case.
> 
> 3. Any other reason is discussed with Hans. And he explained alternative method.
>    so, I'll follow this because I think he is right.
> 
> I thought, exact when the wrong MACRO usage case told at CodingStyle is happened.
> (I don't believe that wrong MACRO usage must keep all the time in the kernel code.)
> And concluded If another code(like a general function used in various driver,
> kernel core. etc.) use dangerous MACROs, the developer do not know well MACROs,
> it would happen the problems. 
> 
> But, this MACROs in M5MOLS driver is only use in this code itself.

I just wanted to ease the maintainer's job by drawing your attention to issues
that otherwise would be pointed out anyway. The sooner the serious issues are
eliminated the less work for you. I do not accept excuses that your device
is special so it may break the rules ;-)
In the past I had also been doing similar mistakes.

> 
> Then, I wanna ask Sylwester.
> Can you explain to me exact reasonable why "don't look good" in the M5MOLS case,
> rather than the truth enumerating Documentaion, to be kept by linux driver developers?
> 
> Actually I already was working another version of driver. and removed this MACRO's.
> Because It's not to declare in the CodingStyle, said not to do that.
> Because I know and hear the another reasonable why.
> 
> I wanna just know resonable why of you thinking.

These macros are simply annoying to read. They are not descriptive enough and
many times I see them in the code I have to go back to their definition, with
multiple levels of indirection, to see what is really going on. Please mind all
the poor people that will be trying to understand and perhaps modify your code.
It's in public domain so one must be prepared for that when submitting ;-)

Since new v4l2 controls need to be introduced based on the functionality
of the M-5MO(LS) others are going to be inspecting the code and even more
important it might need to be a reference in the future on how to use the new
v4l2 controls.

Regards,
Sylwester

> 
> If you check this reasons and tell me, I reflects your opinions straightly.
> 
> < snip >
> 
> Very thanks to review one more time. and Welcome any time :)
> 
> Regards,
> Heungjun Kim

-- 
Sylwester Nawrocki
Samsung Poland R&D Center
