Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50497 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab1FIPKW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jun 2011 11:10:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH 3/3] adp1653: Add driver for LED flash controller
Date: Thu, 9 Jun 2011 17:10:16 +0200
Cc: linux-media@vger.kernel.org, nkanchev@mm-sol.com,
	g.liakhovetski@gmx.de, hverkuil@xs4all.nl, dacohen@gmail.com,
	riverful@gmail.com, andrew.b.adams@gmail.com, shpark7@stanford.edu
References: <4DD11FEC.8050308@maxwell.research.nokia.com> <1305550839-16724-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1305550839-16724-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106091710.18273.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sakari,

On Monday 16 May 2011 15:00:39 Sakari Ailus wrote:
> This patch adds the driver for the adp1653 LED flash controller. This
> controller supports a high power led in flash and torch modes and an
> indicator light, sometimes also called privacy light.
> 
> The adp1653 is used on the Nokia N900.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> Signed-off-by: Tuukka Toivonen <tuukkat76@gmail.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: David Cohen <dacohen@gmail.com>

[snip]

> +	v4l2_ctrl_new_std(&flash->ctrls, &adp1653_ctrl_ops,
> +			  V4L2_CID_FLASH_FAULT, 0, V4L2_FLASH_FAULT_OVER_VOLTAGE
> +			  | V4L2_FLASH_FAULT_OVER_TEMPERATURE
> +			  | V4L2_FLASH_FAULT_SHORT_CIRCUIT, 0, 0);

You need to mark the fault control as volatile.

-- 
Regards,

Laurent Pinchart
