Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:36053 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaLCAvK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Dec 2014 19:51:10 -0500
Received: by mail-wg0-f51.google.com with SMTP id k14so18541937wgh.10
        for <linux-media@vger.kernel.org>; Tue, 02 Dec 2014 16:51:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1417522901-43604-1-git-send-email-hverkuil@xs4all.nl>
References: <1417522901-43604-1-git-send-email-hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 3 Dec 2014 00:50:39 +0000
Message-ID: <CA+V-a8utLpogPEYUVtMxYJS_cDixa-xcyZw4r9Vek3R9x+Gtxg@mail.gmail.com>
Subject: Re: [PATCH 1/2] v4l2 subdevs: replace get/set_crop by get/set_selection
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Tue, Dec 2, 2014 at 12:21 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> The crop and selection pad ops are duplicates. Replace all uses of get/set_crop
> by get/set_selection. This will make it possible to drop get/set_crop
> altogether.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
> Cc: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/i2c/mt9m032.c                     | 40 +++++++-------
>  drivers/media/i2c/mt9p031.c                     | 40 +++++++-------
>  drivers/media/i2c/mt9t001.c                     | 41 ++++++++-------
>  drivers/media/i2c/mt9v032.c                     | 43 ++++++++-------
>  drivers/media/i2c/s5k6aa.c                      | 44 +++++++++-------
>  drivers/staging/media/davinci_vpfe/dm365_isif.c | 69 +++++++++++++------------

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Thanks,
--Prabhakar Lad
