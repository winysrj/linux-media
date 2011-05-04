Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:34684 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752818Ab1EDMU2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2011 08:20:28 -0400
References: <4DC138F7.5050400@infradead.org> <1304509147-28058-1-git-send-email-simon.farnsworth@onelan.co.uk>
In-Reply-To: <1304509147-28058-1-git-send-email-simon.farnsworth@onelan.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] cx18: Bump driver version to 1.5.0
From: Andy Walls <awalls@md.metrocast.net>
Date: Wed, 04 May 2011 08:20:23 -0400
To: Simon Farnsworth <simon.farnsworth@onelan.co.uk>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Steven Toth <stoth@kernellabs.com>
Message-ID: <1d34e674-1494-4bfd-8929-0837fb7c4ae5@email.android.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Simon Farnsworth <simon.farnsworth@onelan.co.uk> wrote:

>To simplify maintainer support of this driver, bump the version to
>1.5.0 - this will be the first version that is expected to support
>mmap() for raw video frames.
>
>Signed-off-by: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
>---
>Mauro,
>
>This is an incremental patch to apply on top of my cleanup patch - if
>you would prefer a complete new patch with this squashed into the
>cleanup patch, just ask and it will be done.
>
> drivers/media/video/cx18/cx18-version.h |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/media/video/cx18/cx18-version.h
>b/drivers/media/video/cx18/cx18-version.h
>index 62c6ca2..cd189b6 100644
>--- a/drivers/media/video/cx18/cx18-version.h
>+++ b/drivers/media/video/cx18/cx18-version.h
>@@ -24,8 +24,8 @@
> 
> #define CX18_DRIVER_NAME "cx18"
> #define CX18_DRIVER_VERSION_MAJOR 1
>-#define CX18_DRIVER_VERSION_MINOR 4
>-#define CX18_DRIVER_VERSION_PATCHLEVEL 1
>+#define CX18_DRIVER_VERSION_MINOR 5
>+#define CX18_DRIVER_VERSION_PATCHLEVEL 0
> 
>#define CX18_VERSION __stringify(CX18_DRIVER_VERSION_MAJOR) "."
>__stringify(CX18_DRIVER_VERSION_MINOR) "."
>__stringify(CX18_DRIVER_VERSION_PATCHLEVEL)
>#define CX18_DRIVER_VERSION KERNEL_VERSION(CX18_DRIVER_VERSION_MAJOR, \
>-- 
>1.7.4
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks Simon.

Acked-by: Andy Walls <awalls@md.metrocast.net>

Regards,
Andy
