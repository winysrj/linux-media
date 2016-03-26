Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36371 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbcCZU2W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Mar 2016 16:28:22 -0400
Received: by mail-wm0-f65.google.com with SMTP id l68so11762646wml.3
        for <linux-media@vger.kernel.org>; Sat, 26 Mar 2016 13:28:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1458809408-32611-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458809408-32611-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Sat, 26 Mar 2016 20:27:51 +0000
Message-ID: <CA+V-a8tFe0Qxhr5WL=F=koTCRM-4bvOba8A2Gyo9es8XcvsxmA@mail.gmail.com>
Subject: Re: [PATCH v6 0/2] media: Add entity types
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

Thanks for the patches.


On Thu, Mar 24, 2016 at 8:50 AM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> Hello,
>
> This patch series adds an obj_type field to the media entity structure. It
> is a resend of v5 with the MEDIA_ENTITY_TYPE_INVALID type replaced by
> MEDIA_ENTITY_TYPE_BASE to identify media entity instances not embedded in
> another structure.
>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
>
> Laurent Pinchart (2):
>   media: Add obj_type field to struct media_entity
>   media: Rename is_media_entity_v4l2_io to
>     is_media_entity_v4l2_video_device
>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad
