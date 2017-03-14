Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:40850 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751077AbdCNHzo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 03:55:44 -0400
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
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
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>,
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
Message-ID: <e0a6c60b-1735-de0b-21f4-d8c3f4b3f10f@xs4all.nl>
Date: Tue, 14 Mar 2017 08:55:36 +0100
MIME-Version: 1.0
In-Reply-To: <20170314004533.3b3cd44b@vento.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/14/2017 04:45 AM, Mauro Carvalho Chehab wrote:
> Hi Sakari,
> 
> I started preparing a long argument about it, but gave up in favor of a
> simpler one.
> 
> Em Mon, 13 Mar 2017 14:46:22 +0200
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
>> Drivers are written to support hardware, not particular use case.  
> 
> No, it is just the reverse: drivers and hardware are developed to
> support use cases.
> 
> Btw, you should remember that the hardware is the full board, not just the
> SoC. In practice, the board do limit the use cases: several provide a
> single physical CSI connector, allowing just one sensor.
> 
>>> This situation is there since 2009. If I remember well, you tried to write
>>> such generic plugin in the past, but never finished it, apparently because
>>> it is too complex. Others tried too over the years.   
>>
>> I'd argue I know better what happened with that attempt than you do. I had a
>> prototype of a generic pipeline configuration library but due to various
>> reasons I haven't been able to continue working on that since around 2012.
> 
> ...
> 
>>> The last trial was done by Jacek, trying to cover just the exynos4 driver. 
>>> Yet, even such limited scope plugin was not good enough, as it was never
>>> merged upstream. Currently, there's no such plugins upstream.
>>>
>>> If we can't even merge a plugin that solves it for just *one* driver,
>>> I have no hope that we'll be able to do it for the generic case.  
>>
>> I believe Jacek ceased to work on that plugin in his day job; other than
>> that, there are some matters left to be addressed in his latest patchset.
> 
> The two above basically summaries the issue: the task of doing a generic
> plugin on userspace, even for a single driver is complex enough to
> not cover within a reasonable timeline.
> 
> From 2009 to 2012, you were working on it, but didn't finish it.
> 
> Apparently, nobody worked on it between 2013-2014 (but I may be wrong, as
> I didn't check when the generic plugin interface was added to libv4l).
> 
> In the case of Jacek's work, the first patch I was able to find was
> written in Oct, 2014:
> 	https://patchwork.kernel.org/patch/5098111/
> 	(not sure what happened with the version 1).
> 
> The last e-mail about this subject was issued in Dec, 2016.
> 
> In summary, you had this on your task for 3 years for an OMAP3
> plugin (where you have a good expertise), and Jacek for 2 years, 
> for Exynos 4, where he should also have a good knowledge.
> 
> Yet, with all that efforts, no concrete results were achieved, as none
> of the plugins got merged.
> 
> Even if they were merged, if we keep the same mean time to develop a
> libv4l plugin, that would mean that a plugin for i.MX6 could take 2-3
> years to be developed.
> 
> There's a clear message on it:
> 	- we shouldn't keep pushing for a solution via libv4l.

Or:

	- userspace plugin development had a very a low priority and
	  never got the attention it needed.

I know that's *my* reason. I rarely if ever looked at it. I always assumed
Sakari and/or Laurent would look at it. If this reason is also valid for
Sakari and Laurent, then it is no wonder nothing has happened in all that
time.

We're all very driver-development-driven, and userspace gets very little
attention in general. So before just throwing in the towel we should take
a good look at the reasons why there has been little or no development: is
it because of fundamental design defects, or because nobody paid attention
to it?

I strongly suspect it is the latter.

In addition, I suspect end-users of these complex devices don't really care
about a plugin: they want full control and won't typically use generic
applications. If they would need support for that, we'd have seen much more
interest. The main reason for having a plugin is to simplify testing and
if this is going to be used on cheap hobbyist devkits.

An additional complication is simply that it is hard to find fully supported
MC hardware. omap3 boards are hard to find these days, renesas boards are not
easy to get, freescale isn't the most popular either. Allwinner, mediatek,
amlogic, broadcom and qualcomm all have closed source implementations or no
implementation at all.

I know it took me a very long time before I had a working omap3.

So I am not at all surprised that little progress has been made.

Regards,

	Hans
