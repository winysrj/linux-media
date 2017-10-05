Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50306 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751295AbdJEMdH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Oct 2017 08:33:07 -0400
Date: Thu, 5 Oct 2017 15:32:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] [STABLE-4.13] [media] imx-media-of: avoid uninitialized
 variable warning
Message-ID: <20171005123217.a4hpgbpq7ifv4d34@mwanda>
References: <20171004133507.3539072-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171004133507.3539072-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 04, 2017 at 03:34:55PM +0200, Arnd Bergmann wrote:
> Replaces upstream commit 0b2e9e7947e7 ("media: staging/imx: remove
> confusing IS_ERR_OR_NULL usage")
> 
> We get a harmless warning about a potential uninitialized variable
> use in the driver:
> 
> drivers/staging/media/imx/imx-media-of.c: In function 'of_parse_subdev':
> drivers/staging/media/imx/imx-media-of.c:216:4: warning: 'remote_np' may be used uninitialized in this function [-Wmaybe-uninitialized]
> 
> I reworked that code to be easier to understand by gcc in mainline,
> but that commit is too large to backport. This is a much simpler
> workaround, avoiding the warning by adding a fake initialization
> to the variable. The driver was only introduced in linux-4.13,
> so the workaround is not needed for earlier stable kernels.
> 
> Fixes: e130291212df ("[media] media: Add i.MX media core driver")

I normally leave off the Fixes tag when it's not a bugfix.  The warning
is, as you mentioned, harmless.

regards,
dan carpenter
