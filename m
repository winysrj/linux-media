Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:59858 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932481Ab3GWPu1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 11:50:27 -0400
Received: by mail-we0-f177.google.com with SMTP id m46so546913wev.8
        for <linux-media@vger.kernel.org>; Tue, 23 Jul 2013 08:50:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1374516287-7638-5-git-send-email-s.nawrocki@samsung.com>
References: <1374516287-7638-1-git-send-email-s.nawrocki@samsung.com> <1374516287-7638-5-git-send-email-s.nawrocki@samsung.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 23 Jul 2013 21:20:06 +0530
Message-ID: <CA+V-a8t+tqvJXZrFUJ2sA2TM=7AM1U50h7aAfHze+yKnAzsYMw@mail.gmail.com>
Subject: Re: [PATCH RFC 4/5] V4L2: Rename subdev field of struct v4l2_async_notifier
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Mon, Jul 22, 2013 at 11:34 PM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> This is a purely cosmetic change. Since the 'subdev' member
> points to an array of subdevs it seems more intuitive to name
> it in plural form.
>
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/platform/soc_camera/soc_camera.c |    2 +-
>  drivers/media/v4l2-core/v4l2-async.c           |    2 +-
>  include/media/v4l2-async.h                     |    4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)
>

can you include the following changes in the same patch ?
so that git bisect doesn’t break.

(maybe you need to rebase the patches on
http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/for-v3.12)

Regards,
--Prabhakar Lad

diff --git a/drivers/media/platform/davinci/vpif_capture.c
b/drivers/media/platform/davinci/vpif_capture.c
index b11d7a7..7fbde6d 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -2168,7 +2168,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 		}
 		vpif_probe_complete();
 	} else {
-		vpif_obj.notifier.subdev = vpif_obj.config->asd;
+		vpif_obj.notifier.subdevs = vpif_obj.config->asd;
 		vpif_obj.notifier.num_subdevs = vpif_obj.config->asd_sizes[0];
 		vpif_obj.notifier.bound = vpif_async_bound;
 		vpif_obj.notifier.complete = vpif_async_complete;
diff --git a/drivers/media/platform/davinci/vpif_display.c
b/drivers/media/platform/davinci/vpif_display.c
index c2ff067..6336dfc 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1832,7 +1832,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 		}
 		vpif_probe_complete();
 	} else {
-		vpif_obj.notifier.subdev = vpif_obj.config->asd;
+		vpif_obj.notifier.subdevs = vpif_obj.config->asd;
 		vpif_obj.notifier.num_subdevs = vpif_obj.config->asd_sizes[0];
 		vpif_obj.notifier.bound = vpif_async_bound;
 		vpif_obj.notifier.complete = vpif_async_complete;
