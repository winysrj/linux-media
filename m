Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot1-f65.google.com ([209.85.210.65]:34309 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbeIMOvQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 10:51:16 -0400
Received: by mail-ot1-f65.google.com with SMTP id i12-v6so660307otl.1
        for <linux-media@vger.kernel.org>; Thu, 13 Sep 2018 02:42:35 -0700 (PDT)
MIME-Version: 1.0
References: <20180829105828.4502-1-sakari.ailus@linux.intel.com>
In-Reply-To: <20180829105828.4502-1-sakari.ailus@linux.intel.com>
From: Sylwester Nawrocki <sylwester.nawrocki@gmail.com>
Date: Thu, 13 Sep 2018 11:42:22 +0200
Message-ID: <CAB_H8rspDcsTKJ8+AtRB_-v80cmSHfStv1U=e2zbMtsLsC2=+w@mail.gmail.com>
Subject: Re: [RFC 1/1] v4l: samsung, ov9650: Rely on V4L2-set sub-device names
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        riverful.kim@samsung.com, Akinobu Mita <akinobu.mita@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thu, 13 Sep 2018 at 11:21, Sakari Ailus <sakari.ailus@linux.intel.com> wrote:
[...]
> diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> index ce196b60f917..64212551524e 100644
> --- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> +++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> @@ -1683,7 +1683,7 @@ static int s5c73m3_probe(struct i2c_client *client,
>         v4l2_subdev_init(sd, &s5c73m3_subdev_ops);
>         sd->owner = client->dev.driver->owner;
>         v4l2_set_subdevdata(sd, state);
> -       strlcpy(sd->name, "S5C73M3", sizeof(sd->name));
> +       v4l2_i2c_subdev_set_name(sd, client, NULL, NULL);
>
>         sd->internal_ops = &s5c73m3_internal_ops;
>         sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> @@ -1698,7 +1698,7 @@ static int s5c73m3_probe(struct i2c_client *client,
>                 return ret;
>
>         v4l2_i2c_subdev_init(oif_sd, client, &oif_subdev_ops);
> -       strcpy(oif_sd->name, "S5C73M3-OIF");
> +       v4l2_i2c_subdev_set_name(sd, client, NULL, "-OIF");

I would suggest to change the "OIF-" prefix to lower case, to avoid
something like
"s5c73m3-OIF". IIRC client->name is derived from DT compatible string, which is
in lower case.
Otherwise looks OK to me.

--
Thanks,
Sylwester
