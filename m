Return-path: <mchehab@gaivota>
Received: from moutng.kundenserver.de ([212.227.126.187]:50619 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112Ab1ELJcs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2011 05:32:48 -0400
Date: Thu, 12 May 2011 11:32:18 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Wu, Josh" <Josh.wu@atmel.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	mchehab@redhat.com, linux-media@vger.kernel.org,
	"Haring, Lars" <Lars.Haring@atmel.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: RE: [PATCH] [media] at91: add Atmel Image Sensor Interface (ISI)support
In-Reply-To: <4C79549CB6F772498162A641D92D532801AC28CD@penmb01.corp.atmel.com>
Message-ID: <Pine.LNX.4.64.1105121131040.24486@axis700.grange>
References: <1305186138-5656-1-git-send-email-josh.wu@atmel.com>
 <20110512074725.GA1356@n2100.arm.linux.org.uk>
 <4C79549CB6F772498162A641D92D532801AC28CD@penmb01.corp.atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Thu, 12 May 2011, Wu, Josh wrote:

> Hi, Russell
> 
> From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk] Sent: Thursday, May 12, 2011 3:47 PM
> > On Thu, May 12, 2011 at 03:42:18PM +0800, Josh Wu wrote:
> >> +err_alloc_isi:
> >> +	clk_disable(pclk);
> > clk_put() ?
> Ok, will be fixed in V2 patch. Thanks.

You might wait with v2 until I find time to review your patch. Will take a 
couple of days, I think. A general question, though: how compatible is 
this driver with the AVR32?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
