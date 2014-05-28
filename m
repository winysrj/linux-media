Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32827 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791AbaE1OhW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 May 2014 10:37:22 -0400
Message-ID: <1401287840.3054.63.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v2] [media] mt9v032: fix hblank calculation
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Date: Wed, 28 May 2014 16:37:20 +0200
In-Reply-To: <63696231.uYod94i5s6@avalon>
References: <1401112551-21046-1-git-send-email-p.zabel@pengutronix.de>
	 <63696231.uYod94i5s6@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Am Mittwoch, den 28.05.2014, 13:12 +0200 schrieb Laurent Pinchart:
> Hi Philipp,
> 
> Thank you for the patch.
> 
> On Monday 26 May 2014 15:55:51 Philipp Zabel wrote:
> > Since (min_row_time - crop->width) can be negative, we have to do a signed
> > comparison here. Otherwise max_t casts the negative value to unsigned int
> > and sets min_hblank to that invalid value.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> and applied to my tree. Do you see a need to fasttrack this to v3.16 or can it 
> be applied to v3.17 ? Should I CC stable ?

Thank you, no need to fasttrack this from my side.

regards
Philipp

