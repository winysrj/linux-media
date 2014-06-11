Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42165 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626AbaFKLWi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jun 2014 07:22:38 -0400
Message-ID: <1402485756.4107.111.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 06/43] imx-drm: ipu-v3: Add functions to set CSI/IC
 source muxes
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Wed, 11 Jun 2014 13:22:36 +0200
In-Reply-To: <1402178205-22697-7-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
	 <1402178205-22697-7-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Samstag, den 07.06.2014, 14:56 -0700 schrieb Steve Longerbeam:
> Adds two new functions, ipu_set_csi_src_mux() and ipu_set_ic_src_mux(),
> that select the inputs to the CSI and IC respectively. Both muxes are
> programmed in the IPU_CONF register.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

