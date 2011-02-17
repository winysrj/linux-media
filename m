Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:57932 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab1BQTeV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 14:34:21 -0500
Date: Thu, 17 Feb 2011 20:34:18 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Andrew Chew <AChew@nvidia.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: soc-camera and videobuf2
In-Reply-To: <643E69AA4436674C8F39DCC2C05F763816BD96CFB8@HQMAIL03.nvidia.com>
Message-ID: <Pine.LNX.4.64.1102172031240.30692@axis700.grange>
References: <643E69AA4436674C8F39DCC2C05F763816BD96CFB7@HQMAIL03.nvidia.com>
 <643E69AA4436674C8F39DCC2C05F763816BD96CFB8@HQMAIL03.nvidia.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 16 Feb 2011, Andrew Chew wrote:

> Reposting.  Sorry for the rich text in my previous email.
> 
> I'm looking at the videobuf2 stuff, and would like to use it because it 
> solves a bunch of problems for me that were in videobuf (for example, 
> I'm writing a variant of videobuf-dma-contig, and there's some private 
> memory allocator state I needed to track, but the videobuf stuff didn't 
> seem to let you do that).
> 
> But I'm also using soc_camera.  I was wondering if there's a time 
> estimate for soc_camera to be converted over to the videobuf2 framework.
> 
> Also, are SoC camera host drivers expected to call the methods in the 
> videobuf2 ops table directly (as in, vb2_ops->alloc())?  Or will there 
> be wrappers around these in the future (the wrappers can take the 
> videobuf2's alloc_ctx as a parameter and thereby figure out which method 
> to call).

Please, have a look at this thread:

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/28782

I plan to push soc-camera videobuf2 support for 2.6.39.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
