Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52858 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510AbaFKLW3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jun 2014 07:22:29 -0400
Message-ID: <1402485748.4107.110.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 03/43] imx-drm: ipu-v3: Add ipu_get_num()
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Wed, 11 Jun 2014 13:22:28 +0200
In-Reply-To: <1402178205-22697-4-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
	 <1402178205-22697-4-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Samstag, den 07.06.2014, 14:56 -0700 schrieb Steve Longerbeam:
> Adds of-alias id to ipu_soc and retrieve with ipu_get_num().

It would be nice to have a comment here what this will be needed for.

I see that later ipu-csi uses this to find the correct input mux and
mx6-encode selects the DMA channel depending on this.
I feel like the mux should be handled as a separate v4l2_subdev since it
is not part of the IPU, it is different between i.MX6Q and i.MX6DL, and
it doesn't even exist on i.MX5.

regards
Philipp

