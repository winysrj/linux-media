Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58624 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbaJOQsM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Oct 2014 12:48:12 -0400
Date: Wed, 15 Oct 2014 18:48:08 +0200
Message-ID: <s5ha94xwa7r.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: m.chehab@samsung.com, akpm@linux-foundation.org,
	gregkh@linuxfoundation.org, crope@iki.fi, olebowle@gmx.com,
	dheitmueller@kernellabs.com, hverkuil@xs4all.nl,
	ramakrmu@cisco.com, sakari.ailus@linux.intel.com,
	laurent.pinchart@ideasonboard.com, perex@perex.cz,
	prabhakar.csengg@gmail.com, tim.gardner@canonical.com,
	linux@eikelenboom.it, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] media token resource framework 
In-Reply-To: <cover.1413246370.git.shuahkh@osg.samsung.com>
References: <cover.1413246370.git.shuahkh@osg.samsung.com>
MIME-Version: 1.0 (generated by SEMI 1.14.6 - "Maruoka")
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

At Tue, 14 Oct 2014 08:58:36 -0600,
Shuah Khan wrote:
> 
> Add media token device resource framework to allow sharing
> resources such as tuner, dma, audio etc. across media drivers
> and non-media sound drivers that control media hardware. The
> Media token resource is created at the main struct device that
> is common to all drivers that claim various pieces of the main
> media device, which allows them to find the resource using the
> main struct device. As an example, digital, analog, and
> snd-usb-audio drivers can use the media token resource API
> using the main struct device for the interface the media device
> is attached to.
> 
> This patch series consists of media token resource framework
> and changes to use it in dvb-core, v4l2-core, au0828 driver,
> and snd-usb-audio driver.
> 
> With these changes dvb and v4l2 can share the tuner without
> disrupting each other. Used tvtime, xawtv, kaffeine, and vlc,
> vlc audio capture option, arecord/aplay during development to
> identify v4l2 vb2 and vb1 ioctls and file operations that
> disrupt the digital stream and would require changes to check
> tuner ownership prior to changing the tuner configuration.
> vb2 changes are made in the v4l2-core and vb1 changes are made
> in the au0828 driver to encourage porting drivers to vb2 to
> advantage of the new media token resource framework with changes
> in the core.
> 
> In this patch v2 series, fixed problems identified in the
> patch v1 series. Important ones are changing snd-usb-audio
> to use media tokens, holding tuner lock in VIDIOC_ENUMINPUT,
> and VIDIOC_QUERYSTD.

Just took a quick glance over the patches, and my first concern is why
this has to be lib/*.  This means it's always built-in as long as this
config is enabled (and will be so on distro kernel) even if it's not
used at all.


thanks,

Takashi
