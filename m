Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:51078 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703Ab1FQAlE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 20:41:04 -0400
Message-ID: <4DFAA296.903@infradead.org>
Date: Thu, 16 Jun 2011 21:40:54 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Kassey Lee <kassey1216@gmail.com>
CC: Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
	g.liakhovetski@gmx.de, Kassey Lee <ygli@marvell.com>,
	Daniel Drake <dsd@laptop.org>, ytang5@marvell.com,
	leiwen@marvell.com, qingx@marvell.com
Subject: Re: [PATCH 2/8] marvell-cam: Separate out the Marvell camera core
References: <1307814409-46282-1-git-send-email-corbet@lwn.net>	<1307814409-46282-3-git-send-email-corbet@lwn.net>	<BANLkTikVeHLL6+T74tpmwmsL4_3h5f3PmA@mail.gmail.com>	<20110614084948.2d158323@bike.lwn.net> <BANLkTikztbcm_+PR5oFVB+v0Jn4q8GCVTQ@mail.gmail.com>
In-Reply-To: <BANLkTikztbcm_+PR5oFVB+v0Jn4q8GCVTQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 15-06-2011 23:30, Kassey Lee escreveu:
> 2011/6/14 Jonathan Corbet <corbet@lwn.net>:
>> On Tue, 14 Jun 2011 10:58:47 +0800
>> Kassey Lee <kassey1216@gmail.com> wrote:
>>>> +       /*
>>>> +        * Try to find the sensor.
>>>> +        */
>>>> +       cam->sensor_addr = ov7670_info.addr;
>>>> +       cam->sensor = v4l2_i2c_new_subdev_board(&cam->v4l2_dev,
>>>> +                       &cam->i2c_adapter, &ov7670_info, NULL);
>>> I do not thinks so.
>>
>> I don't understand what this comment is meant to mean...?
> this should be move out to arch/arm/mach-xxx/board.c

Please drop the parts that you're not commenting. It is very hard to find a one-line
comment in the middle of a long patch, especially since you don't even add blank
lines before/after it.

With respect to your comment, it doesn't makes much sense,as cafe_ccic 
runs on OLPC 1 hardware (at least the version I have here) is x86-based.

So, I'm not seeing any reason why not apply patch 2/8.

Applying on my tree.

Mauro.

