Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:47661 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab1LOMdT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 07:33:19 -0500
Received: by wgbds13 with SMTP id ds13so1048941wgb.1
        for <linux-media@vger.kernel.org>; Thu, 15 Dec 2011 04:33:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACKLOr0KG9hS0a=qdYHfjrZzse2etbhPmCPpUjXwi5TLSqP5SA@mail.gmail.com>
References: <1323941987-23428-1-git-send-email-javier.martin@vista-silicon.com>
	<4EE9C7FA.8070607@infradead.org>
	<CACKLOr1DLj_uc-NDQPNjXHcej2isE==d=_wUinXDDfJLgFiPKg@mail.gmail.com>
	<4EE9DF50.20904@infradead.org>
	<CACKLOr0KG9hS0a=qdYHfjrZzse2etbhPmCPpUjXwi5TLSqP5SA@mail.gmail.com>
Date: Thu, 15 Dec 2011 13:33:18 +0100
Message-ID: <CACKLOr1N0i0tmA7f3WT+nZ6Tn45naRz0CtR6mHyKJ9P5_Lgr+w@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: tvp5150 Fix default input selection.
From: javier Martin <javier.martin@vista-silicon.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15 December 2011 13:01, javier Martin
<javier.martin@vista-silicon.com> wrote:
>> The mx2_camera needs some code to forward calls to S_INPUT/S_ROUTING to
>> tvp5150, in order to set the pipelines there.
>
> This sounds like a sensible solution I will work on that soon.
>

Hi Mauro,
regarding this subject it seems soc-camera assumes the attached sensor
has only one input: input 0. This means I am not able to forward
S_INPUT/S_ROUTING as you suggested:
http://lxr.linux.no/#linux+v3.1.5/drivers/media/video/soc_camera.c#L213

This trick is clearly a loss of functionality because it restricts
sensors to output 0, but it should work since the subsystem can assume
a sensor whose inputs have not been configured has input 0 as the one
selected.

However, this trick in the tvp5150 which selects input 1 (instead of
0) as the default input is breaking that assumption. The solution
could be either apply my patch to set input 0 (COMPOSITE0) as default
or swap input numbers so that COMPOSITE1 input is input 0.

Personally I find my approach more convenient since it matches with
the default behavior expected in the datasheet.

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
