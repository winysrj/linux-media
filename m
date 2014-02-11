Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f53.google.com ([209.85.212.53]:50484 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaBKN4e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Feb 2014 08:56:34 -0500
MIME-Version: 1.0
In-Reply-To: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de>
References: <1392119105-25298-1-git-send-email-p.zabel@pengutronix.de>
Date: Tue, 11 Feb 2014 07:56:33 -0600
Message-ID: <CAL_Jsq+U9zU1i+STLHMBjY5BeEP6djYnJVE5X1ix-D2q_zWztQ@mail.gmail.com>
Subject: Re: [RFC PATCH] [media]: of: move graph helpers from
 drivers/media/v4l2-core to drivers/of
From: Rob Herring <robherring2@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <robh+dt@kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Philipp Zabel <philipp.zabel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 11, 2014 at 5:45 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> From: Philipp Zabel <philipp.zabel@gmail.com>
>
> This patch moves the parsing helpers used to parse connected graphs
> in the device tree, like the video interface bindings documented in
> Documentation/devicetree/bindings/media/video-interfaces.txt, from
> drivers/media/v4l2-core to drivers/of.

This is the opposite direction things have been moving...

> This allows to reuse the same parser code from outside the V4L2 framework,
> most importantly from display drivers. There have been patches that duplicate
> the code (and I am going to send one of my own), such as
> http://lists.freedesktop.org/archives/dri-devel/2013-August/043308.html
> and others that parse the same binding in a different way:
> https://www.mail-archive.com/linux-omap@vger.kernel.org/msg100761.html
>
> I think that all common video interface parsing helpers should be moved to a
> single place, outside of the specific subsystems, so that it can be reused
> by all drivers.

Perhaps that should be done rather than moving to drivers/of now and
then again to somewhere else.

> I moved v4l2_of_get_next_endpoint, v4l2_of_get_remote_port,
> and v4l2_of_get_remote_port_parent. They are renamed to
> of_graph_get_next_endpoint, of_graph_get_remote_port, and
> of_graph_get_remote_port_parent, respectively.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/Kconfig             |   1 +
>  drivers/media/v4l2-core/v4l2-of.c | 117 ---------------------------------
>  drivers/of/Kconfig                |   3 +
>  drivers/of/Makefile               |   1 +
>  drivers/of/of_graph.c             | 133 ++++++++++++++++++++++++++++++++++++++
>  include/linux/of_graph.h          |  23 +++++++
>  include/media/v4l2-of.h           |  16 ++---
>  7 files changed, 167 insertions(+), 127 deletions(-)
>  create mode 100644 drivers/of/of_graph.c
>  create mode 100644 include/linux/of_graph.h

[snip]

> diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
> index 541cea4..404a493 100644
> --- a/include/media/v4l2-of.h
> +++ b/include/media/v4l2-of.h
> @@ -17,6 +17,7 @@
>  #include <linux/list.h>
>  #include <linux/types.h>
>  #include <linux/errno.h>
> +#include <linux/of_graph.h>
>
>  #include <media/v4l2-mediabus.h>
>
> @@ -72,11 +73,6 @@ struct v4l2_of_endpoint {
>  #ifdef CONFIG_OF
>  int v4l2_of_parse_endpoint(const struct device_node *node,
>                            struct v4l2_of_endpoint *endpoint);
> -struct device_node *v4l2_of_get_next_endpoint(const struct device_node *parent,
> -                                       struct device_node *previous);
> -struct device_node *v4l2_of_get_remote_port_parent(
> -                                       const struct device_node *node);
> -struct device_node *v4l2_of_get_remote_port(const struct device_node *node);
>  #else /* CONFIG_OF */
>
>  static inline int v4l2_of_parse_endpoint(const struct device_node *node,
> @@ -85,25 +81,25 @@ static inline int v4l2_of_parse_endpoint(const struct device_node *node,
>         return -ENOSYS;
>  }
>
> +#endif /* CONFIG_OF */
> +
>  static inline struct device_node *v4l2_of_get_next_endpoint(
>                                         const struct device_node *parent,
>                                         struct device_node *previous)
>  {
> -       return NULL;
> +       return of_graph_get_next_endpoint(parent, previous);

Won't this break for !OF?

Rob
