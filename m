Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43058 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbaFDPDu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jun 2014 11:03:50 -0400
Message-ID: <1401894225.3447.17.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v2 1/5] [media] mt9v032: reset is self clearing
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Date: Wed, 04 Jun 2014 17:03:45 +0200
In-Reply-To: <2378157.AyxZjdgtXs@avalon>
References: <1401788155-3690-1-git-send-email-p.zabel@pengutronix.de>
	 <1401788155-3690-2-git-send-email-p.zabel@pengutronix.de>
	 <2378157.AyxZjdgtXs@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Am Mittwoch, den 04.06.2014, 16:49 +0200 schrieb Laurent Pinchart:
> Hi Philipp,
> 
> Thank you for the patch.
> 
> On Tuesday 03 June 2014 11:35:51 Philipp Zabel wrote:
> > According to the publicly available MT9V032 data sheet, the reset bits are
> > self clearing and the reset register always reads 0. The reset will be
> > asserted for 15 SYSCLK cycles. Instead of writing 0 to the register, wait
> > using ndelay.
> 
> On the other hand, revision D of the datasheet states on page 71 ("Appendix A 
> - Serial Configurations, Figure 46: Stand-Alone Topology") that the typical 
> configuration of the sensor includes issuing a soft reset with 
> 
> 4. Issue a soft reset (set R0x0C[0] = 1 followed by R0x0C[0] = 0.
> 
> I wonder whether it wouldn't be safer to keep the register write. Do you see 
> any adverse effect of keeping it ?

No, writing 0 doesn't have any effect. Since the datasheet suggests
doing this, let's just drop this patch and keep the code as is.

regards
Philipp

