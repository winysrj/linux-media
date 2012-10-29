Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:47094 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab2J2OMH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Oct 2012 10:12:07 -0400
Received: from eusync4.samsung.com (mailout4.w1.samsung.com [210.118.77.14])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MCN00GBBRH2J130@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 29 Oct 2012 14:12:38 +0000 (GMT)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MCN00I0PRG5I990@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 29 Oct 2012 14:12:05 +0000 (GMT)
Message-id: <508E8EB3.9050808@samsung.com>
Date: Mon, 29 Oct 2012 15:12:03 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 0/2] Fix a few more warnings
References: <1351506118-2385-1-git-send-email-mchehab@redhat.com>
 <508E6644.4040104@samsung.com> <20121029093251.1bb2acfa@redhat.com>
In-reply-to: <20121029093251.1bb2acfa@redhat.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/29/2012 12:32 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 29 Oct 2012 12:19:32 +0100
> Sylwester Nawrocki <s.nawrocki@samsung.com> escreveu:
> 
>> On 10/29/2012 11:21 AM, Mauro Carvalho Chehab wrote:
>>> Hans Verkuil yesterday's build still got two warnings at the
>>> generic drivers:
>>>         http://hverkuil.home.xs4all.nl/logs/Sunday.log
>>>
>>> They didn't appear at i386 build probably because of some
>>> optimization done there.
>>>
>>> Anyway, fixing them are trivial, so let's do it.
>>>
>>> After applying those patches, the only drivers left producing
>>> warnings are the following platform drivers:
>>>
>>> drivers/media/platform/davinci/dm355_ccdc.c
>>> drivers/media/platform/davinci/dm644x_ccdc.c
>>> drivers/media/platform/davinci/vpbe_osd.c
>>> drivers/media/platform/omap3isp/ispccdc.c
>>> drivers/media/platform/omap3isp/isph3a_aewb.c
>>> drivers/media/platform/omap3isp/isph3a_af.c
>>> drivers/media/platform/omap3isp/isphist.c
>>> drivers/media/platform/omap3isp/ispqueue.c
>>> drivers/media/platform/omap3isp/ispvideo.c
>>> drivers/media/platform/omap/omap_vout.c
>>> drivers/media/platform/s5p-fimc/fimc-capture.c
>>> drivers/media/platform/s5p-fimc/fimc-lite.c
>>
>> For these two files I've sent already a pull request [1], which
>> includes a fixup patch
>> s5p-fimc: Don't ignore return value of vb2_queue_init()
>>
>> BTW, shouldn't things like these be taken care when someone does
>> a change at the core code ? 
> 
> Sure. I remember I saw one patch with s5p on that series[1].
> Can't remember anymore if it were acked and merged directly, if
> it was opted to send it via your tree (or maybe that patch was just
> incomplete, and got unnoticed on that time).

I think this was one of the first patches from Ezequiel, when he wanted
to change the vb2_queue_init() function signature so it returns void (as
there were only BUG_ON()s used inside it). But what we need now at drivers
is the opposite, i.e. to keep checking the return value and to add where
such checks are missing. Thus patch [1] is not applicable, since BUG_ONs
were replaced with WARN_ON and __must_check annotation was added to the
vb2_queue_init() function declaration.

> [1] https://patchwork.kernel.org/patch/1372871/
> 
> It is not easy to enforce those kind of things for platform drivers,
> as there's not yet a single .config file that could be used to test
> all arm drivers. Hans automatic builds might be useful, if there weren't

The ARM arch consolidation efforts are ongoing, for 1.5 year now IIRC
and there are good results. Still it looks like there is one year or so 
needed to be able to build one single image usable on all ARM sub-archs.
I think the progress is good and it all looks very promising, perhaps 
mostly thanks to the Linaro initiative.

> any warns at the -git tree build at the tested archs, but there are
> so many warnings that I think I never saw any such report saying that
> there's no warning.
> 
> Btw, are there anyone really consistently using his reports to fix things?

Yes, I'm often looking at those logs. I find them useful, especially that 
it nearly doesn't happen I build some drivers on architectures other than 
ARM. So it's good to have those build logs.

Some projects, e.g. [2], use build/test systems that allow to track status
after each commit. Not sure if something like this is feasible for whole
media subsystem.

[2] https://chromium-build.appspot.com/p/chromium/console

--
Regards,
Sylwester
