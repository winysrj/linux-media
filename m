Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:33784 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab1JCTBO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Oct 2011 15:01:14 -0400
Date: Mon, 3 Oct 2011 22:01:09 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Javier Martinez Canillas <martinez.javier@gmail.com>,
	linux-media@vger.kernel.org,
	laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Enrico <ebutera@users.berlios.de>,
	Gary Thomas <gary@mlbassoc.com>
Subject: Re: [PATCH 3/3] [media] tvp5150: Migrate to media-controller
 framework and add video format detection
Message-ID: <20111003190109.GN6180@valkosipuli.localdomain>
References: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com>
 <CAAwP0s1ozMVi5TgWUGmu5Pxd2cTEHd1rTD72HU9R+Fth3Rb9-A@mail.gmail.com>
 <4E891B22.1020204@infradead.org>
 <201110030830.25364.hverkuil@xs4all.nl>
 <4E8A04C2.5000508@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8A04C2.5000508@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 03, 2011 at 03:53:54PM -0300, Mauro Carvalho Chehab wrote:
> Em 03-10-2011 03:30, Hans Verkuil escreveu:
> > On Monday, October 03, 2011 04:17:06 Mauro Carvalho Chehab wrote:
> >> Em 02-10-2011 18:18, Javier Martinez Canillas escreveu:
> >>> On Sun, Oct 2, 2011 at 6:30 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> >>>> Hi Javier,
> >>>>
> >>>> Thanks for the patch! It's very interesting to see a driver for a video
> >>>> decoder using the MC interface. Before this we've had just image sensors.
> >>>>
> >>>
> >>> Hello Sakari,
> >>>
> >>> Thanks for your comments.
> >>>
> >>>> Javier Martinez Canillas wrote:
> >>>>> +             /* use the standard status register */
> >>>>> +             std_status = tvp5150_read(sd, TVP5150_STATUS_REG_5);
> >>>>> +     else
> >>>>> +             /* use the standard register itself */
> >>>>> +             std_status = std;
> >>>>
> >>>> Braces would be nice here.
> >>>>
> >>>
> >>> Ok.
> >>>
> >>>>> +     switch (std_status & VIDEO_STD_MASK) {
> >>>>> +     case VIDEO_STD_NTSC_MJ_BIT:
> >>>>> +     case VIDEO_STD_NTSC_MJ_BIT_AS:
> >>>>> +             return STD_NTSC_MJ;
> >>>>> +
> >>>>> +     case VIDEO_STD_PAL_BDGHIN_BIT:
> >>>>> +     case VIDEO_STD_PAL_BDGHIN_BIT_AS:
> >>>>> +             return STD_PAL_BDGHIN;
> >>>>> +
> >>>>> +     default:
> >>>>> +             return STD_INVALID;
> >>>>> +     }
> >>>>> +
> >>>>> +     return STD_INVALID;
> >>>>
> >>>> This return won't do anything.
> >>>>
> >>>
> >>> Yes, will clean this.
> >>>
> >>>>> @@ -704,19 +812,19 @@ static int tvp5150_set_std(struct v4l2_subdev *sd, v4l2_std_id std)
> >>>>>       if (std == V4L2_STD_ALL) {
> >>>>>               fmt = 0;        /* Autodetect mode */
> >>>>>       } else if (std & V4L2_STD_NTSC_443) {
> >>>>> -             fmt = 0xa;
> >>>>> +             fmt = VIDEO_STD_NTSC_4_43_BIT;
> >>>>>       } else if (std & V4L2_STD_PAL_M) {
> >>>>> -             fmt = 0x6;
> >>>>> +             fmt = VIDEO_STD_PAL_M_BIT;
> >>>>>       } else if (std & (V4L2_STD_PAL_N | V4L2_STD_PAL_Nc)) {
> >>>>> -             fmt = 0x8;
> >>>>> +             fmt = VIDEO_STD_PAL_COMBINATION_N_BIT;
> >>>>>       } else {
> >>>>>               /* Then, test against generic ones */
> >>>>>               if (std & V4L2_STD_NTSC)
> >>>>> -                     fmt = 0x2;
> >>>>> +                     fmt = VIDEO_STD_NTSC_MJ_BIT;
> >>>>>               else if (std & V4L2_STD_PAL)
> >>>>> -                     fmt = 0x4;
> >>>>> +                     fmt = VIDEO_STD_PAL_BDGHIN_BIT;
> >>>>>               else if (std & V4L2_STD_SECAM)
> >>>>> -                     fmt = 0xc;
> >>>>> +                     fmt = VIDEO_STD_SECAM_BIT;
> >>>>>       }
> >>>>
> >>>> Excellent! Less magic numbers...
> >>>>
> >>>>>
> >>>>> +static struct v4l2_mbus_framefmt *
> >>>>> +__tvp5150_get_pad_format(struct tvp5150 *tvp5150, struct v4l2_subdev_fh *fh,
> >>>>> +                      unsigned int pad, enum v4l2_subdev_format_whence which)
> >>>>> +{
> >>>>> +     switch (which) {
> >>>>> +     case V4L2_SUBDEV_FORMAT_TRY:
> >>>>> +             return v4l2_subdev_get_try_format(fh, pad);
> >>>>> +     case V4L2_SUBDEV_FORMAT_ACTIVE:
> >>>>> +             return tvp5150->format;
> >>>>> +     default:
> >>>>> +             return NULL;
> >>>>
> >>>> Hmm. This will never happen, but is returning NULL the right thing to
> >>>> do? An easy alternative is to just replace this with if (which may only
> >>>> have either of the two values).
> >>>>
> >>>
> >>> Ok I'll cleanup, I was being a bit paranoid there :)
> >>>
> >>>>> +
> >>>>> +static int tvp5150_set_pad_format(struct v4l2_subdev *subdev,
> >>>>> +                           struct v4l2_subdev_fh *fh,
> >>>>> +                           struct v4l2_subdev_format *format)
> >>>>> +{
> >>>>> +     struct tvp5150 *tvp5150 = to_tvp5150(subdev);
> >>>>> +     tvp5150->std_idx = STD_INVALID;
> >>>>
> >>>> The above assignment will always be overwritten immediately.
> >>>>
> >>>
> >>> Yes, since tvp515x_query_current_std() already returns STD_INVALID on
> >>> error the assignment is not needed. Will change that.
> >>>
> >>>>> +     tvp5150->std_idx = tvp515x_query_current_std(subdev);
> >>>>> +     if (tvp5150->std_idx == STD_INVALID) {
> >>>>> +             v4l2_err(subdev, "Unable to query std\n");
> >>>>> +             return 0;
> >>>>
> >>>> Isn't this an error?
> >>>>
> >>>
> >>> Yes, I'll change to report the error to the caller.
> >>>
> >>>>> + * tvp515x_mbus_fmt_cap() - V4L2 decoder interface handler for try/s/g_mbus_fmt
> >>>>
> >>>> The name of the function is different.
> >>>>
> >>>
> >>> Yes, I'll change that.
> >>>
> >>>>>  static const struct v4l2_subdev_video_ops tvp5150_video_ops = {
> >>>>>       .s_routing = tvp5150_s_routing,
> >>>>> +     .s_stream = tvp515x_s_stream,
> >>>>> +     .enum_mbus_fmt = tvp515x_enum_mbus_fmt,
> >>>>> +     .g_mbus_fmt = tvp515x_mbus_fmt,
> >>>>> +     .try_mbus_fmt = tvp515x_mbus_fmt,
> >>>>> +     .s_mbus_fmt = tvp515x_mbus_fmt,
> >>>>> +     .g_parm = tvp515x_g_parm,
> >>>>> +     .s_parm = tvp515x_s_parm,
> >>>>> +     .s_std_output = tvp5150_s_std,
> >>>>
> >>>> Do we really need both video and pad format ops?
> >>>>
> >>>
> >>> Good question, I don't know. Can this device be used as a standalone
> >>> v4l2 device? Or is supposed to always be a part of a video streaming
> >>> pipeline as a sub-device with a source pad? Sorry if my questions are
> >>> silly but as I stated before, I'm a newbie with v4l2 and MCF.
> >>
> >> The tvp5150 driver is used on some em28xx devices. It is nice to add auto-detection
> >> code to the driver, but converting it to the media bus should be done with
> >> enough care to not break support for the existing devices.
> > 
> > So in other words, the tvp5150 driver needs both pad and non-pad ops.
> > Eventually all non-pad variants in subdev drivers should be replaced by the
> > pad variants so you don't have duplication of ops. But that will take a lot
> > more work.
> > 
> >> Also, as I've argued with Laurent before, the expected behavior is that the standards
> >> format selection should be done via the video node, and not via the media 
> >> controller node. The V4L2 API has enough support for all you need to do with the
> >> video decoder, so there's no excuse to duplicate it with any other API.
> > 
> > This is relevant for bridge drivers, not for subdev drivers.
> > 
> >> The media controller API is there not to replace V4L2, but to complement
> >> it where needed.
> > 
> > That will be a nice discussion during the workshop :-)
> > 
> >> In the specific code of standards auto-detection, a few drivers currently support
> >> this feature. They're (or should be) coded to do is:
> >>
> >> If V4L2_STD_ALL is used, the driver should autodetect the video standard of the
> >> currently tuned channel.
> > 
> > Actually, this is optional. As per the spec:
> > 
> > "When the standard set is ambiguous drivers may return EINVAL or choose any of
> > the requested standards."
> 
> Yes. The entire auto-detection thing is optional. Several devices aren't capable of
> auto-detecting standards. Btw, userspace support for standards auto-detection is
> another chapter. I don't think they implement standards auto-detection.
> 
> There are even some applications (qv4l2 and tvtime, for example) that aren't capable of 
> refreshing the maximum height when the standard changes.
> 
> > Nor does the spec say anything about doing an autodetect when STD_ALL is passed
> > in. Most drivers will just set the std to PAL or NTSC in this case.
> 
> Auto-detection is device specific. That's why most applications don't handle it 
> well (or don't even care on trying to do it). Btw, I did some tests with autodetection
> on a device with a saa7115, and I found some bugs. Just sent a fix for it.
> 
> > If you want to autodetect, then use QUERYSTD. Applications cannot rely on drivers
> > to handle V4L2_STD_ALL the way you say.
> > 
> >> The detected standard can be returned to userspace via VIDIOC_G_STD.
> > 
> > No! G_STD always returns the current *selected* standard. Only QUERYSTD returns
> > the detected standard.
> 
> Yes, you're right. I should not try to answer emails when I'm lazy enough to not
> look in to the code ;)
> 
> Anyway, the thing is that V4L2 API has enough support for auto-detection. There's
> no need to duplicate stuff with MC API.

It's not MC API but V4L2 subdev API. No-one has proposed to add video
standard awareness to the Media controller API. There's no reason to export
a video node in video decoder drivers... but I guess you didn't mean that.

Would implementing ENUM/G/S_STD make sense for the camera ISP driver, that
has nothing to do with any video standard? If you have two video decoders
connected to your system, then which one should the ioctls be redirected to?
What if there's a sensor and a video decoder? And how could the user know
about this?

It's the same old issues again... let's discuss this in the Multimedia
summit.

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
