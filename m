Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45684 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab1I0XUN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 19:20:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Deepthy Ravi <deepthy.ravi@ti.com>
Subject: Re: [PATCH v2 2/5] [media] v4l: Add support for mt9t111 sensor driver
Date: Wed, 28 Sep 2011 01:20:08 +0200
Cc: hvaibhav@ti.com, linux-media@vger.kernel.org, g.liakhovetski@gmx.de
References: <1317130848-21136-1-git-send-email-deepthy.ravi@ti.com> <1317130848-21136-3-git-send-email-deepthy.ravi@ti.com>
In-Reply-To: <1317130848-21136-3-git-send-email-deepthy.ravi@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109280120.09228.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Deepthy,

Thanks for the patch.

Please try to avoid adding too many people (and mailing lists) to the CC list. 
I've pruned it down as most of them are not directly concerned by this patch.

On Tuesday 27 September 2011 15:40:45 Deepthy Ravi wrote:
> Added support for mt9t111 sensor in the existing
> mt9t112 driver. Also added support for media controller
> framework. The sensor driver currently supports only
> VGA resolution.
> 
> Signed-off-by: Deepthy Ravi <deepthy.ravi@ti.com>

[snip]

> +mt9t111_regs patch_rev6[] = {
> +	{0, 0x0982, 0x0},
> +	{0, 0x098A, 0xCE7},
> +	{0, 0x0990, 0x3C3C},
> +	{0, 0x0992, 0x3C3C},
> +	{0, 0x0994, 0x3C5F},
> +	{0, 0x0996, 0x4F30},
> +	{0, 0x0998, 0xED08},
> +	{0, 0x099a, 0xBD61},
> +	{0, 0x099c, 0xD5CE},

[snip]

I'm afraid register lists are not an option. You will need to follow the 
mt9t112 driver practice and program the registers based on formats, crop 
rectangles and other settings.

-- 
Regards,

Laurent Pinchart
