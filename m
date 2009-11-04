Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:36864 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbZKDPJJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2009 10:09:09 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Martin Rod <martin.rod@email.cz>
Subject: Re: MSI StarCam Racer - No valid video chain found
Date: Wed, 4 Nov 2009 16:09:29 +0100
Cc: linux-media@vger.kernel.org
References: <4AED4C3B.3020706@email.cz> <200911021437.05207.laurent.pinchart@ideasonboard.com> <4AEF41B6.6080102@email.cz>
In-Reply-To: <4AEF41B6.6080102@email.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911041609.29721.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Martin,

On Monday 02 November 2009 21:31:50 Martin Rod wrote:
> Hi Laurent,
> 
> I send you output of lsusb. I think, that the uvcdriver is the latest. I
> try older kernel tomorrow.

Could you please load the driver with trace=255 (modprobe uvcvideo trace=255) 
or, if the driver is already loaded, change the trace parameter to 255 (echo 
255 > /sys/module/uvcvideo/parameters/trace), plug your camera and send me the 
messages printed by the uvcvideo driver to the kernel log?

Thanks.

-- 
Regards,

Laurent Pinchart
