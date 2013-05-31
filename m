Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f49.google.com ([209.85.212.49]:35388 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab3EaHxn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 03:53:43 -0400
Received: by mail-vb0-f49.google.com with SMTP id q13so822459vbe.22
        for <linux-media@vger.kernel.org>; Fri, 31 May 2013 00:53:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1369825211-29770-3-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
	<1369825211-29770-3-git-send-email-hverkuil@xs4all.nl>
Date: Fri, 31 May 2013 15:53:42 +0800
Message-ID: <CAHG8p1AsG1DiTxdnztqrcCu-RANpUUY=d9+V4D9-4ub4umZcLQ@mail.gmail.com>
Subject: Re: [PATCHv1 02/38] v4l2: remove g_chip_ident from bridge drivers
 where it is easy to do so.
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	stoth@linuxtv.org, "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Ezequiel Garcia <elezegarcia@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Andrey Smirnov <andrew.smirnov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2013/5/29 Hans Verkuil <hverkuil@xs4all.nl>:
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

>  drivers/media/platform/blackfin/bfin_capture.c |   41 ---------------

Acked-by: Scott Jiang <scott.jiang.linux@gmail.com>
