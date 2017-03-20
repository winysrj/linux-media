Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:44820 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753107AbdCTNYd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 09:24:33 -0400
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <20170303230645.GR21222@n2100.armlinux.org.uk>
 <20170304131329.GV3220@valkosipuli.retiisi.org.uk>
 <a7b8e095-a95c-24bd-b1e9-e983f18061c4@xs4all.nl>
 <20170310130733.GU21222@n2100.armlinux.org.uk>
 <c679f755-52a6-3c6f-3d65-277db46676cc@xs4all.nl>
 <20170310140124.GV21222@n2100.armlinux.org.uk>
 <cc8900b0-c091-b14b-96f4-01f8fa72431c@xs4all.nl>
 <20170310125342.7f047acf@vento.lan>
 <20170310223714.GI3220@valkosipuli.retiisi.org.uk>
 <20170311082549.576531d0@vento.lan>
 <20170313124621.GA10701@valkosipuli.retiisi.org.uk>
 <20170314004533.3b3cd44b@vento.lan>
 <e0a6c60b-1735-de0b-21f4-d8c3f4b3f10f@xs4all.nl>
 <20170314072143.498cde9b@vento.lan>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, mchehab@kernel.org, nick@shmanahar.org,
        markus.heiser@darmarIT.de, p.zabel@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Jacek Anaszewski <j.anaszewski@samsung.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5c935062-61f4-40e7-0ee9-87655197e661@xs4all.nl>
Date: Mon, 20 Mar 2017 14:24:25 +0100
MIME-Version: 1.0
In-Reply-To: <20170314072143.498cde9b@vento.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/14/2017 11:21 AM, Mauro Carvalho Chehab wrote:
> Em Tue, 14 Mar 2017 08:55:36 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 03/14/2017 04:45 AM, Mauro Carvalho Chehab wrote:
>>> Hi Sakari,
>>>
>>> I started preparing a long argument about it, but gave up in favor of a
>>> simpler one.
>>>
>>> Em Mon, 13 Mar 2017 14:46:22 +0200
>>> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
>>>   
>>>> Drivers are written to support hardware, not particular use case.    
>>>
>>> No, it is just the reverse: drivers and hardware are developed to
>>> support use cases.
>>>
>>> Btw, you should remember that the hardware is the full board, not just the
>>> SoC. In practice, the board do limit the use cases: several provide a
>>> single physical CSI connector, allowing just one sensor.
>>>   
>>>>> This situation is there since 2009. If I remember well, you tried to write
>>>>> such generic plugin in the past, but never finished it, apparently because
>>>>> it is too complex. Others tried too over the years.     
>>>>
>>>> I'd argue I know better what happened with that attempt than you do. I had a
>>>> prototype of a generic pipeline configuration library but due to various
>>>> reasons I haven't been able to continue working on that since around 2012.  
>>>
>>> ...
>>>   
>>>>> The last trial was done by Jacek, trying to cover just the exynos4 driver. 
>>>>> Yet, even such limited scope plugin was not good enough, as it was never
>>>>> merged upstream. Currently, there's no such plugins upstream.
>>>>>
>>>>> If we can't even merge a plugin that solves it for just *one* driver,
>>>>> I have no hope that we'll be able to do it for the generic case.    
>>>>
>>>> I believe Jacek ceased to work on that plugin in his day job; other than
>>>> that, there are some matters left to be addressed in his latest patchset.  
>>>
>>> The two above basically summaries the issue: the task of doing a generic
>>> plugin on userspace, even for a single driver is complex enough to
>>> not cover within a reasonable timeline.
>>>
>>> From 2009 to 2012, you were working on it, but didn't finish it.
>>>
>>> Apparently, nobody worked on it between 2013-2014 (but I may be wrong, as
>>> I didn't check when the generic plugin interface was added to libv4l).
>>>
>>> In the case of Jacek's work, the first patch I was able to find was
>>> written in Oct, 2014:
>>> 	https://patchwork.kernel.org/patch/5098111/
>>> 	(not sure what happened with the version 1).
>>>
>>> The last e-mail about this subject was issued in Dec, 2016.
>>>
>>> In summary, you had this on your task for 3 years for an OMAP3
>>> plugin (where you have a good expertise), and Jacek for 2 years, 
>>> for Exynos 4, where he should also have a good knowledge.
>>>
>>> Yet, with all that efforts, no concrete results were achieved, as none
>>> of the plugins got merged.
>>>
>>> Even if they were merged, if we keep the same mean time to develop a
>>> libv4l plugin, that would mean that a plugin for i.MX6 could take 2-3
>>> years to be developed.
>>>
>>> There's a clear message on it:
>>> 	- we shouldn't keep pushing for a solution via libv4l.  
>>
>> Or:
>>
>> 	- userspace plugin development had a very a low priority and
>> 	  never got the attention it needed.
> 
> The end result is the same: we can't count on it.
> 
>>
>> I know that's *my* reason. I rarely if ever looked at it. I always assumed
>> Sakari and/or Laurent would look at it. If this reason is also valid for
>> Sakari and Laurent, then it is no wonder nothing has happened in all that
>> time.
>>
>> We're all very driver-development-driven, and userspace gets very little
>> attention in general. So before just throwing in the towel we should take
>> a good look at the reasons why there has been little or no development: is
>> it because of fundamental design defects, or because nobody paid attention
>> to it?
> 
> No. We should look it the other way: basically, there are patches
> for i.MX6 driver that sends control from videonode to subdevs. 
> 
> If we nack apply it, who will write the userspace plugin? When
> such change will be merged upstream?
> 
> If we don't have answers to any of the above questions, we should not
> nack it.
> 
> That's said, that doesn't prevent merging a libv4l plugin if/when
> someone can find time/interest to develop it.

I don't think this control inheritance patch will magically prevent you
from needed a plugin.

> 
>> I strongly suspect it is the latter.
>>
>> In addition, I suspect end-users of these complex devices don't really care
>> about a plugin: they want full control and won't typically use generic
>> applications. If they would need support for that, we'd have seen much more
>> interest. The main reason for having a plugin is to simplify testing and
>> if this is going to be used on cheap hobbyist devkits.
> 
> What are the needs for a cheap hobbyist devkit owner? Do we currently
> satisfy those needs? I'd say that having a functional driver when
> compiled without the subdev API, that implements the ioctl's/controls
> that a generic application like camorama/google talk/skype/zbar...
> would work should be enough to make them happy, even if they need to
> add some udev rule and/or run some "prep" application that would setup 
> the pipelines via MC and eventually rename the device with a working
> pipeline to /dev/video0.

This is literally the first time we have to cater to a cheap devkit. We
were always aware of this issue, but nobody really needed it.

> 
>>
>> An additional complication is simply that it is hard to find fully supported
>> MC hardware. omap3 boards are hard to find these days, renesas boards are not
>> easy to get, freescale isn't the most popular either. Allwinner, mediatek,
>> amlogic, broadcom and qualcomm all have closed source implementations or no
>> implementation at all.
> 
> I'd say that we should not care anymore on providing a solution for
> generic applications to run on boards like OMAP3[1]. For hardware that
> are currently available that have Kernel driver and boards developed
> to be used as "cheap hobbyist devkit", I'd say we should implement
> a Kernel solution that would allow them to be used without subdev
> API, e. g. having all ioctls needed by generic applications to work
> functional, after some external application sets the pipeline.

I liked Russell's idea of having the DT set up an initial video path.
This would (probably) make it much easier to provide a generic plugin since
there is already an initial valid path when the driver is loaded, and it
doesn't require custom code in the driver since this is left to the DT
which really knows about the HW.

> 
> [1] Yet, I might eventually do that for fun, an OMAP3 board with tvp5150
> just arrived here last week. It would be nice to have xawtv3 running on it :-)
> So, if I have a lot of spare time (with is very unlikely), I might eventually 
> do something for it to work.
> 
>> I know it took me a very long time before I had a working omap3.
> 
> My first OMAP3 board with working V4L2 source just arrived last week :-)
> 
>> So I am not at all surprised that little progress has been made.
> 
> I'm not surprised, but I'm disappointed, as I tried to push toward a
> solution for this problem since when we had our initial meetings about
> it.

So many things to do, so little time. Sounds corny, but really, that's what
this is all about. There were always (and frankly, still are) more important
things that needed to be done.

Regards,

	Hans
