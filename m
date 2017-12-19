Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:35631 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751090AbdLSPkM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 10:40:12 -0500
Received: by mail-pl0-f67.google.com with SMTP id b96so7167962pli.2
        for <linux-media@vger.kernel.org>; Tue, 19 Dec 2017 07:40:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171219103515.6eetdss4cmlbsxzk@valkosipuli.retiisi.org.uk>
References: <1513180849-7913-1-git-send-email-akinobu.mita@gmail.com> <20171219103515.6eetdss4cmlbsxzk@valkosipuli.retiisi.org.uk>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Wed, 20 Dec 2017 00:39:51 +0900
Message-ID: <CAC5umyiHxSfPRkP21-XJuMgiE8+1fLSMbYNXLYC19cPdXv_8JQ@mail.gmail.com>
Subject: Re: [PATCH] media: ov9650: support VIDIOC_DBG_G/S_REGISTER ioctls
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        hverkuil@xs4all.nl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

2017-12-19 19:35 GMT+09:00 Sakari Ailus <sakari.ailus@iki.fi>:
> Hi Akinobu,
>
> On Thu, Dec 14, 2017 at 01:00:49AM +0900, Akinobu Mita wrote:
>> This adds support VIDIOC_DBG_G/S_REGISTER ioctls.
>>
>> There are many device control registers contained in the OV9650.  So
>> this helps debugging the lower level issues by getting and setting the
>> registers.
>>
>> Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
>> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
>> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>
> Just wondering --- doesn't the I=E6=B6=8E user space interface offer esse=
ntially
> the same functionality?

You are right.  I thought /dev/i2c-X interface is not allowed for the
i2c device that is currently in use by a driver.  But I found that
there is I2C_SLAVE_FORCE ioctl to bypass the check and the i2cget and
i2cset with '-f' option use I2C_SLAVE_FORCE ioctls.

So I can live without the proposed patch.

> See: Documentation/i2c/dev-interface
>
> Cc Hans.
>
>> ---
>>  drivers/media/i2c/ov9650.c | 36 ++++++++++++++++++++++++++++++++++++
>>  1 file changed, 36 insertions(+)
>>
>> diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
>> index 69433e1..c6462cf 100644
>> --- a/drivers/media/i2c/ov9650.c
>> +++ b/drivers/media/i2c/ov9650.c
>> @@ -1374,6 +1374,38 @@ static int ov965x_open(struct v4l2_subdev *sd, st=
ruct v4l2_subdev_fh *fh)
>>       return 0;
>>  }
>>
>> +#ifdef CONFIG_VIDEO_ADV_DEBUG
>> +
>> +static int ov965x_g_register(struct v4l2_subdev *sd,
>> +                          struct v4l2_dbg_register *reg)
>> +{
>> +     struct i2c_client *client =3D v4l2_get_subdevdata(sd);
>> +     u8 val =3D 0;
>> +     int ret;
>> +
>> +     if (reg->reg > 0xff)
>> +             return -EINVAL;
>> +
>> +     ret =3D ov965x_read(client, reg->reg, &val);
>> +     reg->val =3D val;
>> +     reg->size =3D 1;
>> +
>> +     return ret;
>> +}
>> +
>> +static int ov965x_s_register(struct v4l2_subdev *sd,
>> +                          const struct v4l2_dbg_register *reg)
>> +{
>> +     struct i2c_client *client =3D v4l2_get_subdevdata(sd);
>> +
>> +     if (reg->reg > 0xff || reg->val > 0xff)
>> +             return -EINVAL;
>> +
>> +     return ov965x_write(client, reg->reg, reg->val);
>> +}
>> +
>> +#endif
>> +
>>  static const struct v4l2_subdev_pad_ops ov965x_pad_ops =3D {
>>       .enum_mbus_code =3D ov965x_enum_mbus_code,
>>       .enum_frame_size =3D ov965x_enum_frame_sizes,
>> @@ -1397,6 +1429,10 @@ static const struct v4l2_subdev_core_ops ov965x_c=
ore_ops =3D {
>>       .log_status =3D v4l2_ctrl_subdev_log_status,
>>       .subscribe_event =3D v4l2_ctrl_subdev_subscribe_event,
>>       .unsubscribe_event =3D v4l2_event_subdev_unsubscribe,
>> +#ifdef CONFIG_VIDEO_ADV_DEBUG
>> +     .g_register =3D ov965x_g_register,
>> +     .s_register =3D ov965x_s_register,
>> +#endif
>>  };
>>
>>  static const struct v4l2_subdev_ops ov965x_subdev_ops =3D {
>> --
>> 2.7.4
>>
>
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi
