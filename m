Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6GBHDtf003541
	for <video4linux-list@redhat.com>; Wed, 16 Jul 2008 07:17:14 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6GBGiDR019456
	for <video4linux-list@redhat.com>; Wed, 16 Jul 2008 07:17:00 -0400
Date: Wed, 16 Jul 2008 13:16:54 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
In-Reply-To: <20080716104506.GO6739@pengutronix.de>
Message-ID: <Pine.LNX.4.64.0807161305470.12100@axis700.grange>
References: <20080715135618.GE6739@pengutronix.de>
	<20080715140141.GG6739@pengutronix.de>
	<Pine.LNX.4.64.0807152224040.6361@axis700.grange>
	<20080716054922.GI6739@pengutronix.de>
	<20080716064336.GK6739@pengutronix.de>
	<Pine.LNX.4.64.0807160845450.11471@axis700.grange>
	<20080716091255.GM6739@pengutronix.de>
	<Pine.LNX.4.64.0807161117120.12100@axis700.grange>
	<20080716104506.GO6739@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

(list re-added)

On Wed, 16 Jul 2008, Sascha Hauer wrote:

> On Wed, Jul 16, 2008 at 11:24:17AM +0200, Guennadi Liakhovetski wrote:
> > On Wed, 16 Jul 2008, Sascha Hauer wrote:
> > 
> > > On Wed, Jul 16, 2008 at 09:19:44AM +0200, Guennadi Liakhovetski wrote:
> > > > 
> > > > There is one, and it is used during parameter negotiation. See 
> > > > SOCAM_MASTER and its use in mt9v022.c and pxa_camera.c, mt9m001 can only 
> > > > be a master (use internal clock), so, it is not including SOCAM_SLAVE in 
> > > > its supported mode flags. Isn't this enough? Do you really have to enforce 
> > > > the use of one or another clock, or is it enough to let the two drivers 
> > > > choose a supported configuration?
> > > 
> > > My camera supports a maximum clock input of 96MHz without PLL and a
> > > range of 16-27MHz with PLL. Say you want to use the PLL so you choose a
> > > clock input of 25MHz (in struct pxa_camera_platform_data). To what value
> > > do you adjust the PLL? The highest possible value of 96MHz is too fast
> > > for my long data lines.
> > 
> > Sorry, I do not quite understand the question. Are you asking what 
> > frequency I would select, or you're asking how to let the driver(s) 
> > configure the selected frequency?
> 
> My problem is that I do not have a way to specify the pixelclock for the
> sensor. I can specify the clock output of the pxa, but not the one from
> the sensor.
> 
> > 
> > > Well, I don't like the use of void pointers, too, but Specifying colour/bw
> > > directly does not solve the problem with the input clocks though. The
> > > gpio field in soc_camera_link is camera specific aswell, so I have the
> > > feeling that we end up adding more and more fields to soc_camera_link
> > > which are useful only for a few cameras.
> > 
> > So far we haven't decided, that we need to specify the frequency in camera 
> > configuration. Maybe we will need to add supported frequencies to 
> > parameter negotiation. In your case it would suffice, if the host-driver 
> > specified, that it wants to run at 25MHz, as configured by the platform 
> > data, then the camera driver can decide which modes (master / slave) it 
> > supports at _this_ frequency. Say, if you request 15 or 30MHz the driver 
> > will only report slave-mode.
> 
> I'm not talking about master/slave mode. My camera always works in
> master mode (meaning that it generates synchronization signals).
> 
> To make my point a bit more clear, my clock flow is as follows:
> 
> CIF_MCLK -> sensor PLL -> CIF_PCLK
> 
> I can specify CIF_MCLK via mclk_10khz, but the sensor driver has no idea
> to what frequency it has to adjust the PLL:
> 
> - The sensor can generate a maximum clock of 96MHz out of whatever input
>   clock thanks to its PLL
> - The pxa accepts a maximum clock of 26MHz
> - The user may want to limit the pixel clock to a lower value because of
>   long data lines.

Ok, _now_ I see your problem - you really have 2 clock frequencies, that 
can be configured independently... That's bad:-( And you think it's not 
worth it adding sensor type (colour vs. monochrome) _and_ clock frequency 
to the link struct because not many cameras will need them and other 
comeras might have other similarly "unique" properties, which, if all 
added to the link struct, would needlessly blow it up. Well, still, I 
would prefer putting these two directly into the link struct. But if you 
strongly disagree, I will accept a single void pointer to camera private 
config data in it too:-(

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
