Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:50941 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab3HEHIc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 03:08:32 -0400
Received: by mail-wg0-f41.google.com with SMTP id l18so1009814wgh.4
        for <linux-media@vger.kernel.org>; Mon, 05 Aug 2013 00:08:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1375101661-6493-7-git-send-email-hverkuil@xs4all.nl>
References: <1375101661-6493-1-git-send-email-hverkuil@xs4all.nl> <1375101661-6493-7-git-send-email-hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 5 Aug 2013 12:38:11 +0530
Message-ID: <CA+V-a8veUgRFSTpEOMenNSKT3YHG+U64AQ-C0sOFwowa-ffiRA@mail.gmail.com>
Subject: Re: [RFC PATCH 6/8] v4l2: use new V4L2_DV_BT_BLANKING/FRAME defines
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Mon, Jul 29, 2013 at 6:10 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Use the new defines to calculate the full blanking and frame sizes.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: Scott Jiang <scott.jiang.linux@gmail.com>
> ---
[Snip]
>  drivers/media/i2c/ths7303.c                    | 6 ++----
>  drivers/media/i2c/ths8200.c                    | 8 ++++----

For the above two,

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

May be you can split this patch into two ? one with i2c changes and
other with driver.

Regards,
--Prabhakar Lad
