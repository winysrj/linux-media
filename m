Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:44279 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbbCKWXF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2015 18:23:05 -0400
Received: by labgm9 with SMTP id gm9so11973648lab.11
        for <linux-media@vger.kernel.org>; Wed, 11 Mar 2015 15:23:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1425950282-30548-4-git-send-email-sakari.ailus@iki.fi>
References: <1425950282-30548-1-git-send-email-sakari.ailus@iki.fi> <1425950282-30548-4-git-send-email-sakari.ailus@iki.fi>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Wed, 11 Mar 2015 22:22:33 +0000
Message-ID: <CA+V-a8u3o7fouVF5=cD=jsVdg0HGzP-ibU34mDW=q81ERknAaQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] v4l: of: Add link-frequencies array to struct v4l2_of_endpoint
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>,
	laurent pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Tue, Mar 10, 2015 at 1:18 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Parse and read the link-frequencies property in v4l2_of_parse_endpoint().
> The property is an u64 array of undefined length, thus the memory allocation
> may fail, leading
>
> - v4l2_of_parse_endpoint() to return an error in such a case (as well as
>   when failing to parse the property) and
> - to requiring releasing the memory reserved for the array
>   (v4l2_of_release_endpoint()).
>
> If a driver does not need to access properties that require memory
> allocation (such as link-frequencies), it may choose to call
> v4l2_of_release_endpoint() right after calling v4l2_of_parse_endpoint().
>
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/media/i2c/adv7604.c                    |    1 +
>  drivers/media/i2c/s5c73m3/s5c73m3-core.c       |    1 +
>  drivers/media/i2c/s5k5baf.c                    |    1 +
>  drivers/media/i2c/smiapp/smiapp-core.c         |   32 ++++++++--------
>  drivers/media/i2c/tvp514x.c                    |    1 +
>  drivers/media/i2c/tvp7002.c                    |    1 +
>  drivers/media/platform/am437x/am437x-vpfe.c    |    1 +
>  drivers/media/platform/exynos4-is/media-dev.c  |    1 +
>  drivers/media/platform/exynos4-is/mipi-csis.c  |    1 +
>  drivers/media/platform/soc_camera/atmel-isi.c  |    1 +
>  drivers/media/platform/soc_camera/pxa_camera.c |    1 +
>  drivers/media/platform/soc_camera/rcar_vin.c   |    1 +
>  drivers/media/v4l2-core/v4l2-of.c              |   47 +++++++++++++++++++++++-
>  include/media/v4l2-of.h                        |    9 +++++
>  14 files changed, 81 insertions(+), 18 deletions(-)
>
[snip]
> diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
> index b4ed9a9..e24610c 100644
> --- a/drivers/media/v4l2-core/v4l2-of.c
> +++ b/drivers/media/v4l2-core/v4l2-of.c
> @@ -14,6 +14,7 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
> +#include <linux/slab.h>
>  #include <linux/string.h>
>  #include <linux/types.h>
>
> @@ -109,6 +110,26 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
>  }
>
>  /**
> + * v4l2_of_release_endpoint() - release resources acquired by
> + * v4l2_of_parse_endpoint()
> + * @endpoint - the endpoint the resources of which are to be released
> + *
> + * It is safe to call this function on an endpoint which is not parsed or
> + * and endpoint the parsing of which failed. However in the former case the
> + * argument must point to a struct the memory of which has been set to zero.
> + *
> + * Values in the struct v4l2_of_endpoint that are not connected to resources
> + * acquired by v4l2_of_parse_endpoint() are guaranteed to remain untouched.
> + */
> +void v4l2_of_release_endpoint(struct v4l2_of_endpoint *endpoint)
> +{
> +       kfree(endpoint->link_frequencies);
> +       endpoint->link_frequencies = NULL;
> +       endpoint->nr_of_link_frequencies = 0;
> +}
> +EXPORT_SYMBOL(v4l2_of_parse_endpoint);
> +
> +/**
>   * v4l2_of_parse_endpoint() - parse all endpoint node properties
>   * @node: pointer to endpoint device_node
>   * @endpoint: pointer to the V4L2 OF endpoint data structure
> @@ -122,15 +143,39 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
>   * V4L2_MBUS_CSI2_CONTINUOUS_CLOCK flag.
>   * The caller should hold a reference to @node.
>   *
> + * An endpoint parsed using v4l2_of_parse_endpoint() must be released using
> + * v4l2_of_release_endpoint().
> + *
>   * Return: 0.
>   */
>  int v4l2_of_parse_endpoint(const struct device_node *node,
>                            struct v4l2_of_endpoint *endpoint)
>  {
> +       int len;
> +
>         of_graph_parse_endpoint(node, &endpoint->base);
>         endpoint->bus_type = 0;
>         memset(&endpoint->bus, 0, sizeof(endpoint->bus));
>
endpoint->link_frequencies = NULL; required here.

Apart from that patch looks good.

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Tested-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad

> +       if (of_get_property(node, "link-frequencies", &len)) {
> +               int rval;
> +
> +               endpoint->link_frequencies = kmalloc(len, GFP_KERNEL);
> +               if (!endpoint->link_frequencies)
> +                       return -ENOMEM;
> +
> +               endpoint->nr_of_link_frequencies =
> +                       len / sizeof(*endpoint->link_frequencies);
> +
> +               rval = of_property_read_u64_array(
> +                       node, "link-frequencies", endpoint->link_frequencies,
> +                       endpoint->nr_of_link_frequencies);
> +               if (rval < 0) {
> +                       v4l2_of_release_endpoint(endpoint);
> +                       return rval;
> +               }
> +       }
> +
>         v4l2_of_parse_csi_bus(node, endpoint);
>         /*
>          * Parse the parallel video bus properties only if none
> @@ -141,4 +186,4 @@ int v4l2_of_parse_endpoint(const struct device_node *node,
>
>         return 0;
>  }
> -EXPORT_SYMBOL(v4l2_of_parse_endpoint);
> +EXPORT_SYMBOL(v4l2_of_release_endpoint);
> diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
> index 70fa7b7..8c123ff 100644
> --- a/include/media/v4l2-of.h
> +++ b/include/media/v4l2-of.h
> @@ -54,6 +54,8 @@ struct v4l2_of_bus_parallel {
>   * @base: struct of_endpoint containing port, id, and local of_node
>   * @bus_type: bus type
>   * @bus: bus configuration data structure
> + * @link_frequencies: array of supported link frequencies
> + * @nr_of_link_frequencies: number of elements in link_frequenccies array
>   * @head: list head for this structure
>   */
>  struct v4l2_of_endpoint {
> @@ -63,12 +65,15 @@ struct v4l2_of_endpoint {
>                 struct v4l2_of_bus_parallel parallel;
>                 struct v4l2_of_bus_mipi_csi2 mipi_csi2;
>         } bus;
> +       u64 *link_frequencies;
> +       unsigned int nr_of_link_frequencies;
>         struct list_head head;
>  };
>
>  #ifdef CONFIG_OF
>  int v4l2_of_parse_endpoint(const struct device_node *node,
>                            struct v4l2_of_endpoint *endpoint);
> +void v4l2_of_release_endpoint(struct v4l2_of_endpoint *endpoint);
>  #else /* CONFIG_OF */
>
>  static inline int v4l2_of_parse_endpoint(const struct device_node *node,
> @@ -77,6 +82,10 @@ static inline int v4l2_of_parse_endpoint(const struct device_node *node,
>         return -ENOSYS;
>  }
>
> +static void v4l2_of_release_endpoint(struct v4l2_of_endpoint *endpoint)
> +{
> +}
> +
>  #endif /* CONFIG_OF */
>
>  #endif /* _V4L2_OF_H */
> --
> 1.7.10.4
>
