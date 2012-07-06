Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3532 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab2GFJW0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 05:22:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [Device-drivers-devel] [RFCv1 PATCH 0/7] Add adv7604/ad9389b drivers
Date: Fri, 6 Jul 2012 10:46:07 +0200
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
	device-drivers-devel@blackfin.uclinux.org
References: <1341498375-9411-1-git-send-email-hans.verkuil@cisco.com> <4FF69D67.8050408@metafoo.de>
In-Reply-To: <4FF69D67.8050408@metafoo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207061046.07949.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri July 6 2012 10:10:15 Lars-Peter Clausen wrote:
> On 07/05/2012 04:26 PM, Hans Verkuil wrote:
> > Hi all,
> > 
> > This RFC patch series builds on an earlier RFC patch series (posted only to
> > linux-media) that adds support for DVI/HDMI/DP connectors to the V4L2 API.
> > 
> > This earlier patch series is here:
> > 
> > 	http://www.spinics.net/lists/linux-media/msg48529.html
> > 
> > The first 3 patches are effectively unchanged compared to that patch series,
> > patch 4 adds support for the newly defined controls to the V4L2 control framework
> > and patch 5 adds helper functions to v4l2-common.c to help in detecting VESA
> > CVT and GTF formats.
> > 
> > Finally, two Analog Devices drivers are added to actually use this new API.
> > The adv7604 is an HDMI/DVI receiver and the ad9389b is an HDMI transmitter.
> > 
> > Another tree of mine also contains preliminary drivers for the adv7842
> > and adv7511:
> 
> Hm, ok that's interesting I do have a DRM driver for the adv7511:
> https://github.com/lclausen-adi/linux-2.6/blob/adv7511_zynq/drivers/gpu/drm/i2c/adv7511_core.c
> 
> I wonder if it is possible to share some code on this.

That will be an interesting exercise. The V4L and DRM subsystems are trying to
improve their cooperation, but we are not yet at the stage that you can easily
share video encoders. This might be a good starting point, though.

> > 
> > 	http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/hdmi
> > 
> > However, I want to start with adv7604 and ad9389b since those have had the most
> > testing.
> 
> I've also have some code which adds adv7611 support to your adv7604 driver.

Let's try and get this driver in first, before we start adding patches other
than fixes. The main purpose is to get the new API elements merged in the
kernel, after that the drivers can easily be expanded and improved (which is
so much easier once they are in the kernel).

Regards,

	Hans

> 
> > 
> > As the commit message of says these drivers do not implement the full
> > functionality of these devices, but that can be added later, either
> > by Cisco or by others.
> > 
> > A lot of work has been put into the V4L2 subsystem to reach this point,
> > particularly the control framework, the VIDIOC_G/S/ENUM/QUERY_DV_TIMINGS
> > ioctls, and the V4L2 event mechanism. So I'm very pleased to be able to finally
> > post this code.
> > 
> > Comments are welcome!
> > 
> > Regards,
> > 
> > 	Hans Verkuil
> > 
> > _______________________________________________
> > Device-drivers-devel mailing list
> > Device-drivers-devel@blackfin.uclinux.org
> > https://blackfin.uclinux.org/mailman/listinfo/device-drivers-devel
> 
