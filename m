Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:37208 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbZIOVix convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 17:38:53 -0400
Received: by fg-out-1718.google.com with SMTP id 22so1006320fge.1
        for <linux-media@vger.kernel.org>; Tue, 15 Sep 2009 14:38:55 -0700 (PDT)
From: Marek Vasut <marek.vasut@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: V4L2: Add a v4l2-subdev (soc-camera) driver for OmniVision OV9640 sensor
Date: Tue, 15 Sep 2009 23:38:28 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <200908220850.07435.marek.vasut@gmail.com> <200909150006.00150.marek.vasut@gmail.com> <Pine.LNX.4.64.0909152150090.4640@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0909152150090.4640@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909152338.28109.marek.vasut@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dne Út 15. září 2009 21:55:32 Guennadi Liakhovetski napsal(a):
> On Tue, 15 Sep 2009, Marek Vasut wrote:
> > Just briefly skimmed over it. Ok then, that diff seems fine. I assume the
> > imagebus will fix the rgb issues anyway.
> 
> Sorry, have to ask to make quite sure - so, you're ok with me pushing that
> patch as it was in the mail - not just the diff but also the patch header?
> And no, imagebus cannot fix the problem automagically - until we know for
> sure what those formats are. So, someone will have to test the driver
> again.

Yeah, I'll eventually fix it if you broke something. btw. I know what those 
formats are, I was able to get both YUV and RGB encoded data from it.

> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 
