Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48645 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758076AbZIOTzc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 15:55:32 -0400
Date: Tue, 15 Sep 2009 21:55:32 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Marek Vasut <marek.vasut@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: V4L2: Add a v4l2-subdev (soc-camera) driver for OmniVision OV9640
 sensor
In-Reply-To: <200909150006.00150.marek.vasut@gmail.com>
Message-ID: <Pine.LNX.4.64.0909152150090.4640@axis700.grange>
References: <200908220850.07435.marek.vasut@gmail.com>
 <200909142315.14697.marek.vasut@gmail.com> <Pine.LNX.4.64.0909142319240.4359@axis700.grange>
 <200909150006.00150.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 15 Sep 2009, Marek Vasut wrote:

> Just briefly skimmed over it. Ok then, that diff seems fine. I assume the imagebus 
> will fix the rgb issues anyway.

Sorry, have to ask to make quite sure - so, you're ok with me pushing that 
patch as it was in the mail - not just the diff but also the patch header? 
And no, imagebus cannot fix the problem automagically - until we know for 
sure what those formats are. So, someone will have to test the driver 
again.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
