Return-path: <mchehab@pedra>
Received: from smtp6-g21.free.fr ([212.27.42.6]:51675 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756701Ab1FFUov (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Jun 2011 16:44:51 -0400
Message-ID: <4DED3C3B.8090804@free.fr>
Date: Mon, 06 Jun 2011 22:44:43 +0200
From: Robert Jarzmik <robert.jarzmik@free.fr>
Reply-To: robert.jarzmik@free.fr
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] V4L: pxa_camera: remove redundant calculations
References: <Pine.LNX.4.64.1106061900480.11169@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1106061900480.11169@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 06/06/2011 07:02 PM, Guennadi Liakhovetski wrote:
> soc_camera core now performs the standard .bytesperline and .sizeimage
> calculations internally, no need to duplicate in drivers.
Haven't I noticed that this patch is twofold :
  - the calculation duplication
  - the suspend/resume change from old suspend/resume to new v4l2_subdev 
power function

Shouldn't this patch have either the commit message amended, or even 
better be split into 2 distinct patches ?

Apart from that, the patch looks ok to me.

--
Robert
