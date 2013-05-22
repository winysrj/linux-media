Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:32722 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab3EVLMK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 May 2013 07:12:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sachin Kamat <sachin.kamat@linaro.org>
Subject: Re: Warnings related to anonymous unions in s5p-tv driver
Date: Wed, 22 May 2013 13:11:54 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	hans.verkuil@cisco.com
References: <CAK9yfHxBW4wF_sqyzW0+h1xycbDUyJLfWkSKBwZAjU00sh7akA@mail.gmail.com> <201305211128.31301.hverkuil@xs4all.nl> <CAK9yfHyPGdNBbn6o-GLaoeTuYLCEQdCjaw+r2T_UU7_TQLHk8Q@mail.gmail.com>
In-Reply-To: <CAK9yfHyPGdNBbn6o-GLaoeTuYLCEQdCjaw+r2T_UU7_TQLHk8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305221311.54681.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 22 May 2013 13:05:29 Sachin Kamat wrote:
> On 21 May 2013 14:58, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On Fri 17 May 2013 10:24:50 Sachin Kamat wrote:
> >> Hi Hans,
> >>
> >> I noticed the following sparse warnings with S5P HDMI driver which I
> >> think got introduced due to the following commit:
> >> 5efb54b2b7b ([media] s5p-tv: add dv_timings support for hdmi)
> >>
> >> Warnings:
> >> drivers/media/platform/s5p-tv/hdmi_drv.c:483:18: error: unknown field
> >> name in initializer
> >> drivers/media/platform/s5p-tv/hdmi_drv.c:484:18: error: unknown field
> >> name in initializer
> >> drivers/media/platform/s5p-tv/hdmi_drv.c:485:18: error: unknown field
> >> name in initializer
> >> drivers/media/platform/s5p-tv/hdmi_drv.c:486:18: error: unknown field
> >> name in initializer
> >> drivers/media/platform/s5p-tv/hdmi_drv.c:487:18: error: unknown field
> >> name in initializer
> >> drivers/media/platform/s5p-tv/hdmi_drv.c:488:18: error: unknown field
> >> name in initializer
> >> drivers/media/platform/s5p-tv/hdmi_drv.c:489:18: error: unknown field
> >> name in initializer
> >> drivers/media/platform/s5p-tv/hdmi_drv.c:490:18: error: unknown field
> >> name in initializer
> >> drivers/media/platform/s5p-tv/hdmi_drv.c:491:18: error: unknown field
> >> name in initializer
> >> drivers/media/platform/s5p-tv/hdmi_drv.c:492:18: error: unknown field
> >> name in initializer
> >>
> >> This looks like the anonymous union initialization problem with GCC.
> >> Surprisingly I get this with GCC 4.6, 4.7 and 4.8 as well.
> >>
> >> If I add additional braces to the macro V4L2_INIT_BT_TIMINGS like done
> >> for GCC version < 4.6
> >> like
> >> { .bt = { _width , ## args } }
> >>
> >> or if I change the GNUC_MINOR comparison to 9 like (__GNUC_MINOR__ < 9)
> >> I dont see this error.
> >>
> >> I am using the Linaro GCC toolchain.
> >>
> >> I am not sure if this has already been reported and/or fixed.
> >>
> >
> > Could it be that a different compiler version is used when using sparse?
> > I don't see these errors when running sparse during the daily build.
> 
> Please let me know your compiler version. I could probably try with it and see.

For the sparse run I suspect it is using the standard compiler which is version
4.7.2. It might use a 4.8.0 cross-compiler, but certainly nothing older than 4.7.2.

Regards,

	Hans
