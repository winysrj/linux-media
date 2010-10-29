Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40831 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab0J2Mjy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Oct 2010 08:39:54 -0400
Received: by ywk9 with SMTP id 9so1921853ywk.19
        for <linux-media@vger.kernel.org>; Fri, 29 Oct 2010 05:39:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinWnGtb32kBNwoeN27OcCh7sVvZOoC=Vi1BtOua@mail.gmail.com>
References: <AANLkTimx6XJKEz9883cwrm977OtXVPVB5K5PjSGFi_AJ@mail.gmail.com>
	<AANLkTi=Nv2Oe=61NQjzH0+P+TcODDJW3_n+NbfzxF5g3@mail.gmail.com>
	<201010290139.10204.laurent.pinchart@ideasonboard.com>
	<AANLkTinWnGtb32kBNwoeN27OcCh7sVvZOoC=Vi1BtOua@mail.gmail.com>
Date: Fri, 29 Oct 2010 14:39:53 +0200
Message-ID: <AANLkTimJu-QDToxGNWKPj_B4QM_iO_x6G6eE4U2WnDPB@mail.gmail.com>
Subject: Re: New media framework user space usage
From: Bastian Hecht <hechtb@googlemail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

> I did as you said and everything works fine until I use yavta:
>
> Video format set: width: 2952 height: 1944 buffer size: 11508480
> Video format: BA10 (30314142) 2952x1944

ooops, I had a typo... 2952 becomes 2592

> 4 buffers requested.
> length: 11508480 offset: 0
> Buffer 0 mapped at address 0x4016d000.
> length: 11508480 offset: 11509760
> Buffer 1 mapped at address 0x40c67000.
> length: 11508480 offset: 23019520
> Buffer 2 mapped at address 0x41761000.
> length: 11508480 offset: 34529280
> Buffer 3 mapped at address 0x4225b000.
> Unable to start streaming: 22
>
> This is in
> ret = ioctl(dev->fd, enable ? VIDIOC_STREAMON : VIDIOC_STREAMOFF, &type);
> errno 22 is: Invalid argument

Now it becomes
Unable to start streaming: 32 : Broken pipe

I will check if the video format of the sensor chip is SGRBG10 in default.

cheers,

 Bastian


> Any ideas where to look next?
>
> Thanks,
>
>  Bastian
>
>
>> --
>> Regards,
>>
>> Laurent Pinchart
>>
>
