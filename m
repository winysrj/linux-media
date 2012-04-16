Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34509 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751052Ab2DPRIe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Apr 2012 13:08:34 -0400
Message-ID: <4F8C5210.5030604@iki.fi>
Date: Mon, 16 Apr 2012 20:08:32 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v3 5/9] omap3isp: preview: Merge configuration and feature
 bits
References: <1334582994-6967-1-git-send-email-laurent.pinchart@ideasonboard.com> <1334582994-6967-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1334582994-6967-6-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patch.

Laurent Pinchart wrote:
> The preview engine parameters are referenced by a value suitable for
> being used in a bitmask. Two macros named OMAP3ISP_PREV_* and PREV_* are
> declared for each parameter and are used interchangeably. Remove the
> private macro.
>
> Replace the configuration bit field in the parameter update attributes
> structure with a boolean that indicates whether the parameter can be
> updated through the preview engine configuration ioctl.
>
> Signed-off-by: Laurent Pinchart<laurent.pinchart@ideasonboard.com>

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
sakari.ailus@iki.fi
