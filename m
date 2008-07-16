Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6G6c1Ck024089
	for <video4linux-list@redhat.com>; Wed, 16 Jul 2008 02:38:01 -0400
Received: from metis.extern.pengutronix.de (metis.extern.pengutronix.de
	[83.236.181.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6G6biMV005947
	for <video4linux-list@redhat.com>; Wed, 16 Jul 2008 02:37:49 -0400
Date: Wed, 16 Jul 2008 08:43:36 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Message-ID: <20080716064336.GK6739@pengutronix.de>
References: <20080715135618.GE6739@pengutronix.de>
	<20080715140141.GG6739@pengutronix.de>
	<Pine.LNX.4.64.0807152224040.6361@axis700.grange>
	<20080716054922.GI6739@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080716054922.GI6739@pengutronix.de>
Cc: video4linux-list@redhat.com
Subject: Re: PATCH: soc-camera: use flag for colour / bw camera instead of
	module parameter
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

On Wed, Jul 16, 2008 at 07:49:22AM +0200, Sascha Hauer wrote:
> On Tue, Jul 15, 2008 at 10:43:53PM +0200, Guennadi Liakhovetski wrote:
> > On Tue, 15 Jul 2008, Sascha Hauer wrote:
> > 
> > > Use a flag in struct soc_camera_link for differentiation between
> > > a black/white and a colour camera rather than a module parameter.
> > > This allows for having colour and black/white cameras in the same
> > > system.
> > > Note that this one breaks the phytec pcm027 pxa board as it makes it
> > > impossible to switch between cameras on the command line. I will send
> > > an updated version of this patch once I know this patch is acceptable
> > > this way.
> > 
> > Yes, we did discuss this on IRC and I did agree to use a platform-provided 
> > parameter to specify camera properties like colour / monochrome, but now 
> > as I see it, I think, it might not be a very good idea. Having it as a 
> > parameter you can just reload the driver with a different parameter to 
> > test your colour camera in b/w mode. With this change you would need a new 
> > kernel.
> 
> I think it's a more common case to specify the correct camera on a
> per-board basis than to test a colour camera in b/w mode. Only
> developers want to do this and they know how to start a new kernel,
> right? ;)
> Another thing that came to my mind is that this particular camera has an
> internal PLL for pixel clock generation. It can use the pxa pixel clock
> directly or the one from the PLL. At the moment there is no way to
> specify which clock to use, so we might even want to add a pointer to a
> camera specific struct to soc_camera_link. This would be the right place
> to put colour/bw flags aswell.

Speaking of which, what's currently in pxa_camera_platform_data is
camera specific and not board specific (think of two cameras connected
to the pxa requiring two different clocks). So soc_camera_link should
look something like:

struct soc_camera_link {
	/* Camera bus id, used to match a camera and a bus */
	int bus_id;
	/* host specific data, i.e. struct pxa_camera_platform_data */
	void *host_info;
	/* camera specific info, i.e. struct mt9v022_data */
	void *camera_info;
	/* (de-)activate this camera. Can be left empty if only one camera is
	 * connected to this bus. */
	void (*activate)(struct soc_camera_link *, int);
};

I'm lucky, at the moment I have two identical cameras connected to my board
(besides the colour/bw thing)

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
