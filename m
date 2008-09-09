Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m897JxGW030035
	for <video4linux-list@redhat.com>; Tue, 9 Sep 2008 03:19:59 -0400
Received: from metis.extern.pengutronix.de (metis.extern.pengutronix.de
	[83.236.181.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m897JCDM001169
	for <video4linux-list@redhat.com>; Tue, 9 Sep 2008 03:19:12 -0400
Date: Tue, 9 Sep 2008 09:19:14 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Message-ID: <20080909071914.GC7126@pengutronix.de>
References: <20080905103917.GQ4941@pengutronix.de>
	<Pine.LNX.4.64.0809051330390.5482@axis700.grange>
	<20080908103441.GB6496@pengutronix.de>
	<Pine.LNX.4.64.0809081248360.4466@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0809081248360.4466@axis700.grange>
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

On Tue, Sep 09, 2008 at 08:38:55AM +0200, Guennadi Liakhovetski wrote:
> On Mon, 8 Sep 2008, Sascha Hauer wrote:
> 
> > On Fri, Sep 05, 2008 at 08:12:56PM +0200, Guennadi Liakhovetski wrote:
> > > 
> > > Hm, AFAIR, the reason was different. I was told, that "all" cameras 
> > > corrupt the first line, that's why that parameter has been introduced. I 
> > > don't think it was related to PXA270. In any case, why don't you just set 
> > > this parameter to whatever you need in your hist driver .add method, for 
> > > example, before calling camera's .init?
> > 
> > That's what I'm doing at the moment. I just had the feeling that there
> > is a bug fixed in the wrong place, but I did not know that it's the cameras
> > that corrupt the first line.
> > Anyway, what in case of bayer cameras? don't we have to skip the first
> > two lines then?
> 
> I think so, yes. Or you start with the wrong line in your user-space 
> application.
> 
> > I'm asking because I'm still struggling with getting the
> > correct pixel in the top left corner without introducing funny offsets.
> > This brings me back to the question: Which color does the top left
> > corner have? http://v4l2spec.bytesex.org/spec/r3735.htm says the first is a
> > blue/red line, due to y_skip_top=1 the pxa actually delivers a green/red
> > line
> 
> http://www.siliconimaging.com/RGB%20Bayer.htm shows a green/red line on 
> the top. But look in your camera datasheet - at least datasheets I was 
> working with did describe the specific pattern the camera was producing. 
> For example, mt9m001 also specifies green/red at the top.

Ah ok, so even the Micron chips are not consistent. I wonder whether we
should move the pictures in kernel so that they all have the same pixel
in the top left corner or introduce a second bayer fourcc then. It
doesn't seem practical that the userspace apps hold a database of camera
chips.

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
