Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42193 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbaFKLXs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jun 2014 07:23:48 -0400
Message-ID: <1402485824.4107.115.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 22/43] imx-drm: ipu-v3: Add ipu-cpmem unit
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>,
	Drew Moseley <drew_moseley@mentor.com>
Date: Wed, 11 Jun 2014 13:23:44 +0200
In-Reply-To: <1402178205-22697-23-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
	 <1402178205-22697-23-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Samstag, den 07.06.2014, 14:56 -0700 schrieb Steve Longerbeam:
> Move channel parameter memory setup functions and macros into a new
> submodule ipu-cpmem. In the process, cleanup arguments to the functions
> to take a channel pointer instead of a pointer into cpmem for that
> channel. That allows the structure of the parameter memory to be
> private to ipu-cpmem.c.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> Signed-off-by: Drew Moseley <drew_moseley@mentor.com>

I like the move of cpmem handling code into its own submodule.
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

