Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:35811 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbbBBPY2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2015 10:24:28 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NJ500J8AHGRC790@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 02 Feb 2015 10:24:27 -0500 (EST)
Date: Mon, 02 Feb 2015 13:24:21 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH v2 1/3] Add BGR888_1X24 and GBR888_1X24 media bus formats
Message-id: <20150202132421.6f2ecbd3.m.chehab@samsung.com>
In-reply-to: <1422890460.6112.9.camel@pengutronix.de>
References: <1417614811-15634-1-git-send-email-p.zabel@pengutronix.de>
 <54CF92DD.6020308@xs4all.nl> <1422890460.6112.9.camel@pengutronix.de>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 02 Feb 2015 16:21:00 +0100
Philipp Zabel <p.zabel@pengutronix.de> escreveu:

> Am Montag, den 02.02.2015, 16:08 +0100 schrieb Hans Verkuil:
> > On 12/03/2014 02:53 PM, Philipp Zabel wrote:
> > > This patch adds two more 24-bit RGB formats. BGR888 is more or less common,
> > > GBR888 is used on the internal connection between the IPU display interface
> > > and the TVE (VGA DAC) on i.MX53 SoCs.
> > > 
> > > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > 
> > This three-part patch series doesn't apply. Is it on top of another patch
> > series?
> 
> It is on top of "Add RGB444_1X12 and RGB565_1X16 media bus formats" and
> "Add LVDS RGB media bus formats".
> 
> > Anyway, it can't be merged unless it is actually used in a driver.
> 
> I'd like to use these in the imx-drm driver, so this is kind of a
> chicken and egg situation. Shall I submit a patch that uses the defines
> to dri-devel and reference it here?

Submit the full patch series with the imx-drm driver, mentioning at the
V4L2 patch that it will be applied via the DRM tree. We'll review
and give our ack for it to be applied via DRM tree.

Regards,
Mauro

> 
> regards
> Philipp
> 
