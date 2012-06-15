Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39908 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756961Ab2FOOOP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jun 2012 10:14:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl, snjw23@gmail.com,
	t.stanislaws@samsung.com
Subject: Re: [PATCH v4 7/7] v4l: Correct conflicting V4L2 subdev selection API documentation
Date: Fri, 15 Jun 2012 16:14:21 +0200
Message-ID: <1580520.TYuvdPHuRK@avalon>
In-Reply-To: <1339767880-8412-7-git-send-email-sakari.ailus@iki.fi>
References: <4FDB3C2E.9060502@iki.fi> <1339767880-8412-7-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Friday 15 June 2012 16:44:40 Sakari Ailus wrote:
> The API reference documents that the KEEP_CONFIG flag tells the
> configuration should not be propatgated by the driver whereas the interface

s/propatgated/propagated/

> documentation (dev-subdev.xml) categorically prohibited any changes to the
> rest of the pipeline. The latter makes no sense, since it would severely
> limit the usefulness of the KEEP_CONFIG flag.
> 
> Correct the documentation in dev-subddev.xml.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  Documentation/DocBook/media/v4l/dev-subdev.xml |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/dev-subdev.xml
> b/Documentation/DocBook/media/v4l/dev-subdev.xml index 8c44b3f..95ebf87
> 100644
> --- a/Documentation/DocBook/media/v4l/dev-subdev.xml
> +++ b/Documentation/DocBook/media/v4l/dev-subdev.xml
> @@ -361,11 +361,11 @@
>        performed by the user: the changes made will be propagated to
>        any subsequent stages. If this behaviour is not desired, the
>        user must set
> -      <constant>V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG</constant> flag. This
> -      flag causes no propagation of the changes are allowed in any
> -      circumstances. This may also cause the accessed rectangle to be
> -      adjusted by the driver, depending on the properties of the
> -      underlying hardware.</para>
> +      <constant>V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG</constant> flag,

This should be V4L2_SEL_FLAG_KEEP_CONFIG.

> +      which tells the driver to make minimum changes to the rest of
> +      the subdev's configuration.

I'm not sure to like this. "minimum changes" is not clearly defined. Isn't the 
point of the KEEP_CONFIG flag is to avoid propagating *any* change down the 
pipeline inside the subdev ?

> This may also cause the accessed
> +      rectangle to be adjusted by the driver, depending on the
> +      properties of the underlying hardware.</para>
> 
>        <para>The coordinates to a step always refer to the actual size
>        of the previous step. The exception to this rule is the source

-- 
Regards,

Laurent Pinchart

