Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.epfl.ch ([128.178.224.219]:36564 "HELO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752131AbZFRJwA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2009 05:52:00 -0400
Message-ID: <4A3A0E41.5020208@epfl.ch>
Date: Thu, 18 Jun 2009 11:52:01 +0200
From: Valentin Longchamp <valentin.longchamp@epfl.ch>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: mx31moboard MT9T031 camera support
References: <4A39FE96.4010004@epfl.ch> <Pine.LNX.4.64.0906181054280.5779@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0906181054280.5779@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski wrote:
> On Thu, 18 Jun 2009, Valentin Longchamp wrote:
> 
>> Hi Guennadi,
>>
>> I am trying to follow your developments at porting soc-camera to v4l2-subdev.
>> However, even if I understand quite correctly soc-camera, it is quite
>> difficult for me to get all the subtleties in your work.
>>
>> That's why I am asking you for a little help: when do you think would be the
>> best timing for me to add the mt9t031 camera support for mx31moboard within
>> your current process ?
> 
> You can do this now, based either on the v4l tree, or wait for Linus to 
> pull it - a pull request has been sent ba Mauro yesterday, looks like 
> Linus hasn't pulled yet.
> 
> The way you add your platform is going to change, and the pull, that I'm 
> referring to above makes it possible for both "old style" and "new style" 
> board camera data to work. Of course, it would be best for you to 
> implement the "new style" platform data. You can do this by either looking 
> at my patches, which I've posted to the lists earlier, and which are also 
> included in my patch stack, which I announced yesterday. Or you can wait a 
> bit until I update my pcm037 patch (going to do this now) and post it to 
> arm-kernel. I'll (try not to forget to) add you to cc, that should be 
> quite easy to follow for you.
> 
>> I guess it should not be too difficult, I had done it before, and I can base
>> myself on what you have done for pcm037:
>> http://download.open-technology.de/soc-camera/20090617/0025-pcm037-add-MT9T031-camera-support.patch
> 
> Yes, use this or wait a bit for an updated version.

OK, thanks a lot. Since I am busy at other things at the moment, I am 
going to wait for you updated version and that things are stabilized a 
little bit with the 31-rc1. And I will use the "new style" platform data.

> 
>> Now I have a second question. On our robot, we physically have two cameras
>> (one looking to the front and one looking at a mirror) connected to the i.MX31
>> physical bus. We have one signal that allows us to control the multiplexer for
>> the bus lines (video signals and I2C) through a GPIO. This now works with a
>> single camera declared in software and choices to the multiplexer done when no
>> image transfer is happening ( /dev/video is not open). What do you think
>> should be the correct way of dealing with these two cameras with the current
>> driver implementation (should I continue to declare only one camera in the
>> software) ?
>>
>> And do you think it could be possible to "hot-switch" from one camera to the
>> other ? My colleagues ask about it, I tell them that from my point of view
>> this seems not possible without changing the drivers, and even the drivers
>> would have to be changed quite heavily and it is not trivial.
> 
> Do the cameras use different i2c addresses? If they use the same address I 
> don't think you'd be able to register them simultaneously. If they do use 
> different addresses, you can register both of them and use platform 
> .power() callback to switch between them using your multiplexer. See 
> arch/sh/boards/mach-migor/setup.c for an example. There was also a 
> proposal to use switching input to select a data source, but this is 
> currently unsupported by soc-camera.
> 

The sensor chips both are mt9t031 so they have the same i2c address (I 
have looked at the datasheet, and I don't think this can be changed). So 
I cannot use them both at the same time.

Now you talk about the .power() callback, I could use it so that the 
multiplexer is managed by it, using a similar mechanism as in 
mach-migor. If this could allow me one different /dev/video nod for each 
camera (that of course cannot be used at the same time), it would 
simplify a lot of things for my users. I will give it a try (hoping that 
this also works at driver registering ... we will see).

Thanks for your answers.

Val

-- 
Valentin Longchamp, PhD Student, EPFL-STI-LSRO1
valentin.longchamp@epfl.ch, Phone: +41216937827
http://people.epfl.ch/valentin.longchamp
MEA3485, Station 9, CH-1015 Lausanne
