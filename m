Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58314 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab0KDDEa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Nov 2010 23:04:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: media-ctl header patch
Date: Thu, 4 Nov 2010 04:04:36 +0100
Cc: "Aguirre, Sergio" <saaguirre@ti.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4CD045FA.8040003@matrix-vision.de>
In-Reply-To: <4CD045FA.8040003@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011040404.36966.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Michael,

On Tuesday 02 November 2010 18:10:18 Michael Jones wrote:
> Hi Sergio & Laurent,
> 
> Back in July, Sergio submitted a patch "Just include kernel headers"
> (http://www.mail-archive.com/linux-media%40vger.kernel.org/msg20397.html)
> which Laurent didn't yet want to apply.
> 
> Now I'm using Laurent's branch "new-api" (and the new media API to match),
> and w/o Sergio's patch, I get a warning:
> 
> types.h:13: warning: #warning "Attempt to use kernel headers from user
> space, see http://kernelnewbies.org/KernelHeaders"
> 
> With Sergio's patch and setting HDIR, I get rid of this warning.  Laurent,
> what do you think about applying the patch now?  I would ack it if I
> could, but I don't know how to resurrect an old patch.

As answered to Sergio, at the moment most users will build media-ctl against a 
kernel tree instead against installed kernel headers. I will merge the patch 
when the media controller code will reach the mainline kernel. It should be 
safe to ignore the compilation warning for now.

-- 
Regards,

Laurent Pinchart
