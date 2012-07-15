Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55229 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab2GOMLI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jul 2012 08:11:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de,
	mchehab@redhat.com, linux@arm.linux.org.uk, kernel@pengutronix.de,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] media: mx2_camera: Remove MX2_CAMERA_SWAP16 and MX2_CAMERA_PACK_DIR_MSB flags.
Date: Sun, 15 Jul 2012 14:11:11 +0200
Message-ID: <9522639.Z8oXnMrKic@avalon>
In-Reply-To: <1342083809-19921-1-git-send-email-javier.martin@vista-silicon.com>
References: <1342083809-19921-1-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Thursday 12 July 2012 11:03:29 Javier Martin wrote:
> These flags are not used any longer and can be safely removed
> since the following patch:
> http://www.spinics.net/lists/linux-media/msg50165.html
>
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>

I would replace the URL with the commit ID in mainline. Apart from that,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

