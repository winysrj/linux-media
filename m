Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:40980 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab2APNEg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 08:04:36 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Oliver Neukum <oneukum@suse.de>
Subject: Re: [RFC PATCH 1/3] v4l2-ctrls: fix ugly control name.
Date: Mon, 16 Jan 2012 14:04:23 +0100
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org,
	Jiri Kosina <jkosina@suse.cz>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1326716960-4424-1-git-send-email-hverkuil@xs4all.nl> <4f4e18b94612a34be98e2304a4d9b0cef74acd39.1326716517.git.hans.verkuil@cisco.com> <201201161400.00203.oneukum@suse.de>
In-Reply-To: <201201161400.00203.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201161404.23328.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 16 January 2012 14:00:00 Oliver Neukum wrote:
> Am Montag, 16. Januar 2012, 13:29:18 schrieb Hans Verkuil:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> > 
> >  drivers/media/video/v4l2-ctrls.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/media/video/v4l2-ctrls.c
> > b/drivers/media/video/v4l2-ctrls.c index da1f4c2..35316f9 100644
> > --- a/drivers/media/video/v4l2-ctrls.c
> > +++ b/drivers/media/video/v4l2-ctrls.c
> > @@ -588,7 +588,7 @@ const char *v4l2_ctrl_get_name(u32 id)
> > 
> >  	case V4L2_CID_PILOT_TONE_ENABLED:	return "Pilot Tone Feature 
Enabled";
> >  	case V4L2_CID_PILOT_TONE_DEVIATION:	return "Pilot Tone Deviation";
> >  	case V4L2_CID_PILOT_TONE_FREQUENCY:	return "Pilot Tone Frequency";
> > 
> > -	case V4L2_CID_TUNE_PREEMPHASIS:		return "Pre-emphasis 
settings";
> > +	case V4L2_CID_TUNE_PREEMPHASIS:		return "Pre-Emphasis";
> > 
> >  	case V4L2_CID_TUNE_POWER_LEVEL:		return "Tune Power Level";
> >  	case V4L2_CID_TUNE_ANTENNA_CAPACITOR:	return "Tune Antenna 
Capacitor";
> 
> This looks like generic code. What happens if a programm is looking for
> this string?

User space can't rely on the name being constant. Perhaps in the future
they can but not at the moment.

Regards,

	Hans
