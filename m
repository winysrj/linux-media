Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:41895 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab1FOLhk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 07:37:40 -0400
Message-ID: <4DF8997A.8090007@infradead.org>
Date: Wed, 15 Jun 2011 08:37:30 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Kassey Lee <kassey1216@gmail.com>
CC: Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
	g.liakhovetski@gmx.de, Kassey Lee <ygli@marvell.com>,
	Daniel Drake <dsd@laptop.org>, ytang5@marvell.com,
	qingx@marvell.com, leiwen@marvell.com
Subject: Re: [PATCH 1/8] marvell-cam: Move cafe-ccic into its own directory
References: <1307814409-46282-1-git-send-email-corbet@lwn.net>	<1307814409-46282-2-git-send-email-corbet@lwn.net>	<BANLkTikXATbgOZQbzaj4sQEmELsdpNobfQ@mail.gmail.com>	<20110614082333.43098c95@bike.lwn.net> <BANLkTikmvsgBTLgu46xXYiUHmOVvGoZAag@mail.gmail.com>
In-Reply-To: <BANLkTikmvsgBTLgu46xXYiUHmOVvGoZAag@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 14-06-2011 23:01, Kassey Lee escreveu:
> Jon,
>      if you agree to change it in another patch, and now just to keep
> it with the driver that works for years.
>      that is OK. thanks.
>      I am looking forward your patch based on VB2, because based on
> current cafe_ccic.c, it is hard to share with my driver.
> 
> 2011/6/14 Jonathan Corbet <corbet@lwn.net>:
>> On Tue, 14 Jun 2011 10:23:58 +0800
>> Kassey Lee <kassey1216@gmail.com> wrote:
>>
>>> Jon, Here is my comments.
>>
>> Thanks for having a look.
>>
>>>> +config VIDEO_CAFE_CCIC
>>>> +       tristate "Marvell 88ALP01 (Cafe) CMOS Camera Controller support"
>>>> +       depends on PCI && I2C && VIDEO_V4L2
>>>> +       select VIDEO_OV7670
>>>>
>>>  why need binds with sensor ? suppose CCIC driver and sensor driver are
>>> independent, even if your hardware only support OV7670
>>
>> We all agree that needs to change.  This particular patch, though, is
>> concerned with moving a working driver into a new directory; making that
>> sort of functional change would not be appropriate here.

While cafe-ccic only supports ov7670, the above select is OK, as otherwise,
the driver won't be operational. After adding new sensors, however, the above
should be changed to:

select VIDEO_OV7670 if VIDEO_HELPER_CHIPS_AUTO
select VIDEO_FOO if VIDEO_HELPER_CHIPS_AUTO
select VIDEO_BAR if VIDEO_HELPER_CHIPS_AUTO
...

This way, if VIDEO_HELPER_CHIPS_AUTO is enabled, all the possible sensors
used with cafe-ccic will be selected.

>>
>>>> +#include <media/ov7670.h>
>>>>
>>>      ccic would not be aware of the sensor name.
>>
>> Ditto.
>>
>> Thanks,
>>
>> jon
>>
> 
> 
> 

