Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:60199 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731585AbeKOBD3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 20:03:29 -0500
Message-ID: <1542207593.4095.13.camel@pengutronix.de>
Subject: Re: [PATCH 07/15] media: coda: don't disable IRQs across buffer
 meta handling
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Date: Wed, 14 Nov 2018 15:59:53 +0100
In-Reply-To: <20181105152513.26345-7-p.zabel@pengutronix.de>
References: <20181105152513.26345-1-p.zabel@pengutronix.de>
         <20181105152513.26345-7-p.zabel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-11-05 at 16:25 +0100, Philipp Zabel wrote:
> From: Lucas Stach <l.stach@pengutronix.de>
> 
> The CODA driver uses threaded IRQs only, so there is nothing happening
> in hardirq context that could interfere with the buffer meta handling.
> 
> Signed-off-by: Lucas Stach <l.stach@pengutronix.de>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
