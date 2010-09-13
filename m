Return-path: <mchehab@pedra>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3418 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab0IMRGf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 13:06:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [Query] Is there a spec to request video sensor information?
Date: Mon, 13 Sep 2010 19:06:20 +0200
Cc: "Aguirre, Sergio" <saaguirre@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ivan Ivanov <iivanov@mm-sol.com>
References: <A24693684029E5489D1D202277BE894472336FC3@dlee02.ent.ti.com> <4C8E42F8.1080201@maxwell.research.nokia.com>
In-Reply-To: <4C8E42F8.1080201@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009131906.20757.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday, September 13, 2010 17:27:52 Sakari Ailus wrote:
> Aguirre, Sergio wrote:
> > Hi,
> 
> Hi Sergio,
> 
> > I was wondering if there exists a current standard way to query a
> > Imaging sensor driver for knowing things like the signal vert/horz blanking time.
> > 
> > In an old TI custom driver, we used to have a private IOCTL in the sensor
> > Driver we interfaced with the omap3 ISP, which was basically reporting:
> > 
> > - Active resolution (Actual image size)
> > - Full resolution (Above size + dummy pixel columns/rows representing blanking times)
> > 
> > However I resist to keep importing that custom interface, since I think its
> > Something that could be already part of an standard API.
> 
> The N900 sensor drivers currently use private controls for this purpose.
> That is an issue which should be resolved. I agree there should be a
> uniform, standard way to access this information.
> 
> What we currently have is this, not in upstream:
> 
> ---
> /* SMIA-type sensor information */
> #define V4L2_CID_MODE_CLASS_BASE                (V4L2_CTRL_CLASS_MODE |
> 0x900)
> #define V4L2_CID_MODE_CLASS                     (V4L2_CTRL_CLASS_MODE | 1)
> #define V4L2_CID_MODE_FRAME_WIDTH               (V4L2_CID_MODE_CLASS_BASE+1)
> #define V4L2_CID_MODE_FRAME_HEIGHT              (V4L2_CID_MODE_CLASS_BASE+2)
> #define V4L2_CID_MODE_VISIBLE_WIDTH             (V4L2_CID_MODE_CLASS_BASE+3)
> #define V4L2_CID_MODE_VISIBLE_HEIGHT            (V4L2_CID_MODE_CLASS_BASE+4)
> #define V4L2_CID_MODE_PIXELCLOCK                (V4L2_CID_MODE_CLASS_BASE+5)
> #define V4L2_CID_MODE_SENSITIVITY               (V4L2_CID_MODE_CLASS_BASE+6)
> ---
> 
> The pixel clock is read-only but some of the others should likely be
> changeable.

It is very similar to the VIDIOC_G/S_DV_TIMINGS ioctls. I think we should look
into adding an e.g. V4L2_DV_SMIA_SENSOR type or something along those lines.

I'm no sensor expert, so I don't know what sort of timing information is needed
for the various sensor types. But I'm sure there are other people who have this
knowledge. It would be useful if someone can list the information that you need
from the various sensor types. Based on that we can see if this ioctl is a good
fit.

Regards,

	Hans

> 
> Regards,
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
