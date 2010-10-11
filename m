Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37169 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007Ab0JKQN3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Oct 2010 12:13:29 -0400
Received: by ewy20 with SMTP id 20so661142ewy.19
        for <linux-media@vger.kernel.org>; Mon, 11 Oct 2010 09:13:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1010111718010.11865@axis700.grange>
References: <AANLkTimyR117ZiHq8GFz4YW5tBtW3k82NzGVZqKoVTbY@mail.gmail.com>
	<Pine.LNX.4.64.1010072012280.15141@axis700.grange>
	<AANLkTinJhywDoZg5F2tvqdW44to-6P4hgNd9Fav9qTv8@mail.gmail.com>
	<201010111514.37592.laurent.pinchart@ideasonboard.com>
	<AANLkTikBWjgNmDdG6dCXQQmcDRBUc4gP7717uqAY3+_J@mail.gmail.com>
	<Pine.LNX.4.64.1010111718010.11865@axis700.grange>
Date: Mon, 11 Oct 2010 18:13:27 +0200
Message-ID: <AANLkTi=DpmOum+m_YNrn-ENaAZk9rOi8rZF-fGp-dRf1@mail.gmail.com>
Subject: Re: OMAP 3530 camera ISP forks and new media framework
From: Bastian Hecht <hechtb@googlemail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2010/10/11 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> On Mon, 11 Oct 2010, Bastian Hecht wrote:
>
>> 2010/10/11 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>> > Hi Bastian,
>> >
>> > On Monday 11 October 2010 14:59:15 Bastian Hecht wrote:
>> >> So... let's see if i got some things right, please let me now if you
>> >> disagree:
>> >>
>> >> - I do want to use the omap34xxcam.c driver as it is for the newest
>> >> framework and I get most support for it
>> >
>> > That's a bad start. With the latest driver, omap34xxcam.c doesn't exist
>> > anymore :-)
>>
>> Nice :S
>>
>> I think I take the mt9t001 approach (Sorry Guennadi, I think modifying
>> your framework is too much for me to start with).
>
> AFAIR, you said, that register sets of mt9t031 and mt9p031 are identical,
> so, I think, I will be against mainlining a new driver for the "same"
> hardware for the pad-level ops, duplicating an soc-camera driver. Apart
> from creating a one-off redundancy, this looks like an extremely negative
> precedent to me.
>
> That said, please, double check your estimate as "identical." If there are
> differences, say, even in only 10% of registers, it might still be
> justified to make a new driver. mt9m001 and mt9t031 are also "very
> similar," still, it appeared to me at that time, that a new driver would
> be cleaner, than a single driver full of forks or other indirections.
>
> Thanks
> Guennadi
>

The point is, I will jump around my office for a full day when I get
out a single picture of my camera PCB. After that I will gladly work
towards uncluttering the driver duplication. I will see if it fits
better the mt9t001 or mt9t031 and integrate it in there.

Cheers,

 Bastian


>> So in this driver I
>> tell the framework that I can do i2c probing, some subdev_core_ops and
>> some subdev_video_ops. I define these functions that mostly do some
>> basic i2c communication to the sensor chip. I guess I can handle that
>> as there are so many examples out there.
>>
>> But where do I stack that on top? On the camera bridge host, but if it
>> isn't omap34xxcam, which driver can I use? How are they connected?
>>
>> Thanks,
>>
>>  Bastian
>>
>
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
>
