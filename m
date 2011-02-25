Return-path: <mchehab@pedra>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3132 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932427Ab1BYJyO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Feb 2011 04:54:14 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC PATCH v2 1/3] v4l2-ctrls: change the boolean type of V4L2_CID_FOCUS_AUTO to menu type
Date: Fri, 25 Feb 2011 10:54:02 +0100
Cc: riverful.kim@samsung.com,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
References: <4D674A67.3000504@samsung.com> <201102251021.59847.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201102251021.59847.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102251054.02328.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday, February 25, 2011 10:21:59 Laurent Pinchart wrote:
> On Friday 25 February 2011 07:21:27 Kim, HeungJun wrote:
> > Support more modes of autofocus, it changes the type of V4L2_CID_FOCUS_AUTO
> > from boolean to menu. And it includes 4 kinds of enumeration types:
> > 
> > V4L2_FOCUS_AUTO, V4L2_FOCUS_MANUAL, V4L2_FOCUS_MACRO, V4L2_FOCUS_CONTINUOUS
> > 
> > Signed-off-by: Heungjun Kim <riverful.kim@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  drivers/media/video/v4l2-ctrls.c |   11 ++++++++++-
> >  include/linux/videodev2.h        |    6 ++++++
> >  2 files changed, 16 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/media/video/v4l2-ctrls.c
> > b/drivers/media/video/v4l2-ctrls.c index 2412f08..0b1cce0 100644
> > --- a/drivers/media/video/v4l2-ctrls.c
> > +++ b/drivers/media/video/v4l2-ctrls.c
> > @@ -197,6 +197,13 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
> >  		"Aperture Priority Mode",
> >  		NULL
> >  	};
> > +	static const char * const camera_focus_auto[] = {
> > +		"Manual Mode",
> > +		"Auto Mode",
> > +		"Macro Mode",
> > +		"Continuous Mode",
> 
> This might be nit-picking, but maybe the menu entries should be named "Manual 
> Focus", "Auto Focus", "Macro Focus" and "Continuous Auto Focus". Hans ?

Yes, that's better. Although I believe that it should be 'Macro Auto Focus',
right?

But if we change this for 'focus' then we need to do the same for the auto
exposure menu which currently also uses the term 'Mode'.

Do you agree?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
