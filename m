Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m896UoLf018117
	for <video4linux-list@redhat.com>; Tue, 9 Sep 2008 02:30:50 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m896UXPo010274
	for <video4linux-list@redhat.com>; Tue, 9 Sep 2008 02:30:33 -0400
Date: Tue, 9 Sep 2008 08:38:55 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
In-Reply-To: <20080908103441.GB6496@pengutronix.de>
Message-ID: <Pine.LNX.4.64.0809081248360.4466@axis700.grange>
References: <20080905103917.GQ4941@pengutronix.de>
	<Pine.LNX.4.64.0809051330390.5482@axis700.grange>
	<20080908103441.GB6496@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

On Mon, 8 Sep 2008, Sascha Hauer wrote:

> On Fri, Sep 05, 2008 at 08:12:56PM +0200, Guennadi Liakhovetski wrote:
> > 
> > Hm, AFAIR, the reason was different. I was told, that "all" cameras 
> > corrupt the first line, that's why that parameter has been introduced. I 
> > don't think it was related to PXA270. In any case, why don't you just set 
> > this parameter to whatever you need in your hist driver .add method, for 
> > example, before calling camera's .init?
> 
> That's what I'm doing at the moment. I just had the feeling that there
> is a bug fixed in the wrong place, but I did not know that it's the cameras
> that corrupt the first line.
> Anyway, what in case of bayer cameras? don't we have to skip the first
> two lines then?

I think so, yes. Or you start with the wrong line in your user-space 
application.

> I'm asking because I'm still struggling with getting the
> correct pixel in the top left corner without introducing funny offsets.
> This brings me back to the question: Which color does the top left
> corner have? http://v4l2spec.bytesex.org/spec/r3735.htm says the first is a
> blue/red line, due to y_skip_top=1 the pxa actually delivers a green/red
> line

http://www.siliconimaging.com/RGB%20Bayer.htm shows a green/red line on 
the top. But look in your camera datasheet - at least datasheets I was 
working with did describe the specific pattern the camera was producing. 
For example, mt9m001 also specifies green/red at the top.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
