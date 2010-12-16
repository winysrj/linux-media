Return-path: <mchehab@gaivota>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4086 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab0LPMUW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Dec 2010 07:20:22 -0500
Message-ID: <235e6a932320c0c7bc20fe76deaf1c2e.squirrel@webmail.xs4all.nl>
In-Reply-To: <4D09F80F.807@samsung.com>
References: <4D01D96B.8040707@samsung.com>
    <201012160827.46575.hverkuil@xs4all.nl> <4D09F80F.807@samsung.com>
Date: Thu, 16 Dec 2010 13:20:17 +0100
Subject: Re: [PATCH] V4L/DVB: Add support for M5MOLS Mega Pixel camera
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: riverful.kim@samsung.com
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	g.liakhovetski@gmx.de,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

> Hi Hans,
>
>
> 2010-12-16 오후 4:27, Hans Verkuil 쓴 글:
>> Thanks for the reminder, I missed this patch.
>>
>> Review comments are below.
>>
>
> <snip>
>
>>> +
>>> +/* MACRO */
>>> +#define e_check_w(fn, cat, byte, val, bitwidth)		do {	\
>>> +	int ret;						\
>>> +	ret = (int)(fn);					\
>>> +	if ((ret) < 0) {					\
>>> +		dev_err(&client->dev, "fail i2c WRITE [%s] - "	\
>>> +				"category:0x%02x, "		\
>>> +				"bytes:0x%02x, "		\
>>> +				"value:0x%02x\n",		\
>>> +				(bitwidth),			\
>>> +				(cat), (byte), (u32)val);	\
>>> +		return ret;					\
>>> +	}							\
>>> +} while (0)
>>> +
>>> +#define e_check_r(fn, cat, byte, val, bitwidth)		do {	\
>>> +	int ret;						\
>>> +	ret = (int)(fn);					\
>>> +	if ((ret) < 0) {					\
>>> +		dev_err(&client->dev, "fail i2c READ [%s] - "	\
>>> +				"category:0x%02x, "		\
>>> +				"bytes:0x%02x, "		\
>>> +				"value:0x%02x\n",		\
>>> +				(bitwidth),			\
>>> +				(cat), (byte), (u32)(*val));	\

I would place this error in the m5mols_read_reg function itself rather
than in the macro.

>>> +		return ret;					\
>>> +	}							\
>>> +} while (0)
>>> +
>>> +#define REG_W_8(cat, byte, value)					\
>>> +	e_check_w(m5mols_write_reg(sd, M5MOLS_8BIT, cat, byte, value),	\
>>> +			cat, byte, value, "8bit")
>>> +#define REG_R_8(cat, byte, value)					\
>>> +	e_check_r(m5mols_read_reg(sd, M5MOLS_8BIT, cat, byte, value),	\
>>> +			cat, byte, value, "8bit")
>>> +
>>> +#define e_check_mode(fn, mode)				do {	\
>>> +	int ret;						\
>>> +	ret = (int)(fn);					\
>>> +	if (ret < 0) {						\
>>> +		dev_err(&client->dev, "Failed to %s mode\n",	\
>>> +				(mode));			\
>>> +		return ret;					\
>>> +	}							\
>>> +} while (0)
>>> +
>>> +#define mode_monitoring(sd)					\
>>> +	e_check_mode(m5mols_monitoring_mode(sd), "MONITORING")
>>> +#define mode_parameter(sd)					\
>>> +	e_check_mode(m5mols_parameter_mode(sd), "PARAMETER")
>>
>> All these #defines above can be replaced by static inline functions.
>> That the
>> better option since static inline functions are type-safe.
>>
> You're definitely right. So, I know that #defines must be used carefully,
> either.
> But, in this driver code, the macros to use ultimately like this(e.g.,
> REG_W_8(),
> REG_R_8(), mode_monitoring(), mode_parameter()), is never return any
> value.
> It return itself, if any error is sensed.

I actually missed that during my first review. Thanks for pointing that
out, but this is even more reason not to do it like this.

> Namely, it's a bulk of codes, not a function.
>
> IMHO, The reasons I made of this macro are 3 things.
>
> 1. It may not looks good to add 3 or 4 lines code for checking error
> return values.

But what is worse is that you hide the return in the macro. So what looks
like a simple function-like macro will in reality have the side-effect of
returning. It's much better to explicitly handle the error in the calling
function.

> 2. It can prevent to miss error-checking code. Just use macro, then be
> able to
>     handle error check, and show the kernel msg about i2c error return, or
> anything
>     errors.

You can add a __must_check attribute to the function that will force the
compiler to generate a warning if the return code isn't checked. Much
cleaner.

> 3. If this macro changes to function type, it need one more error checking
> codes
>     in the functions using this macros. So, then, the driver operation
> flow is a
>     litte mess-up.

Actually, I don't think the macros are needed at all. For reading and
writing you can just call m5mols_write/read_reg directly and check the
error. For the mode check you can make simple static inlines like:

bool is_monitoring_mode()

and

bool is_parameter_mode()

and use it like this:

if (!is_monitoring_mode())
     return ...

The only place where you might want to do something fancy is if you have a
lot of reads and/or writes in a function. Then you can do something like
this:

static inline void my_write(int reg, int val, int *err)
{
      if (*err)
            return;
      *err = i2c_read(...);
}

int err = 0;

my_write(0, 10, &err);
my_write(1, 11, &err);
my_write(2, 12, &err);

if (err)
         return err;

(just hacked together, so ignore the poor syntax :-) ).

This allows you to do many reads and writes without having to check the
error code each time.

> Actually, to use static inline function for typesafing is right, I know.
> But, can you think one more time, plz?
> If I'm wrong after your thinking, I'll change this to inline functions.
>
> <snip>

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco

