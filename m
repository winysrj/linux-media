Return-path: <mchehab@pedra>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37978 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab1FQCv1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 22:51:27 -0400
Received: by gyh3 with SMTP id 3so394194gyh.19
        for <linux-media@vger.kernel.org>; Thu, 16 Jun 2011 19:51:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DFAA296.903@infradead.org>
References: <1307814409-46282-1-git-send-email-corbet@lwn.net>
	<1307814409-46282-3-git-send-email-corbet@lwn.net>
	<BANLkTikVeHLL6+T74tpmwmsL4_3h5f3PmA@mail.gmail.com>
	<20110614084948.2d158323@bike.lwn.net>
	<BANLkTikztbcm_+PR5oFVB+v0Jn4q8GCVTQ@mail.gmail.com>
	<4DFAA296.903@infradead.org>
Date: Fri, 17 Jun 2011 10:51:26 +0800
Message-ID: <BANLkTimn2o0W-f3NWvZOrhnGvZv2-mo4Pw@mail.gmail.com>
Subject: Re: [PATCH 2/8] marvell-cam: Separate out the Marvell camera core
From: Kassey Lee <kassey1216@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
	g.liakhovetski@gmx.de, Kassey Lee <ygli@marvell.com>,
	Daniel Drake <dsd@laptop.org>, ytang5@marvell.com,
	leiwen@marvell.com, qingx@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/6/17 Mauro Carvalho Chehab <mchehab@infradead.org>:
> Em 15-06-2011 23:30, Kassey Lee escreveu:
>> 2011/6/14 Jonathan Corbet <corbet@lwn.net>:
>>> On Tue, 14 Jun 2011 10:58:47 +0800
>>> Kassey Lee <kassey1216@gmail.com> wrote:
>>>>> +       /*
>>>>> +        * Try to find the sensor.
>>>>> +        */
>>>>> +       cam->sensor_addr = ov7670_info.addr;
>>>>> +       cam->sensor = v4l2_i2c_new_subdev_board(&cam->v4l2_dev,
>>>>> +                       &cam->i2c_adapter, &ov7670_info, NULL);
>>>> I do not thinks so.
>>>
>>> I don't understand what this comment is meant to mean...?
>> this should be move out to arch/arm/mach-xxx/board.c
>
> Please drop the parts that you're not commenting. It is very hard to find a one-line
> comment in the middle of a long patch, especially since you don't even add blank
> lines before/after it.
>
sorry for the confusion.
this is the same idea that we want to separate the ccic driver and sensor info.
here is how we do this:
on arch/arm/mach-mmp/ttc_dkb.c

static struct i2c_board_info dkb_i2c_camera[] = {
        {
                I2C_BOARD_INFO("ov5642", 0x3c),
        },
};

i2c_register_board_info(0, &dkb_i2c_camera, 1);


> With respect to your comment, it doesn't makes much sense,as cafe_ccic
> runs on OLPC 1 hardware (at least the version I have here) is x86-based.
>
 that is fine, sorry, i always thought it was ARM platform.

> So, I'm not seeing any reason why not apply patch 2/8.
>
> Applying on my tree.
>
> Mauro.
>
>



-- 
Best regards
Kassey
Application Processor Systems Engineering, Marvell Technology Group Ltd.
Shanghai, China.
