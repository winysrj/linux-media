Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49302 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaGaSGr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jul 2014 14:06:47 -0400
Message-ID: <1406830005.16697.86.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 27/28] gpu: ipu-cpmem: Add ipu_cpmem_dump()
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Thu, 31 Jul 2014 20:06:45 +0200
In-Reply-To: <1403744755-24944-28-git-send-email-steve_longerbeam@mentor.com>
References: <1403744755-24944-1-git-send-email-steve_longerbeam@mentor.com>
	 <1403744755-24944-28-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mittwoch, den 25.06.2014, 18:05 -0700 schrieb Steve Longerbeam:
> Adds ipu_cpmem_dump() which dumps a channel's cpmem to debug.

Maybe #ifdef DEBUG this and ipu_dump?

regards
Philipp

