Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53098 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751952AbcIGMrt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2016 08:47:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        corbet@lwn.net, mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com
Subject: Re: [PATCHv3 2/2] v4l: vsp1: Add HGT support
Date: Wed, 07 Sep 2016 15:48:19 +0300
Message-ID: <3579545.u5RR9atB6T@avalon>
In-Reply-To: <20160907120938.818-3-niklas.soderlund+renesas@ragnatech.se>
References: <20160907120938.818-1-niklas.soderlund+renesas@ragnatech.se> <20160907120938.818-3-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thank you for the patch.

On Wednesday 07 Sep 2016 14:09:38 Niklas S=F6derlund wrote:
> The HGT is a Histogram Generator Two-Dimensions. It computes a weight=
ed
> frequency histograms for hue and saturation areas over a configurable=

> region of the image with optional subsampling.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech=
.se>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

However, please note that we might need to upstream HGT support before =
HGO. To=20
ease that, I've split the HGO patches in common code and HGO-specific c=
ode,=20
and rebased your patch on top of that. The result is available at

=09git://linuxtv.org/pinchartl/media.git vsp1/next

There will still be conflicts if we need to reorder the patches, but th=
ey=20
should be easier to handle now.

> ---
>  drivers/media/platform/vsp1/Makefile      |   2 +-
>  drivers/media/platform/vsp1/vsp1.h        |   3 +
>  drivers/media/platform/vsp1/vsp1_drv.c    |  33 ++++-
>  drivers/media/platform/vsp1/vsp1_entity.c |  33 +++--
>  drivers/media/platform/vsp1/vsp1_entity.h |   1 +
>  drivers/media/platform/vsp1/vsp1_hgt.c    | 221 ++++++++++++++++++++=
+++++++
>  drivers/media/platform/vsp1/vsp1_hgt.h    |  42 ++++++
>  drivers/media/platform/vsp1/vsp1_pipe.c   |  16 +++
>  drivers/media/platform/vsp1/vsp1_pipe.h   |   2 +
>  drivers/media/platform/vsp1/vsp1_regs.h   |   9 ++
>  drivers/media/platform/vsp1/vsp1_video.c  |  10 +-
>  11 files changed, 356 insertions(+), 16 deletions(-)
>  create mode 100644 drivers/media/platform/vsp1/vsp1_hgt.c
>  create mode 100644 drivers/media/platform/vsp1/vsp1_hgt.h

--=20
Regards,

Laurent Pinchart

