Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54081 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382Ab0JLNCT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Oct 2010 09:02:19 -0400
Received: by iwn7 with SMTP id 7so733523iwn.19
        for <linux-media@vger.kernel.org>; Tue, 12 Oct 2010 06:02:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTiks9qzC6W4iyu2_QWkWeK-cN-pTOS=trGxeRF=6@mail.gmail.com>
References: <AANLkTimyR117ZiHq8GFz4YW5tBtW3k82NzGVZqKoVTbY@mail.gmail.com>
	<201010111514.37592.laurent.pinchart@ideasonboard.com>
	<AANLkTikBWjgNmDdG6dCXQQmcDRBUc4gP7717uqAY3+_J@mail.gmail.com>
	<201010111707.21537.laurent.pinchart@ideasonboard.com>
	<AANLkTiks9qzC6W4iyu2_QWkWeK-cN-pTOS=trGxeRF=6@mail.gmail.com>
Date: Tue, 12 Oct 2010 15:02:16 +0200
Message-ID: <AANLkTimzU8rR2a0=gTLX8UOxGZaiY0gxx4zTr2VH-iMa@mail.gmail.com>
Subject: Re: OMAP 3530 camera ISP forks and new media framework
From: Bastian Hecht <hechtb@googlemail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2010/10/12 Bastian Hecht <hechtb@googlemail.com>:
> Hello Laurent,
>
> 2010/10/11 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>> Hi Bastian,
>>
>> On Monday 11 October 2010 16:58:35 Bastian Hecht wrote:
>>> 2010/10/11 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>>> > On Monday 11 October 2010 14:59:15 Bastian Hecht wrote:
>>> >> So... let's see if i got some things right, please let me now if you
>>> >> disagree:
>>> >>
>>> >> - I do want to use the omap34xxcam.c driver as it is for the newest
>>> >> framework and I get most support for it
>>> >
>>> > That's a bad start. With the latest driver, omap34xxcam.c doesn't exist
>>> > anymore :-)
>>>
>>> Nice :S
>>>
>>> I think I take the mt9t001 approach (Sorry Guennadi, I think modifying
>>> your framework is too much for me to start with). So in this driver I
>>> tell the framework that I can do i2c probing, some subdev_core_ops and
>>> some subdev_video_ops. I define these functions that mostly do some
>>> basic i2c communication to the sensor chip. I guess I can handle that
>>> as there are so many examples out there.
>>
>> The best solution would be to add mt9p031 support to the mt9t001 driver. If
>> that's too difficult to start with, you can copy mt9t001 to mt9p031 and modify
>> the driver as needed and merge the two drivers when you will be satisfied with
>> the result.
>>
>
> OK, now I built the nokia kernel for the omap3-isp and made your
> mt9t001.c work for it.
> In mt9t001.c you call i2c_add_driver(&mt9t001_driver);
> As far I as I figured out the driver core system looks for matches
> between registered devices in arch/arm/omap/devices.c and appropriate
> drivers.
> Is the next step to include a static struct platform_device into
> devices.c? Or is there a special i2c_device struct that I have to use?
>
> Thanks so much,
>
>  Bastian
>

I now use the board-rx51-camera.c as scaffold and try to integrate my
camera chip device information.

>
>>> But where do I stack that on top? On the camera bridge host, but if it
>>> isn't omap34xxcam, which driver can I use? How are they connected?
>>
>> http://gitorious.org/maemo-multimedia/omap3isp-rx51
>>
>> The omap34xxcam.ko and isp-mod.ko modules have been merged into a single
>> omap3-isp.ko module. All the driver code is now in drivers/media/video/isp.
>>
>> --
>> Regards,
>>
>> Laurent Pinchart
>>
>
