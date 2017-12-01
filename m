Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20896 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750975AbdLAPHp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Dec 2017 10:07:45 -0500
Date: Fri, 1 Dec 2017 18:07:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 1/3] media: atomisp: convert default struct values to use
 compound-literals with designated initializers.
Message-ID: <20171201150725.cfcp6b4bs2ncqsip@mwanda>
References: <20171129083835.tam3avqz5vishwqw@azazel.net>
 <20171130214014.31412-1-jeremy@azazel.net>
 <20171130214014.31412-2-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171130214014.31412-2-jeremy@azazel.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I can't apply this (to today's linux-next) but does this really work:

> +(struct ia_css_3a_grid_info) { \
> +	.ae_enable		= 0, \
> +	.ae_grd_info		= (struct ae_public_config_grid_config) { \
> +					width = 0, \
> +					height = 0, \
> +					b_width = 0, \
> +					b_height = 0, \
> +					x_start = 0, \
> +					y_start = 0, \
> +					x_end = 0, \
> +					y_end = 0 \

I'm pretty sure those lines should start with a period.

- 					width = 0, \
+					.width = 0, \

regards,
dan
