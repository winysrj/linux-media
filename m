Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35973 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403955AbeKWBkf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 20:40:35 -0500
Received: by mail-pf1-f193.google.com with SMTP id b85so2072732pfc.3
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2018 07:00:51 -0800 (PST)
MIME-Version: 1.0
References: <20181122035229.3630-1-matt.ranostay@konsulko.com>
 <20181122035229.3630-3-matt.ranostay@konsulko.com> <4e408e8a-414b-a6cd-37c6-ce3a378c6e25@xs4all.nl>
In-Reply-To: <4e408e8a-414b-a6cd-37c6-ce3a378c6e25@xs4all.nl>
From: Matt Ranostay <matt.ranostay@konsulko.com>
Date: Thu, 22 Nov 2018 07:00:40 -0800
Message-ID: <CAJCx=g=AjDZatGHDVFKbcE3VCmWSuyrmS3Ob-X5+r5R=6WRJqA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] media: video-i2c: add Melexis MLX90640 thermal
 camera support
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 22, 2018 at 12:57 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 11/22/2018 04:52 AM, Matt Ranostay wrote:
> > Add initial support for MLX90640 thermal cameras which output an 32x24
> > greyscale pixel image along with 2 rows of coefficent data.
> >
> > Because of this the data outputed is really 32x26 and needs the two rows
> > removed after using the coefficent information to generate processed
> > images in userspace.
> >
> > Cc: devicetree@vger.kernel.org
> > Signed-off-by: Matt Ranostay <matt.ranostay@konsulko.com>
> > ---
> >  .../bindings/media/i2c/melexis,mlx90640.txt   |  20 ++++
> >  drivers/media/i2c/Kconfig                     |   1 +
> >  drivers/media/i2c/video-i2c.c                 | 110 +++++++++++++++++-
> >  3 files changed, 130 insertions(+), 1 deletion(-)
> >  create mode 100644 Documentation/devicetree/bindings/media/i2c/melexis,mlx90640.txt
> >
> > diff --git a/Documentation/devicetree/bindings/media/i2c/melexis,mlx90640.txt b/Documentation/devicetree/bindings/media/i2c/melexis,mlx90640.txt
> > new file mode 100644
> > index 000000000000..060d2b7a5893
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/i2c/melexis,mlx90640.txt
> > @@ -0,0 +1,20 @@
> > +* Melexis MLX90640 FIR Sensor
> > +
> > +Melexis MLX90640 FIR sensor support which allows recording of thermal data
> > +with 32x24 resolution excluding 2 lines of coefficient data that is used by
> > +userspace to render processed frames.
>
> So this means that the image doesn't conform to V4L2_PIX_FMT_Y12!
>

The data for this sensor is V4L2_PIX_FMT_Y16BE not Y12

> I missed that the first time around.
>
> You have three options here:
>
> 1) Create a new V4L2_PIX_FMT define + documentation describing the format that
>    this device produces.
>
> 2) Split off the image from the meta data and create a new META_CAPTURE device
>    node. For the META device node you would again have to document the format
>
> 3) Split off the image from the meta data and store the meta data in a V4L2
>    control, which again has to be documented.
>
> I'm leaning towards 1 since that's easiest to implement. But the key is that
> you should document those two lines. The datasheet is publicly available,
> so you can refer to it for details.
>

1 is mostly what I have now, excluding the documentation and new pixel format.

Although I have to say the META_CAPTURE options seems a bit more
clean, but doesn't seem
to be documented well.  So would it basically mux the pixel data, and
metadata with the same
timestamp?  Originally I looked at the VBI/closed caption to show the
metadata/frame-only data but that
was a way too low of a bandwidth (43-bytes a second IIRC).

> Those extra two lines return addresses 0x700-0x73f, right? Is it even sufficient
> to calculate the relevant data from just those lines?

Yep that is the last 2 lines so 32x26 of reported data, but only 32x24
is pixel data.

> Looking at 11.2.2 there
> is a whole calculation that should be done that is also dependent on the eeprom
> values, which are not exported.
>

You must have missed the nvmem part of the patchset.. :) The
respective eeprom values are exported to userspace using that.

> I wonder if it isn't the job of the driver to do all the calculations. It has
> all the information it needs and looking at the datasheet it seems all the
> calculations are integer based, so it shouldn't be too difficult. This would
> be a fourth option.

Well it isn't really all integer based.. sure the value from the frame
and eeprom are integers but the
coefficients you generate ( frame value divided by eeprom value )
usually produces a floating point value.

>
> BTW, did we document somewhere what the panasonic device returns? It returns
> Y12 data, but what does that data mean? In order to use this in userspace you
> need to be able to convert it to temperatures, so how is that done?

It is a signed 12-bit value with 0.25C resolution per LSB but doesn't
need any processing.

>
> Regards,
>
>         Hans
>
> > +
> > +Required Properties:
> > + - compatible : Must be "melexis,mlx90640"
> > + - reg : i2c address of the device
> > +
> > +Example:
> > +
> > +     i2c0@1c22000 {
> > +             ...
> > +             mlx90640@33 {
> > +                     compatible = "melexis,mlx90640";
> > +                     reg = <0x33>;
> > +             };
> > +             ...
> > +     };
