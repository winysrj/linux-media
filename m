Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:50141 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753247AbdGLPuP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Jul 2017 11:50:15 -0400
Message-ID: <1499874605.6374.56.camel@pengutronix.de>
Subject: Re: [PATCH v2] [media] staging/imx: remove confusing IS_ERR_OR_NULL
 usage
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Marek Vasut <marex@denx.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Wed, 12 Jul 2017 17:50:05 +0200
In-Reply-To: <20170711132001.2266388-1-arnd@arndb.de>
References: <20170711132001.2266388-1-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-07-11 at 15:18 +0200, Arnd Bergmann wrote:
> While looking at a compiler warning, I noticed the use of
> IS_ERR_OR_NULL, which is generally a sign of a bad API design
> and should be avoided.
> 
> In this driver, this is fairly easy, we can simply stop storing
> error pointers in persistent structures, and change the two
> functions that might return either a NULL pointer or an error
> code to consistently return error pointers when failing.
> 
> of_parse_subdev() now separates the error code and the pointer
> it looks up, to clarify the interface. There are two cases
> where this function originally returns 'NULL', and I have
> changed that to '0' for success to keep the current behavior,
> though returning an error would also make sense there.
> 
> Fixes: e130291212df ("[media] media: Add i.MX media core driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v2: fix type mismatch
> v3: rework of_parse_subdev() as well.

Thanks!

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Tested-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
