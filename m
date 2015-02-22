Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:54095 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbbBVUEM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2015 15:04:12 -0500
Received: by mail-wg0-f41.google.com with SMTP id b13so22136082wgh.0
        for <linux-media@vger.kernel.org>; Sun, 22 Feb 2015 12:04:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1423827006-32878-2-git-send-email-hverkuil@xs4all.nl>
References: <1423827006-32878-1-git-send-email-hverkuil@xs4all.nl> <1423827006-32878-2-git-send-email-hverkuil@xs4all.nl>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Sun, 22 Feb 2015 20:03:41 +0000
Message-ID: <CA+V-a8u1n8emCNt3c9_52Q0U1WUjQLpOTBS+301ubYOrFO5qXQ@mail.gmail.com>
Subject: Re: [PATCH 1/7] v4l2-subdev: replace v4l2_subdev_fh by v4l2_subdev_pad_config
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	laurent pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Fri, Feb 13, 2015 at 11:30 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> If a subdevice pad op is called from a bridge driver, then there is
> no v4l2_subdev_fh struct that can be passed to the subdevice. This
> made it hard to use such subdevs from a bridge driver.
>
> This patch replaces the v4l2_subdev_fh pointer by a v4l2_subdev_pad_config
> pointer in the pad ops. This allows bridge drivers to use the various
> try_ pad ops by creating a v4l2_subdev_pad_config struct and passing it
> along to the pad op.
>
> The v4l2_subdev_get_try_* macros had to be changed because of this, so
> I also took the opportunity to use the full name of the v4l2_subdev_get_try_*
> functions in the __V4L2_SUBDEV_MK_GET_TRY macro arguments: if you now do
> 'git grep v4l2_subdev_get_try_format' you will actually find the header
> where it is defined.
>
> One remark regarding the drivers/staging/media/davinci_vpfe patches: the
> *_init_formats() functions assumed that fh could be NULL. However, that's
> not true for this driver, it's always set. This is almost certainly a copy
> and paste from the omap3isp driver. I've updated the code to reflect the
> fact that fh is never NULL.
>
Yes omap3isp was the only reference at that time :)

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---

The series has few checkpatch warnings, apart from that,

For patches 1-7
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Tested-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
