Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:43503 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab0IPLHs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 07:07:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: [Query] Is there a spec to request video sensor information?
Date: Thu, 16 Sep 2010 13:07:46 +0200
Cc: "Sakari Ailus" <sakari.ailus@maxwell.research.nokia.com>,
	"Aguirre, Sergio" <saaguirre@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Ivan Ivanov" <iivanov@mm-sol.com>
References: <A24693684029E5489D1D202277BE894472336FC3@dlee02.ent.ti.com> <201009161140.36383.laurent.pinchart@ideasonboard.com> <c41fd486bf84d84b14b316e9aed099f8.squirrel@webmail.xs4all.nl>
In-Reply-To: <c41fd486bf84d84b14b316e9aed099f8.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009161307.47464.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Thursday 16 September 2010 12:36:34 Hans Verkuil wrote:
> > On Monday 13 September 2010 19:06:20 Hans Verkuil wrote:
> >> On Monday, September 13, 2010 17:27:52 Sakari Ailus wrote:

[snip]

> >> > What we currently have is this, not in upstream:
> >> > 
> >> > ---
> >> > /* SMIA-type sensor information */
> >> > #define V4L2_CID_MODE_CLASS_BASE         (V4L2_CTRL_CLASS_MODE | 0x900)
> >> > #define V4L2_CID_MODE_CLASS              (V4L2_CTRL_CLASS_MODE | 1)
> >> > #define V4L2_CID_MODE_FRAME_WIDTH        (V4L2_CID_MODE_CLASS_BASE+1)
> >> > #define V4L2_CID_MODE_FRAME_HEIGHT       (V4L2_CID_MODE_CLASS_BASE+2)
> >> > #define V4L2_CID_MODE_VISIBLE_WIDTH      (V4L2_CID_MODE_CLASS_BASE+3)
> >> > #define V4L2_CID_MODE_VISIBLE_HEIGHT     (V4L2_CID_MODE_CLASS_BASE+4)
> >> > #define V4L2_CID_MODE_PIXELCLOCK         (V4L2_CID_MODE_CLASS_BASE+5)
> >> > #define V4L2_CID_MODE_SENSITIVITY        (V4L2_CID_MODE_CLASS_BASE+6)
> > 
> > ---
> > 
> >> > The pixel clock is read-only but some of the others should likely be
> >> > changeable.
> >> 
> >> It is very similar to the VIDIOC_G/S_DV_TIMINGS ioctls. I think we should
> >> look into adding an e.g. V4L2_DV_SMIA_SENSOR type or something along
> >> those lines.
> > 
> > I'm not sure if sensivity would fit in there. The rest probably would.
> > 
> >> I'm no sensor expert, so I don't know what sort of timing information is
> >> needed for the various sensor types. But I'm sure there are other people
> >> who have this knowledge. It would be useful if someone can list the
> >> information that you need from the various sensor types. Based on that
> >> we can see if this ioctl is a good fit.
> > 
> > Another possibility could be to report the information using the media
> > controller framework and an upcoming MEDIA_IOC_ENTITY_INFO ioctl.
> 
> Are you talking about timing information? That doesn't belong in the media
> framework. But I think I didn't quite understood what you meant here.

Driver need to report driver-specific entity information (such as extension 
unit GUIDs for the UVC driver for instance). The idea was to add a media 
controller ioctl for that. Sensor information could be reported using the same 
mechanism.

-- 
Regards,

Laurent Pinchart
