Return-Path: <ricardo.ribalda@gmail.com>
MIME-version: 1.0
In-reply-to: <557AE172.7070408@xs4all.nl>
References: <1434114742-7420-1-git-send-email-ricardo.ribalda@gmail.com>
 <557AE172.7070408@xs4all.nl>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Fri, 12 Jun 2015 15:55:17 +0200
Message-id: <CAPybu_2HzHxCK1z9--v7c8MMJ_S1K2Gvr5WLoZye3Gikf0atTA@mail.gmail.com>
Subject: Re: [RFC v2 00/27] New ioct VIDIOC_G_DEF_EXT_CTRLS
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
 Sakari Ailus <sakari.ailus@linux.intel.com>,
 Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
 Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
 Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
 linux-media <linux-media@vger.kernel.org>
Content-type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>

Hello Hans

On Fri, Jun 12, 2015 at 3:41 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:

>
> I did a quick analysis and for the following i2c modules you can just remove the
> compat control ops altogether since they are no longer used in old non-control-framework
> bridge drivers:
>
> saa7706
> ivtv-gpio
> wm8739
> tvp7002
> tvp514x
> tvl320aic23b
> tda7432
> sr030pc30
> saa717x
> cs5345
> adv7393
> adv7343
>
> Also note that the uvc driver needs to be adapted manually since it can't use
> the control framework. The ioctls are implemented in the driver itself.

Would it make sense to split this patchset in two?

1) This patchset - all i2c modules that dont need compat control ops +
uvc driver
2) A new patchset removing compat control ops on the list that you provided

Thanks
