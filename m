Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:65115 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab1BERVB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Feb 2011 12:21:01 -0500
Date: Sat, 5 Feb 2011 18:20:57 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Prashanth umamaheshwar <umamaheshwarprashanth@staff.vce.ac.in>
cc: linux-media@vger.kernel.org, deanrnd@staff.vce.ac.in,
	pamidighantamvr@gmail.com, abid.khan@staff.vce.ac.in,
	abid.net@gmail.com, AJAY R&D <ajaydnvv@staff.vce.ac.in>,
	uma <umamaheshwarprashanth@yahoo.com>
Subject: Re: Linux Driver --for MT9M032
In-Reply-To: <COL104-W12E63A6D4E48C4F84CAA8DABE90@phx.gbl>
Message-ID: <Pine.LNX.4.64.1102051803030.11500@axis700.grange>
References: <COL104-W12E63A6D4E48C4F84CAA8DABE90@phx.gbl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 5 Feb 2011, Prashanth umamaheshwar wrote:

> Dear Guennadi Liakhovetski,

> We are using EM2440-III kit with ARM Processor S3C2440; here we are 
> trying to interface the CMOS sensor (MT9M032) camera board to 20 pin 
> header (camera interface) present on EM2440-III kit.

> Here the task involved is to render the image /video captured by camera 
> on to the Touch screen LCD present on EM2440-III kit.

AFAICS your main problem is not the sensor driver, but the host driver, 
i.e., a driver for the camera / video capture interface on your s3c2440 
SoC. Specifically, the problem is that no such driver is currently 
available in the Linux mainline kernel and I don't remember seeing any 
patches for your SoC either recently. It might be the case, that such a 
driver is available in a vendor kernel, but then you would have to either 
contact your vendor for support with that kernel, or you would have to 
port that driver to the mainline. And then, of course, you would have to 
use the current (ATM 2.6.38-rcX) kernel for that work. Unfortunately, I 
think, finding any (unpaid) help with old (2.6.30) and / or non-mainline 
kernels on this mailing list will be difficult.

Thanks
Guennadi

> We are using the kernel version 2.6.30.4 & there is the variation in 
> the kernel version for which the patch files have been provided.
>  

> We tried our level best to compile the kernel with MT9M032 Camera 
> drivers but could not succeed.

> In order to apply this patch to the current bleeding edge kernel, we 
> need to track many dependencies which are not centralized.
>  

> Here the issue is, we need to cut down the General Purpose O.S kernel to 
> the embedded level.
>  

> All these above mentioned are the technical difficulties which we are facing now.
>  
> Please help us in this regard.
> Thanking You,
> With Best Regards,
> Prashanth B.U.V 		 	   		  

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
