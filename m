Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45581 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932078Ab2F3Qqn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jun 2012 12:46:43 -0400
Date: Sat, 30 Jun 2012 19:46:34 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
Subject: Re: [PATCH v2] [media] Feature removal: V4L2 selections API target
 and flag definitions
Message-ID: <20120630164634.GD19384@valkosipuli.retiisi.org.uk>
References: <1340643118-32340-1-git-send-email-sylvester.nawrocki@gmail.com>
 <1340651681-21125-1-git-send-email-sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340651681-21125-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 25, 2012 at 09:14:41PM +0200, Sylwester Nawrocki wrote:
> Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
> ---
> Added more precise description of what is being removed.
> ---
>  Documentation/feature-removal-schedule.txt |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index 09701af..b998030 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -558,3 +558,21 @@ Why:	The V4L2_CID_VCENTER, V4L2_CID_HCENTER controls have been deprecated
>  	There are newer controls (V4L2_CID_PAN*, V4L2_CID_TILT*) that provide
>  	similar	functionality.
>  Who:	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
> +
> +----------------------------
> +
> +What:	V4L2 selections API target rectangle and flags unification, the
> +	following definitions will be removed: V4L2_SEL_TGT_CROP_ACTIVE,
> +	V4L2_SEL_TGT_COMPOSE_ACTIVE, V4L2_SUBDEV_SEL_*, V4L2_SUBDEV_SEL_FLAG_*
> +	in favor of common V4L2_SEL_TGT_* and V4L2_SEL_FLAG_* definitions.
> +	For more details see include/linux/v4l2-common.h.
> +When:	3.8
> +Why:	The regular V4L2 selections and the subdev selection API originally
> +	defined distinct names for the target rectangles and flags - V4L2_SEL_*
> +	and V4L2_SUBDEV_SEL_*. Although, it turned out that the meaning of these
> +	target rectangles is virtually identical and the APIs were consolidated
> +	to use single set of names - V4L2_SEL_*. This didn't involve any ABI
> +	changes. Alias definitions were created for the original ones to avoid
> +	any instabilities in the user space interface. After few cycles these
> +	backward compatibility definitions will be removed.
> +Who:	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>

Thanks, Sylwester!

I've added this to my patchset.

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
