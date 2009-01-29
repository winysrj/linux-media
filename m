Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f21.google.com ([209.85.217.21]:33631 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983AbZA2Vf5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 16:35:57 -0500
Received: by gxk14 with SMTP id 14so149463gxk.13
        for <linux-media@vger.kernel.org>; Thu, 29 Jan 2009 13:35:54 -0800 (PST)
Cc: linux-media@vger.kernel.org,
	=?EUC-KR?B?x/zB2CCx6A==?= <riverful.kim@samsung.com>,
	jongse.won@samsung.com, kyungmin.park@samsung.com
Message-Id: <B44B29E7-9C46-4F34-8CE4-AB17D6CCBCB7@gmail.com>
From: Dongsoo Kim <dongsoo.kim@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0901291934300.5474@axis700.grange>
Content-Type: text/plain; charset=EUC-KR; format=flowed; delsp=yes
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [V4L2] EV control API for digital camera
Date: Fri, 30 Jan 2009 06:35:49 +0900
References: <5e9665e10901281824ibccbf00lcbecba5b01fdcbea@mail.gmail.com> <Pine.LNX.4.64.0901291934300.5474@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you.

So if V4L2_CID_EXPOSURE is for Exposure Value control, I think there  
is no api for exposure metering. right?

Actually many of APIs for camera are missing I guess.

Cheers
Nate


2009. 01. 30, 오전 3:35, Guennadi Liakhovetski 작성:

> [removed redhat list from CC]
>
> On Thu, 29 Jan 2009, DongSoo Kim wrote:
>
>> Hello.
>>
>> When we take pictures, sometimes we don't get satisfied with the
>> exposure of picture. Too dark or too bright.
>>
>> For that reason, we need to bias EV which represents Exposure Value.
>>
>> So..if I want to control digital camera module with V4L2 API, which
>> API should I take for EV control?
>>
>> V4L2 document says that V4L2_CID_BRIGHTNESS is for picture  
>> brightness,
>> but it is for "Image properties" and that "image" means the image
>> frame of TV or PVR things.Am I right?
>
> There's also V4L2_CID_EXPOSURE
>
>>
>> If I may, can I use V4L2_CID_BRIGHTNESS for EV control of digital  
>> cameras?
>>
>> or..otherwise I should make a new API for that functionality.
>>
>> I'm little bit confused, because I think the brightness of picture
>> could differ from exposure value of digital camera..help me ;(
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer

