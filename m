Return-path: <linux-media-owner@vger.kernel.org>
Received: from vs1.galsoft.net ([88.198.34.156]:38971 "EHLO mail.galsoft.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbbGQCIO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2015 22:08:14 -0400
Date: Thu, 16 Jul 2015 20:58:35 -0500
From: Adam Majer <adamm@zombino.com>
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH] [media]: Fix compilation when
 CONFIG_VIDEO_V4L2_SUBDEV_API is not set
Message-ID: <20150717015833.GA28249@mira.lan.galacticasoftware.com>
References: <1437088855-17002-1-git-send-email-adamm@zombino.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1437088855-17002-1-git-send-email-adamm@zombino.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 16, 2015 at 06:20:55PM -0500, Adam Majer wrote:
> When CONFIG_VIDEO_V4L2_SUBDEV_API is unset, some drivers fail to
> compile as they use unavailable API.
> 
>   drivers/media/i2c/adv7511.c:968:3: error: implicit declaration of
>   function ‘v4l2_subdev_get_try_format’
>   [-Werror=implicit-function-declaration]


oops, maybe this is unnecessary. Seems I had CONFIG_COBALT set which
was causing problems.

warning: (VIDEO_COBALT) selects VIDEO_ADV7511 which has unmet direct
dependencies (MEDIA_SUPPORT && VIDEO_V4L2 && I2C &&
VIDEO_V4L2_SUBDEV_API)
....

so please ignore.

- Adam


-- 
Adam Majer
adamm@zombino.com
