Return-path: <mchehab@pedra>
Received: from mail-px0-f179.google.com ([209.85.212.179]:60224 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab1FFJOf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2011 05:14:35 -0400
Received: by pxi2 with SMTP id 2so2648508pxi.10
        for <linux-media@vger.kernel.org>; Mon, 06 Jun 2011 02:14:35 -0700 (PDT)
Subject: Re: [PATCH v9] Add support for M-5MOLS 8 Mega Pixel camera ISP
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=euc-kr
From: Kim HeungJun <riverful@gmail.com>
In-Reply-To: <20110605115529.GC6073@valkosipuli.localdomain>
Date: Mon, 6 Jun 2011 18:14:27 +0900
Cc: Kim HeungJun <riverful@gmail.com>,
	"Kim, HeungJun" <riverful.kim@samsung.com>,
	linux-media@vger.kernel.org, mchehab@infradead.org,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <0C30F8BF-C452-4FD1-96DF-0205C3D43FBB@gmail.com>
References: <1305507806-10692-1-git-send-email-riverful.kim@samsung.com> <1305871017-22924-1-git-send-email-riverful.kim@samsung.com> <20110525135435.GA3547@valkosipuli.localdomain> <4DDDFD6F.9000601@samsung.com> <20110605115529.GC6073@valkosipuli.localdomain>
To: Sakari Ailus <sakari.ailus@iki.fi>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sakari,

2011. 6. 5., 오후 8:55, Sakari Ailus 작성:

> On Thu, May 26, 2011 at 04:12:47PM +0900, Kim, HeungJun wrote:
>> Hi Sakari,
> 
> Hi HeungJun,
> 
>> 2011-05-25 ?????? 10:54, Sakari Ailus ??? ???:
>>> Hi HeungJun,
>>> 
>>> Thanks for the patch!
>> Also, thanks for the interests of this driver!

[snip]
>> 
>>> shouldn't the underlying low level controls be exposed to user space as
>>> such?
>>> 
>>> There definitely are different approaches to this; providing higher level
>>> interface is restricting but on the other hand it may be better depending on
>>> an application.
>>> 
>>> Some of these parameters would already have a V4L2 control for them.
>> Actually, I have a plan to prepare RFC to expose some controls and
>> things related with control timing. :)
> 
> I'm looking forward to this. Control timing is also something I'm interested
> in.

Yeah, we're still thinking of this, but it's true we still don't have clean solution about that
in the linux side. Especially, the timing of camera(the more Higher-performance sensor
the more tricky to control timing) is sensitive, but anyway it's also true the camera device
not using linux is available to handle well now.

My point of thinking is that going in/out the kernel-space/user-space occurs the latency,
and this latency occurs imbalance of image. For example, before the capturing, the flash
or adequate exposure value should be maintained constantly, but if any other process
interrupts between flash-ctrl and exposure-ctrl or something occurs the delay, we can
not get the prefect image configured by our purpose.

But, I'm still considering how to handle this now.

If my thought will somewhat concrete, it's taking not much longer, and I'll soon make
another threads or RFC about this subject. Let's talk in this thread later. :)

[snip]
>>>> +
>>>> +/* The regulator consumer names for external voltage regulators */
>>>> +static struct regulator_bulk_data supplies[] = {
>>>> +	{
>>>> +		.supply = "core",	/* ARM core power, 1.2V */
>>>> +	}, {
>>>> +		.supply	= "dig_18",	/* digital power 1, 1.8V */
>>>> +	}, {
>>>> +		.supply	= "d_sensor",	/* sensor power 1, 1.8V */
>>>> +	}, {
>>>> +		.supply	= "dig_28",	/* digital power 2, 2.8V */
>>>> +	}, {
>>>> +		.supply	= "a_sensor",	/* analog power */
>>>> +	}, {
>>>> +		.supply	= "dig_12",	/* digital power 3, 1.2V */
>>>> +	},
>>>> +};
>>> 
>>> This looks like something that belongs to board code, or perhaps in the near
>>> future, to the device tree. The power supplies that are required by a device
>>> is highly board dependent.
>> If the regulator name is not common all M-5MOLS, You're right.
>> But the regulator name of M-5MOLS is fixed.
> 
> As far as I understand, M-5MOLS is a sensor which you can, in principle,
> attach to more or less random hardware. The regulators are not part of the
> sensor. If someone adds a board which has regulators names or otherwise
> arranged differently, this change must be done at that time.

Sylwester already explained about this, and I agree with Sylwester.
And I want to add more comments.

The point is the regulator consumer names and the sensor's power names do not
depend on(or are irrelevant) each other, and we can not define or explain about
the platform or board only having the regulator's names in the drivers.

Namely, it means these names in the driver is not a platform side, and if the regulator
framework is available in any other drivers, we can use regulator name for convenient.
So then, if the name is clear and been not changed until now, I think this usage of
regulator framework's is fine.

[snip]
>>> 
>>> #define I2C_SIZE_U8	1
>> I already try to do like this, using width as definition.
>> But it makes many lines over 80 characters. Moreover, using just number
>> is more simple in this case.
> 
> Wrapping lines is also possible but sometimes it's just better not to.

I didn't know that before. I'll keep that in mind. Thanks :)

[snip]
>>>> 
>>>> +
>>>> +	usleep_range(200, 200);
>>> 
>>> Why to sleep always? Does the sensor require a delay between each I2C
>>> access?
>> It's experimental values. The M-5MOLS I2C communication is a litte sensitive,
>> and I expect that this sensor is integrated with another ARM-core and internal
>> Firmware, and ARM-core's performance is not good. So, the dealy should be needed.
> 
> Perhaps a comment telling this would be good?

like /* This value comes from experiment. */?

As I say the value itself, the value had the ranges about at least 150ms in my case.
For being clear, I just use 200ms.
 
[snip]
>>>> 
>>>> +
>>>> +static int m5mols_enum_mbus_code(struct v4l2_subdev *sd,
>>>> +				 struct v4l2_subdev_fh *fh,
>>>> +				 struct v4l2_subdev_mbus_code_enum *code)
>>>> +{
>>>> +	ifv (!code || code->index >= SIZE_DEFAULT_FFMT)
>>> 
>>> Is it possible that code == NULL?
>> It depends on the driver using this subdev driver. 
>> The test have done on the s5p-fimc driver for now, but I don't have
>> any trouble cause of code == NULL.
>> 
>> But, probably the code can get through by userspace, so it should be
>> needed I guess.
> 
> The contents are from user space but the pointer is not. No need to check
> for NULL. See subdev_do_ioctl() in v4l2-subdev.c.

Ok, it's good to know.

[snip]

And I think there is not another big problem.
Thanks for the reviews!

Best Regards,
Heungjun Kim


> Regards,
> 
> -- 
> Sakari Ailus
> sakari dot ailus at iki dot fi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> 

