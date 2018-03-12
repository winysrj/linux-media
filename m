Return-path: <linux-media-owner@vger.kernel.org>
Received: from mslow1.mail.gandi.net ([217.70.178.240]:43556 "EHLO
        mslow1.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751248AbeCLQJv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Mar 2018 12:09:51 -0400
Date: Mon, 12 Mar 2018 13:02:35 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] media: MAINTAINERS: Add entry for Aptina MT9T112
Message-ID: <20180312120235.GD10752@w540>
References: <1520008541-3961-1-git-send-email-jacopo+renesas@jmondi.org>
 <1520008541-3961-6-git-send-email-jacopo+renesas@jmondi.org>
 <20180311201514.7ljwikv4twj6hxpk@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20180311201514.7ljwikv4twj6hxpk@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Sun, Mar 11, 2018 at 10:15:14PM +0200, Sakari Ailus wrote:
> Hi Jacopo,
>
> On Fri, Mar 02, 2018 at 05:35:41PM +0100, Jacopo Mondi wrote:
> > Add entry for Aptina/Micron MT9T112 camera sensor. The driver is
> > currently orphaned.
> >
> > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> > ---
> >  MAINTAINERS | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 91ed6ad..1d8be25 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -9385,6 +9385,13 @@ S:	Maintained
> >  F:	drivers/media/i2c/mt9t001.c
> >  F:	include/media/i2c/mt9t001.h
> >
> > +MT9T112 APTINA CAMERA SENSOR
> > +L:	linux-media@vger.kernel.org
> > +T:	git git://linuxtv.org/media_tree.git
> > +S:	Orphan
>
> I don't like adding a driver which is in orphaned state to begin with.

I don't as well :)

>
> Would you like to maintain it? :-)

I would, but I currently have no camera module to test with... Maybe
just for "Odd Fixes"?

>
> > +F:	drivers/media/i2c/mt9t112.c
> > +F:	include/media/i2c/mt9t112.h
> > +
> >  MT9V032 APTINA CAMERA SENSOR
> >  M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >  L:	linux-media@vger.kernel.org
>
> --
> Regards,
>
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi
