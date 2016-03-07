Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35892 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbcCGKYb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2016 05:24:31 -0500
Received: by mail-wm0-f68.google.com with SMTP id l68so9884282wml.3
        for <linux-media@vger.kernel.org>; Mon, 07 Mar 2016 02:24:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1456844246-18778-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1456844246-18778-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1456844246-18778-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Mon, 7 Mar 2016 10:23:58 +0000
Message-ID: <CA+V-a8twkPoC6BZ-HVcU+cgaq5DkAPcK-76Pc8ce4QSiP0Nubg@mail.gmail.com>
Subject: Re: [PATCH 4/8] media: Rename is_media_entity_v4l2_io to is_media_entity_v4l2_video_device
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patch.

On Tue, Mar 1, 2016 at 2:57 PM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> All users of is_media_entity_v4l2_io() (the exynos4-is, omap3isp,
> davince_vpfe and omap4iss drivers) use the function to check whether
> entities are video_device instances, either to ensure they can cast the
> entity to a struct video_device, or to count the number of video nodes
> users.
>
> The purpose of the function is thus to identify whether the media entity
> instance is an instance of the video_device object, not to check whether
> it can perform I/O. Rename it accordingly, we will introduce a more
> specific is_media_entity_v4l2_io() check when needed.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad
