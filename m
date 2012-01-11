Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:58689 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab2AKMIU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 07:08:20 -0500
Date: Wed, 11 Jan 2012 13:08:17 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Bhupesh SHARMA <bhupesh.sharma@st.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: Purpose of .init and .release methods in soc_camera framework
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384ECE79A897@EAPEX1MAIL1.st.com>
Message-ID: <Pine.LNX.4.64.1201111302500.1191@axis700.grange>
References: <D5ECB3C7A6F99444980976A8C6D896384ECE79A86C@EAPEX1MAIL1.st.com>
 <Pine.LNX.4.64.1201111242160.1191@axis700.grange>
 <D5ECB3C7A6F99444980976A8C6D896384ECE79A897@EAPEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 11 Jan 2012, Bhupesh SHARMA wrote:

> Hi Guennadi,
> 
> > -----Original Message-----
> > From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
> > Sent: Wednesday, January 11, 2012 5:18 PM
> > To: Bhupesh SHARMA
> > Cc: linux-media@vger.kernel.org
> > Subject: Re: Purpose of .init and .release methods in soc_camera
> > framework
> > 
> > Hi Bhupesh
> > 
> > On Wed, 11 Jan 2012, Bhupesh SHARMA wrote:
> > 
> > > Hi Guennadi,
> > >
> > > I was reading the latest soc_camera framework documentation (see
> > [1]).
> > > I can see on line 71 to 73 the following text:
> > >
> > > " .add and .remove methods are called when a sensor is attached to or
> > detached
> > >  from the host, apart from performing host-internal tasks they shall
> > also call
> > >  sensor driver's .init and .release methods respectively."
> > >
> > > Now, I was puzzled on seeing that none of the soc_camera bridge
> > drivers (
> > > like PXA and SH Mobile) call the sensor's .init and .release from
> > their
> > > .add and .remove methods respectively.
> > 
> > .init() and .release() methods were a part of the soc-camera client
> > API.
> > It has been removed with the migration to the v4l2-subdev API.
> 
> Ok. So, can the documentation be updated to reflect the same.

That documentation has more problems, than just that. It shall be updated 
at some point, yes...

> > > Also I cannot trace these calls in soc_camera.c layer
> > >
> > > Actually, I am working on a camera sensor that requires certain
> > > patches to be written to it before it can start working:
> > >
> > > - Now, if I write these patches in the _probe_ of the sensor driver
> > (similar
> > > to the ST VS6624 driver here : [2]), my sensor can work well for the
> > 1st run
> > > of the user-space application. But, if I launch the application again
> > the patches
> > > need to be written to the sensor again as I have implemented an 'icl-
> > >power' routine
> > > which basically turns ON and OFF the sensor by toggling its CE (chip
> > enable pin).
> > >
> > > - As the soc_camera layer provides no explicit call to the camera
> > sensor driver
> > > when an _open_ is invoked from the userland, when and how should I
> > write the
> > > patch registers.
> > >
> > > I can only think of using the .init routine to initialize the sensor
> > patch registers
> > > in such a case.
> > 
> > Why don't you perform that initialisation in your .power() method?
> 
> You mean in the icl->power method?

No, I mean the v4l2-subdev struct v4l2_subdev_core_ops::s_power() method, 
sorry for confusion.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
