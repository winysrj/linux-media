Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:34920 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbcDUTph (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2016 15:45:37 -0400
MIME-Version: 1.0
In-Reply-To: <1461201253-12170-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1461201253-12170-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Date: Fri, 22 Apr 2016 05:45:34 +1000
Message-ID: <CAPM=9txvkSgKZxkiAr-EoGBP8=b-jo3bxibt5Xam=7qCq8w6AA@mail.gmail.com>
Subject: Re: [PATCH 0/2] Renesas R-Car Gen3 DU alpha and z-order support
From: Dave Airlie <airlied@gmail.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
	linux-renesas-soc@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21 April 2016 at 11:14, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> Hello,
>
> This patch series implement support for alpha and z-order configuration in the
> R-Car DU driver for the Gen3 SoCs family.
>
> The Gen3 SoCs delegate composition to an external IP core called VSP,
> supported by a V4L2 driver. The DU driver interfaces with the VSP driver using
> direct function calls. Alpha and z-order configuration is implemented in the
> VSP driver, the DU driver thus just needs to pass the values using the VSP
> API.
>
> This series depends on a large VSP series that has been merged in the Linux
> media git tree for v4.7. Dave, instead of merging the media tree in your tree
> to pull the dependency in, it would be easier to get those two patches
> upstream through the media tree. I don't expect any conflict related to the
> DU driver for v4.7. If you're fine with that, could you ack the patches ?
>
> Laurent Pinchart (2):
>   drm: rcar-du: Add Z-order support for VSP planes
>   drm: rcar-du: Add alpha support for VSP planes
>

Seems fine,

Acked-by: Dave AIrlie <airlied@redhat.com>

for inclusion via media.

Dave.

>  drivers/gpu/drm/rcar-du/rcar_du_vsp.c | 16 ++++++++++++----
>  drivers/gpu/drm/rcar-du/rcar_du_vsp.h |  2 ++
>  2 files changed, 14 insertions(+), 4 deletions(-)
>
> --
> Regards,
>
> Laurent Pinchart
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
