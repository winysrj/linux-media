Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52850 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253AbaFKLWN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jun 2014 07:22:13 -0400
Message-ID: <1402485730.4107.109.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 01/43] imx-drm: ipu-v3: Move imx-ipu-v3.h to
 include/linux/platform_data/
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Wed, 11 Jun 2014 13:22:10 +0200
In-Reply-To: <1402178205-22697-2-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
	 <1402178205-22697-2-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Samstag, den 07.06.2014, 14:56 -0700 schrieb Steve Longerbeam:
> In subsequent patches, the video capture units will be added (csi, smfc,
> ic, irt). So the IPU prototypes are no longer needed only by imx-drm,
> so we need to export them to a common include path.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>

I have already moved the header into include/video/imx-ipu-v3.h in
39b9004d1f626b88b775c7655d3f286e135dfec6.

regards
Philipp

