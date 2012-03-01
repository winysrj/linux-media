Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42150 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965273Ab2CAWaA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2012 17:30:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH/RFC][DRAFT] V4L: Add camera auto focus controls
Date: Thu, 01 Mar 2012 23:30:16 +0100
Message-ID: <1441235.tcAt0gpJAF@avalon>
In-Reply-To: <4F4A6493.1080004@gmail.com>
References: <1326749622-11446-1-git-send-email-sylvester.nawrocki@gmail.com> <4F4A6493.1080004@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Sunday 26 February 2012 17:57:55 Sylwester Nawrocki wrote:
> On 01/16/2012 10:33 PM, Sylwester Nawrocki wrote:
> > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > index 012a296..0808b12 100644
> > --- a/include/linux/videodev2.h
> > +++ b/include/linux/videodev2.h
> > @@ -1662,6 +1662,34 @@ enum  v4l2_exposure_auto_type {
> > 
> >   #define V4L2_CID_IRIS_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+17)
> >   #define V4L2_CID_IRIS_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+18)
> > 
> > +#define V4L2_CID_AUTO_FOCUS_START		(V4L2_CID_CAMERA_CLASS_BASE+19)
> > +#define V4L2_CID_AUTO_FOCUS_STOP		(V4L2_CID_CAMERA_CLASS_BASE+20)
> > +#define V4L2_CID_AUTO_FOCUS_STATUS		(V4L2_CID_CAMERA_CLASS_BASE+21)
> > +enum v4l2_auto_focus_status {
> > +	V4L2_AUTO_FOCUS_STATUS_IDLE		= 0,
> > +	V4L2_AUTO_FOCUS_STATUS_BUSY		= 1,
> > +	V4L2_AUTO_FOCUS_STATUS_SUCCESS		= 2,
> > +	V4L2_AUTO_FOCUS_STATUS_FAIL		= 3,
> > +};
> > +
> > +#define V4L2_CID_AUTO_FOCUS_DISTANCE		(V4L2_CID_CAMERA_CLASS_BASE+22)
> > +enum v4l2_auto_focus_distance {
> > +	V4L2_AUTO_FOCUS_DISTANCE_NORMAL		= 0,
> > +	V4L2_AUTO_FOCUS_DISTANCE_MACRO		= 1,
> > +	V4L2_AUTO_FOCUS_DISTANCE_INFINITY	= 2,
> > +};
> > +
> > +#define V4L2_CID_AUTO_FOCUS_SELECTION		
(V4L2_CID_CAMERA_CLASS_BASE+23)
> > +enum v4l2_auto_focus_selection {
> > +	V4L2_AUTO_FOCUS_SELECTION_NORMAL	= 0,
> > +	V4L2_AUTO_FOCUS_SELECTION_SPOT		= 1,
> > +	V4L2_AUTO_FOCUS_SELECTION_RECTANGLE	= 2,
> > +};
> 
> I'd like to ask your advice, I've found those two above controls
> rather painful in use. After changing V4L2_CID_AUTO_FOCUS_SELECTION to
> 
> #define V4L2_CID_AUTO_FOCUS_AREA		(V4L2_CID_CAMERA_CLASS_BASE+23)
> enum v4l2_auto_focus_selection {
> 	V4L2_AUTO_FOCUS_SELECTION_ALL		= 0,
> 	V4L2_AUTO_FOCUS_SELECTION_SPOT		= 1,
> 	V4L2_AUTO_FOCUS_SELECTION_RECTANGLE	= 2,
> };
> 
> I tried use them with the M-5MOLS sensor driver where there is only
> one register for setting following automatic focus modes:
> 
> NORMAL AUTO (single-shot),
> MACRO,
> INFINITY,
> SPOT,
> FACE_DETECTION
> 
> The issue is that when V4L2_CID_AUTO_FOCUS_AREA is set to for example
> V4L2_AUTO_FOCUS_SELECTION_SPOT, none of the menu entries of
> V4L2_CID_AUTO_FOCUS_DISTANCE is valid.
> 
> So it would really be better to use single control for automatic focus
> mode. A private control could handle that. But there will be more than
> one sensor driver needing such a control, so I thought about an
> additional header, e.g. samsung_camera.h in include/linux/ that would
> define reguired control IDs and menus in the camera class private id
> range.
> 
> What do you think about it ?

One option would be to disable the focus area control when the focus distance 
is set to a value different than normal (or the other way around). Control 
change events could be used to report that to userspace. Would that work with 
your hardware ?

-- 
Regards,

Laurent Pinchart

