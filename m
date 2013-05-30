Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:41313 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967578Ab3E3HUW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 May 2013 03:20:22 -0400
Received: by mail-wg0-f47.google.com with SMTP id e11so7205166wgh.14
        for <linux-media@vger.kernel.org>; Thu, 30 May 2013 00:20:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1369825211-29770-3-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl> <1369825211-29770-3-git-send-email-hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 30 May 2013 12:50:00 +0530
Message-ID: <CA+V-a8s8ersTemd4tb0LrO8AdV=XO9RzwtVgOMRV0Z4XCbNxAQ@mail.gmail.com>
Subject: Re: [PATCHv1 02/38] v4l2: remove g_chip_ident from bridge drivers
 where it is easy to do so.
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	stoth@linuxtv.org, Scott Jiang <scott.jiang.linux@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Ezequiel Garcia <elezegarcia@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Andrey Smirnov <andrew.smirnov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Wed, May 29, 2013 at 4:29 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> VIDIOC_DBG_G_CHIP_IDENT has been replaced by VIDIOC_DBG_G_CHIP_INFO. Remove
> g_chip_ident support from bridge drivers since it is no longer needed.
>
> This patch takes care of all the trivial cases.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: stoth@linuxtv.org
> Cc: Scott Jiang <scott.jiang.linux@gmail.com>
> Cc: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Ezequiel Garcia <elezegarcia@gmail.com>
> Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
> Cc: Andrey Smirnov <andrew.smirnov@gmail.com>
> ---
>  drivers/media/platform/davinci/vpif_capture.c  |   66 ------------------------
>  drivers/media/platform/davinci/vpif_display.c  |   66 ------------------------

for the above,

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
