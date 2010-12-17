Return-path: <mchehab@gaivota>
Received: from mailout4.samsung.com ([203.254.224.34]:56690 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab0LQGm7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Dec 2010 01:42:59 -0500
Received: from epmmp1 (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LDK002SZ7ZFPR30@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 17 Dec 2010 15:42:51 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LDK00HLU7ZF6O@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 17 Dec 2010 15:42:51 +0900 (KST)
Date: Fri, 17 Dec 2010 15:42:51 +0900
From: "Kim, HeungJun" <riverful.kim@samsung.com>
Subject: Re: [PATCH] V4L/DVB: Add support for M5MOLS Mega Pixel camera
In-reply-to: <4D0A985A.6010007@gmail.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, g.liakhovetski@gmx.de,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Reply-to: riverful.kim@samsung.com
Message-id: <4D0B066B.3000703@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
References: <4D01D96B.8040707@samsung.com> <4D0A985A.6010007@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Sylwester,

Thanks for some comments. I'll reflects this comments for the next version
patch. It's clear that there is a few things I missed. It's better to let's
talk about this rest things, as Mr. Park said.

But, I wanna remind one thing, and know your exact thiking. about MACROs.

I re-comments of that. look around and re-re-comments it, plz.

>> +
>> +/* MACRO */
>> +#define e_check_w(fn, cat, byte, val, bitwidth)        do {    \
>> +    int ret;                        \
>> +    ret = (int)(fn);                    \
>> +    if ((ret)<  0) {                    \
>> +        dev_err(&client->dev, "fail i2c WRITE [%s] - "    \
>> +                "category:0x%02x, "        \
>> +                "bytes:0x%02x, "        \
>> +                "value:0x%02x\n",        \
>> +                (bitwidth),            \
>> +                (cat), (byte), (u32)val);    \
>> +        return ret;                    \
>> +    }                            \
>> +} while (0)
>> +
>> +#define e_check_r(fn, cat, byte, val, bitwidth)        do {    \
>> +    int ret;                        \
>> +    ret = (int)(fn);                    \
>> +    if ((ret)<  0) {                    \
>> +        dev_err(&client->dev, "fail i2c READ [%s] - "    \
>> +                "category:0x%02x, "        \
>> +                "bytes:0x%02x, "        \
>> +                "value:0x%02x\n",        \
>> +                (bitwidth),            \
>> +                (cat), (byte), (u32)(*val));    \
>> +        return ret;                    \
>> +    }                            \
>> +} while (0)
>> +
>> +#define REG_W_8(cat, byte, value)                    \
>> +    e_check_w(m5mols_write_reg(sd, M5MOLS_8BIT, cat, byte, value),    \
>> +            cat, byte, value, "8bit")
>> +#define REG_R_8(cat, byte, value)                    \
>> +    e_check_r(m5mols_read_reg(sd, M5MOLS_8BIT, cat, byte, value),    \
>> +            cat, byte, value, "8bit")
>> +
>> +#define e_check_mode(fn, mode)                do {    \
>> +    int ret;                        \
>> +    ret = (int)(fn);                    \
>> +    if (ret<  0) {                        \
>> +        dev_err(&client->dev, "Failed to %s mode\n",    \
>> +                (mode));            \
>> +        return ret;                    \
>> +    }                            \
>> +} while (0)
> 
> These macros really do not look good. Moreover they all change
> the control flow, i.e. return a value. From Documentation/CodingStyle:
> 
> "Things to avoid when using macros:
> 
> 1) macros that affect control flow:
> 
> #define FOO(x)                                  \
>         do {                                    \
>                 if (blah(x) < 0)                \
>                         return -EBUGGERED;      \
>         } while(0)
> 
> is a _very_ bad idea.  It looks like a function call but exits the
> "calling" function; don't break the internal parsers of those who will
> read the code."

I know about Documentation/CodingStyle and absolutely know about 
the risks of MACRO like upper case. I even know the _very_'s meanings.
But, I think this case is different any other MACRO cases to be concrete
whether use or not. Actually, I've not even found address symbol using T32
debuggers cause of MACROs. I have realized danger before long time.

I know Documentation/CodingStyle is very strong recommandation.
And must keep this style but, it seems to happen the specific case.
The specific means, not general and only used in the M5MOLS code.
The following is my thinking at past.

1. There are a lot of I2C communication is in M5MOLS driver code.
   The M5MOLS has 16 category, and about 50 commands in the each category.
   If each command need 1 line on the code, the amount to be charged I2C
   communication only is 800 lines. What if each command be plused 3~4
   error checking code? The code amount is 3200 lines at least. Moreover,
   No guarantiee 1 command only 1 time excuetion. So, 3200 more lines
   would be added at the future. (The m5mo driver you've seen and used before,
   is not yet inserted all controls.)

   For now, this driver supports only small function. But, If any all other
   controls inserted this code, I can guarantee. it seems so hard to catch
   the flow of code and operation. And, it seems to cause more problems for
   functionalities and hiding bugs, rather than keep using CodingStyle.

2. m5mols I2C communications, namely m5mols_read_reg/write_reg is needed
   many arguments. It violates to do checkpatch.pl 80 characters frequently.
   So, I inserted next lines the rest of m5mols_read_reg(), it effects more
   line added, consequently it looks like upper case.

3. Any other reason is discussed with Hans. And he explained alternative method.
   so, I'll follow this because I think he is right.

I thought, exact when the wrong MACRO usage case told at CodingStyle is happened.
(I don't believe that wrong MACRO usage must keep all the time in the kernel code.)
And concluded If another code(like a general function used in various driver,
kernel core. etc.) use dangerous MACROs, the developer do not know well MACROs,
it would happen the problems. 

But, this MACROs in M5MOLS driver is only use in this code itself.

Then, I wanna ask Sylwester.
Can you explain to me exact reasonable why "don't look good" in the M5MOLS case,
rather than the truth enumerating Documentaion, to be kept by linux driver developers?

Actually I already was working another version of driver. and removed this MACRO's.
Because It's not to declare in the CodingStyle, said not to do that.
Because I know and hear the another reasonable why.

I wanna just know resonable why of you thinking.

If you check this reasons and tell me, I reflects your opinions straightly.

< snip >

Very thanks to review one more time. and Welcome any time :)

Regards,
Heungjun Kim


