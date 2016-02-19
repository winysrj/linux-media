Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:39503 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1427134AbcBSSML (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2016 13:12:11 -0500
Subject: Re: [RFC] Move some soc-camera drivers to staging in preparation for
 removal
To: Robert Jarzmik <robert.jarzmik@free.fr>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <56C71778.2030706@xs4all.nl> <20160219142410.478488cc@recife.lan>
 <56C74324.1010106@xs4all.nl> <87a8mwziie.fsf@belgarion.home>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Josh Wu <josh.wu@atmel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56C75AF5.3010807@xs4all.nl>
Date: Fri, 19 Feb 2016 19:12:05 +0100
MIME-Version: 1.0
In-Reply-To: <87a8mwziie.fsf@belgarion.home>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/19/2016 07:01 PM, Robert Jarzmik wrote:
> Hans Verkuil <hverkuil@xs4all.nl> writes:
> 
>> On 02/19/2016 05:24 PM, Mauro Carvalho Chehab wrote:
>>> Em Fri, 19 Feb 2016 14:24:08 +0100
>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>>
>>>> Hi all,
>>>>
>>>> The soc-camera framework is a problem for reusability of sub-device drivers since
>>>> those need access to the soc-camera framework. Which defeats the purpose of the
>>>> sub-device framework. It is the reason why we still have a media/i2c/soc-camera
>>>> directory for subdevs that can only work with soc-camera.
>>>>
>>>> Ideally I would like to drop soc-camera completely, but it is still in use.
>>>>
>>>> One of the largest users is Renesas with their r-car SoC, but Niklas Söderlund
>>>> made a replacement driver that should make it possible to remove the soc-camera
>>>> r-car driver, hopefully this year.
>>>>
>>>> What I would like to do is to move soc-camera drivers that we consider obsolete
>>>> to staging, and remove them in 1-2 kernel cycles if nobody steps up.
>>>>
>>>> See also this past thread from Guennadi:
>>>>
>>>> http://www.spinics.net/lists/linux-media/msg89253.html
>>>>
>>>> And yes, I said in that thread that I was OK with keeping soc-camera as-is. But
>>>> it still happens that companies pick this framework for new devices (the driver
>>>> for the Tegra K1 for example). It is another reason besides the reusability issue
>>>> for remove this framework more aggressively then I intended originally.
>>>>
>>>>
>>>> We have the following drivers:
>>>>
>>>> - pxa_camera for the PXA27x Quick Capture Interface
>>>>
>>>>   Apparently this architecture still gets attention (see the link to the thread
>>>>   above). But it does use vb1 which we really want to phase out soon. Does anyone
>>>>   know if this driver still works with the latest kernel? Because it is using vb1
>>>>   it is a strong candidate for removing it (or replacing it with something better
>>>>   if someone steps up).
> Most certainly.
> 
> pxa27x_camera is actively maintained, the latest submission request for merge
> is 11 days ago :
>   https://lkml.org/lkml/2016/2/8/789
> 
> I can submit a patch in MAINTAINERS if you wish to take it in my bucket.

Please do! That's an easy patch, and then it is clear someone is actively maintaining
this.

> 
> I am maintaining the pxa architecture, and I do have the hardware to test the
> submissions. As you will see in the above message the driver works fine with
> v4.5-rc2.
> 
> If you want modifications, let me know, explain to me what you want, and I'll
> see how to carry them out (because vb1 out of context is obfuscated to me). A
> good explanation would a an example of another driver pxa_camera should look
> like, so that I can see the difference in the APIs from soc_camera and evaluate
> the work to be done.
> 
>>>> Now I am not planning to remove soc-camera (yet), but at least we should get
>>>> rid of unmaintained drivers, especially if they don't work anymore or if they
>>>> use the old vb1 mess.
>>>>
>>>> And we can then take a good look at what remains.
>>>
>>> You're forgetting the I2C sensor cam drivers. There are 14 such drivers
>>> under drivers/media/i2c/soc_camera/.
>>
>> I didn't forget those, but I thought that we should tackle those later.
>> It's not so easy to remove the soc-camera dependency from them. I tried
>> that once, and I think I could only make one or two of those drivers soc-camera
>> independent :-(
>>
>> And without hardware you have no idea if they still work.
> Same thing as above, I can commit at least for mt9m111.c, for which I have both
> the hardware and the knowledge. I cannot speak for the other drivers.
> 
> So all in all, if you point me in the right direction, I'll take care of the
> changes in pxa_camera.c and mt9m111.c.

Good to know.

I will investigate this driver in more detail so I can explain what would be needed
to get this driver out of soc-camera.

BTW, vb1 refers to videobuf-core.h whereas vb2 refers to its successor videobuf2-core.h
and videobuf2-v4l2.h. The vb2 framework is vastly superior and integrates nicely with
dmabuf for buffer sharing between hardware components.

Regards,

	Hans
