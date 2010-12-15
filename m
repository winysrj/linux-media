Return-path: <mchehab@gaivota>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1997 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab0LOH5e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Dec 2010 02:57:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: What if add enumerations at the V4L2_FOCUS_MODE_AUTO?
Date: Wed, 15 Dec 2010 08:57:29 +0100
Cc: riverful.kim@samsung.com,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org
References: <201012150119.43918.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201012150119.43918.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="euc-kr"
Content-Transfer-Encoding: 7bit
Message-Id: <201012150857.29099.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Wednesday, December 15, 2010 01:19:43 Laurent Pinchart wrote:
> Hi,
> 
> (CC'ing linux-media this time, please discard the previous mail)
> 
> On Tuesday 14 December 2010 12:27:32 Kim, HeungJun wrote:
> > Hi Laurent and Hans,
> > 
> > I am working on V4L2 subdev for M5MOLS by Fujitsu.
> > and I wanna listen your comments about Auto Focus mode of my ideas.
> > the details is in the following link discussed at the past.
> > Although the situation(adding the more various functions at the M5MOLS
> > or any other MEGA camera sensor, I worked.)is changed,
> > so I wanna continue this threads for now.
> > 
> > http://www.mail-archive.com/linux-media@vger.kernel.org/msg03543.html
> > 
> > First of all, the at least two more mode of auto-focus exists in the
> > M5MOLS camera sensor. So, considering defined V4L2 controls and the
> > controls in the M5MOLS, I suggest like this:
> > 
> > +enum  v4l2_focus_auto_type {
> > +	V4L2_FOCUS_AUTO_NORMAL = 0,
> > +	V4L2_FOCUS_AUTO_MACRO = 1,
> > +	V4L2_FOCUS_AUTO_POSITION = 2,
> > +};
> > +#define V4L2_CID_FOCUS_POSITION			(V4L2_CID_CAMERA_CLASS_BASE+13)
> > 
> > -#define V4L2_CID_ZOOM_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+13)
> > -#define V4L2_CID_ZOOM_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+14)
> > +#define V4L2_CID_ZOOM_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+14)
> > +#define V4L2_CID_ZOOM_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+15)
> > 
> > 
> > The M5MOLS(or other recent camera sensor) can have at least 2 mode although
> > in any cases : *MACRO* and *NORMAL* mode. plus, M5MOLS supports
> > positioning focus mode, AKA. POSITION AF mode.
> > 
> > The MACRO mode scan short range, and this mode can be used at the
> > circumstance in the short distance with object and camera lens. So, It has
> > fast lens movement, but the command FOCUSING dosen't works well at the
> > long distance object.
> > 
> > On the other hand, NORMAL mode can this. As the words, It's general and
> > normal focus mode. The M5MOLS scan fully in the mode.
> > 
> > In the Position AF mode, the position(expressed x,y) is given at the
> > M5MOLS, and then the M5MOLS focus this area. But, the time given the
> > position, is normally touch the lcd screen at the mobile device, in my
> > case. If the time is given from button, it's no big problem *when*. But,
> > in touch-lcd screen case, the position is read at the touch screen driver,
> > before command FOCUS to camera sensor. It's the why I add another
> > CID(V4L2_CID_FOCUS_POSITION).
> 
> I'm pretty sure that some devices would require a rectangle instead of 
> coordinates to define the focus point. Even a rectangle might not be enough. 
> It would help if we could get feedback from camera designers here.
> 
> Hans, should we add a new control type to pass coordinates/rectangles ? :-)

It's a bit tricky actually since QUERYCTRL can return only one set of min/max
values. For coordinates/rectangles we need two sets (horizontal and vertical).

And I think it is important to know the min/max values.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
