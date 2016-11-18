Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:52786 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751989AbcKRTgv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 14:36:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>,
        Simon Horman <horms+renesas@verge.net.au>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] [media] v4l: rcar_fdp1: add FCP dependency
Date: Fri, 18 Nov 2016 20:36:26 +0100
Message-ID: <3658477.0zLolAi2Y1@wuerfel>
In-Reply-To: <CAMuHMdWj9_X-kgbJ4FHXMR2hnUzwKCkjXbOfu0kY6bk5rcVzfQ@mail.gmail.com>
References: <20161118161621.798004-1-arnd@arndb.de> <20161118161621.798004-2-arnd@arndb.de> <CAMuHMdWj9_X-kgbJ4FHXMR2hnUzwKCkjXbOfu0kY6bk5rcVzfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, November 18, 2016 6:08:01 PM CET Geert Uytterhoeven wrote:
> > diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> > index 3c5a0b6b23a9..cd0cab6e0e31 100644
> > --- a/drivers/media/platform/Kconfig
> > +++ b/drivers/media/platform/Kconfig
> > @@ -311,6 +311,7 @@ config VIDEO_RENESAS_FDP1
> >         tristate "Renesas Fine Display Processor"
> >         depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
> >         depends on ARCH_SHMOBILE || COMPILE_TEST
> > +       depends on (!ARCH_RENESAS && !VIDEO_RENESAS_FCP) || VIDEO_RENESAS_FCP
> 
> Which tree and config is this? I don't have fdp1_pm_runtime_resume in my
> renesas-drivers tree.
> 
> Why are the dummies for !CONFIG_VIDEO_RENESAS_FCP in include/media/rcar-fcp.h
> not working?

Oops, I forgot to write a proper changelog.

Commit 4710b752e029 ("[media] v4l: Add Renesas R-Car FDP1 Driver") in the
v4l-dvb tree adds CONFIG_VIDEO_RENESAS_FDP1.

It calls into the FCP driver, but when there is no dependency, FCP might
be a module while FDP1 is built-in.

We have the same logic in VIDEO_RENESAS_VSP1, which also depends on
FCP not being a module when it is built-in itself.

	Arnd
