Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:51103 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbZDOUgb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Apr 2009 16:36:31 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/5] soc-camera: convert to platform device
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Wed, 15 Apr 2009 22:36:20 +0200
Message-ID: <87ljq1mz7f.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> This patch series is a preparation for the v4l2-subdev conversion. Please, 
> review and test. My current patch-stack in the form of a 
> (manually-created) quilt-series is at 
> http://www.open-technology.de/download/20090415/ based on linux-next 
> history branch, commit ID in 0000-base file. Don't be surprised, that 
> patch-set also contains a few not directly related patches.

Right, apart from a few comments, the bright side is your serie resists my full
test campaign.

I need to make some additionnal tests with I2C loading/unloading, but otherwise
it works perfectly for (soc_camera / pxa_camera /mt9m111 combination).

Cheers.

--
Robert
