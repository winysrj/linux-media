Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:62289 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbbF2OkF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2015 10:40:05 -0400
Subject: Re: [PATCH 1/1] SMI PCIe IR driver for DVBSky cards
To: Nibble Max <nibble.max@gmail.com>, Dirk Nehring <dnehring@gmx.net>
References: <201506292209394689855@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
From: Ole Ernst <olebowle@gmx.com>
Message-ID: <559158C1.5050704@gmx.com>
Date: Mon, 29 Jun 2015 16:40:01 +0200
MIME-Version: 1.0
In-Reply-To: <201506292209394689855@gmail.com>
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Max,

Am 29.06.2015 um 16:09 schrieb Nibble Max:
> ported from the manufacturer's source tree, available from
> http://dvbsky.net/download/linux/media_build-bst-150211.tar.gz
> 
> This is the second patch after a public review.

just for the sake of clarity: I see commented out bits and pieces of
RC_DRIVER_IR_RAW in your linked archive. Does this mean S950/S952/T9580
V3 models theoretically support arbitrary IR codes, but with this patch
only RC5 is implemented? Or are those models only able to handle RC5?

Regards,
Ole
