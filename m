Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6G97GrA028671
	for <video4linux-list@redhat.com>; Wed, 16 Jul 2008 05:07:17 -0400
Received: from metis.extern.pengutronix.de (metis.extern.pengutronix.de
	[83.236.181.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6G973wH013451
	for <video4linux-list@redhat.com>; Wed, 16 Jul 2008 05:07:03 -0400
Date: Wed, 16 Jul 2008 11:12:55 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Message-ID: <20080716091255.GM6739@pengutronix.de>
References: <20080715135618.GE6739@pengutronix.de>
	<20080715140141.GG6739@pengutronix.de>
	<Pine.LNX.4.64.0807152224040.6361@axis700.grange>
	<20080716054922.GI6739@pengutronix.de>
	<20080716064336.GK6739@pengutronix.de>
	<Pine.LNX.4.64.0807160845450.11471@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807160845450.11471@axis700.grange>
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

On Wed, Jul 16, 2008 at 09:19:44AM +0200, Guennadi Liakhovetski wrote:
> On Wed, 16 Jul 2008, Sascha Hauer wrote:
> 
> > On Tue, Jul 15, 2008 at 10:43:53PM +0200, Guennadi Liakhovetski wrote:
> > > On Tue, 15 Jul 2008, Sascha Hauer wrote:
> > > 
> > > > Use a flag in struct soc_camera_link for differentiation between
> > > > a black/white and a colour camera rather than a module parameter.
> > > > This allows for having colour and black/white cameras in the same
> > > > system.
> > > > Note that this one breaks the phytec pcm027 pxa board as it makes it
> > > > impossible to switch between cameras on the command line. I will send
> > > > an updated version of this patch once I know this patch is acceptable
> > > > this way.
> > > 
> > > Yes, we did discuss this on IRC and I did agree to use a platform-provided 
> > > parameter to specify camera properties like colour / monochrome, but now 
> > > as I see it, I think, it might not be a very good idea. Having it as a 
> > > parameter you can just reload the driver with a different parameter to 
> > > test your colour camera in b/w mode. With this change you would need a new 
> > > kernel.
> > 
> > I think it's a more common case to specify the correct camera on a
> > per-board basis than to test a colour camera in b/w mode. Only
> > developers want to do this and they know how to start a new kernel,
> > right? ;)
> 
> Let me think: ker-nel... Yeah, I think, I've heard something about it 
> already...
> 
> But I can also imagine cases when end-users would benefit from this module 
> parameter: think about a company producing two cameras - one with colour 
> and one with bw sensor. With the module parameter they only have to 
> load drivers / the kernel differently, with platform data they have to 
> maintain two kernel versions. Unless they are smart enough and put those 
> cameras on different i2c addresses. But, ok, the current trend seems 
> indeed to be to specify such information in the platform data, even though 
> not only ISA drivers use module-parameters for this. Anyway, I'm flexible 
> about this:-) Let's do it.
> 
> > Another thing that came to my mind is that this particular camera has an
> > internal PLL for pixel clock generation. It can use the pxa pixel clock
> > directly or the one from the PLL.
> 
> Many CMOS cameras have this.
> 
> > At the moment there is no way to
> > specify which clock to use, so we might even want to add a pointer to a
> > camera specific struct to soc_camera_link. This would be the right place
> > to put colour/bw flags aswell.
> 
> There is one, and it is used during parameter negotiation. See 
> SOCAM_MASTER and its use in mt9v022.c and pxa_camera.c, mt9m001 can only 
> be a master (use internal clock), so, it is not including SOCAM_SLAVE in 
> its supported mode flags. Isn't this enough? Do you really have to enforce 
> the use of one or another clock, or is it enough to let the two drivers 
> choose a supported configuration?

My camera supports a maximum clock input of 96MHz without PLL and a
range of 16-27MHz with PLL. Say you want to use the PLL so you choose a
clock input of 25MHz (in struct pxa_camera_platform_data). To what value
do you adjust the PLL? The highest possible value of 96MHz is too fast
for my long data lines.

> 
> > Speaking of which, what's currently in pxa_camera_platform_data is
> > camera specific and not board specific (think of two cameras connected
> > to the pxa requiring two different clocks).
> 
> Yes, someone already suggested to make .power and .reset per camera: 
> http://marc.info/?t=120974473900009&r=1&w=2 and 
> http://marc.info/?t=121007886200003&r=1&w=2, but this work is not finished 
> yet - he wanted to resubmit his patches when his camera driver is ready.
> 
> > So soc_camera_link should
> > look something like:
> > 
> > struct soc_camera_link {
> > 	/* Camera bus id, used to match a camera and a bus */
> > 	int bus_id;
> > 	/* host specific data, i.e. struct pxa_camera_platform_data */
> > 	void *host_info;
> > 	/* camera specific info, i.e. struct mt9v022_data */
> > 	void *camera_info;
> > 	/* (de-)activate this camera. Can be left empty if only one camera is
> > 	 * connected to this bus. */
> > 	void (*activate)(struct soc_camera_link *, int);
> > };
> > 
> > I'm lucky, at the moment I have two identical cameras connected to my board
> > (besides the colour/bw thing)
> 
> Well, soc_camera_link is indeed per-sensor and we can and shall use it to 
> specify camera-specific platform parameters. So, I'm fine with moving 
> .power and .reset into it. Then you won't need your .activate any more,

Ok, I like 'power' better than 'activate', so I'll change it.

> right? As for the rest - I don't like too many void pointers... This 
> struct is for the platform to configure camera drivers. So, it should 
> contain _data_, not pointers to camera- and host-specific structs. If we 
> need to specify a colour / monochrome sensor, let's do this directly. But 
> without void pointers, please.

Well, I don't like the use of void pointers, too, but Specifying colour/bw
directly does not solve the problem with the input clocks though. The
gpio field in soc_camera_link is camera specific aswell, so I have the
feeling that we end up adding more and more fields to soc_camera_link
which are useful only for a few cameras.


> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> 

-- 
-- 
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
