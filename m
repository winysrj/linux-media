Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44206 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaGaP2E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jul 2014 11:28:04 -0400
Message-ID: <1406820482.16697.59.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 00/28] IPUv3 prep for video capture
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Thu, 31 Jul 2014 17:28:02 +0200
In-Reply-To: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
References: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Steve,

Am Mittwoch, den 25.06.2014, 18:05 -0700 schrieb Steve Longerbeam:
> Hi Philip, Sascha,
> 
> Here is a rebased set of IPU patches that prepares for video capture
> support. Video capture is not included in this set. I've addressed
> all your IPU-specific concerns from the previous patch set, the
> major ones being:
> 
> - the IOMUXC control for CSI input selection has been removed. This
>   should be part of a future CSI media entity driver.
> 
> - the ipu-irt unit has been removed. Enabling the IRT module is
>   folded into ipu-ic unit. The ipu-ic unit is also cleaned up a bit.
>
> - the ipu-csi APIs are consolidated/simplified.
> 
> - added CSI and IC base offsets for i.MX51/i.MX53.

Sorry for the delay, I have only now started to look at the IPU again in
detail, and I still have a few comments. I'll reply to the individual
patches.

regards
Philipp


