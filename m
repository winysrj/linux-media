Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:33526 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751963AbcJWNoS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Oct 2016 09:44:18 -0400
Received: by mail-it0-f68.google.com with SMTP id k64so6809501itb.0
        for <linux-media@vger.kernel.org>; Sun, 23 Oct 2016 06:44:18 -0700 (PDT)
MIME-Version: 1.0
Reply-To: henrik.ingo@avoinelama.fi
In-Reply-To: <1475227433-27813-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1475227433-27813-1-git-send-email-laurent.pinchart@ideasonboard.com>
From: Henrik Ingo <henrik.ingo@avoinelama.fi>
Date: Sun, 23 Oct 2016 16:44:17 +0300
Message-ID: <CAKHykevvMVnmOdfrxbCa3Y1P3UugYYPgv7fLtQLWVkfP5PzkbA@mail.gmail.com>
Subject: Re: [PATCH] uvcvideo: uvc_scan_fallback() for webcams with broken chain
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linux-media. I'm the patch author.

I wanted to share a link to the Ubuntu bug tracking the issue that
this patch is fixing:
https://bugs.launchpad.net/hwe-next/+bug/1433906?comments=all

Canonical employees have made available a 4.4.0 test kernel with this
patch included, and several users have successfully tested it
(including myself, of course).

Both users and Canonical are also wondering if there's any reasonable
guess for ETA of this patch landing in upstream Linux?

henrik

On Fri, Sep 30, 2016 at 12:23 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> From: Henrik Ingo <henrik.ingo@avoinelama.fi>
>
> Some devices have invalid baSourceID references, causing uvc_scan_chain()
> to fail, but if we just take the entities we can find and put them
> together in the most sensible chain we can think of, turns out they do
> work anyway. Note: This heuristic assumes there is a single chain.
>
> At the time of writing, devices known to have such a broken chain are
>   - Acer Integrated Camera (5986:055a)
>   - Realtek rtl157a7 (0bda:57a7)
>
> Signed-off-by: Henrik Ingo <henrik.ingo@avoinelama.fi>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/usb/uvc/uvc_driver.c | 118 +++++++++++++++++++++++++++++++++++--
>  1 file changed, 112 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
> index 302e284a95eb..cde43b63c3da 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -1595,6 +1595,114 @@ static const char *uvc_print_chain(struct uvc_video_chain *chain)
>         return buffer;
>  }
>
> +static struct uvc_video_chain *uvc_alloc_chain(struct uvc_device *dev)
> +{
> +       struct uvc_video_chain *chain;
> +
> +       chain = kzalloc(sizeof(*chain), GFP_KERNEL);
> +       if (chain == NULL)
> +               return NULL;
> +
> +       INIT_LIST_HEAD(&chain->entities);
> +       mutex_init(&chain->ctrl_mutex);
> +       chain->dev = dev;
> +       v4l2_prio_init(&chain->prio);
> +
> +       return chain;
> +}
> +
> +/*
> + * Fallback heuristic for devices that don't connect units and terminals in a
> + * valid chain.
> + *
> + * Some devices have invalid baSourceID references, causing uvc_scan_chain()
> + * to fail, but if we just take the entities we can find and put them together
> + * in the most sensible chain we can think of, turns out they do work anyway.
> + * Note: This heuristic assumes there is a single chain.
> + *
> + * At the time of writing, devices known to have such a broken chain are
> + *  - Acer Integrated Camera (5986:055a)
> + *  - Realtek rtl157a7 (0bda:57a7)
> + */
> +static int uvc_scan_fallback(struct uvc_device *dev)
> +{
> +       struct uvc_video_chain *chain;
> +       struct uvc_entity *iterm = NULL;
> +       struct uvc_entity *oterm = NULL;
> +       struct uvc_entity *entity;
> +       struct uvc_entity *prev;
> +
> +       /*
> +        * Start by locating the input and output terminals. We only support
> +        * devices with exactly one of each for now.
> +        */
> +       list_for_each_entry(entity, &dev->entities, list) {
> +               if (UVC_ENTITY_IS_ITERM(entity)) {
> +                       if (iterm)
> +                               return -EINVAL;
> +                       iterm = entity;
> +               }
> +
> +               if (UVC_ENTITY_IS_OTERM(entity)) {
> +                       if (oterm)
> +                               return -EINVAL;
> +                       oterm = entity;
> +               }
> +       }
> +
> +       if (iterm == NULL || oterm == NULL)
> +               return -EINVAL;
> +
> +       /* Allocate the chain and fill it. */
> +       chain = uvc_alloc_chain(dev);
> +       if (chain == NULL)
> +               return -ENOMEM;
> +
> +       if (uvc_scan_chain_entity(chain, oterm) < 0)
> +               goto error;
> +
> +       prev = oterm;
> +
> +       /*
> +        * Add all Processing and Extension Units with two pads. The order
> +        * doesn't matter much, use reverse list traversal to connect units in
> +        * UVC descriptor order as we build the chain from output to input. This
> +        * leads to units appearing in the order meant by the manufacturer for
> +        * the cameras known to require this heuristic.
> +        */
> +       list_for_each_entry_reverse(entity, &dev->entities, list) {
> +               if (entity->type != UVC_VC_PROCESSING_UNIT &&
> +                   entity->type != UVC_VC_EXTENSION_UNIT)
> +                       continue;
> +
> +               if (entity->num_pads != 2)
> +                       continue;
> +
> +               if (uvc_scan_chain_entity(chain, entity) < 0)
> +                       goto error;
> +
> +               prev->baSourceID[0] = entity->id;
> +               prev = entity;
> +       }
> +
> +       if (uvc_scan_chain_entity(chain, iterm) < 0)
> +               goto error;
> +
> +       prev->baSourceID[0] = iterm->id;
> +
> +       list_add_tail(&chain->list, &dev->chains);
> +
> +       uvc_trace(UVC_TRACE_PROBE,
> +                 "Found a video chain by fallback heuristic (%s).\n",
> +                 uvc_print_chain(chain));
> +
> +       return 0;
> +
> +error:
> +       kfree(chain);
> +       return -EINVAL;
> +}
> +
>  /*
>   * Scan the device for video chains and register video devices.
>   *
> @@ -1617,15 +1725,10 @@ static int uvc_scan_device(struct uvc_device *dev)
>                 if (term->chain.next || term->chain.prev)
>                         continue;
>
> -               chain = kzalloc(sizeof(*chain), GFP_KERNEL);
> +               chain = uvc_alloc_chain(dev);
>                 if (chain == NULL)
>                         return -ENOMEM;
>
> -               INIT_LIST_HEAD(&chain->entities);
> -               mutex_init(&chain->ctrl_mutex);
> -               chain->dev = dev;
> -               v4l2_prio_init(&chain->prio);
> -
>                 term->flags |= UVC_ENTITY_FLAG_DEFAULT;
>
>                 if (uvc_scan_chain(chain, term) < 0) {
> @@ -1639,6 +1742,9 @@ static int uvc_scan_device(struct uvc_device *dev)
>                 list_add_tail(&chain->list, &dev->chains);
>         }
>
> +       if (list_empty(&dev->chains))
> +               uvc_scan_fallback(dev);
> +
>         if (list_empty(&dev->chains)) {
>                 uvc_printk(KERN_INFO, "No valid video chain found.\n");
>                 return -1;
> --
> Regards,
>
> Laurent Pinchart
>



-- 
henrik.ingo@avoinelama.fi
+358-40-5697354        skype: henrik.ingo            irc: hingo
www.openlife.cc

My LinkedIn profile: http://fi.linkedin.com/pub/henrik-ingo/3/232/8a7
