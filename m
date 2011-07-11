Return-path: <mchehab@localhost>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49360 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab1GKK4k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2011 06:56:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: Error routes through omap3isp ccdc.
Date: Mon, 11 Jul 2011 12:57:23 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4E1AD36D.4030702@cam.ac.uk> <201107111254.43151.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201107111254.43151.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107111257.24089.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On Monday 11 July 2011 12:54:42 Laurent Pinchart wrote:
> On Monday 11 July 2011 12:41:49 Jonathan Cameron wrote:

[snip]

> I think we should try to fix it in ispvideo.c instead. You could add a
> check to isp_video_validate_pipeline() to make sure that the pipeline has
> a video source.

And I forgot to mention, I can send a patch if you don't want to write it.

-- 
Regards,

Laurent Pinchart
