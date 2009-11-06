Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51490 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752868AbZKFOLl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Nov 2009 09:11:41 -0500
Date: Fri, 6 Nov 2009 15:11:55 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Antonio Ospite <ospite@studenti.unina.it>
cc: linux-arm-kernel@lists.infradead.org,
	Eric Miao <eric.y.miao@gmail.com>,
	openezx-devel@lists.openezx.org, Bart Visscher <bartv@thisnet.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3 v2] ezx: Add camera support for A780 and A910 EZX
 phones
In-Reply-To: <20091105234429.ef855e2d.ospite@studenti.unina.it>
Message-ID: <Pine.LNX.4.64.0911061419220.4389@axis700.grange>
References: <f17812d70911040119g6eb1f254pa78dd8519afef61d@mail.gmail.com>
 <1257367650-15056-1-git-send-email-ospite@studenti.unina.it>
 <Pine.LNX.4.64.0911050040160.4837@axis700.grange>
 <20091105234429.ef855e2d.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 5 Nov 2009, Antonio Ospite wrote:

> On Thu, 5 Nov 2009 00:53:46 +0100 (CET)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
> > On Wed, 4 Nov 2009, Antonio Ospite wrote:
> > 
> > > Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
> > > Signed-off-by: Bart Visscher <bartv@thisnet.nl>
> > 
> > Is this patch going via Bart? Or should this be an Acked-by?
> >
> 
> Bart did the initial research and wrote a first, partially working,
> version of the patch for A780, then I made it work and refactored it,
> adding code for A910. So I put two SOBs here as we are both the
> authors, in a sense.

Then, I think, his Sob should be the first.

> > > Changes since previous version:
> > >   Addressed all the comments from Eric and Guennadi.
> > 
> > I said I still wanted to have a better look at it, so, basically, I just 
> > think you have a typo in two comments:
> >
> 
> Or the code is wrong, even if it works :)
> Let's sort this out.
> 
> [...] 
> > > +/* camera */
> > > +static int a780_pxacamera_init(struct device *dev)
> > > +{
> > > +	int err;
> > > +
> > > +	/*
> > > +	 * GPIO50_nCAM_EN is active low
> > > +	 * GPIO19_GEN1_CAM_RST is active high
> > > +	 */
> > > +	err = gpio_request(GPIO50_nCAM_EN, "nCAM_EN");
> > > +	if (err) {
> > > +		pr_err("%s: Failed to request nCAM_EN\n", __func__);
> > > +		goto fail;
> > > +	}
> > > +
> > > +	err = gpio_request(GPIO19_GEN1_CAM_RST, "CAM_RST");
> > > +	if (err) {
> > > +		pr_err("%s: Failed to request CAM_RST\n", __func__);
> > > +		goto fail_gpio_cam_rst;
> > > +	}
> > > +
> > > +	gpio_direction_output(GPIO50_nCAM_EN, 0);
> > > +	gpio_direction_output(GPIO19_GEN1_CAM_RST, 1);
> > 
> > Don't understand this, are you sure your comments are correct? This would 
> > mean, that in init() you enable the camera and hold it in reset.
> >
> 
> I am pretty confident the comments are right,
> they came from runtime analysis with gpiotool on original firmware.
> 
> The reset happens when bringing the signal from low to high, so
> holding it high or low it's basically the same here, and given how 
> a780_pxacamera_reset() works I decided to keep it high.

Then it is not level- but edge-sensitive. Maybe put reset - rising edge to 
activate, or something like that.

> I also need to put CAM_EN active in init(), because of how
> soc_camera_probe() works, adding some debug I get this call sequence
> (with CAM_EN not active):
> 
> Linux video capture interface: v2.00
> pxa27x-camera pxa27x-camera.0: Limiting master clock to 26000000
> pxa27x-camera pxa27x-camera.0: LCD clock 104000000Hz, target freq 26000000Hz, divisor 1
> pxa27x-camera pxa27x-camera.0: got DMA channel 1
> pxa27x-camera pxa27x-camera.0: got DMA channel (U) 2
> pxa27x-camera pxa27x-camera.0: got DMA channel (V) 3
> camera 0-0: Probing 0-0
> camera 0-0: soc_camera_probe: power 1
> --> a780_pxacamera_power: called. on: 1  !on: 0
> camera 0-0: soc_camera_probe: reset
> --> a780_pxacamera_reset: called
> pxa27x-camera pxa27x-camera.0: Registered platform device at cc8a5380 data c03a40a8
> pxa27x-camera pxa27x-camera.0: pxa_camera_activate: Init gpios
> --> a780_pxacamera_init: called
> pxa27x-camera pxa27x-camera.0: PXA Camera driver attached to camera 0
> camera 0-0: mt9m111_video_probe: called
> i2c: error: exhausted retries
> i2c: msg_num: 0 msg_idx: -2000 msg_ptr: 0
> i2c: ICR: 000007e0 ISR: 00000002
> i2c: log: [00000446:000007e0] 
> mt9m111 0-005d: read  reg.00d -> ffffff87
> mt9m111 0-005d: mt9m11x init failed: -121
> mt9m111: probe of 0-005d failed with error -121
> pxa27x-camera pxa27x-camera.0: PXA Camera driver detached from camera 0
> camera 0-0: soc_camera_probe: power 0
> a780_pxacamera_power: called. on: 0  !on: 1
> camera: probe of 0-0 failed with error -12
> 
> See? It's power(), reset(), init().
> Maybe the problem is in soc_camera_probe()?

Sorry, you'd have to elaborate more on this. So, what's wrong with that 
sequence? it doesn't make sense to reset a powered down device or reset 
after init or whatever...

> > > +
> > > +	return 0;
> > > +
> > > +fail_gpio_cam_rst:
> > > +	gpio_free(GPIO50_nCAM_EN);
> > > +fail:
> > > +	return err;
> > > +}
> > > +
> > > +static int a780_pxacamera_power(struct device *dev, int on)
> > > +{
> > > +	gpio_set_value(GPIO50_nCAM_EN, !on);
> > 
> > This agrees with the comment above, but then why do you enable it 
> > immediately in init?
> >
> 
> See above.
> 
> > > +	return 0;
> > > +}
> > > +
> > > +static int a780_pxacamera_reset(struct device *dev)
> > > +{
> > > +	gpio_set_value(GPIO19_GEN1_CAM_RST, 0);
> > > +	msleep(10);
> > > +	gpio_set_value(GPIO19_GEN1_CAM_RST, 1);
> > 
> > This, however, seems to contradict the comment and confirm the code above 
> > - looks like your reset pin is active low too?
> >
> 
> Well, reset happens when bringing the GPIO to HIGH but only after some
> time it was LOW, so I consider it "active high" but maybe I am messing up
> with terminology here?

As I said, I'd suggest switching from level- to edge-terminology.

> [...]
> > > +static struct soc_camera_link a780_iclink = {
> > > +	.bus_id         = 0,
> > > +	.flags          = SOCAM_SENSOR_INVERT_PCLK,
> > 
> > Do you have schematics or have you found this out experimentally? What 
> > happens if you don't invert pclk?
> >
> 
> I've found this experimentally, and I think I was the reason why you
> introduced SOCAM_SENSOR_INVERT_PCLK, see
> http://thread.gmane.org/gmane.comp.video.video4linux/40592
> 
> If I don't invert pixelclock I get a picture like this:
> http://people.openezx.org/ao2/a780-not-yet.jpg

Ok, understand.

> 
> [...]
> > 
> > A general question for the ezx.c: wouldn't it be better to convert that 
> > full-of-ifdef's file to a mach-pxa/ezx/ directory?
> >
> 
> Actually we are fine using a single file, there are many parts shared
> between different platform generations and different phones, and often
> when we change something for a phone we had to do a similar change for
> the others, so living into a single file is a little bit easier.
> 
> Sure that the ifdefs can be reorganized and reduced, and I will do
> that when most of the out-of-tree stuff is in.

Well, that's your area, but I would've thought, an ezx directory with some 
function-specific files, common for some boards and one file per board 
with board-specific configuration would be easier to manage. But that's up 
to you and other EZX developers (and Eric), really:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
