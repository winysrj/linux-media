Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:34278 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751203AbdGRHLV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 03:11:21 -0400
MIME-Version: 1.0
In-Reply-To: <20170717165917.24851-4-niklas.soderlund+renesas@ragnatech.se>
References: <20170717165917.24851-1-niklas.soderlund+renesas@ragnatech.se> <20170717165917.24851-4-niklas.soderlund+renesas@ragnatech.se>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 18 Jul 2017 09:11:19 +0200
Message-ID: <CAMuHMdV6Y5_VNUOHr4E_J6rYMUTbwR6aYwcPuREx59A4fxkS-A@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] v4l: async: add subnotifier to subdevices
To: =?UTF-8?Q?Niklas_S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Mon, Jul 17, 2017 at 6:59 PM, Niklas S=C3=B6derlund
<niklas.soderlund+renesas@ragnatech.se> wrote:
> Add a subdevice specific notifier which can be used by a subdevice
> driver to compliment the master device notifier to extend the subdevice
> discovery.
>
> The master device registers the subdevices closest to itself in its
> notifier while the subdevice(s) register notifiers for their closest
> neighboring devices. Subdevice drivers configures a notifier at probe
> time which are registered by the v4l2-async framework once the subdevice
> itself is register, since it's only at this point the v4l2_dev is
> available to the subnotifier.
>
> Using this incremental approach two problems can be solved:
>
> 1. The master device no longer has to care how many devices exist in
>    the pipeline. It only needs to care about its closest subdevice and
>    arbitrary long pipelines can be created without having to adapt the
>    master device for each case.
>
> 2. Subdevices which are represented as a single DT node but register
>    more than one subdevice can use this to improve the pipeline
>    discovery, since the subdevice driver is the only one who knows which
>    of its subdevices is linked with which subdevice of a neighboring DT
>    node.
>
> To allow subdevices to provide its own list of subdevices to the
> v4l2-async framework v4l2_async_subdev_register_notifier() is added.
> This new function must be called before the subdevice itself is
> registered with the v4l2-async framework using
> v4l2_async_register_subdev().
>
> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.=
se>

Thanks for your patch!

> --- a/drivers/media/v4l2-core/v4l2-async.c
> +++ b/drivers/media/v4l2-core/v4l2-async.c

> @@ -217,6 +293,12 @@ void v4l2_async_notifier_unregister(struct v4l2_asyn=
c_notifier *notifier)
>                         "Failed to allocate device cache!\n");
>         }
>
> +       subdev =3D kvmalloc_array(n_subdev, sizeof(*subdev), GFP_KERNEL);
> +       if (!dev) {

if (!subdev) {

(noticed accidentally[*] :-)

> +               dev_err(notifier->v4l2_dev->dev,
> +                       "Failed to allocate subdevice cache!\n");
> +       }
> +
>         mutex_lock(&list_lock);
>
>         list_del(&notifier->list);
> @@ -224,6 +306,8 @@ void v4l2_async_notifier_unregister(struct v4l2_async=
_notifier *notifier)
>         list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
>                 if (dev)
>                         dev[count] =3D get_device(sd->dev);
> +               if (subdev)
> +                       subdev[count] =3D sd;

I don't like these "memory allocation fails, let's continue but check the
pointer first"-games.
Why not abort when the dev/subdev arrays cannot be allocated? It's not
like the system is in a good state anyway.
kmalloc() may have printed a big fat warning and invoked the OOM-killer
already.

[*] while checking if you perhaps removed the "dev" games in a later patch.
     No, you added another one :-(

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
