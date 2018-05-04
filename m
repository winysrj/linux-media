Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:38163 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751425AbeEDQcl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 12:32:41 -0400
MIME-Version: 1.0
In-Reply-To: <20180503202931.GE19612@w540>
References: <1525021993-17789-1-git-send-email-akinobu.mita@gmail.com>
 <1525021993-17789-11-git-send-email-akinobu.mita@gmail.com> <20180503202931.GE19612@w540>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Sat, 5 May 2018 01:32:19 +0900
Message-ID: <CAC5umyj_mCPEFE03_ZabC5rFfJYC1zsvO4A8WdTsg2VgMWG0+Q@mail.gmail.com>
Subject: Re: [PATCH v4 10/14] media: ov772x: reconstruct s_frame_interval()
To: jacopo mondi <jacopo@jmondi.org>
Cc: linux-media@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-05-04 5:29 GMT+09:00 jacopo mondi <jacopo@jmondi.org>:
> Hi Akinobu,
>    thank you for the patch
>
> On Mon, Apr 30, 2018 at 02:13:09AM +0900, Akinobu Mita wrote:
>> This splits the s_frame_interval() in subdev video ops into selecting the
>> frame interval and setting up the registers.
>>
>> This is a preparatory change to avoid accessing registers under power
>> saving mode.
>>
>> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
>> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> ---
>> * v4
>> - No changes
>>
>>  drivers/media/i2c/ov772x.c | 56 +++++++++++++++++++++++++++++-----------------
>>  1 file changed, 35 insertions(+), 21 deletions(-)
>>
>> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
>> index edc013d..7ea157e 100644
>> --- a/drivers/media/i2c/ov772x.c
>> +++ b/drivers/media/i2c/ov772x.c
>> @@ -617,25 +617,16 @@ static int ov772x_s_stream(struct v4l2_subdev *sd, int enable)
>>       return 0;
>>  }
>>
>> -static int ov772x_set_frame_rate(struct ov772x_priv *priv,
>> -                              struct v4l2_fract *tpf,
>> -                              const struct ov772x_color_format *cfmt,
>> -                              const struct ov772x_win_size *win)
>> +static unsigned int ov772x_select_fps(struct ov772x_priv *priv,
>> +                              struct v4l2_fract *tpf)
>
> Please align to the open brace, as all the other functions in the
> driver.

OK.

> Also, is it worth making a function out of this? It is called from one
> place only... see below.
>
>>  {
>> -     struct i2c_client *client = v4l2_get_subdevdata(&priv->subdev);
>> -     unsigned long fin = clk_get_rate(priv->clk);
>>       unsigned int fps = tpf->numerator ?
>>                          tpf->denominator / tpf->numerator :
>>                          tpf->denominator;
>>       unsigned int best_diff;
>> -     unsigned int fsize;
>> -     unsigned int pclk;
>>       unsigned int diff;
>>       unsigned int idx;
>>       unsigned int i;
>> -     u8 clkrc = 0;
>> -     u8 com4 = 0;
>> -     int ret;
>>
>>       /* Approximate to the closest supported frame interval. */
>>       best_diff = ~0L;
>> @@ -646,7 +637,25 @@ static int ov772x_set_frame_rate(struct ov772x_priv *priv,
>>                       best_diff = diff;
>>               }
>>       }
>> -     fps = ov772x_frame_intervals[idx];
>> +
>> +     return ov772x_frame_intervals[idx];
>> +}
>> +
>> +static int ov772x_set_frame_rate(struct ov772x_priv *priv,
>> +                              unsigned int fps,
>> +                              const struct ov772x_color_format *cfmt,
>> +                              const struct ov772x_win_size *win)
>> +{
>> +     struct i2c_client *client = v4l2_get_subdevdata(&priv->subdev);
>> +     unsigned long fin = clk_get_rate(priv->clk);
>> +     unsigned int fsize;
>> +     unsigned int pclk;
>> +     unsigned int best_diff;
>
> Please keep variable declarations sorted as in other functions in the
> driver.

OK.

>> +     unsigned int diff;
>> +     unsigned int i;
>> +     u8 clkrc = 0;
>> +     u8 com4 = 0;
>> +     int ret;
>>
>>       /* Use image size (with blankings) to calculate desired pixel clock. */
>>       switch (cfmt->com7 & OFMT_MASK) {
>> @@ -711,10 +720,6 @@ static int ov772x_set_frame_rate(struct ov772x_priv *priv,
>>       if (ret < 0)
>>               return ret;
>>
>> -     tpf->numerator = 1;
>> -     tpf->denominator = fps;
>> -     priv->fps = tpf->denominator;
>> -
>>       return 0;
>>  }
>>
>> @@ -735,8 +740,20 @@ static int ov772x_s_frame_interval(struct v4l2_subdev *sd,
>>  {
>>       struct ov772x_priv *priv = to_ov772x(sd);
>>       struct v4l2_fract *tpf = &ival->interval;
>> +     unsigned int fps;
>> +     int ret;
>> +
>> +     fps = ov772x_select_fps(priv, tpf);
>
> That's the only caller of this function. I'm fine if you want to keep
> it as it is though.

I would like to keep ov772x_select_fps() because the function name is
self descriptive and imples it doesn't change HW registers.  So I feel
it helps readability a bit.

> Thanks
>    j
>
>
>> +
>> +     ret = ov772x_set_frame_rate(priv, fps, priv->cfmt, priv->win);
>> +     if (ret)
>> +             return ret;
>>
>> -     return ov772x_set_frame_rate(priv, tpf, priv->cfmt, priv->win);
>> +     tpf->numerator = 1;
>> +     tpf->denominator = fps;
>> +     priv->fps = fps;
>> +
>> +     return 0;
>>  }
>>
>>  static int ov772x_s_ctrl(struct v4l2_ctrl *ctrl)
>> @@ -993,7 +1010,6 @@ static int ov772x_set_params(struct ov772x_priv *priv,
>>                            const struct ov772x_win_size *win)
>>  {
>>       struct i2c_client *client = v4l2_get_subdevdata(&priv->subdev);
>> -     struct v4l2_fract tpf;
>>       int ret;
>>       u8  val;
>>
>> @@ -1075,9 +1091,7 @@ static int ov772x_set_params(struct ov772x_priv *priv,
>>               goto ov772x_set_fmt_error;
>>
>>       /* COM4, CLKRC: Set pixel clock and framerate. */
>> -     tpf.numerator = 1;
>> -     tpf.denominator = priv->fps;
>> -     ret = ov772x_set_frame_rate(priv, &tpf, cfmt, win);
>> +     ret = ov772x_set_frame_rate(priv, priv->fps, cfmt, win);
>>       if (ret < 0)
>>               goto ov772x_set_fmt_error;
>>
>> --
>> 2.7.4
>>
