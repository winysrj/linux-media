Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:43007 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756043AbZFWOUb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2009 10:20:31 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Valentin Longchamp <valentin.longchamp@epfl.ch>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>
Date: Tue, 23 Jun 2009 09:19:56 -0500
Subject: RE: mx31moboard MT9T031 camera support
Message-ID: <A69FA2915331DC488A831521EAE36FE40139EDB5A2@dlee06.ent.ti.com>
References: <4A39FE96.4010004@epfl.ch>
 <Pine.LNX.4.64.0906181054280.5779@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0906181054280.5779@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am already working on porting MT9T031 driver to sub device framework. I have communicated this to Guennadi, earlier. So please don't work on it. I am going to send a patch for review in a week.

Thanks.
Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
email: m-karicheri2@ti.com

>-----Original Message-----
>From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>owner@vger.kernel.org] On Behalf Of Guennadi Liakhovetski
>Sent: Thursday, June 18, 2009 5:20 AM
>To: Valentin Longchamp
>Cc: Linux Media Mailing List; Sascha Hauer
>Subject: Re: mx31moboard MT9T031 camera support
>
>On Thu, 18 Jun 2009, Valentin Longchamp wrote:
>
>> Hi Guennadi,
>>
>> I am trying to follow your developments at porting soc-camera to v4l2-
>subdev.
>> However, even if I understand quite correctly soc-camera, it is quite
>> difficult for me to get all the subtleties in your work.
>>
>> That's why I am asking you for a little help: when do you think would be
>the
>> best timing for me to add the mt9t031 camera support for mx31moboard
>within
>> your current process ?
>
>You can do this now, based either on the v4l tree, or wait for Linus to
>pull it - a pull request has been sent ba Mauro yesterday, looks like
>Linus hasn't pulled yet.
>
>The way you add your platform is going to change, and the pull, that I'm
>referring to above makes it possible for both "old style" and "new style"
>board camera data to work. Of course, it would be best for you to
>implement the "new style" platform data. You can do this by either looking
>at my patches, which I've posted to the lists earlier, and which are also
>included in my patch stack, which I announced yesterday. Or you can wait a
>bit until I update my pcm037 patch (going to do this now) and post it to
>arm-kernel. I'll (try not to forget to) add you to cc, that should be
>quite easy to follow for you.
>
>> I guess it should not be too difficult, I had done it before, and I can
>base
>> myself on what you have done for pcm037:
>> http://download.open-technology.de/soc-camera/20090617/0025-pcm037-add-
>MT9T031-camera-support.patch
>
>Yes, use this or wait a bit for an updated version.
>
>> Now I have a second question. On our robot, we physically have two
>cameras
>> (one looking to the front and one looking at a mirror) connected to the
>i.MX31
>> physical bus. We have one signal that allows us to control the
>multiplexer for
>> the bus lines (video signals and I2C) through a GPIO. This now works with
>a
>> single camera declared in software and choices to the multiplexer done
>when no
>> image transfer is happening ( /dev/video is not open). What do you think
>> should be the correct way of dealing with these two cameras with the
>current
>> driver implementation (should I continue to declare only one camera in
>the
>> software) ?
>>
>> And do you think it could be possible to "hot-switch" from one camera to
>the
>> other ? My colleagues ask about it, I tell them that from my point of
>view
>> this seems not possible without changing the drivers, and even the
>drivers
>> would have to be changed quite heavily and it is not trivial.
>
>Do the cameras use different i2c addresses? If they use the same address I
>don't think you'd be able to register them simultaneously. If they do use
>different addresses, you can register both of them and use platform
>.power() callback to switch between them using your multiplexer. See
>arch/sh/boards/mach-migor/setup.c for an example. There was also a
>proposal to use switching input to select a data source, but this is
>currently unsupported by soc-camera.
>
>Thanks
>Guennadi
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer
>http://www.open-technology.de/
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

