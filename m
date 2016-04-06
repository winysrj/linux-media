Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:21184 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbcDFGnV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Apr 2016 02:43:21 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 1/2] media: platform: transfer format translations to soc_mediabus
References: <1459607213-15774-1-git-send-email-robert.jarzmik@free.fr>
	<1459607213-15774-2-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.1604060549100.12238@axis700.grange>
Date: Wed, 06 Apr 2016 08:43:15 +0200
In-Reply-To: <Pine.LNX.4.64.1604060549100.12238@axis700.grange> (Guennadi
	Liakhovetski's message of "Wed, 6 Apr 2016 05:53:36 +0200 (CEST)")
Message-ID: <8760vvutj0.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

Hi Guennadi,
> Not sure I understand, what should the purpose of this patch be?
See in [1].

> Why do you want to move some function(s) from one file to another?  And you
> aren't even calling the new soc_mbus_build_fmts_xlate() function
I'm calling it in pxa_camera_build_formats() in patch 2/2.

> and you aren't replacing the currently used analogous
> soc_camera_init_user_formats() function.
I'm doing that in patch 2/2.

> Or was this patch not-to-be-reviewed?
Actually these 2 patches are designed to be discussion openers :)
For me, their purpose is to expose the transition of pxa_camera out of
soc_camera and see if the chosen path is good, or if there exists a better one.

In other words, these patches show that :
 - in a first stage, soc_mediabus should be kept [1]
   => at least for formats translation (soc_mbus_build_fmts_xlate())
   => and for used formats by sensors
   => this is why patch 1/1 exists

 - the conversion almost doesn't touch the pxa_camera_() core functions (IP
   manipulation), which is good, and only touch the upper layer

 - that soc_mediabus adherence removal will be another task

 - the amount of code which is shifted from soc_camera to pxa_camera

 - the functionalities that are lost through conversion which should be readded
   later
   => cropping is one
   => pixel clock sensing is another one

All in all, before submitting patch for real, ie. not in RFC mode, I wanted to
be sure the proposed conversion is sound, and compare to other drivers
conversion to see if we were going in the same direction.

As to whether this patch should be reviewed or not, I'd say that I was just
expecting to have an "that might be the way to go" or "NAK, wrong patch, let's
do something else instead".

Cheers.

-- 
Robert
