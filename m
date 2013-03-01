Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3123 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab3CALcR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2013 06:32:17 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [RFC PATCH 00/18] Remove DV_PRESET API
Date: Fri, 1 Mar 2013 12:32:04 +0100
Cc: linux-media@vger.kernel.org,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>
References: <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl> <51308A75.4040300@samsung.com>
In-Reply-To: <51308A75.4040300@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303011232.04059.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri March 1 2013 12:01:09 Tomasz Stanislawski wrote:
> Hi Hans,
> Thank you for the patches.
> I applied the patchset on the top of SPRC's 3.8-rc4 kernel.
> I tested the s5p-tv dv-timings using 0.9.3 using v4l-utils.
> The test platform was Universal C210 (based on Exynos 4210 SoC).
> 
> Every timing mode worked correctly so do not hesitate to add:
> 
> Tested-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> 
> to all s5p-tv related patches.

Thanks for testing! Much appreciated.

> 
> I tested following features:
> a) v4l2-ctl --list-dv-timings
>    Result: got 10 timings entries as expected
> b) v4l2-ctl --get-dv-timings-cap
>    Result: got timings caps. The was minor issue. Minimal with is 720 not 640.
> c) for each available timing
>    v4l2-ctl --set-dv-bt-timings=index={index}
>    v4l2-ctl --get-dv-bt-timings
>    Show test image on the screen
>    Result: TV detected correct timings for all cases
> 
> I found some minor issues in the patches.
> Please refer to the inlined comments.

I'll take those into account for my v2 posting.

> BTW.
> The v4l2-ctl reports that fps for 1080i50 and 1080i60 as 25 and 30 respectively.
> I agree that those values correctly reflects relation between
> image resolution and the pixel rate.
> However, I admit it looks a little bit confusing when suddenly 50 changes into 25.
> It should clarified if F in FPS stands for "frame" or "field".

Can you add this patch to v4l2-ctl and see if that looks better?

--------------- cut here ---------------
diff --git a/utils/v4l2-ctl/v4l2-ctl-stds.cpp b/utils/v4l2-ctl/v4l2-ctl-stds.cpp
index 863357a..d39faca 100644
--- a/utils/v4l2-ctl/v4l2-ctl-stds.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-stds.cpp
@@ -260,10 +260,9 @@ static void print_dv_timings(const struct v4l2_dv_timings *t)
 				(bt->polarities & V4L2_DV_HSYNC_POS_POL) ? '+' : '-');
 		printf("\tPixelclock: %lld Hz", bt->pixelclock);
 		if (bt->width && bt->height)
-			printf(" (%.2f fps)", (double)bt->pixelclock /
+			printf(" (%.2f fields per second)", (double)bt->pixelclock /
 					((bt->width + bt->hfrontporch + bt->hsync + bt->hbackporch) *
-					 (bt->height + bt->vfrontporch + bt->vsync + bt->vbackporch +
-					  bt->il_vfrontporch + bt->il_vsync + bt->il_vbackporch)));
+					 (bt->height + bt->vfrontporch + bt->vsync + bt->vbackporch)));
 		printf("\n");
 		printf("\tHorizontal frontporch: %d\n", bt->hfrontporch);
 		printf("\tHorizontal sync: %d\n", bt->hsync);
--------------- cut here ---------------

Also, can you run v4l2-compliance as well? See what that reports.

Regards,

	Hans
