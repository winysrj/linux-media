Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:49717 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037Ab1JCK0Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Oct 2011 06:26:25 -0400
Date: Mon, 3 Oct 2011 13:26:14 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Enrico <ebutera@users.berlios.de>,
	Gary Thomas <gary@mlbassoc.com>
Subject: Re: [PATCH 3/3] [media] tvp5150: Migrate to media-controller
 framework and add video format detection
Message-ID: <20111003102614.GL6180@valkosipuli.localdomain>
References: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com>
 <1317429231-11359-4-git-send-email-martinez.javier@gmail.com>
 <4E8891C1.6000208@iki.fi>
 <CAAwP0s1ozMVi5TgWUGmu5Pxd2cTEHd1rTD72HU9R+Fth3Rb9-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAwP0s1ozMVi5TgWUGmu5Pxd2cTEHd1rTD72HU9R+Fth3Rb9-A@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Oct 02, 2011 at 11:18:29PM +0200, Javier Martinez Canillas wrote:
> On Sun, Oct 2, 2011 at 6:30 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > Hi Javier,
> >
> > Thanks for the patch! It's very interesting to see a driver for a video
> > decoder using the MC interface. Before this we've had just image sensors.
> >
> 
> Hello Sakari,
> 
> Thanks for your comments.

Hi Javier,

You're welcome. You also got very good comments from others.

> > Javier Martinez Canillas wrote:
> >> +             /* use the standard status register */
> >> +             std_status = tvp5150_read(sd, TVP5150_STATUS_REG_5);
> >> +     else
> >> +             /* use the standard register itself */
> >> +             std_status = std;
> >
> > Braces would be nice here.
> >
> 
> Ok.
> 
> >> +     switch (std_status & VIDEO_STD_MASK) {
> >> +     case VIDEO_STD_NTSC_MJ_BIT:
> >> +     case VIDEO_STD_NTSC_MJ_BIT_AS:
> >> +             return STD_NTSC_MJ;
> >> +
> >> +     case VIDEO_STD_PAL_BDGHIN_BIT:
> >> +     case VIDEO_STD_PAL_BDGHIN_BIT_AS:
> >> +             return STD_PAL_BDGHIN;
> >> +
> >> +     default:
> >> +             return STD_INVALID;
> >> +     }
> >> +
> >> +     return STD_INVALID;
> >
> > This return won't do anything.
> >
> 
> Yes, will clean this.
> 
> >> @@ -704,19 +812,19 @@ static int tvp5150_set_std(struct v4l2_subdev *sd, v4l2_std_id std)
> >>       if (std == V4L2_STD_ALL) {
> >>               fmt = 0;        /* Autodetect mode */
> >>       } else if (std & V4L2_STD_NTSC_443) {
> >> -             fmt = 0xa;
> >> +             fmt = VIDEO_STD_NTSC_4_43_BIT;
> >>       } else if (std & V4L2_STD_PAL_M) {
> >> -             fmt = 0x6;
> >> +             fmt = VIDEO_STD_PAL_M_BIT;
> >>       } else if (std & (V4L2_STD_PAL_N | V4L2_STD_PAL_Nc)) {
> >> -             fmt = 0x8;
> >> +             fmt = VIDEO_STD_PAL_COMBINATION_N_BIT;
> >>       } else {
> >>               /* Then, test against generic ones */
> >>               if (std & V4L2_STD_NTSC)
> >> -                     fmt = 0x2;
> >> +                     fmt = VIDEO_STD_NTSC_MJ_BIT;
> >>               else if (std & V4L2_STD_PAL)
> >> -                     fmt = 0x4;
> >> +                     fmt = VIDEO_STD_PAL_BDGHIN_BIT;
> >>               else if (std & V4L2_STD_SECAM)
> >> -                     fmt = 0xc;
> >> +                     fmt = VIDEO_STD_SECAM_BIT;
> >>       }
> >
> > Excellent! Less magic numbers...
> >
> >>
> >> +static struct v4l2_mbus_framefmt *
> >> +__tvp5150_get_pad_format(struct tvp5150 *tvp5150, struct v4l2_subdev_fh *fh,
> >> +                      unsigned int pad, enum v4l2_subdev_format_whence which)
> >> +{
> >> +     switch (which) {
> >> +     case V4L2_SUBDEV_FORMAT_TRY:
> >> +             return v4l2_subdev_get_try_format(fh, pad);
> >> +     case V4L2_SUBDEV_FORMAT_ACTIVE:
> >> +             return tvp5150->format;
> >> +     default:
> >> +             return NULL;
> >
> > Hmm. This will never happen, but is returning NULL the right thing to
> > do? An easy alternative is to just replace this with if (which may only
> > have either of the two values).
> >
> 
> Ok I'll cleanup, I was being a bit paranoid there :)
> 
> >> +
> >> +static int tvp5150_set_pad_format(struct v4l2_subdev *subdev,
> >> +                           struct v4l2_subdev_fh *fh,
> >> +                           struct v4l2_subdev_format *format)
> >> +{
> >> +     struct tvp5150 *tvp5150 = to_tvp5150(subdev);
> >> +     tvp5150->std_idx = STD_INVALID;
> >
> > The above assignment will always be overwritten immediately.
> >
> 
> Yes, since tvp515x_query_current_std() already returns STD_INVALID on
> error the assignment is not needed. Will change that.
> 
> >> +     tvp5150->std_idx = tvp515x_query_current_std(subdev);
> >> +     if (tvp5150->std_idx == STD_INVALID) {
> >> +             v4l2_err(subdev, "Unable to query std\n");
> >> +             return 0;
> >
> > Isn't this an error?
> >
> 
> Yes, I'll change to report the error to the caller.

Thinking about this again, the error likely shouldn't be returned to the
user.

<URL:http://hverkuil.home.xs4all.nl/spec/media.html#vidioc-subdev-g-fmt>

Nonetheless, something should definitely be returned to the user. It might
be best to leave it unchanged.

> >> + * tvp515x_mbus_fmt_cap() - V4L2 decoder interface handler for try/s/g_mbus_fmt
> >
> > The name of the function is different.
> >
> 
> Yes, I'll change that.
> 
> >>  static const struct v4l2_subdev_video_ops tvp5150_video_ops = {
> >>       .s_routing = tvp5150_s_routing,
> >> +     .s_stream = tvp515x_s_stream,
> >> +     .enum_mbus_fmt = tvp515x_enum_mbus_fmt,
> >> +     .g_mbus_fmt = tvp515x_mbus_fmt,
> >> +     .try_mbus_fmt = tvp515x_mbus_fmt,
> >> +     .s_mbus_fmt = tvp515x_mbus_fmt,
> >> +     .g_parm = tvp515x_g_parm,
> >> +     .s_parm = tvp515x_s_parm,
> >> +     .s_std_output = tvp5150_s_std,
> >
> > Do we really need both video and pad format ops?
> >
> 
> Good question, I don't know. Can this device be used as a standalone
> v4l2 device? Or is supposed to always be a part of a video streaming
> pipeline as a sub-device with a source pad? Sorry if my questions are
> silly but as I stated before, I'm a newbie with v4l2 and MCF.

You got good comments from others to this.

I agree with Laurent, the right thing to do is to implement wrappers for the
video fmt ops so that the driver only needed to implement pad ops. This way
all the bridge drivers would work with your subdev driver.

> > s_std should be added to pad ops so it would be available on the subdev
> > node.
> >
> 
> Ok, I'll add s_std operation.
> 
> >>
> >> +static int tvp515x_enum_mbus_code(struct v4l2_subdev *subdev,
> >> +                               struct v4l2_subdev_fh *fh,
> >> +                               struct v4l2_subdev_mbus_code_enum *code)
> >> +{
> >> +     if (code->index >= ARRAY_SIZE(tvp515x_std_list))
> >> +             return -EINVAL;
> >> +
> >> +     code->code = V4L2_MBUS_FMT_UYVY8_2X8;
> >
> > If there's just one supported mbus code, non-zero code->index must
> > return -EINVAL.
> >
> 
> Ok, I'll change that.
> 
> >> +     return 0;
> >> +}
> >> +
> >> +static int tvp515x_enum_frame_size(struct v4l2_subdev *subdev,
> >> +                                struct v4l2_subdev_fh *fh,
> >> +                                struct v4l2_subdev_frame_size_enum *fse)
> >> +{
> >> +     int current_std = STD_INVALID;
> >
> > current_std is overwritten before it gets used.
> >
> 
> Yes, same case here, will remove the assignment.
> 
> >> +     if (fse->code != V4L2_MBUS_FMT_UYVY8_2X8)
> >> +             return -EINVAL;
> >> +
> >> +     /* query the current standard */
> >> +     current_std = tvp515x_query_current_std(subdev);
> >> +     if (current_std == STD_INVALID) {
> >> +             v4l2_err(subdev, "Unable to query std\n");
> >> +             return 0;
> >> +     }
> >
> > I wonder how the enum_frame_size and s_std are supposed to interact,
> > especially that I understand, after reading the discussion, the chip may
> > be used to force certain standard while the actual signal is different.
> >
> 
> Well my thought was that the application can select which standard
> (i.e: V4L2_STD_PAL) and enum_frame_size will return the width and
> height for that standard (i.e: 720x625 for PAL). Since that is what
> the device is capturing.
> 
> Then a user-space application can configure the CCDC and RESIZER to
> modify the format. Does this make sense to you? Or the user-space
> application can select a different frame size at the sub-dev level
> (tvp5151)?

That's a good question.

I think that if the receiver should output the format it can and try nothing
else.

The resizer may then be used to scale that. Then, g_std does return
framelines that corresponds to the original received video signal but I
don't think that's an issue. The user knows nevertheless that scaling is
being made since he must have configured that.

To support generic applications properly we do need a plugin for libv4l. We
have a few bits in place already, like libmediactl, libv4l2subdev and an
OMAP 3 plugin for libv4l.

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
