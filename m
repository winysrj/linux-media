Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42170 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219AbaFKLWr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jun 2014 07:22:47 -0400
Message-ID: <1402485765.4107.112.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 07/43] imx-drm: ipu-v3: Rename and add IDMAC channels
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Wed, 11 Jun 2014 13:22:45 +0200
In-Reply-To: <1402178205-22697-8-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
	 <1402178205-22697-8-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Samstag, den 07.06.2014, 14:56 -0700 schrieb Steve Longerbeam:
> Rename the ENC/VF/PP rotation channel names, to be more consistent
> with the convention that *_MEM is write-to-memory channels and
> MEM_* is read-from-memory channels. Also add the channels who's
> source and destination is the IC.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>

Looks good to me,
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

