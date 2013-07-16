Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33787 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755071Ab3GPX6L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jul 2013 19:58:11 -0400
Date: Wed, 17 Jul 2013 02:58:05 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Thomas Vajzovic <thomas.vajzovic@irisys.co.uk>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: MT9D131 context switching [was RE: width and height of JPEG
 compressed images]
Message-ID: <20130716235805.GA11369@valkosipuli.retiisi.org.uk>
References: <A683633ABCE53E43AFB0344442BF0F05361689EE@server10.irisys.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A683633ABCE53E43AFB0344442BF0F05361689EE@server10.irisys.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thomas,

On Mon, Jul 15, 2013 at 09:30:33AM +0000, Thomas Vajzovic wrote:
> Hi Sylwester,
> 
> On 10 July 2013 20:44 Sylwester Nawrocki wrote:
> >On 07/07/2013 10:18 AM, Thomas Vajzovic wrote:
> >> On 06 July 2013 20:58 Sylwester Nawrocki wrote:
> >>> On 07/05/2013 10:22 AM, Thomas Vajzovic wrote:
> >>>>
> >>>> I am writing a driver for the sensor MT9D131.
> >
> > As a side note, looking at the MT9D131 sensor datasheet I can see it
> > has preview (Mode A) and capture (Mode B) modes. Are you also
> > planning adding proper support for switching between those modes ?
> > I'm interested in supporting this in standard way in V4L2, as lot's
> > of sensors I have been working with also support such modes.
> 
> This camera has more like three modes:
> 
> 
> preview (context A) up to 800x600, up to 30fps, YUV/RGB
> 
> capture video (context B) up to 1600x1200, up to 15fps, YUV/RGB/JPEG
> 
> capture stills (context B) up to 1600x1200,
> sequence of 1 or more frames with no fixed timing, YUV/RGB/JPEG
> 
> 
> I have implemented switching between the first two of these, but the
> choice is forced by the framerate, resolution and format that the user
> requests, so I have not exposed any interface to change the context,
> the driver just chooses the one that can do what the user wants.
> 
> As for the third mode, I do not currently plan to implement it, but
> if I was going to then I think the only API that would be required
> is V4L2_MODE_HIGHQUALITY in v4l2_captureparm.capturemode.

Is there a practical difference in video and still capture in this case?

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
