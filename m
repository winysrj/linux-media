Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59851 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750763AbeEROVz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 10:21:55 -0400
Message-ID: <1526653313.3948.13.camel@pengutronix.de>
Subject: Re: [PATCH v3 1/2] media: imx: capture: refactor enum_/try_fmt
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Jan Luebbe <jlu@pengutronix.de>, linux-media@vger.kernel.org
Cc: slongerbeam@gmail.com, kernel@pengutronix.de
Date: Fri, 18 May 2018 16:21:53 +0200
In-Reply-To: <20180518135639.19889-2-jlu@pengutronix.de>
References: <20180518135639.19889-1-jlu@pengutronix.de>
         <20180518135639.19889-2-jlu@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-05-18 at 15:56 +0200, Jan Luebbe wrote:
> By checking and handling the internal IPU formats (ARGB or AYUV) first,
> we don't need to check whether it's a bayer format, as we can default to
> passing the input format on in all other cases.
> 
> This simplifies handling the different configurations for RGB565 between
> parallel and MIPI CSI-2, as we don't need to check the details of the
> format anymore.
> 
> Signed-off-by: Jan Luebbe <jlu@pengutronix.de>

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
