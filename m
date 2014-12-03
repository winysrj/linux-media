Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60069 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaLCNvT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Dec 2014 08:51:19 -0500
Message-ID: <1417614670.5124.15.camel@pengutronix.de>
Subject: Re: [PATCH 1/3] Add BGR888_1X24 and GBR888_1X24 media bus formats
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Date: Wed, 03 Dec 2014 14:51:10 +0100
In-Reply-To: <1857174.h7s3t8B9N4@avalon>
References: <1417602500-29152-1-git-send-email-p.zabel@pengutronix.de>
	 <1857174.h7s3t8B9N4@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mittwoch, den 03.12.2014, 14:48 +0200 schrieb Laurent Pinchart:
> Hi Philipp,
> 
> Thank you for the patch.

Thank you for the comments. I'll fix the issues you pointed out and
resend.

> On Wednesday 03 December 2014 11:28:18 Philipp Zabel wrote:
> > This patch adds two more 24-bit RGB formats. BGR888 is more or less common,
> > GBR888 is used on the internal connection between the IPU display interface
> > and the TVE (VGA DAC) on i.MX53 SoCs.
> 
> Were RGB and BGR patented that they had to use a new format ? :-)

I wish I knew.
[...]

regards
Philipp

