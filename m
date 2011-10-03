Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47975 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab1JCLVq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Oct 2011 07:21:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 0/9] Media Controller for soc-camera
Date: Mon, 3 Oct 2011 13:21:52 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Deepthy Ravi <deepthy.ravi@ti.com>
References: <1317313137-4403-1-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1317313137-4403-1-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201110031321.53090.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for the patches. I'm glad to see soc-camera adopting the MC API :-)

On Thursday 29 September 2011 18:18:48 Guennadi Liakhovetski wrote:
> This is the first attempt at extending soc-camera with Media Controller /
> pad-level APIs. Yes, I know, that Laurent wasn't quite happy with "V4L:
> add convenience macros to the subdevice / Media Controller API," maybe
> we'll remove it eventually, but so far my patches use it, so, I kept it
> for now.

I'm fine with keeping it to allow the other patches to be reviewed already, 
but I still think we should drop it.

> The general idea has been described in
> 
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/380
> 83
> 
> In short: soc-camera implements a media controller device and two entities
> per camera host (bridge) instance, linked statically to each other and to
> the client. The host driver gets a chance to implement "local" only
> configuration, as opposed to the standard soc-camera way of propagating the
> configuration up the pipeline to the client (sensor / decoder) driver. An
> example implementation is provided for sh_mobile_ceu_camera and two sensor
> drivers. The whole machinery gets activated if the soc-camera core finds a
> client driver, that implements pad operations. In that case both the
> "standard" (V4L2) and the "new" (MC) ways of addressing the driver become
> available. I.e., it is possible to run both standard V4L2 applications and
> MC-aware ones.
>
> Of course, applies on top of
> 
> git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.2
> 
> Deepthy: this is what I told you about in
> 
> http://article.gmane.org/gmane.linux.ports.arm.omap/64847
> 
> it just took me a bit longer, than I thought.

-- 
Regards,

Laurent Pinchart
