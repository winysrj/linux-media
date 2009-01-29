Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1101 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbZA2I16 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 03:27:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Shah, Hardik" <hardik.shah@ti.com>
Subject: Re: [PATCHv2] New V4L2 ioctls for OMAP class of Devices
Date: Thu, 29 Jan 2009 09:27:52 +0100
Cc: Trent Piepho <xyzzy@speakeasy.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>
References: <5A47E75E594F054BAF48C5E4FC4B92AB02F535F671@dbde02.ent.ti.com>
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB02F535F671@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901290927.52413.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hardik,

Just a minor point: it's enough to post to linux-media, no need to post to 
the video4linux list as well. I assume everyone involved in v4l-dvb has now 
subscribed to linux-media.

On Thursday 29 January 2009 07:57:22 Shah, Hardik wrote:
> > -----Original Message-----
> > From: Trent Piepho [mailto:xyzzy@speakeasy.org]
> > Sent: Thursday, January 29, 2009 11:50 AM
> > To: Shah, Hardik
> > Cc: linux-media@vger.kernel.org; video4linux-list@redhat.com; Jadav,
> > Brijesh R; Nagalla, Hari; Hiremath, Vaibhav
> > Subject: Re: [PATCHv2] New V4L2 ioctls for OMAP class of Devices
> >
> > On Thu, 29 Jan 2009, Hardik Shah wrote:
> > > 1.  Control ID added for rotation.  Same as HFLIP.
> > > 2.  Control ID added for setting background color on
> > >     output device.
> > > 3.  New ioctl added for setting the color space conversion from
> > >     YUV to RGB.
> > > 4.  Updated the v4l2-common.c file according to comments.
> >
> > Wasn't there supposed to be some documentation?
> >
> > > +	case V4L2_CID_BG_COLOR:
> > > +		/* Max value is 2^24 as RGB888 is used for background color */
> > > +		return v4l2_ctrl_query_fill(qctrl, 0, 16777216, 1, 0);
> >
> > Wouldn't it make more sense to set background in the same colorspace as
> > the selected format?
>
> [Shah, Hardik] Background color setting can be done only in the RGB space
> as hardware doesn't understand YUV or RGB565 for the background color
> setting.  And background color and pixel format are not related.  If we
> want to have the background setting format same as the color format then
> driver will have to do the color conversion and that is not optimal.

In the case of a chromakey the value is interpreted according to the pixel 
format of the associated framebuffer. However, if I understand the omap 
architecture correctly, this background color is pretty much independent 
from either graphics or videoplane pixel formats. As such it makes sense to 
fix it to a specific pixel format and let the driver transform it if it 
needs to. It is similar in that respect to the V4L2_CID_MPEG_VIDEO_MUTE_YUV 
control. The documentation needs to specify the format precisely, of 
course.

I also noticed this:

@@ -548,6 +553,7 @@ int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, 
s32 min, s32 max, s32 ste
        case V4L2_CID_CONTRAST:
        case V4L2_CID_SATURATION:
        case V4L2_CID_HUE:
+       case V4L2_CID_BG_COLOR:
                qctrl->flags |= V4L2_CTRL_FLAG_SLIDER;
                break;
        }

BG_COLOR is hardly a slider-like control! It's just a regular integer 
control.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
