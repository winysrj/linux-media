Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:58066 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755834AbZDFLvq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Apr 2009 07:51:46 -0400
From: "Shah, Hardik" <hardik.shah@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Jadav, Brijesh R" <brijesh.j@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>
Date: Mon, 6 Apr 2009 17:21:10 +0530
Subject: RE: [PATCH 2/3] New V4L2 CIDs for OMAP class of Devices.
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB02FB102FD4@dbde02.ent.ti.com>
In-Reply-To: <200903301358.40555.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
Please find my comments inline.

Regards,
Hardik Shah

> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Monday, March 30, 2009 5:29 PM
> To: Shah, Hardik
> Cc: linux-media@vger.kernel.org; linux-omap@vger.kernel.org; Jadav, Brijesh R;
> Hiremath, Vaibhav
> Subject: Re: [PATCH 2/3] New V4L2 CIDs for OMAP class of Devices.
> 
> On Friday 20 March 2009 06:19:57 Hardik Shah wrote:
> > Added V4L2_CID_BG_COLOR for background color setting.
> > Added V4L2_CID_ROTATION for rotation setting.
> > Above two ioclts are indepth discussed. Posting
> > again with the driver usage.
> >
> > ---
> >  linux/drivers/media/video/v4l2-common.c |    7 +++++++
> >  linux/include/linux/videodev2.h         |    6 +++++-
> >  2 files changed, 12 insertions(+), 1 deletions(-)
> >
> > diff --git a/linux/drivers/media/video/v4l2-common.c
> b/linux/drivers/media/video/v4l2-common.c
> > index 3c42316..fa408f0 100644
> > --- a/linux/drivers/media/video/v4l2-common.c
> > +++ b/linux/drivers/media/video/v4l2-common.c
> > @@ -422,6 +422,8 @@ const char *v4l2_ctrl_get_name(u32 id)
> >  	case V4L2_CID_CHROMA_AGC:		return "Chroma AGC";
> >  	case V4L2_CID_COLOR_KILLER:		return "Color Killer";
> >  	case V4L2_CID_COLORFX:			return "Color Effects";
> > +	case V4L2_CID_ROTATION:                 return "Rotation";
> 
> I'm having second thoughts about this name. I think V4L2_CID_ROTATE is better,
> since it is an action ('you rotate an image') rather than a status ('what is
> the rotation of an image').
> 
> What do you think?
[Shah, Hardik] Yes, it should be V4L2_CID_ROTATE as V4L2_CID_HFLIP.
> 
> > +	case V4L2_CID_BG_COLOR:                 return "Background color";
> >
> >  	/* MPEG controls */
> >  	case V4L2_CID_MPEG_CLASS: 		return "MPEG Encoder Controls";
> > @@ -547,6 +549,10 @@ int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl,
> s32 min, s32 max, s32 ste
> >  		qctrl->flags |= V4L2_CTRL_FLAG_READ_ONLY;
> >  		min = max = step = def = 0;
> >  		break;
> > +	case V4L2_CID_BG_COLOR:
> > +		 qctrl->type = V4L2_CTRL_TYPE_INTEGER;
> > +		 step = 1;
> > +		 break;
> 
> Set the min to 0 and max to 0xffffff.
[Shah, Hardik] Added
> 
> >  	default:
> >  		qctrl->type = V4L2_CTRL_TYPE_INTEGER;
> >  		break;
> > @@ -571,6 +577,7 @@ int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl,
> s32 min, s32 max, s32 ste
> >  	case V4L2_CID_BLUE_BALANCE:
> >  	case V4L2_CID_GAMMA:
> >  	case V4L2_CID_SHARPNESS:
> > +	case V4L2_CID_BG_COLOR:
> 
> This definitely isn't a slider control.
[Shah, Hardik] Removed
> 
> > --
> > 1.5.6
> 
> Regards,
> 
> 	Hans
> 
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG

