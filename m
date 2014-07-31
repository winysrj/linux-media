Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52397 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaGaSCs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jul 2014 14:02:48 -0400
Message-ID: <1406829766.16697.84.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 16/28] gpu: ipu-v3: Add ipu_stride_to_bytes()
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Thu, 31 Jul 2014 20:02:46 +0200
In-Reply-To: <1403744755-24944-17-git-send-email-steve_longerbeam@mentor.com>
References: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
	 <1403744755-24944-17-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mittwoch, den 25.06.2014, 18:05 -0700 schrieb Steve Longerbeam:
> Adds ipu_stride_to_bytes(), which converts a pixel stride to bytes,
> suitable for passing to cpmem.

This is not IPU specific. You already have the bytesperline information
from the V4L2 driver or have to calculate it there, and that shouldn't
be done by calling into IPU core code.

regards
Philipp

