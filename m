Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38529 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbeJCOFW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2018 10:05:22 -0400
MIME-Version: 1.0
References: <20181002133058.12942-1-ricardo.ribalda@gmail.com>
 <20181002133058.12942-2-ricardo.ribalda@gmail.com> <20181002162438.zia2pwztd6vuqme2@paasikivi.fi.intel.com>
In-Reply-To: <20181002162438.zia2pwztd6vuqme2@paasikivi.fi.intel.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 3 Oct 2018 09:17:56 +0200
Message-ID: <CAPybu_1B+zAasFuiRrhByXaVGz6KfuBxXJYWRwBM-CL8Bh6C=g@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] [media] imx214: Add imx214 camera sensor driver
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>, jacopo@jmondi.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HI Sakari

Thanks a lot for your review!

On Tue, Oct 2, 2018 at 6:27 PM Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
> > +static int imx214_s_power(struct v4l2_subdev *sd, int on)
> > +{
> > +     struct imx214 *imx214 = to_imx214(sd);
> > +     int ret = 0;
> > +
> > +     on = !!on;
> > +
> > +     if (imx214->power_on == on)
> > +             return 0;
> > +
> > +     if (on)
> > +             ret = imx214_set_power_on(imx214);
> > +     else
> > +             imx214_set_power_off(imx214);
> > +
> > +     imx214->power_on = on;
> > +
> > +     return 0;
>
> Using runtime PM would relieve you of this function.

Tried using runtime PM, but did not manage to get it working with the
qcom i2c driver. Will try again when this is merged on a separated
patch.
>
> > +static int imx214_find_mode(u32 height)
> > +{
> > +     int i;
>
> Unsigned int.
>
> > +
> > +     for (i = 0; (i < ARRAY_SIZE(imx214_modes) - 1) ; i++)
>
> Extra parentheses.
>
> How about using v4l2_find_nearest_size()?
>
> > +static int imx214_probe(struct i2c_client *client)
> > +{
> > +     struct device *dev = &client->dev;
> > +     struct imx214 *imx214;
> > +     int ret;
> > +     static const s64 link_freq[] = {
> > +             IMX214_DEFAULT_LINK_FREQ,
>
> This should come from firmware.

Thanks for clarifying this on the IRC. The link frequencies should
come from the firmware, but since we only support one and is probed it
is fine to get a static list.

> Kind regards,
>
> Sakari Ailus
> sakari.ailus@linux.intel.com

Thanks again

--
Ricardo Ribalda
