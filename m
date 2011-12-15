Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:42355 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758987Ab1LOQER (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 11:04:17 -0500
Message-ID: <4EEA1A78.9000504@infradead.org>
Date: Thu, 15 Dec 2011 14:04:08 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: javier Martin <javier.martin@vista-silicon.com>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 1/2] media: tvp5150 Fix default input selection.
References: <1323941987-23428-1-git-send-email-javier.martin@vista-silicon.com> <4EE9C7FA.8070607@infradead.org> <CACKLOr1DLj_uc-NDQPNjXHcej2isE==d=_wUinXDDfJLgFiPKg@mail.gmail.com> <4EE9DF50.20904@infradead.org> <CACKLOr0KG9hS0a=qdYHfjrZzse2etbhPmCPpUjXwi5TLSqP5SA@mail.gmail.com> <CACKLOr1N0i0tmA7f3WT+nZ6Tn45naRz0CtR6mHyKJ9P5_Lgr+w@mail.gmail.com>
In-Reply-To: <CACKLOr1N0i0tmA7f3WT+nZ6Tn45naRz0CtR6mHyKJ9P5_Lgr+w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15-12-2011 10:33, javier Martin wrote:
> On 15 December 2011 13:01, javier Martin
> <javier.martin@vista-silicon.com> wrote:
>>> The mx2_camera needs some code to forward calls to S_INPUT/S_ROUTING to
>>> tvp5150, in order to set the pipelines there.
>>
>> This sounds like a sensible solution I will work on that soon.
>>
> 
> Hi Mauro,
> regarding this subject it seems soc-camera assumes the attached sensor
> has only one input: input 0. This means I am not able to forward
> S_INPUT/S_ROUTING as you suggested:
> http://lxr.linux.no/#linux+v3.1.5/drivers/media/video/soc_camera.c#L213

Then, you need to submit a patch for soc_camera, in order to allow it
to work with devices that provide more than one input.

> This trick is clearly a loss of functionality because it restricts
> sensors to output 0, but it should work since the subsystem can assume
> a sensor whose inputs have not been configured has input 0 as the one
> selected.
> 
> However, this trick in the tvp5150 which selects input 1 (instead of
> 0) as the default input is breaking that assumption. The solution
> could be either apply my patch to set input 0 (COMPOSITE0) as default
> or swap input numbers so that COMPOSITE1 input is input 0.
> 
> Personally I find my approach more convenient since it matches with
> the default behavior expected in the datasheet.

Both of your described ways are just hacks. tvp5150 has more than one
input. So, the bridge should be supporting the selection between
them.

Regards,
Mauro
> 
> Regards.

