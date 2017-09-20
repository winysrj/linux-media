Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:40665 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751468AbdITKFD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 06:05:03 -0400
Message-ID: <1505901896.7865.4.camel@pengutronix.de>
Subject: Re: [PATCH v2 1/2] [media] coda: Handle return value of kasprintf
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Arvind Yadav <arvind.yadav.cs@gmail.com>, mchehab@kernel.org,
        hans.verkuil@cisco.com, sean@mess.org, andi.shyti@samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 20 Sep 2017 12:04:56 +0200
In-Reply-To: <5533660490db4a91bb25e3984c3d6bd20eb230f6.1505899966.git.arvind.yadav.cs@gmail.com>
References: <5533660490db4a91bb25e3984c3d6bd20eb230f6.1505899966.git.arvind.yadav.cs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-09-20 at 15:10 +0530, Arvind Yadav wrote:
> kasprintf() can fail here and we must check its return value.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
> changes in v2 :
> 	Calling coda_free_framebuffers to release already allocated buffers.

Thanks,

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
