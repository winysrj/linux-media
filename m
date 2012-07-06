Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-146.synserver.de ([212.40.185.146]:1112 "EHLO
	smtp-out-146.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab2GFINE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 04:13:04 -0400
Message-ID: <4FF69D67.8050408@metafoo.de>
Date: Fri, 06 Jul 2012 10:10:15 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Hans Verkuil <hans.verkuil@cisco.com>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	device-drivers-devel@blackfin.uclinux.org
Subject: Re: [Device-drivers-devel] [RFCv1 PATCH 0/7] Add adv7604/ad9389b
 drivers
References: <1341498375-9411-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <1341498375-9411-1-git-send-email-hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/05/2012 04:26 PM, Hans Verkuil wrote:
> Hi all,
> 
> This RFC patch series builds on an earlier RFC patch series (posted only to
> linux-media) that adds support for DVI/HDMI/DP connectors to the V4L2 API.
> 
> This earlier patch series is here:
> 
> 	http://www.spinics.net/lists/linux-media/msg48529.html
> 
> The first 3 patches are effectively unchanged compared to that patch series,
> patch 4 adds support for the newly defined controls to the V4L2 control framework
> and patch 5 adds helper functions to v4l2-common.c to help in detecting VESA
> CVT and GTF formats.
> 
> Finally, two Analog Devices drivers are added to actually use this new API.
> The adv7604 is an HDMI/DVI receiver and the ad9389b is an HDMI transmitter.
> 
> Another tree of mine also contains preliminary drivers for the adv7842
> and adv7511:

Hm, ok that's interesting I do have a DRM driver for the adv7511:
https://github.com/lclausen-adi/linux-2.6/blob/adv7511_zynq/drivers/gpu/drm/i2c/adv7511_core.c

I wonder if it is possible to share some code on this.

> 
> 	http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/hdmi
> 
> However, I want to start with adv7604 and ad9389b since those have had the most
> testing.

I've also have some code which adds adv7611 support to your adv7604 driver.

> 
> As the commit message of says these drivers do not implement the full
> functionality of these devices, but that can be added later, either
> by Cisco or by others.
> 
> A lot of work has been put into the V4L2 subsystem to reach this point,
> particularly the control framework, the VIDIOC_G/S/ENUM/QUERY_DV_TIMINGS
> ioctls, and the V4L2 event mechanism. So I'm very pleased to be able to finally
> post this code.
> 
> Comments are welcome!
> 
> Regards,
> 
> 	Hans Verkuil
> 
> _______________________________________________
> Device-drivers-devel mailing list
> Device-drivers-devel@blackfin.uclinux.org
> https://blackfin.uclinux.org/mailman/listinfo/device-drivers-devel

