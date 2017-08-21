Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:38853 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753823AbdHUOfE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 10:35:04 -0400
MIME-Version: 1.0
In-Reply-To: <20170821125107.20746-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170821125107.20746-1-niklas.soderlund+renesas@ragnatech.se>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 21 Aug 2017 16:35:03 +0200
Message-ID: <CAMuHMdUpUW2Vyq=8vBWSMz+xF05Wc=rOo9KNZmZjkU0BDVjzJw@mail.gmail.com>
Subject: Re: [PATCH] device property: preserve usecount for node passed to of_fwnode_graph_get_port_parent()
To: =?UTF-8?Q?Niklas_S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Mon, Aug 21, 2017 at 2:51 PM, Niklas S=C3=B6derlund
<niklas.soderlund+renesas@ragnatech.se> wrote:
> Using CONFIG_OF_DYNAMIC=3Dy uncovered an imbalance in the usecount of the
> node being passed to of_fwnode_graph_get_port_parent(). Preserve the
> usecount just like it is done in of_graph_get_port_parent().
>
> Fixes: 3b27d00e7b6d7c88 ("device property: Move fwnode graph ops to firmw=
are specific locations")
> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.=
se>
> ---
>  drivers/of/property.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/of/property.c b/drivers/of/property.c
> index 067f9fab7b77c794..637dcb4833e2af60 100644
> --- a/drivers/of/property.c
> +++ b/drivers/of/property.c
> @@ -922,6 +922,12 @@ of_fwnode_graph_get_port_parent(struct fwnode_handle=
 *fwnode)
>  {
>         struct device_node *np;
>
> +       /*
> +        * Preserve usecount for passed in node as of_get_next_parent()
> +        * will do of_node_put() on it.
> +        */
> +       of_node_get(to_of_node(fwnode));
> +
>         /* Get the parent of the port */
>         np =3D of_get_next_parent(to_of_node(fwnode));
>         if (!np)

FWIW, I'd use "np" to store the intermediate value:

    struct device_node *np =3D to_of_node(fwnode);

     /*
      * Preserve usecount for passed in node as of_get_next_parent()
      * will do of_node_put() on it.
      */
    of_node_get(np);

    /* Get the parent of the port */
    np =3D of_get_next_parent(np);

Alternatively, perhaps to_of_node() should increment the refcount and
call of_node_get()? Oh, there's (static) of_fwnode_get(), too.

Is drivers/iommu/iommu.c:iommu_fwspec_init() really the only place outside
drivers/of/property.c that calls of_node_get() on a node obtained by
to_of_node()?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
