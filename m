Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:60140 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754213Ab2FDQxn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jun 2012 12:53:43 -0400
From: Albert Wang <twang13@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 4 Jun 2012 09:54:24 -0700
Subject: RE: [PATCH] [media] soc-camera: Correct icl platform data assignment
Message-ID: <477F20668A386D41ADCC57781B1F7043083A727388@SC-VEXCH1.marvell.com>
References: <1338803000-26019-1-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1206041425010.22611@axis700.grange>
 <477F20668A386D41ADCC57781B1F7043083A727354@SC-VEXCH1.marvell.com>
 <alpine.DEB.2.00.1206041738190.23951@axis700.grange>
In-Reply-To: <alpine.DEB.2.00.1206041738190.23951@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Guennadi

Got it! Thank you!
We will update our client driver.


Thanks
Albert Wang
86-21-61092656
-----Original Message-----
From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de] 
Sent: Monday, 04 June, 2012 23:49
To: Albert Wang
Cc: linux-media@vger.kernel.org
Subject: RE: [PATCH] [media] soc-camera: Correct icl platform data assignment

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

Since you have already found the change, you could also use git blame to find this commit:

commit b569a3766136e710883a16a91cd12942560e772b
Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date:   Wed Sep 21 20:16:30 2011 +0200

    V4L: soc-camera: start removing struct soc_camera_device from client drivers
    
    Remove most trivial uses of struct soc_camera_device from most client
    drivers, abstracting some of them inside inline functions. Next steps
    will eliminate remaining uses and modify inline functions to not use
    struct soc_camera_device.

I.e., client drivers should become independent of soc-camera, that's why they shoudn't access struct soc_camera_device.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer http://www.open-technology.de/
