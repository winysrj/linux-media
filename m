Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:45507 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754965AbeFNQ0T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 12:26:19 -0400
Received: by mail-qt0-f196.google.com with SMTP id i18-v6so6312004qtp.12
        for <linux-media@vger.kernel.org>; Thu, 14 Jun 2018 09:26:19 -0700 (PDT)
Subject: Re: [PATCH] gpu: ipu-v3: Allow negative offsets for interlaced
 scanning
To: =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>
Cc: Javier Martinez Canillas <javierm@redhat.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org, kernel@pengutronix.de
References: <20180601131316.18728-1-p.zabel@pengutronix.de>
 <ebada35f-23c1-6ca4-5228-d3d91bad48bc@gmail.com>
 <1528708771.3818.7.camel@pengutronix.de>
 <6780e24e-891d-3583-6e38-d1abd69c8a0d@gmail.com>
 <2aff8f80-aa79-6718-6183-6e49088ae498@redhat.com>
 <f6e7eaa3-355e-a5d9-1be5-e5db08a99897@gmail.com> <m3h8m5yaeh.fsf@t19.piap.pl>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <798b8ad7-2fce-8408-b1c4-c2954f524d23@gmail.com>
Date: Thu, 14 Jun 2018 09:26:16 -0700
MIME-Version: 1.0
In-Reply-To: <m3h8m5yaeh.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Krzysztof,


On 06/14/2018 02:39 AM, Krzysztof Hałasa wrote:
> Reporting from the field :-)
>
> The fix-csi-interlaced.3 branch is still a bit off the track I guess:

Yes, it's still a WIP. A couple things are remaining:

- fix interweave with negative offsets for planar pixel formats.
- update the doc again.


>     media-ctl -V "'adv7180 2-0020':0 [fmt:UYVY2X8/576 field:seq-tb]"
>     media-ctl -V "'ipu2_csi1_mux':2 [fmt:UYVY2X8/720x576]"
>     media-ctl -V "'ipu2_csi1':2 [fmt:AYUV32/720x576 field:interlaced-tb]"
>
> does:
> "adv7180 2-0020":0 [fmt:UYVY2X8/720x576 field:alternate]
> "ipu2_csi1_mux":1  [fmt:UYVY2X8/720x576 field:alternate]
> "ipu2_csi1_mux":2  [fmt:UYVY2X8/720x576 field:alternate]
> "ipu2_csi1":0      [fmt:UYVY2X8/720x576 field:alternate
>                   crop.bounds:(0,0)/720x1152
>                   crop:(0,0)/720x1152
>                   compose.bounds:(0,0)/720x1152
>                   compose:(0,0)/720x1152]
> "ipu2_csi1":2      [fmt:AYUV32/720x1152 field:seq-tb]
>
> ... and not interlaced[-*], as with fix-csi-interlaced.2.

Right, the selection of interweave is moved to the capture devices,
so the following will enable interweave:

v4l2-ctl -dN --set-fmt-video=field=interlaced_tb


>
> The double heights are funny, too - probably an ADV7180 issue.

That's because it's been confirmed that for sources that
report ALTERNATE, mbus format height must be the number
of lines per field, not the total frame lines.

See

0018147c964e ("media: v4l: doc: Clarify v4l2_mbus_fmt height definition")

So the patch to adv7180 needs to be modified to report # field lines.

Try the following:

--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -503,6 +503,9 @@ static int adv7180_set_power(struct adv7180_state 
*state, bool on)
          }
      }

+    if (on)
+        msleep(500);
+
      return 0;
  }

@@ -643,6 +646,8 @@ static int adv7180_mbus_fmt(struct v4l2_subdev *sd,
      fmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
      fmt->width = 720;
      fmt->height = state->curr_norm & V4L2_STD_525_60 ? 480 : 576;
+    if (fmt->field == V4L2_FIELD_ALTERNATE)
+        fmt->height /= 2;

      return 0;
  }
@@ -694,8 +699,8 @@ static int adv7180_get_pad_format(struct v4l2_subdev 
*sd,
      if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
          format->format = *v4l2_subdev_get_try_format(sd, cfg, 0);
      } else {
-        adv7180_mbus_fmt(sd, &format->format);
          format->format.field = state->field;
+        adv7180_mbus_fmt(sd, &format->format);
      }

      return 0;
@@ -712,10 +717,10 @@ static int adv7180_set_pad_format(struct 
v4l2_subdev *sd,
      switch (format->format.field) {
      case V4L2_FIELD_NONE:
          if (!(state->chip_info->flags & ADV7180_FLAG_I2P))
-            format->format.field = V4L2_FIELD_INTERLACED;
+            format->format.field = V4L2_FIELD_ALTERNATE;
          break;
      default:
-        format->format.field = V4L2_FIELD_INTERLACED;
+        format->format.field = V4L2_FIELD_ALTERNATE;
          break;
      }

@@ -1291,7 +1296,7 @@ static int adv7180_probe(struct i2c_client *client,
          return -ENOMEM;

      state->client = client;
-    state->field = V4L2_FIELD_INTERLACED;
+    state->field = V4L2_FIELD_ALTERNATE;
      state->chip_info = (struct adv7180_chip_info *)id->driver_data;

      state->pwdn_gpio = devm_gpiod_get_optional(&client->dev, "powerdown",
