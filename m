Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52216 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752789AbbBYN5P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2015 08:57:15 -0500
Date: Wed, 25 Feb 2015 15:57:11 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [REVIEW PATCH 3/3] smiapp: Use __v4l2_ctrl_grab() to grab
 controls
Message-ID: <20150225135711.GK6539@valkosipuli.retiisi.org.uk>
References: <1424867607-4082-1-git-send-email-sakari.ailus@iki.fi>
 <1424867607-4082-4-git-send-email-sakari.ailus@iki.fi>
 <54EDD216.9030806@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54EDD216.9030806@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, Feb 25, 2015 at 02:45:58PM +0100, Hans Verkuil wrote:
...
> > @@ -1535,15 +1529,15 @@ static int smiapp_set_stream(struct v4l2_subdev *subdev, int enable)
> >  	if (sensor->streaming == enable)
> >  		goto out;
> >  
> > -	if (enable) {
> > -		sensor->streaming = true;
> > +	if (enable)
> >  		rval = smiapp_start_streaming(sensor);
> > -		if (rval < 0)
> > -			sensor->streaming = false;
> > -	} else {
> > +	else
> >  		rval = smiapp_stop_streaming(sensor);
> > -		sensor->streaming = false;
> > -	}
> > +
> > +	sensor->streaming = enable;
> > +	__v4l2_ctrl_grab(sensor->hflip, enable);
> > +	__v4l2_ctrl_grab(sensor->vflip, enable);
> > +	__v4l2_ctrl_grab(sensor->link_freq, enable);
> 
> Just checking: is it really not possible to change these controls
> while streaming? Most devices I know of allow changing this on the fly.
> 
> If it is really not possible, then you can add my Ack for this series:

I'm not sure what the sensors would do in practice, but the problem is that
changing the values of these control affect the pixel order. That's why
changing them has been prevented while streaming.

Thanks for the ack!

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
