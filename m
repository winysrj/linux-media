Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:34039 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757362AbbKSJ1R (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2015 04:27:17 -0500
Date: Thu, 19 Nov 2015 07:27:12 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Lucas Stach <l.stach@pengutronix.de>
Cc: linux-media@vger.kernel.org, kernel@pengutronix.de,
	patchwork-lst@pengutronix.de, kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 2/9] [media] tvp5150: add userspace subdev API
Message-ID: <20151119072712.02555d88@recife.lan>
In-Reply-To: <1447923555.3144.67.camel@pengutronix.de>
References: <201511190158.nOgnlwG4%fengguang.wu@intel.com>
	<1447923555.3144.67.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 19 Nov 2015 09:59:15 +0100
Lucas Stach <l.stach@pengutronix.de> escreveu:

> Am Donnerstag, den 19.11.2015, 01:06 +0800 schrieb kbuild test robot:
> > Hi Philipp,
> > 
> > [auto build test ERROR on: v4.4-rc1]
> > [also build test ERROR on: next-20151118]
> > [cannot apply to: linuxtv-media/master]
> > 
> > url:    https://github.com/0day-ci/linux/commits/Lucas-Stach/tvp5150-convert-register-access-to-regmap/20151119-005732
> > config: x86_64-randconfig-x018-11181928 (attached as .config)
> > reproduce:
> >         # save the attached .config to linux build tree
> >         make ARCH=x86_64 
> > 
> > All error/warnings (new ones prefixed by >>):
> > 
> >    drivers/media/i2c/tvp5150.c: In function 'tvp5150_get_pad_format':
> > >> drivers/media/i2c/tvp5150.c:1062:10: error: implicit declaration of function 'v4l2_subdev_get_try_format' [-Werror=implicit-function-declaration]
> >       return v4l2_subdev_get_try_format(sd, cfg, pad);
> >              ^
> > >> drivers/media/i2c/tvp5150.c:1062:10: warning: return makes pointer from integer without a cast [-Wint-conversion]
> >    drivers/media/i2c/tvp5150.c: In function 'tvp5150_get_pad_crop':
> > >> drivers/media/i2c/tvp5150.c:1077:10: error: implicit declaration of function 'v4l2_subdev_get_try_crop' [-Werror=implicit-function-declaration]
> >       return v4l2_subdev_get_try_crop(sd, cfg, pad);
> >              ^
> >    drivers/media/i2c/tvp5150.c:1077:10: warning: return makes pointer from integer without a cast [-Wint-conversion]
> >    drivers/media/i2c/tvp5150.c: In function 'tvp5150_open':
> > >> drivers/media/i2c/tvp5150.c:1180:27: warning: passing argument 2 of 'tvp5150_set_default' makes pointer from integer without a cast [-Wint-conversion]
> >      tvp5150_set_default(std, v4l2_subdev_get_try_crop(fh, 0),
> >                               ^
> >    drivers/media/i2c/tvp5150.c:1152:13: note: expected 'struct v4l2_rect *' but argument is of type 'int'
> >     static void tvp5150_set_default(v4l2_std_id std, struct v4l2_rect *crop,
> >                 ^
> >    drivers/media/i2c/tvp5150.c:1181:6: warning: passing argument 3 of 'tvp5150_set_default' makes pointer from integer without a cast [-Wint-conversion]
> >          v4l2_subdev_get_try_format(fh, 0));
> >          ^
> >    drivers/media/i2c/tvp5150.c:1152:13: note: expected 'struct v4l2_mbus_framefmt *' but argument is of type 'int'
> >     static void tvp5150_set_default(v4l2_std_id std, struct v4l2_rect *crop,
> >                 ^
> >    drivers/media/i2c/tvp5150.c: In function 'tvp5150_probe':
> > >> drivers/media/i2c/tvp5150.c:1340:4: error: 'struct v4l2_subdev' has no member named 'entity'
> >      sd->entity.flags |= MEDIA_ENT_T_V4L2_SUBDEV_DECODER;
> >        ^
> >    drivers/media/i2c/tvp5150.c:1342:29: error: 'struct v4l2_subdev' has no member named 'entity'
> >      res = media_entity_init(&sd->entity, 1, &core->pad, 0);
> >                                 ^
> >    cc1: some warnings being treated as errors
> 
> Ok, this is just a missing depends on VIDEO_V4L2_SUBDEV_API. I'll wait
> for other feedback before resending with that fixed.

Lucas,

Please notice that tvp5150 is used by drivers that doesn't need nor
want VIDEO_V4L2_SUBDEV_API. So, you should be sure that the driver
will compile fine without subdev API, and will keep working properly
for those devices, no matter if subdev API was compiled or not.

Regards,
Mauro
