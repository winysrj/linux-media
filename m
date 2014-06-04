Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60497 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaFDQpk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jun 2014 12:45:40 -0400
Message-ID: <1401900328.3447.41.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v2 5/5] [media] mt9v032: use regmap
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Date: Wed, 04 Jun 2014 18:45:28 +0200
In-Reply-To: <2116541.LBf4Vp52ig@avalon>
References: <1401788155-3690-1-git-send-email-p.zabel@pengutronix.de>
	 <1401788155-3690-6-git-send-email-p.zabel@pengutronix.de>
	 <2116541.LBf4Vp52ig@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Am Mittwoch, den 04.06.2014, 17:44 +0200 schrieb Laurent Pinchart:
> Hi Philipp,
> 
> Thank you for the patch.
> 
> On Tuesday 03 June 2014 11:35:55 Philipp Zabel wrote:
> > This switches all register accesses to use regmap. It allows to
> > use the regmap cache, tracing, and debug register dump facilities,
> > and removes the need to open code read-modify-writes.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> 
> This looks good to me, but I have two small questions:
> 
> - How does regmap handle endianness ? It seems to hardcode a big endian byte 
> order, which is fortunately what we need here.

We could set regmap_config->val_format_endian = REGMAP_ENDIAN_BIG.
This defaults to big endian unless the regmap_bus says otherwise
(regmap-i2c doesn't).

> I suppose you've successfully tested this patch :-)

Yes.

> - How does regmap handle the register cache ? Will it try to populate it when 
> initialized, or will it only read registers on demand due to a read or an 
> update bits operation ?

That depends on the cache implementation. regcache-rbtree has a
cache_present bitmap per node. As long as the corresponding bit is not
set, regcache_read will return -ENOENT and regmap_read will then do an
actual register read (and store the result in the cache).

regcache-flat doesn't have this at all, so it would be necessary to
provide initial register values in the driver or explicitly read back
from the hardware during initialization. This is also be possible with
the rbtree cache.

regards
Philipp

