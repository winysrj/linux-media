Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:36891 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab1LaLfe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 06:35:34 -0500
Date: Sat, 31 Dec 2011 13:35:29 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: v4l: how to get blanking clock count?
Message-ID: <20111231113529.GC3677@valkosipuli.localdomain>
References: <CAHG8p1Ao8UDuCytunFjvGZ1Ugd_xVU9cf_iXv6YjcRD41aMYtw@mail.gmail.com>
 <20111230213301.GA3677@valkosipuli.localdomain>
 <CAHG8p1ACi7CGFEBVaSr5G1cUMqtH8wX2mRY6n1yKF8TqgJ0oYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHG8p1ACi7CGFEBVaSr5G1cUMqtH8wX2mRY6n1yKF8TqgJ0oYw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Scott,

On Sat, Dec 31, 2011 at 02:57:31PM +0800, Scott Jiang wrote:
> 2011/12/31 Sakari Ailus <sakari.ailus@iki.fi>:
> > Hi Scott,
> >
> > On Fri, Dec 30, 2011 at 03:20:43PM +0800, Scott Jiang wrote:
> >> Hi Hans and Guennadi,
> >>
> >> Our bridge driver needs to know line clock count including active
> >> lines and blanking area.
> >> I can compute active clock count according to pixel format, but how
> >> can I get this in blanking area in current framework?
> >
> > Such information is not available currently over the V4L2 subdev interface.
> > Please see this patchset:
> >
> > <URL:http://www.spinics.net/lists/linux-media/msg41765.html>
> >
> > Patches 7 and 8 are probably the most interesting for you. This is an RFC
> > patchset so the final implementation could well still change.
> >
> Hi Sakari,
> 
> Thanks for your reply. Your patch added VBLANK and HBLANK control, but
> my case isn't a user control.
> That is to say, you can't specify a blanking control value for sensor.

I the case of your bridge, that may not be possible, but that's the only one
I've heard of so I think it's definitely a special case. In that case the
sensor driver can't be allowed to change the blanking periods while
streaming is ongoing.

framesamples proposed by Sylwester for v4l2_mbus_framefmt could, and
probably should, be exposed as a control with similar property.

> And you added pixel clock rate in mbus format, I think if I add two
> more parametres such as VBLANK lines and HBLANK clocks I can solve
> this problem. In fact, active lines and blanking lines are essential
> params to define an image.

Only the active lines and rows are, blanking period is just an idle period
where no image data is transferred. It does not affect the resulting image
in any way.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
