Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1EAGIrN030816
	for <video4linux-list@redhat.com>; Thu, 14 Feb 2008 05:16:18 -0500
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.181])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1EAFvYn025038
	for <video4linux-list@redhat.com>; Thu, 14 Feb 2008 05:15:57 -0500
Received: by wa-out-1112.google.com with SMTP id j37so509040waf.7
	for <video4linux-list@redhat.com>; Thu, 14 Feb 2008 02:15:56 -0800 (PST)
Message-ID: <f17812d70802140215p2582fdack595b9e2a2ad9c8b8@mail.gmail.com>
Date: Thu, 14 Feb 2008 18:15:56 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0802140826260.4016@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802051830360.5882@axis700.grange>
	<20080211114129.GA10482@flint.arm.linux.org.uk>
	<Pine.LNX.4.64.0802111440230.4440@axis700.grange>
	<f17812d70802122120r3f8f2c29qa70342d1bda75658@mail.gmail.com>
	<Pine.LNX.4.64.0802131346170.6252@axis700.grange>
	<f17812d70802131807o79dfa71r23f73f827fa49ea1@mail.gmail.com>
	<Pine.LNX.4.64.0802140826260.4016@axis700.grange>
Cc: video4linux-list@redhat.com,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2/6] V4L2 soc_camera driver for PXA27x processors
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

On Thu, Feb 14, 2008 at 3:43 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Thu, 14 Feb 2008, eric miao wrote:
>
>  > readability, compare:
>  >
>  >     DRCMR68 = dma_chan_y | DRCMR_MAPVLD;
>  >
>  > and
>  >
>  >     DRCMR(drcmr_y) = dma_chan_y | DRCMR_MAPVLD;
>  >
>  > And another thing if you take a look into pxa-regs.h about those DRCMRx
>  > register definitions, it's currently a mess. People uses different ways to
>  > reference DRCMR
>  >
>  > 1. DRCMRxx directly, like in your driver
>  > 2. DRCMRRXSSDR - named DRCMR register
>  > 3. DRCMR(xx)
>  >
>  > among these three, I like DRCMR(x) best for the reason I have stated
>  > above. Now most drivers are moving toward that way, once we get
>  > all those reference to DRCMR fixed, we will only define one macro
>  >
>  > DRCMR(xx) and remove all DRCMRxx and DRCMRXXXXX
>
>  Ah, sure, sorry, misunderstood you the first time. Will replace.
>
>
>  > > > 3. by using only Y dma channel, the driver is dropping the capability
>  > > > of the hardware to convert interleaved YCbCr data to planar format,
>  > > > what is your plan for that capability?
>  > >
>  > > This driver so far presents what I had to implement and what I could test.
>  > > I didn't have any YCbCr cameras, so, as long as someone gets a task of
>  > > supporting them and the necessary hardware, it'll have to be implemented
>  > > too. I guess, what I could do now at most, is look in the datasheet and
>  > > see if I can prepare the driver to facilitate those future extensions.
>  > >
>  >
>  > I have boards with YCbCr sensors here, yet I don't know if I will have
>  > time to test this :-(. So yes, you may prepare for that, and let's see
>  > if we can extend that.
>
>  Well, as I do not have access to any of this hardware, I would prefer to
>  first commit the driver without any support for these, and then review
>  patches for them separately. How does this sound?
>

fair enough.

>
>  > > example in my case, the platform supported 8 and 10 bit modes, and a
>  > > method to dynamically switch between those. So, my .flags look like
>  > >
>  > > +       .flags  = PXA_CAMERA_MASTER | PXA_CAMERA_DATAWIDTH_8 | PXA_CAMERA_DATAWIDTH_10 |
>  > > +               PXA_CAMERA_PCLK_EN | PXA_CAMERA_MCLK_EN,
>  > >
>  > > (see the [PATCH 6/6]). And the switching is transparent - it is activated
>  > > upon setting of an 8- or 16-bit pixel format.
>  > >
>  >
>  > Mmm... this is really cool. I didn't know any sensor that needs width
>  > change at run-time. Usually, it's fixed. Two common types of sensors:
>  >
>  > 1. YCbCr sensors - usually comes with 8-bit interleaved pixel format
>  > and
>  > 2. raw sensors - usually comes with 10-bit RGGB output
>  >
>  > There are some smart sensors with different output protocol, but
>  > most of them I know mimics the YCbCr output, except for JPEG,
>  > which is usually specially handled.
>  >
>  > So I'm really curious what exact sensor you are using?
>
>  Ok, I'm not going to disclose any secrets, if I just point you to the
>  patch-series:-) If you looked at it, you would see, that both cameras I
>  submitted with it are normal raw 10-bit cameras. And they just use an
>  external I2C GPIO extender to switch to 8 bits. And the discovery is again
>  performed based upon the platform data.
>
>
>  > One sensor at any given time, Yes. The QCI can handle only _one_
>  > sensor, the others are just put to idle and disconnected. Usually, the
>  > switching is controlled by external analog switch, for example. And
>  > this is common requirement, say when one needs one sensor for
>  > high resolution and another one for low resolution, as commonly
>  > seen on high-end mobile devices.
>  >
>  > The connections might or might not be same. So it would be nice
>  > if the sensor can provide output format information to the camera driver.
>  >
>  > Switching of sensors is board specific, so the platform data should
>  > really provide some kind of switching callback functions if possible.
>
>  Yeah, this is going to be a mess... Currently to set a specific video
>  format an ioctl is passed from the v4l2 layer to the video driver, which
>  is in this case the soc_camera.c. This then calls back into the camera
>  driver and into the interface driver (pxa_camera.c). Now we'll have to
>  also call back into the platform code... Wow.
>
>  But, I think, we'll have to do it differently. The two cameras you mention
>  are two separate video-devices with my framework. So, the application will
>  have to go to /dev/video1 from /dev/video0. And, perhaps, the camera
>  driver (not the interface driver, like pxa-camera) will have to call back
>  into the platform layer to activate the respective controller. How does
>  this sound?
>

Yeah, I personally like the idea of having /dev/video0 and /dev/video1 for
the two sensors, and the pxa_camera.c makes sure they will be opened
exclusively.

>  Thanks
>  Guennadi
>  ---
>  Guennadi Liakhovetski
>



-- 
Cheers
- eric

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
