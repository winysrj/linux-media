Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:33398 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbbDJWQo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2015 18:16:44 -0400
Received: by lbbzk7 with SMTP id zk7so23422601lbb.0
        for <linux-media@vger.kernel.org>; Fri, 10 Apr 2015 15:16:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1428614706-8367-3-git-send-email-sakari.ailus@iki.fi>
References: <1428614706-8367-1-git-send-email-sakari.ailus@iki.fi> <1428614706-8367-3-git-send-email-sakari.ailus@iki.fi>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Fri, 10 Apr 2015 23:16:12 +0100
Message-ID: <CA+V-a8u_0+7U4_=adUx=k7Lcp7QHH8=j-mdS4A7PkE_pSaTKyw@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] v4l: of: Instead of zeroing bus_type and bus field
 separately, unify this
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	laurent pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Thu, Apr 9, 2015 at 10:25 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Zero the entire struct starting from bus_type. As more fields are added, no
> changes will be needed in the function to reset their value explicitly.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad

> ---
>  drivers/media/v4l2-core/v4l2-of.c |    5 +++--
>  include/media/v4l2-of.h           |    1 +
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
> index 83143d3..3ac6348 100644
> --- a/drivers/media/v4l2-core/v4l2-of.c
> +++ b/drivers/media/v4l2-core/v4l2-of.c
> @@ -149,8 +149,9 @@ int v4l2_of_parse_endpoint(const struct device_node *node,
>         int rval;
>
>         of_graph_parse_endpoint(node, &endpoint->base);
> -       endpoint->bus_type = 0;
> -       memset(&endpoint->bus, 0, sizeof(endpoint->bus));
> +       /* Zero fields from bus_type to until the end */
> +       memset(&endpoint->bus_type, 0, sizeof(*endpoint) -
> +              offsetof(typeof(*endpoint), bus_type));
>
>         rval = v4l2_of_parse_csi_bus(node, endpoint);
>         if (rval)
> diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
> index f66b92c..6c85c07 100644
> --- a/include/media/v4l2-of.h
> +++ b/include/media/v4l2-of.h
> @@ -60,6 +60,7 @@ struct v4l2_of_bus_parallel {
>   */
>  struct v4l2_of_endpoint {
>         struct of_endpoint base;
> +       /* Fields below this line will be zeroed by v4l2_of_parse_endpoint() */
>         enum v4l2_mbus_type bus_type;
>         union {
>                 struct v4l2_of_bus_parallel parallel;
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
