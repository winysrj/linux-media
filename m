Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4790 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab3FXIzw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jun 2013 04:55:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH] media: i2c: tvp514x: add support for asynchronous probing
Date: Mon, 24 Jun 2013 10:55:38 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>
References: <1371896189-5475-1-git-send-email-prabhakar.csengg@gmail.com> <201306241039.17147.hverkuil@xs4all.nl> <CA+V-a8vaOPcxxEqoXtia1O=bCpyWAWOrc_xj80O+LmmeLXigEw@mail.gmail.com>
In-Reply-To: <CA+V-a8vaOPcxxEqoXtia1O=bCpyWAWOrc_xj80O+LmmeLXigEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306241055.38698.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon June 24 2013 10:53:37 Prabhakar Lad wrote:
> Hi Hans,
> 
> On Mon, Jun 24, 2013 at 2:09 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On Mon June 24 2013 10:24:02 Prabhakar Lad wrote:
> >> Hi Hans,
> >>
> >> On Mon, Jun 24, 2013 at 12:41 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >> > On Sun June 23 2013 17:48:20 Prabhakar Lad wrote:
> >> >> Hi Guennadi,
> >> >>
> >> >> Thanks for the review.
> >> >>
> >> >> On Sun, Jun 23, 2013 at 8:49 PM, Guennadi Liakhovetski
> >> >> <g.liakhovetski@gmx.de> wrote:
> >> >> > On Sat, 22 Jun 2013, Prabhakar Lad wrote:
> >> >> >
> >> >> >> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> >> >> >>
> >> >> >> Both synchronous and asynchronous tvp514x subdevice probing is supported by
> >> >> >> this patch.
> >> >> >>
> >> >> >> Signed-off-by: Prabhakar Lad <prabhakar.csengg@gmail.com>
> >> >> >> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> >> >> >> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >> >> >> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> >> >> >> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> >> >> >> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> >> >> >> ---
> >> >> >>  drivers/media/i2c/tvp514x.c |   22 +++++++++++++++-------
> >> >> >>  1 file changed, 15 insertions(+), 7 deletions(-)
> >> >> >>
> >> >> >> diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
> >> >> >> index 864eb14..d090caf 100644
> >> >> >> --- a/drivers/media/i2c/tvp514x.c
> >> >> >> +++ b/drivers/media/i2c/tvp514x.c
> >> >> >> @@ -36,6 +36,7 @@
> >> >> >>  #include <linux/module.h>
> >> >> >>  #include <linux/v4l2-mediabus.h>
> >> >> >>
> >> >> >> +#include <media/v4l2-async.h>
> >> >> >>  #include <media/v4l2-device.h>
> >> >> >>  #include <media/v4l2-common.h>
> >> >> >>  #include <media/v4l2-mediabus.h>
> >> >> >
> >> >> > Ok, but this one really does too many things in one patch:
> >> >> >
> >> >> >> @@ -1148,9 +1149,9 @@ tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
> >> >> >>       /* Register with V4L2 layer as slave device */
> >> >> >>       sd = &decoder->sd;
> >> >> >>       v4l2_i2c_subdev_init(sd, client, &tvp514x_ops);
> >> >> >> -     strlcpy(sd->name, TVP514X_MODULE_NAME, sizeof(sd->name));
> >> >> >>
> >> >> >>  #if defined(CONFIG_MEDIA_CONTROLLER)
> >> >> >> +     strlcpy(sd->name, TVP514X_MODULE_NAME, sizeof(sd->name));
> >> >> >
> >> >> > This is unrelated
> >> >> >
> >> >> OK I'll split the patch or may be a line in a commit message can do ?
> >> >
> >> > Please split it up in two patches.
> >> >
> >> > Why is sd->name set anyway? And why is it moved under CONFIG_MEDIA_CONTROLLER?
> >> > It's not obvious to me.
> >> >
> >> while using tvp514x subdev with media controller based drivers, when we
> >> enumerate entities (MEDIA_IOC_ENUM_ENTITIES) to get the index id
> >> of the entity we compare the entity name with "tvp514x", So I moved it
> >> under CONFIG_MEDIA_CONTROLLER config. I hope you are OK with
> >> moving this in a separate patch.
> >
> > Sorry, but this approach is wrong. sd->name must be a unique name, so manually
> > setting sd->name will fail if you have two tvp514x devices.
> >
> > There is no reason to override sd->name here, and it is actually a bug. I see
> > that tvp7002 has the same problem (and a bunch of others as well).
> >
> > When trying to find a tvp514x you can just use strstr() in your application.
> > That will work all the time as long as there is only one tvp514x.
> 
> OK, then I will send out a cleanup patch removing sd->name from this driver
> and others too.

Thanks. I see that it is in tvp7002 as well. Also ov9650 and some Samsung devices,
but I will deal with those.

	Hans
