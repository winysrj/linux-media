Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:22711 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699AbaJ2JdM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Oct 2014 05:33:12 -0400
Date: Wed, 29 Oct 2014 07:33:01 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>, tiwai@suse.de
Cc: Shuah Khan <shuahkh@osg.samsung.com>, akpm@linux-foundation.org,
	gregkh@linuxfoundation.org, crope@iki.fi, olebowle@gmx.com,
	dheitmueller@kernellabs.com, hverkuil@xs4all.nl,
	ramakrmu@cisco.com, laurent.pinchart@ideasonboard.com,
	perex@perex.cz, prabhakar.csengg@gmail.com,
	tim.gardner@canonical.com, linux@eikelenboom.it,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v2 0/6] media token resource framework
Message-id: <20141029073301.50b46665.m.chehab@samsung.com>
In-reply-to: <5450B0B8.2060804@linux.intel.com>
References: <cover.1413246370.git.shuahkh@osg.samsung.com>
 <5450B0B8.2060804@linux.intel.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 29 Oct 2014 11:17:44 +0200
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> Hi Shuah and others,
> 
> Shuah Khan wrote:
> > Add media token device resource framework to allow sharing
> > resources such as tuner, dma, audio etc. across media drivers
> > and non-media sound drivers that control media hardware. The
> > Media token resource is created at the main struct device that
> > is common to all drivers that claim various pieces of the main
> > media device, which allows them to find the resource using the
> > main struct device. As an example, digital, analog, and
> > snd-usb-audio drivers can use the media token resource API
> > using the main struct device for the interface the media device
> > is attached to.
> >
> > This patch series consists of media token resource framework
> > and changes to use it in dvb-core, v4l2-core, au0828 driver,
> > and snd-usb-audio driver.
> >
> > With these changes dvb and v4l2 can share the tuner without
> > disrupting each other. Used tvtime, xawtv, kaffeine, and vlc,
> > vlc audio capture option, arecord/aplay during development to
> > identify v4l2 vb2 and vb1 ioctls and file operations that
> > disrupt the digital stream and would require changes to check
> > tuner ownership prior to changing the tuner configuration.
> > vb2 changes are made in the v4l2-core and vb1 changes are made
> > in the au0828 driver to encourage porting drivers to vb2 to
> > advantage of the new media token resource framework with changes
> > in the core.
> 
> I know this comes quite late after the first patch series has been sent, 
> but I'd like to ask if you have you considered a different approach: 
> rather than implementing something entirely new, the Media controller 
> can almost do this already. It models the physical layout of the device, 
> instead of creating special use case specific Media entity like 
> constructs for tuner and audio. Also the Media token framework does not 
> appear to be as a perfect match for the Media controller framework which 
> is also planned to be used by DVB already:
> 
> <URL:http://linuxtv.org/news.php?entry=2014-10-21.mchehab>; look for "3) 
> DVB API improvements". There have been ALSA MC patches as well but I'm 
> not aware of the status of those at the moment.
> 
> The tokens appear much like media entities of specific kind to me.

Yeah, it could be seen as that.

> Currently, media entities may only be entities bound to a given 
> subsystem, but I don't think it has to (or perhaps even may) stay that way.

We had some discussions about that with Laurent in San Jose. Yeah,
we will likely need to change that at the media controller, for complex
embedded DVB devices.

The usage of the media controller for this specific usage is that
we should not force userspace apps to be aware of the media controller
just because of hardware locking.

> In case of the Media controller, mutual exclusion of different users is 
> currently performed by adding the entities to a pipeline and 
> incrementing the streaming count once streaming is enabled --- on 
> different interfaces streaming may mean a different thing.

Well, we'll still need to find a way for ALSA to prevent it to use
the audio demod and DMA engine that will be powered off when DVB is
streaming.

> The Media controller interface does not handle serialising potential 
> users that may wish to configure the device. If that's needed then we'll 
> need to think how to add it.

Yes, this would be needed needed if we take this approach. 

Reconfiguring the DMA engine and some other registers via V4L2 API 
should be blocked. The same applies to firmware load, if the device 
is using tuner input for analog TV.

If we use the media controller, we'll need to add a state to it,
to indicate that a block at the pipeline is being reconfigured.

Takashi,

What's the status of Media Controller adoption on ALSA?

Regards,
Mauro
