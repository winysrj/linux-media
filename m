Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:42489 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760610Ab2EKQ1y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 12:27:54 -0400
Date: Fri, 11 May 2012 10:27:52 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Albert Wang <twang13@marvell.com>
Cc: 'Guennadi Liakhovetski' <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Chao Xie <cxie4@marvell.com>, Angela Wan <jwan@marvell.com>,
	Kassey Lee <kassey1216@gmail.com>,
	Albert <bluebellice@gmail.com>
Subject: Re: marvell-ccic: lacks of some features
Message-ID: <20120511102752.4b87024f@lwn.net>
In-Reply-To: <477F20668A386D41ADCC57781B1F7043083A57BA08@SC-VEXCH1.marvell.com>
References: <477F20668A386D41ADCC57781B1F7043083A57BA08@SC-VEXCH1.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 11 May 2012 09:02:26 -0700
Albert Wang <twang13@marvell.com> wrote:

> Hi, Jonathan & Guennadi
> 
> We used the marvell-ccic code and found it lacks of some features, but
> our Marvell Camera driver (mv_camera.c) which based on soc_camera can
> support all these features:

The marvell-ccic driver has the features that were needed by the people
doing the work and that I had the documentation and hardware to support.
Of course it's incomplete.

I'll go through your list, but, first: is the purpose of your message to
argue for a replacement of the marvell-ccic driver by your mv_camera
driver?  I am not necessarily opposed to that idea if mv_camera can support
deployed systems back to the OLPC XO 1.0 and if it seems clear that a
replacement makes more sense than adding features to the in-tree driver.  

> 1. marvell-ccic only support MMP2 (PXA688), it can’t support other Marvell SOC chips
> Our mv_camera can support such as MMP3 (PXA2128), TD (PXA910/920) and so
> on besides MMP2

Which is cool.  It is nice that Marvell is finally providing Linux support
for its camera controllers after all these years.  For the last several
years, I've necessarily been limited in the controllers I could support.
Is it Marvell's intention to provide upstream maintenance and support going
forward? 

> 2. marvell-ccic only support parallel (DVP) mode, can’t support MIPI mode
> Our mv_camera can support both DVP mode and MIPI mode, MIPI interface is
> the trend of current camera sensors with high resolution

Adding MIPI doesn't look that hard, I've just never had a reason (or
hardware) to do it.

> 
> 3. marvell-ccic only support ccic1 controller, can’t support ccic2 or
> dual ccic controllers 
> As you known, both MMP2 and MMP3 have 2 ccic controllers, ccic2 is different with ccic1
> Sometimes we need use both 2 ccic controllers for connecting 2 camera sensors
> Actually, we have used 2 ccic controllers' cases in our platforms
> Our mv_camera can support these cases: only use ccic1, only use ccic2 and use ccic1 + ccic2

It doesn't support two because nobody has asked for it, but the driver was
written with that in mind.  I don't see supporting the second controller as
a big job.

> 4. marvell-ccic only support camera sensor OV7670
> It's an old and low resolution parallel sensor, and sensor info also is hard code
> But it loooks we should better separate controller and sensor in driver, controller doesn't care sensor type which will communicate with
> Our mv_camera can support any camera sensor which based on subdev structure

That is a well-known limitation, which, again, isn't that hard to fix.  The
main problem is fixing it without breaking existing users.

> 5. marvell-ccic only support YUYV format which is packed format besides
> RGB444 and RGB565, it can’t support planar formats 
> Our mv_camera can support both packed format and planar formats such as
> YUV420 and YUV422P

Again, not a fundamental driver limitation; definitely worth fixing when
somebody actually needs planar formats.

> 6. marvell-ccic didn't support JPEG format for still capture mode
> Our mv_camera can support JPEG directly for still capture, most high
> resolution camera sensor can output JPEG format directly

That would indeed be a nice feature to have.

> 7. marvell-ccic can’t support dual camera sensors or multi camera sensors cases
> Current most platforms can support dual camera sensor case, include front-facing sensor and rear-facing sensor
> Even some high end platforms can support 3D mode record; it need support 2+1 camera sensors
> Our mv_camera can support these cases:
> dual camera sensor connect to ccic1 or ccic2
> one camera sensor connect to ccic1 and the other camera sensor connect to ccic2
> dual camera sensor connect to ccic1 and one camera sensor connect to ccic2

Sounds like nice stuff.

> 8. marvell-ccic can’t support external ISP + raw camera sensor mode As
> you known, more and more camera sensors with high resolution are raw
> camera sensors but not smart sensors It needs external ISP (Image Signal
> Processor) to generate the desired formats and resolutions with some
> advanced features based on the raw data from sensor Our mv_camera can
> support both smart camera sensors and external ISP + raw camera sensors

Supporting that mode would be a significant bit of work.  But please let's
not confuse "can't" and "doesn't currently."

> 9. marvell-ccic still used obsolete method to stop ccic DMA
> This method should be inheritted from old cafe-ccic driver, it use CF flag which is trigged by SOF
> This method is inefficient, we must wait at least 150ms for stop ccic DMA and it also can result in many issues during thousands resolutions or formats switch stress test
> Actually our ccic can handle it if we use the right stop sequence by config some ccic registers
> Our mv_camera had applied the new and right stop method and it also
> passed the thousands resolutions or formats switch stress test

Which DMA mode are you talking about now?  I've supported DMA to the best
of my ability given the information in the data sheet, plus a couple of
hints from Kassey Lee (who, I believe, no longer works there?).  This can't
be a hard thing to change, anyway.

Anyway, we're seeing the results of Marvell going off and working on its
own private code instead of enhancing the in-tree driver that has been
there since 2006.  Sad, but so it goes.  But if Marvell wants to work
upstream now, I sure don't want to make things harder.  How about we get a
new version of the mv_camera driver for review and we can all think about
what's the best thing to do at this point?

Thanks,

jon
