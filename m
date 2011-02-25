Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57105 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449Ab1BYK2c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Feb 2011 05:28:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH v2 1/3] v4l2-ctrls: change the boolean type of V4L2_CID_FOCUS_AUTO to menu type
Date: Fri, 25 Feb 2011 11:28:32 +0100
Cc: riverful.kim@samsung.com,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
References: <4D674A67.3000504@samsung.com> <201102251021.59847.laurent.pinchart@ideasonboard.com> <201102251054.02328.hverkuil@xs4all.nl>
In-Reply-To: <201102251054.02328.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102251128.32850.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday 25 February 2011 10:54:02 Hans Verkuil wrote:
> On Friday, February 25, 2011 10:21:59 Laurent Pinchart wrote:
> > On Friday 25 February 2011 07:21:27 Kim, HeungJun wrote:
> > > Support more modes of autofocus, it changes the type of
> > > V4L2_CID_FOCUS_AUTO from boolean to menu. And it includes 4 kinds of
> > > enumeration types:
> > > 
> > > V4L2_FOCUS_AUTO, V4L2_FOCUS_MANUAL, V4L2_FOCUS_MACRO,
> > > V4L2_FOCUS_CONTINUOUS
> > > 
> > > Signed-off-by: Heungjun Kim <riverful.kim@samsung.com>
> > > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > > ---
> > > 
> > >  drivers/media/video/v4l2-ctrls.c |   11 ++++++++++-
> > >  include/linux/videodev2.h        |    6 ++++++
> > >  2 files changed, 16 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/media/video/v4l2-ctrls.c
> > > b/drivers/media/video/v4l2-ctrls.c index 2412f08..0b1cce0 100644
> > > --- a/drivers/media/video/v4l2-ctrls.c
> > > +++ b/drivers/media/video/v4l2-ctrls.c
> > > @@ -197,6 +197,13 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
> > > 
> > >  		"Aperture Priority Mode",
> > >  		NULL
> > >  	
> > >  	};
> > > 
> > > +	static const char * const camera_focus_auto[] = {
> > > +		"Manual Mode",
> > > +		"Auto Mode",
> > > +		"Macro Mode",
> > > +		"Continuous Mode",
> > 
> > This might be nit-picking, but maybe the menu entries should be named
> > "Manual Focus", "Auto Focus", "Macro Focus" and "Continuous Auto Focus".
> > Hans ?
> 
> Yes, that's better. Although I believe that it should be 'Macro Auto
> Focus', right?

I suppose so. Heungjun could confirm that.

> But if we change this for 'focus' then we need to do the same for the auto
> exposure menu which currently also uses the term 'Mode'.
> 
> Do you agree?

Auto Mode and Manual Mode could be renamed to Auto Exposure and Manual 
Exposure, but Shutter Priority Exposure and Aperture Priority Exposure don't 
sound right.

-- 
Regards,

Laurent Pinchart
