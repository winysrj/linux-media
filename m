Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:35834 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750751AbeDTQgN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 12:36:13 -0400
MIME-Version: 1.0
In-Reply-To: <20180418125536.GB3999@w540>
References: <1523847111-12986-1-git-send-email-akinobu.mita@gmail.com>
 <1523847111-12986-11-git-send-email-akinobu.mita@gmail.com> <20180418125536.GB3999@w540>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Sat, 21 Apr 2018 01:35:52 +0900
Message-ID: <CAC5umyjj4RAxwBbtGEFwVo+TYH_H+Wv-NDE-_kqJLLzTf_mJ4Q@mail.gmail.com>
Subject: Re: [PATCH v2 10/10] media: ov772x: avoid accessing registers under
 power saving mode
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

2018-04-18 21:55 GMT+09:00 jacopo mondi <jacopo@jmondi.org>:
>> @@ -898,8 +922,20 @@ static int ov772x_s_power(struct v4l2_subdev *sd, int on)
>>       /* If the power count is modified from 0 to != 0 or from != 0 to 0,
>>        * update the power state.
>>        */
>> -     if (priv->power_count == !on)
>> -             ret = on ? ov772x_power_on(priv) : ov772x_power_off(priv);
>> +     if (priv->power_count == !on) {
>> +             if (on) {
>> +                     ret = ov772x_power_on(priv);
>> +                     /* Restore the controls */
>> +                     if (!ret)
>> +                             ret = ov772x_set_params(priv, priv->cfmt,
>> +                                                     priv->win);
>> +                     /* Restore the format and the frame rate */
>> +                     if (!ret)
>> +                             ret = __v4l2_ctrl_handler_setup(&priv->hdl);
>
> frame interval is not listed in the sensor control list, it won't be
> restored if I'm not wrong...

The above two comments were swapped wrongly.  The ov772x_set_params()
actually restores the format, the frame rate.  It restores COM3,
COM8, and BDBASE registers, too.  So calling __v4l2_ctrl_handler_setup()
here is not needed.
