Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55843 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754229AbZJBXMt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Oct 2009 19:12:49 -0400
Date: Sat, 3 Oct 2009 01:12:56 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: mt9t031-VPFE integration issues...
In-Reply-To: <A69FA2915331DC488A831521EAE36FE4015537027D@dlee06.ent.ti.com>
Message-ID: <Pine.LNX.4.64.0910030105570.6075@axis700.grange>
References: <A69FA2915331DC488A831521EAE36FE4015537027D@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Murali

On Fri, 2 Oct 2009, Karicheri, Muralidharan wrote:

> I am currently integrating latest MT9T031 driver to vpfe_capture driver 
> and see following issues:-
> 
> 1) Currently MT9T031 Kconfig configuration variable has a dependency on 
> SOC_CAMERA. We need to remove this dependency since this sensor can be 
> used on other platforms like DM6446/DM355/DM365. This is trivial and I 
> can send a patch to remove the dependency.
> 
> 2) The code still has reference to soc_camera_device and associated 
> changes. I think this should be removed so that it can be used on other 
> platforms as well. I am expecting these will go away once the bus 
> parameter as well data format related RFCs are approved. If this is 
> true, I can wait until the same is approved. If not, we need to work 
> together so that this driver can be integrated with vpfe capture driver.

You're certainly right - soc-camera based drivers, including mt9t031, 
still depend on the soc-camera core, although most of the API has been 
converted to v4l2-subdev. Yes, the two biggest issues are bus-parameter 
and data-format negotiation. Also, we'll have to find a way to supply the 
data to the drivers, that is currently set in platform code. So, ideally, 
yes, we have to wait until the respective RFCs get implemented and until 
soc-camera gets completely converted, but if this is something urgent - 
maybe it would be acceptable to start modifying some drivers for "dual 
operation" - either with soc-camera API or in pure v4l2-subdev mode. This 
would be a bit of an extra work, and I don't know what others think about 
this. So, if you can wait, perhaps, this would be the best.

Thanks
Guennadi
---
Guennadi Liakhovetski
