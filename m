Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:35033 "EHLO
        mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751504AbdGRHjc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 03:39:32 -0400
Received: by mail-lf0-f50.google.com with SMTP id w198so6768069lff.2
        for <linux-media@vger.kernel.org>; Tue, 18 Jul 2017 00:39:31 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Tue, 18 Jul 2017 09:39:28 +0200
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>
Subject: Re: [PATCH v4 3/3] v4l: async: add subnotifier to subdevices
Message-ID: <20170718073928.GA28538@bigcity.dyn.berto.se>
References: <20170717165917.24851-1-niklas.soderlund+renesas@ragnatech.se>
 <20170717165917.24851-4-niklas.soderlund+renesas@ragnatech.se>
 <CAMuHMdV6Y5_VNUOHr4E_J6rYMUTbwR6aYwcPuREx59A4fxkS-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdV6Y5_VNUOHr4E_J6rYMUTbwR6aYwcPuREx59A4fxkS-A@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

Thanks for your feedback.

On 2017-07-18 09:11:19 +0200, Geert Uytterhoeven wrote:
> Hi Niklas,
> 
> On Mon, Jul 17, 2017 at 6:59 PM, Niklas Söderlund
> <niklas.soderlund+renesas@ragnatech.se> wrote:
> > Add a subdevice specific notifier which can be used by a subdevice
> > driver to compliment the master device notifier to extend the subdevice
> > discovery.
> >
> > The master device registers the subdevices closest to itself in its
> > notifier while the subdevice(s) register notifiers for their closest
> > neighboring devices. Subdevice drivers configures a notifier at probe
> > time which are registered by the v4l2-async framework once the subdevice
> > itself is register, since it's only at this point the v4l2_dev is
> > available to the subnotifier.
> >
> > Using this incremental approach two problems can be solved:
> >
> > 1. The master device no longer has to care how many devices exist in
> >    the pipeline. It only needs to care about its closest subdevice and
> >    arbitrary long pipelines can be created without having to adapt the
> >    master device for each case.
> >
> > 2. Subdevices which are represented as a single DT node but register
> >    more than one subdevice can use this to improve the pipeline
> >    discovery, since the subdevice driver is the only one who knows which
> >    of its subdevices is linked with which subdevice of a neighboring DT
> >    node.
> >
> > To allow subdevices to provide its own list of subdevices to the
> > v4l2-async framework v4l2_async_subdev_register_notifier() is added.
> > This new function must be called before the subdevice itself is
> > registered with the v4l2-async framework using
> > v4l2_async_register_subdev().
> >
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> 
> Thanks for your patch!
> 
> > --- a/drivers/media/v4l2-core/v4l2-async.c
> > +++ b/drivers/media/v4l2-core/v4l2-async.c
> 
> > @@ -217,6 +293,12 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> >                         "Failed to allocate device cache!\n");
> >         }
> >
> > +       subdev = kvmalloc_array(n_subdev, sizeof(*subdev), GFP_KERNEL);
> > +       if (!dev) {
> 
> if (!subdev) {

Wops, copy-past coding strikes again! Will fix.

> 
> (noticed accidentally[*] :-)
> 
> > +               dev_err(notifier->v4l2_dev->dev,
> > +                       "Failed to allocate subdevice cache!\n");
> > +       }
> > +
> >         mutex_lock(&list_lock);
> >
> >         list_del(&notifier->list);
> > @@ -224,6 +306,8 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
> >         list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
> >                 if (dev)
> >                         dev[count] = get_device(sd->dev);
> > +               if (subdev)
> > +                       subdev[count] = sd;
> 
> I don't like these "memory allocation fails, let's continue but check the
> pointer first"-games.
> Why not abort when the dev/subdev arrays cannot be allocated? It's not
> like the system is in a good state anyway.
> kmalloc() may have printed a big fat warning and invoked the OOM-killer
> already.

I agree, and I also don't like these "games". In my first attempt to 
work with this function I did remove the memory game, but then it hit me 
that if I did I would alter behavior of the function and I did not dare 
to do so.

Hopefully this can be addressed in the future if someone ever gets 
around to reworking the whole mess of re-probing devices which IMOH 
looks a but like a hack :-) I also ofc be happy to just remove the 
memory game from this function and as you suggest simply abort if the 
allocation fails, but I feel I need the blessing from the v4l2 community 
before doing so. Sometimes v4l2 do funny stuff for legacy reasons beyond 
my understanding.

> 
> [*] while checking if you perhaps removed the "dev" games in a later patch.
>      No, you added another one :-(
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds

-- 
Regards,
Niklas Söderlund
