Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34241 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab1JBVSt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Oct 2011 17:18:49 -0400
Received: by ywb5 with SMTP id 5so2852466ywb.19
        for <linux-media@vger.kernel.org>; Sun, 02 Oct 2011 14:18:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E8891C1.6000208@iki.fi>
References: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com>
 <1317429231-11359-4-git-send-email-martinez.javier@gmail.com> <4E8891C1.6000208@iki.fi>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Sun, 2 Oct 2011 23:18:29 +0200
Message-ID: <CAAwP0s1ozMVi5TgWUGmu5Pxd2cTEHd1rTD72HU9R+Fth3Rb9-A@mail.gmail.com>
Subject: Re: [PATCH 3/3] [media] tvp5150: Migrate to media-controller
 framework and add video format detection
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Enrico <ebutera@users.berlios.de>,
	Gary Thomas <gary@mlbassoc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Oct 2, 2011 at 6:30 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Javier,
>
> Thanks for the patch! It's very interesting to see a driver for a video
> decoder using the MC interface. Before this we've had just image sensors.
>

Hello Sakari,

Thanks for your comments.

> Javier Martinez Canillas wrote:
>> +             /* use the standard status register */
>> +             std_status = tvp5150_read(sd, TVP5150_STATUS_REG_5);
>> +     else
>> +             /* use the standard register itself */
>> +             std_status = std;
>
> Braces would be nice here.
>

Ok.

>> +     switch (std_status & VIDEO_STD_MASK) {
>> +     case VIDEO_STD_NTSC_MJ_BIT:
>> +     case VIDEO_STD_NTSC_MJ_BIT_AS:
>> +             return STD_NTSC_MJ;
>> +
>> +     case VIDEO_STD_PAL_BDGHIN_BIT:
>> +     case VIDEO_STD_PAL_BDGHIN_BIT_AS:
>> +             return STD_PAL_BDGHIN;
>> +
>> +     default:
>> +             return STD_INVALID;
>> +     }
>> +
>> +     return STD_INVALID;
>
> This return won't do anything.
>

Yes, will clean this.

>> @@ -704,19 +812,19 @@ static int tvp5150_set_std(struct v4l2_subdev *sd, v4l2_std_id std)
>>       if (std == V4L2_STD_ALL) {
>>               fmt = 0;        /* Autodetect mode */
>>       } else if (std & V4L2_STD_NTSC_443) {
>> -             fmt = 0xa;
>> +             fmt = VIDEO_STD_NTSC_4_43_BIT;
>>       } else if (std & V4L2_STD_PAL_M) {
>> -             fmt = 0x6;
>> +             fmt = VIDEO_STD_PAL_M_BIT;
>>       } else if (std & (V4L2_STD_PAL_N | V4L2_STD_PAL_Nc)) {
>> -             fmt = 0x8;
>> +             fmt = VIDEO_STD_PAL_COMBINATION_N_BIT;
>>       } else {
>>               /* Then, test against generic ones */
>>               if (std & V4L2_STD_NTSC)
>> -                     fmt = 0x2;
>> +                     fmt = VIDEO_STD_NTSC_MJ_BIT;
>>               else if (std & V4L2_STD_PAL)
>> -                     fmt = 0x4;
>> +                     fmt = VIDEO_STD_PAL_BDGHIN_BIT;
>>               else if (std & V4L2_STD_SECAM)
>> -                     fmt = 0xc;
>> +                     fmt = VIDEO_STD_SECAM_BIT;
>>       }
>
> Excellent! Less magic numbers...
>
>>
>> +static struct v4l2_mbus_framefmt *
>> +__tvp5150_get_pad_format(struct tvp5150 *tvp5150, struct v4l2_subdev_fh *fh,
>> +                      unsigned int pad, enum v4l2_subdev_format_whence which)
>> +{
>> +     switch (which) {
>> +     case V4L2_SUBDEV_FORMAT_TRY:
>> +             return v4l2_subdev_get_try_format(fh, pad);
>> +     case V4L2_SUBDEV_FORMAT_ACTIVE:
>> +             return tvp5150->format;
>> +     default:
>> +             return NULL;
>
> Hmm. This will never happen, but is returning NULL the right thing to
> do? An easy alternative is to just replace this with if (which may only
> have either of the two values).
>

Ok I'll cleanup, I was being a bit paranoid there :)

>> +
>> +static int tvp5150_set_pad_format(struct v4l2_subdev *subdev,
>> +                           struct v4l2_subdev_fh *fh,
>> +                           struct v4l2_subdev_format *format)
>> +{
>> +     struct tvp5150 *tvp5150 = to_tvp5150(subdev);
>> +     tvp5150->std_idx = STD_INVALID;
>
> The above assignment will always be overwritten immediately.
>

Yes, since tvp515x_query_current_std() already returns STD_INVALID on
error the assignment is not needed. Will change that.

>> +     tvp5150->std_idx = tvp515x_query_current_std(subdev);
>> +     if (tvp5150->std_idx == STD_INVALID) {
>> +             v4l2_err(subdev, "Unable to query std\n");
>> +             return 0;
>
> Isn't this an error?
>

Yes, I'll change to report the error to the caller.

>> + * tvp515x_mbus_fmt_cap() - V4L2 decoder interface handler for try/s/g_mbus_fmt
>
> The name of the function is different.
>

Yes, I'll change that.

>>  static const struct v4l2_subdev_video_ops tvp5150_video_ops = {
>>       .s_routing = tvp5150_s_routing,
>> +     .s_stream = tvp515x_s_stream,
>> +     .enum_mbus_fmt = tvp515x_enum_mbus_fmt,
>> +     .g_mbus_fmt = tvp515x_mbus_fmt,
>> +     .try_mbus_fmt = tvp515x_mbus_fmt,
>> +     .s_mbus_fmt = tvp515x_mbus_fmt,
>> +     .g_parm = tvp515x_g_parm,
>> +     .s_parm = tvp515x_s_parm,
>> +     .s_std_output = tvp5150_s_std,
>
> Do we really need both video and pad format ops?
>

Good question, I don't know. Can this device be used as a standalone
v4l2 device? Or is supposed to always be a part of a video streaming
pipeline as a sub-device with a source pad? Sorry if my questions are
silly but as I stated before, I'm a newbie with v4l2 and MCF.

> s_std should be added to pad ops so it would be available on the subdev
> node.
>

Ok, I'll add s_std operation.

>>
>> +static int tvp515x_enum_mbus_code(struct v4l2_subdev *subdev,
>> +                               struct v4l2_subdev_fh *fh,
>> +                               struct v4l2_subdev_mbus_code_enum *code)
>> +{
>> +     if (code->index >= ARRAY_SIZE(tvp515x_std_list))
>> +             return -EINVAL;
>> +
>> +     code->code = V4L2_MBUS_FMT_UYVY8_2X8;
>
> If there's just one supported mbus code, non-zero code->index must
> return -EINVAL.
>

Ok, I'll change that.

>> +     return 0;
>> +}
>> +
>> +static int tvp515x_enum_frame_size(struct v4l2_subdev *subdev,
>> +                                struct v4l2_subdev_fh *fh,
>> +                                struct v4l2_subdev_frame_size_enum *fse)
>> +{
>> +     int current_std = STD_INVALID;
>
> current_std is overwritten before it gets used.
>

Yes, same case here, will remove the assignment.

>> +     if (fse->code != V4L2_MBUS_FMT_UYVY8_2X8)
>> +             return -EINVAL;
>> +
>> +     /* query the current standard */
>> +     current_std = tvp515x_query_current_std(subdev);
>> +     if (current_std == STD_INVALID) {
>> +             v4l2_err(subdev, "Unable to query std\n");
>> +             return 0;
>> +     }
>
> I wonder how the enum_frame_size and s_std are supposed to interact,
> especially that I understand, after reading the discussion, the chip may
> be used to force certain standard while the actual signal is different.
>

Well my thought was that the application can select which standard
(i.e: V4L2_STD_PAL) and enum_frame_size will return the width and
height for that standard (i.e: 720x625 for PAL). Since that is what
the device is capturing.

Then a user-space application can configure the CCDC and RESIZER to
modify the format. Does this make sense to you? Or the user-space
application can select a different frame size at the sub-dev level
(tvp5151)?

>
> --
> Sakari Ailus
> sakari.ailus@iki.fi
>

Thanks a lot for your suggestions and comments.

Best regards,

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
