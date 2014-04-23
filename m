Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f173.google.com ([209.85.220.173]:33669 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381AbaDWRk1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Apr 2014 13:40:27 -0400
Received: by mail-vc0-f173.google.com with SMTP id il7so1585936vcb.32
        for <linux-media@vger.kernel.org>; Wed, 23 Apr 2014 10:40:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394532878-3943-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1394532878-3943-1-git-send-email-laurent.pinchart@ideasonboard.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 23 Apr 2014 23:09:56 +0530
Message-ID: <CA+V-a8sn2wSVs+DXLDU-T4vFF5z_eVB3UbPJdJ4M7EZ4hpBHUA@mail.gmail.com>
Subject: Re: [PATCH] v4l: subdev: Move [gs]_std operation to video ops
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patch.

On Tue, Mar 11, 2014 at 3:44 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> The g_std and s_std operations are video-related, move them to the video
> ops where they belong.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
[snip]
>  drivers/media/i2c/tvp514x.c                     |  2 +-
>  drivers/media/platform/davinci/vpfe_capture.c   |  2 +-
>  drivers/media/platform/davinci/vpif_capture.c   |  2 +-
>  drivers/staging/media/davinci_vpfe/vpfe_video.c |  2 +-
>  include/media/v4l2-subdev.h                     |  6 +++---
>  };
>
>
For the above: Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Thanks,
--Prabhakar Lad
