Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21992 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751219AbdBXT7H (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Feb 2017 14:59:07 -0500
Date: Fri, 24 Feb 2017 22:57:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Stefan Wahren <stefan.wahren@i2se.com>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        mchehab@kernel.org, gregkh@linuxfoundation.org,
        f.fainelli@gmail.com, rjui@broadcom.com, sbranden@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, swarren@wwwdotorg.org,
        lee@kernel.org, eric@anholt.net, arnd@arndb.de,
        devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] staging: bcm2835: Fix a memory leak in error handling
 path
Message-ID: <20170224195731.GB4480@mwanda>
References: <20170219103412.10092-1-christophe.jaillet@wanadoo.fr>
 <6585ca42-71f4-1517-c6fc-b9ed2f23c687@i2se.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6585ca42-71f4-1517-c6fc-b9ed2f23c687@i2se.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 24, 2017 at 01:37:30PM +0100, Stefan Wahren wrote:
> Hi Christophe,
> 
> Am 19.02.2017 um 11:34 schrieb Christophe JAILLET:
> >If 'kzalloc()' fails, we should release resources allocated so far, just as
> >done in all other cases in this function.
> >
> >Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> >---
> >Not sure that the error handling path is correct.
> >Is 'gdev[0]' freed? Should it be?
> 

Yes, but I already sent a patch to fix this and your leak as well and
Greg merged it.

> sorry, didn't checked your patch yet.

It takes like 30 seconds to review this patch.  Do you use mutt?  I have
a macro that applies patches and loads vim at the right line.

regards,
dan carpenter
