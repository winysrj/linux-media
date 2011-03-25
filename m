Return-path: <mchehab@pedra>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:56301 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755226Ab1CYVlq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2011 17:41:46 -0400
Received: by mail-gw0-f45.google.com with SMTP id 19so759651gwb.4
        for <linux-media@vger.kernel.org>; Fri, 25 Mar 2011 14:41:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=tqMHNQs=-R2rUpD_RZvGJSPUFY8uS6Rz1jCEM@mail.gmail.com>
References: <201103080913.59231.hverkuil@xs4all.nl>
	<201103081652.20561.laurent.pinchart@ideasonboard.com>
	<1299611565.24699.12.camel@morgan.silverblock.net>
	<201103082023.58437.laurent.pinchart@ideasonboard.com>
	<AANLkTin=CUsTH-dB2b0PYxSQbnq_e4nm-tDufVaKNM9p@mail.gmail.com>
	<AANLkTi=YcrYKJ5aiqjeFEPceNbg5k0k7p58bYHkm2rEH@mail.gmail.com>
	<AANLkTi=+2-K9-nt_Sahhrr4K9yg1bzotVexq_YnUTJYi@mail.gmail.com>
	<AANLkTi=tqMHNQs=-R2rUpD_RZvGJSPUFY8uS6Rz1jCEM@mail.gmail.com>
Date: Fri, 25 Mar 2011 16:41:32 -0500
Message-ID: <AANLkTinLNB6_QWgbaYj2G=D9e=XqxdodNmuF+=poJJS3@mail.gmail.com>
Subject: Re: Yet another memory provider: can linaro organize a meeting?
From: "Clark, Rob" <rob@ti.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Li Li <eggonlea@gmail.com>, Jonghun Han <jonghun.han@samsung.com>,
	Andy Walls <awalls@md.metrocast.net>,
	linaro-dev@lists.linaro.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Alex Deucher <alexdeucher@gmail.com>,
	linux-media@vger.kernel.org, Andy Gross <andy.gross@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Mar 16, 2011 at 3:14 AM, Kyungmin Park <kmpark@infradead.org> wrote:
>
> Rough schedules.
>
> 1. Warsaw meetings (3/16~3/18): mostly v4l2 person and some SoC vendors
>  Make a consensence at media developers. and share the information.
>  Please note that it's v4l2 brainstorming meeting. so memory
> management is not the main issue.
> 2. ELC (4/11~4/13): DRM, DRI and v4l2 person.

Fyi, I should be at ELC, at least for a day or two.. it would be nice,
as Andy suggested on other thread, to carve out a timeslot to discuss
in advance, because I'm not sure that I'll be able to be there the
entire time..

BR,
-R

>  Discuss GEM/TTM is acceptable for non-X86 system and find out the
> which modules are acceptable.
>  We studied the GEM for our environment. but it's too huge and not
> much benefit for us since current frameworks are enough.
>  The missing is that no generic memory passing mechanism. We need the
> generic memory passing interface. that's all.
> 3. Linaro (5/9~5/13): ARM, SoC vendors and v4l2 persons.
>  I hope several person are anticipated and made a small step for final goal.
