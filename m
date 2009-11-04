Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58519 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751732AbZKDSWk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Nov 2009 13:22:40 -0500
Date: Wed, 4 Nov 2009 19:22:58 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Valentin Longchamp <valentin.longchamp@epfl.ch>
cc: Sascha Hauer <s.hauer@pengutronix.de>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 5/6] mx31moboard: camera support
In-Reply-To: <4AF01475.1010704@epfl.ch>
Message-ID: <Pine.LNX.4.64.0911031455190.5059@axis700.grange>
References: <1255599780-12948-1-git-send-email-valentin.longchamp@epfl.ch>
 <1255599780-12948-2-git-send-email-valentin.longchamp@epfl.ch>
 <1255599780-12948-3-git-send-email-valentin.longchamp@epfl.ch>
 <1255599780-12948-4-git-send-email-valentin.longchamp@epfl.ch>
 <1255599780-12948-5-git-send-email-valentin.longchamp@epfl.ch>
 <1255599780-12948-6-git-send-email-valentin.longchamp@epfl.ch>
 <Pine.LNX.4.64.0910162307160.26130@axis700.grange> <4ADC96A9.3090403@epfl.ch>
 <20091020080941.GN8818@pengutronix.de> <4ADF40BC.4090801@epfl.ch>
 <Pine.LNX.4.64.0910240059150.8342@axis700.grange> <4AE855E4.1040705@epfl.ch>
 <4AF01475.1010704@epfl.ch>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 3 Nov 2009, Valentin Longchamp wrote:

> Hi Guennadi,
> 
> Valentin Longchamp wrote:
> > Guennadi Liakhovetski wrote:
> > 
> > > 3. to support switching inputs, significant modifications to soc_camera.c
> > > would be required. I read Nate's argument before, that as long as clients
> > > can only be accessed one at a time, this should be presented by multiple
> > > inputs rather than multiple device nodes. Somebody else from the V4L folk
> > > has also confirmed this opinion. In principle I don't feel strongly either
> > > way. But currently soc-camera uses a one i2c client to one device node
> > > model, and I'm somewhat reluctant to change this before we're done with
> > > the v4l2-subdev conversion.
> > > 
> > 
> > Sure, one step at a time. So for now the switching is not possible with
> > soc_camera.
> > 
> > My problem is that both cameras have the same I2C address since they are the
> > same.
> > 
> > Would I need to declare 2 i2c_device with the same address (I'm not sure it
> > would even work ...) used by two _client_ platform_devices or would I have
> > to have the two platform devices pointing to the same i2c_device ?
> > 
> 
> I've finally had time to test all this. My current problem with registering
> the two cameras is that they both have the same i2c address, and soc_camera
> calls v4l2_i2c_new_subdev_board where in my case the same address on the same
> i2c tries to be registered and of course fails.
> 
> We would need a way in soc_camera not to register a new i2c client for device
> but use an existing one (but that's what you don't want to change for now as
> you state it in your above last sentence). I just want to point this out once
> more so that you know there is interest about this for the next soc_camera
> works.

These are two separate issues: inability to work with two devices with the 
same i2c address, and arguably suboptimal choice of the way to switch 
between multiple mutually-exclusive clients (sensors) on a single 
interface.

For multiple chips with the same adderess, in principle you could register 
one or more video devices yet before registering respective i2c devices. 
And then on the selected switching operation (either opening of one of the 
/dev/video* nodes, or selecting an input) you register the i2c device, 
probe it, etc. This would work, but looks seriously overengineered to me. 
And it would indeed require pretty fundamental changes to the soc-camera 
core.

Otherwise we could push this switching down into the driver / platform. We 
could just export only one camera from the platform code, implement a 
S_INPUT method in soc-camera, that would be delivered to the sensor 
driver, it would save context of the current sensor, call the platform 
hook to switch to another camera, and restore its configuration. In this 
case the soc-camera core and the host driver would not see two sensors, 
but just one, all the switching would be done internally in the sensor 
driver / platform callback.

If we also decide to use S_INPUT to switch between different sensors on an 
interface, we would have to make a distinction between two cases in the 
core - whether the input we're switching to belongs to the "same" sensor 
or to another one.

> So my current solution for mainline inclusion is to register only one camera
> device node without taking care of the cam mux for now.

Yes, please, send me an updated version of the patch. I think, you haven't 
done that yet, right?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
