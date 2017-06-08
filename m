Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:53747 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751049AbdFHG3x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Jun 2017 02:29:53 -0400
Subject: Re: [PATCH v2 2/4] [media] davinci: vpif_capture: get subdevs from DT
 when available
To: Kevin Hilman <khilman@baylibre.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
References: <20170606233741.26718-1-khilman@baylibre.com>
 <20170606233741.26718-3-khilman@baylibre.com>
Cc: Sekhar Nori <nsekhar@ti.com>, David Lechner <david@lechnology.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Benoit Parrot <bparrot@ti.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        linux-arm-kernel@lists.infradead.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f305d0fc-b5cd-591a-1d95-7ae66bfa72ec@xs4all.nl>
Date: Thu, 8 Jun 2017 08:29:50 +0200
MIME-Version: 1.0
In-Reply-To: <20170606233741.26718-3-khilman@baylibre.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/06/17 01:37, Kevin Hilman wrote:
> Enable  getting of subdevs from DT ports and endpoints.
> 
> The _get_pdata() function was larely inspired by (i.e. stolen from)
> am437x-vpfe.c
> 
> Signed-off-by: Kevin Hilman <khilman@baylibre.com>
> ---
>  drivers/media/platform/davinci/vpif_capture.c | 126 +++++++++++++++++++++++++-
>  drivers/media/platform/davinci/vpif_display.c |   5 +
>  include/media/davinci/vpif_types.h            |   9 +-
>  3 files changed, 134 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
> index fc5c7622660c..b9d927d1e5a8 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -22,6 +22,8 @@
>  #include <linux/slab.h>
>  
>  #include <media/v4l2-ioctl.h>
> +#include <media/v4l2-of.h>

v4l2-of.h no longer exists, so this v2 is wrong. Unfortunately this patch has
already been merged in our master. I'm not sure how this could have slipped past
both my and Mauro's patch testing (and yours, for that matter).

Can you fix this and post a patch on top of the media master that makes this
compile again?

Regards,

	Hans
