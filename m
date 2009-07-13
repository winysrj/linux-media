Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:43302 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbZGMLio (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2009 07:38:44 -0400
Received: by qw-out-2122.google.com with SMTP id 8so53768qwh.37
        for <linux-media@vger.kernel.org>; Mon, 13 Jul 2009 04:38:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1247484571.4067.4.camel@palomino.walls.org>
References: <5e9665e10907110402t4b5777abu5f02a44d609405b1@mail.gmail.com>
	<200907112113.42883.hverkuil@xs4all.nl> <5e9665e10907130119wd9d62ahaa027e49993cdc8c@mail.gmail.com>
	<200907131047.51249.hverkuil@xs4all.nl> <5e9665e10907130417r7e4a7bfep85c89b61981c2748@mail.gmail.com>
	<1247484571.4067.4.camel@palomino.walls.org>
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Date: Mon, 13 Jul 2009 20:38:23 +0900
Message-ID: <5e9665e10907130438i59b5cf33l6e852699d0582832@mail.gmail.com>
Subject: Re: About v4l2 subdev s_config (for core) API?
To: Andy Walls <awalls@radix.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	v4l2_linux <linux-media@vger.kernel.org>,
	=?UTF-8?B?6rmA7ZiV7KSA?= <riverful.kim@samsung.com>,
	Dongsoo Kim <dongsoo45.kim@samsung.com>,
	=?UTF-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/7/13 Andy Walls <awalls@radix.net>:
> On Mon, 2009-07-13 at 20:17 +0900, Dongsoo, Nathaniel Kim wrote:
>
>
>> Well arranged thanks to you. BTW, can you tell me about
>> "s_crystal_freq" in detail? I can see that ivtv and saa7115 are using
>> that but can't figure out what is exactly for. At the earlier mail, I
>> considered that as a function let subdev device know about the
>> frequency of clock "given" not "made by". Am I right? Please let me
>> know if I'm getting wrong.
>> Cheers,
>
> As I understand it, s_crystal_freq() should be used when a different
> crystal frequency could be used with a chip in differnt board designs.
> For programming PLLs or dividers, the sub_device driver needs to know
> what the crystal or reference frequency is.
>
> Regards,
> Andy

Thank you Andy.
Before knowing s_crystal_freq, I preferred to pass MCLK through
platform data of external camera device. Now, I think I can use
s_crystal_freq to pass the clock to the camera device  without using
platform data. cool
Cheers,

Nate
>
>
>
>> Nate
>
>
>



-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
