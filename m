Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48603 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbbBBPVM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2015 10:21:12 -0500
Message-ID: <1422890460.6112.9.camel@pengutronix.de>
Subject: Re: [PATCH v2 1/3] Add BGR888_1X24 and GBR888_1X24 media bus formats
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Date: Mon, 02 Feb 2015 16:21:00 +0100
In-Reply-To: <54CF92DD.6020308@xs4all.nl>
References: <1417614811-15634-1-git-send-email-p.zabel@pengutronix.de>
	 <54CF92DD.6020308@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, den 02.02.2015, 16:08 +0100 schrieb Hans Verkuil:
> On 12/03/2014 02:53 PM, Philipp Zabel wrote:
> > This patch adds two more 24-bit RGB formats. BGR888 is more or less common,
> > GBR888 is used on the internal connection between the IPU display interface
> > and the TVE (VGA DAC) on i.MX53 SoCs.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> This three-part patch series doesn't apply. Is it on top of another patch
> series?

It is on top of "Add RGB444_1X12 and RGB565_1X16 media bus formats" and
"Add LVDS RGB media bus formats".

> Anyway, it can't be merged unless it is actually used in a driver.

I'd like to use these in the imx-drm driver, so this is kind of a
chicken and egg situation. Shall I submit a patch that uses the defines
to dri-devel and reference it here?

regards
Philipp

