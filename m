Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727803AbeIMDzl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 23:55:41 -0400
MIME-Version: 1.0
References: <20180828154433.5693-1-robh@kernel.org> <20180828154433.5693-7-robh@kernel.org>
 <20180912121705.010a999d@coco.lan> <CAL_JsqK8B46x8bm_aYggJSPAWrMGZ1rZ58uWCmyiSqA2KZpiFg@mail.gmail.com>
 <20180912180734.37dfafb2@coco.lan>
In-Reply-To: <20180912180734.37dfafb2@coco.lan>
From: Rob Herring <robh@kernel.org>
Date: Wed, 12 Sep 2018 17:48:50 -0500
Message-ID: <CAL_JsqJdr6q00w8YhTsFdZM9k2bAJGDh-ViqFo19VCgJ1SXyug@mail.gmail.com>
Subject: Re: [PATCH v2] staging: Convert to using %pOFn instead of device_node.name
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Joe Perches <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Arkver <ian.arkver.dev@gmail.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devel@driverdev.osuosl.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 12, 2018 at 4:07 PM Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
>
> Em Wed, 12 Sep 2018 15:26:48 -0500
> Rob Herring <robh@kernel.org> escreveu:
>
> > +Joe P
> >
> > On Wed, Sep 12, 2018 at 10:17 AM Mauro Carvalho Chehab
> > <mchehab+samsung@kernel.org> wrote:
> > >
> > > Em Tue, 28 Aug 2018 10:44:33 -0500
> > > Rob Herring <robh@kernel.org> escreveu:
> > >
> > > > In preparation to remove the node name pointer from struct device_node,
> > > > convert printf users to use the %pOFn format specifier.
> > > >
> > > > Cc: Steve Longerbeam <slongerbeam@gmail.com>
> > > > Cc: Philipp Zabel <p.zabel@pengutronix.de>
> > > > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> > > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > Cc: linux-media@vger.kernel.org
> > > > Cc: devel@driverdev.osuosl.org
> > > > Signed-off-by: Rob Herring <robh@kernel.org>
> > > > ---
> > > > v2:
> > > > - fix conditional use of node name vs devname for imx
> > > >
> > > >  drivers/staging/media/imx/imx-media-dev.c | 15 ++++++++++-----
> > > >  drivers/staging/media/imx/imx-media-of.c  |  4 ++--
> > > >  drivers/staging/mt7621-eth/mdio.c         |  4 ++--
> > >
> > > It would be better if you had submitted the staging/media stuff
> > > on a separate patch, as they usually go via the media tree.
> >
> > Sorry, I thought Greg took all of staging.
>
> No, I usually take media patches on staging. It seems that at least
> the IIO subsystem does the same:
>
> IIO SUBSYSTEM AND DRIVERS
> M:      Jonathan Cameron <jic23@kernel.org>
> R:      Hartmut Knaack <knaack.h@gmx.de>
> R:      Lars-Peter Clausen <lars@metafoo.de>
> R:      Peter Meerwald-Stadler <pmeerw@pmeerw.net>
> L:      linux-iio@vger.kernel.org
> T:      git git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git
> S:      Maintained
> F:      Documentation/ABI/testing/configfs-iio*
> F:      Documentation/ABI/testing/sysfs-bus-iio*
> F:      Documentation/devicetree/bindings/iio/
> F:      drivers/iio/
> F:      drivers/staging/iio/
> F:      include/linux/iio/
> F:      tools/iio/

Yes, the information is there, but needs human processing.

> Anyway, as I said before, I don't have any issues if Greg takes
> this specific patch.

I know. I'm just thinking about how to improve things. Ideally, what
I'd like is a script that spits out a To list for who applies the
patch and a Cc list of reviewers.

> > A problem with MAINTAINERS is there is no way to tell who applies
> > patches for a given path vs. anyone else listed. This frequently
> > happens when the maintainer organization doesn't match the directory
> > org. If we distinguished this, then it would be quite easy to see when
> > you've created a patch that needs to be split to different maintainers
> > (or an explanation why it isn't). Whatever happened with splitting up
> > MAINTAINERS? If there was a file for each maintainer tree, then it
> > would be easier to extract that information.
>
> Yes, but, on the other hand, get_maintainers.pl would likely
> take more time to process, if a patch touches multiple subsystems.
>
> >
> > Or maybe we just need to be stricter with the 'M' vs. 'R' tag and 'M'
> > means that is the person who applies the patch. I don't think many
> > drivers have their own tree and maintainer except for a few big ones.
>
> Hmm... just getting a random file under staging/media:
>
>         ./scripts/get_maintainer.pl -f drivers/staging/media/imx/imx-ic.h
>         Steve Longerbeam <slongerbeam@gmail.com> (maintainer:MEDIA DRIVERS FOR FREESCALE IMX)
>         Philipp Zabel <p.zabel@pengutronix.de> (maintainer:MEDIA DRIVERS FOR FREESCALE IMX)
>         Mauro Carvalho Chehab <mchehab@kernel.org> (maintainer:MEDIA INPUT INFRASTRUCTURE (V4L/DVB))
>         Greg Kroah-Hartman <gregkh@linuxfoundation.org> (supporter:STAGING SUBSYSTEM)
>         linux-media@vger.kernel.org (open list:MEDIA DRIVERS FOR FREESCALE IMX)
>         devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM)
>         linux-kernel@vger.kernel.org (open list)
>
> It seems that the maintainers are already ordered by the tree
> depth (placing the most relevant results first).

Most relevant in the sense of who reviews and cares about the changes,
but not to answer who applies this patch. I could say I just need to
ignore supporters and look at the last maintainer, but then that
breaks for the case below. I don't think 'maintainer' vs. 'supporter'
is very well maintained either.

$ scripts/get_maintainer.pl -f drivers/staging/olpc_dcon/
Jens Frederich <jfrederich@gmail.com> (maintainer:STAGING - OLPC
SECONDARY DISPLAY CONTROLLER (DCON))
Daniel Drake <dsd@laptop.org> (maintainer:STAGING - OLPC SECONDARY
DISPLAY CONTROLLER (DCON))
Jon Nettleton <jon.nettleton@gmail.com> (maintainer:STAGING - OLPC
SECONDARY DISPLAY CONTROLLER (DCON))
Greg Kroah-Hartman <gregkh@linuxfoundation.org> (supporter:STAGING SUBSYSTEM)
devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM)
linux-kernel@vger.kernel.org (open list)

Maybe Jon has a tree and applies it. Who knows... You either have to
know who are "real" maintainers (the ones applying patches) or go look
at git history to see Greg is the only non-author S-o-B.

> So, both driver maintainers appear first, then me and finally
> Greg (as supporter).
>
> Mailing lists are also ordered by relevance: media ML, then staging
> ML and finally LKML.

Another clue, yes, but something you can script?

Rob
