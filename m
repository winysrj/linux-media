Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:51813 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056Ab2FDPtN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2012 11:49:13 -0400
Date: Mon, 4 Jun 2012 17:49:10 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Albert Wang <twang13@marvell.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [PATCH] [media] soc-camera: Correct icl platform data
 assignment
In-Reply-To: <477F20668A386D41ADCC57781B1F7043083A727354@SC-VEXCH1.marvell.com>
Message-ID: <alpine.DEB.2.00.1206041738190.23951@axis700.grange>
References: <1338803000-26019-1-git-send-email-twang13@marvell.com> <Pine.LNX.4.64.1206041425010.22611@axis700.grange> <477F20668A386D41ADCC57781B1F7043083A727354@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 4 Jun 2012, Albert Wang wrote:

> Hi, Guennadi
> 
> Yes, maybe you are right.
> I checked some i2c client drivers, they all changed it to:
> 
> struct soc_camera_link *icl = soc_camera_i2c_to_link(client);
> 
> We also can update our client driver, but could you please explain why 
> do you change it?

Since you have already found the change, you could also use git blame to 
find this commit:

commit b569a3766136e710883a16a91cd12942560e772b
Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date:   Wed Sep 21 20:16:30 2011 +0200

    V4L: soc-camera: start removing struct soc_camera_device from client drivers
    
    Remove most trivial uses of struct soc_camera_device from most client
    drivers, abstracting some of them inside inline functions. Next steps
    will eliminate remaining uses and modify inline functions to not use
    struct soc_camera_device.

I.e., client drivers should become independent of soc-camera, that's why 
they shoudn't access struct soc_camera_device.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
