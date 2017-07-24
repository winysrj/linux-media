Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:46243 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752006AbdGXHVK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Jul 2017 03:21:10 -0400
Message-ID: <1500880868.2391.14.camel@pengutronix.de>
Subject: Re: [PATCH] media: imx: prpencvf: enable double write reduction
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Mon, 24 Jul 2017 09:21:08 +0200
In-Reply-To: <1500758501-5394-1-git-send-email-steve_longerbeam@mentor.com>
References: <1500758501-5394-1-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2017-07-22 at 14:21 -0700, Steve Longerbeam wrote:
> For the write channels with 4:2:0 subsampled YUV formats, avoid chroma
> overdraw by only writing chroma for even lines. Reduces necessary write
> memory bandwidth by at least 25% (more with rotation enabled).
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
