Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:57231 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab3EPTqN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 May 2013 15:46:13 -0400
Date: Thu, 16 May 2013 21:46:09 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Andrei Andreyanau <a.andreyanau@sam-solutions.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: mt9p031 shows purple coloured capture
In-Reply-To: <5194D9AB.3030608@sam-solutions.com>
Message-ID: <Pine.LNX.4.64.1305162142210.27706@axis700.grange>
References: <5194D9AB.3030608@sam-solutions.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 16 May 2013, Andrei Andreyanau wrote:

> Hi, Laurent,
> I have an issue with the mt9p031 camera. The kernel version I use
> uses soc camera framework as well as camera does. And I have
> the following thing which appears randomly while capturing the
> image using gstreamer. When I start the capture for the first time, it
> shows the correct image (live stream). When I stop and start it again
> it may show the image in purple (it can appear on the third or fourth
> time). Or it can show the correct image every time I start the capture.
> Do you have any idea why it appears so?

Wrong clock or *sync polarity selection? Which leads to random 
start-of-frame misplacement?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
