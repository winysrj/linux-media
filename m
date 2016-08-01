Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44037 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbcHAIhV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Aug 2016 04:37:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Niklas =?ISO-8859-1?Q?S=F6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Subject: Re: [PATCH 2/3] soc-camera/rcar-vin: remove obsolete driver
Date: Mon, 01 Aug 2016 11:31:11 +0300
Message-ID: <3585190.qMTDhgQKz3@avalon>
In-Reply-To: <1470038065-30789-3-git-send-email-hverkuil@xs4all.nl>
References: <1470038065-30789-1-git-send-email-hverkuil@xs4all.nl> <1470038065-30789-3-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Monday 01 Aug 2016 09:54:24 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This driver has been replaced by the non-soc-camera rcar-vin driver.
> The soc-camera framework is being deprecated, so drop this older
> rcar-vin driver in favor of the newer version that does not rely on
> this deprecated framework.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

I'm all for removal of dead code :-)

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

But please get Niklas' ack to confirm that the new driver supports all the 
feature available in the old one.

> ---
>  drivers/media/platform/soc_camera/Kconfig    |   10 -
>  drivers/media/platform/soc_camera/Makefile   |    1 -
>  drivers/media/platform/soc_camera/rcar_vin.c | 1970 -----------------------
>  3 files changed, 1981 deletions(-)
>  delete mode 100644 drivers/media/platform/soc_camera/rcar_vin.c

-- 
Regards,

Laurent Pinchart

