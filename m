Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m88AYtu6004174
	for <video4linux-list@redhat.com>; Mon, 8 Sep 2008 06:34:56 -0400
Received: from metis.extern.pengutronix.de (metis.extern.pengutronix.de
	[83.236.181.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m88AYgBZ016735
	for <video4linux-list@redhat.com>; Mon, 8 Sep 2008 06:34:43 -0400
Date: Mon, 8 Sep 2008 12:34:41 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Message-ID: <20080908103441.GB6496@pengutronix.de>
References: <20080905103917.GQ4941@pengutronix.de>
	<Pine.LNX.4.64.0809051330390.5482@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0809051330390.5482@axis700.grange>
Cc: video4linux-list@redhat.com
Subject: Re: [soc-camera] about the y_skip_top parameter
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Fri, Sep 05, 2008 at 08:12:56PM +0200, Guennadi Liakhovetski wrote:
> On Fri, 5 Sep 2008, Sascha Hauer wrote:
> 
> > Hi all,
> > 
> > The y_skip_top parameter tells the cameras to effectively make the
> > picture one line higher. I think this parameter was introduced to work
> > around a bug in the pxa camera interface. The pxa refuses to read the
> > first line of a picture. The problem with this parameter is that it is
> > set to 1 in the sensor drivers and not in the pxa driver, so it's the
> > sensor drivers which work around a bug in the pxa. On other
> > hardware platforms (mx27 in this particular case) I cannot skip the
> > first line, so I think this parameter should be set to 1 in the pxa
> > driver and not the sensor drivers.
> > 
> > What do you think?
> 
> Hm, AFAIR, the reason was different. I was told, that "all" cameras 
> corrupt the first line, that's why that parameter has been introduced. I 
> don't think it was related to PXA270. In any case, why don't you just set 
> this parameter to whatever you need in your hist driver .add method, for 
> example, before calling camera's .init?

That's what I'm doing at the moment. I just had the feeling that there
is a bug fixed in the wrong place, but I did not know that it's the cameras
that corrupt the first line.
Anyway, what in case of bayer cameras? don't we have to skip the first
two lines then? I'm asking because I'm still struggling with getting the
correct pixel in the top left corner without introducing funny offsets.
This brings me back to the question: Which color does the top left
corner have? http://v4l2spec.bytesex.org/spec/r3735.htm says the first is a
blue/red line, due to y_skip_top=1 the pxa actually delivers a green/red
line

Sascha


-- 
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
