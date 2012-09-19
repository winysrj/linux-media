Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:34321 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753078Ab2ISJ7M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Sep 2012 05:59:12 -0400
References: <201209190900.35230.hverkuil@xs4all.nl>
In-Reply-To: <201209190900.35230.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH TRIVIAL] ivtv-alsa-pcm: remove unnecessary printk.h include
From: Andy Walls <awalls@md.metrocast.net>
Date: Wed, 19 Sep 2012 05:59:12 -0400
To: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Message-ID: <3b56ac07-057b-4f64-8a84-fb7fb53a864c@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> wrote:

>Just a quick patch removing the printk.h include: this header is
>already
>included by kernel.h, and it breaks the compat build because this
>header
>only appeared in 2.6.37.
>
>Regards,
>
>	Hans
>
>Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>
>diff --git a/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
>b/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
>index 82c708e..f7022bd 100644
>--- a/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
>+++ b/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
>@@ -26,7 +26,6 @@
> #include <linux/init.h>
> #include <linux/kernel.h>
> #include <linux/vmalloc.h>
>-#include <linux/printk.h>
> 
> #include <media/v4l2-device.h>
> 

Acked-by: Andy Walls <awalls@md.metrocast.net>
