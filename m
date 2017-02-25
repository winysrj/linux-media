Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17740 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751460AbdBYENg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Feb 2017 23:13:36 -0500
Date: Sat, 25 Feb 2017 07:11:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Stefan Wahren <stefan.wahren@i2se.com>
Cc: lee@kernel.org, rjui@broadcom.com, linux-media@vger.kernel.org,
        eric@anholt.net, kernel-janitors@vger.kernel.org, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, mchehab@kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        sbranden@broadcom.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, devel@driverdev.osuosl.org,
        swarren@wwwdotorg.org, f.fainelli@gmail.com,
        linux-rpi-kernel@lists.infradead.org
Subject: Re: [PATCH] staging: bcm2835: Fix a memory leak in error handling
 path
Message-ID: <20170225041111.GB4429@mwanda>
References: <20170219103412.10092-1-christophe.jaillet@wanadoo.fr>
 <6585ca42-71f4-1517-c6fc-b9ed2f23c687@i2se.com>
 <20170224195731.GB4480@mwanda>
 <398315856.259038.1487972318815@email.1und1.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <398315856.259038.1487972318815@email.1und1.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 24, 2017 at 10:38:38PM +0100, Stefan Wahren wrote:
> 
> > Dan Carpenter <dan.carpenter@oracle.com> hat am 24. Februar 2017 um 20:57 geschrieben:
> > 
> > 
> > On Fri, Feb 24, 2017 at 01:37:30PM +0100, Stefan Wahren wrote:
> > > Hi Christophe,
> > > 
> > > Am 19.02.2017 um 11:34 schrieb Christophe JAILLET:
> > > >If 'kzalloc()' fails, we should release resources allocated so far, just as
> > > >done in all other cases in this function.
> > > >
> > > >Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> > > >---
> > > >Not sure that the error handling path is correct.
> > > >Is 'gdev[0]' freed? Should it be?
> > > 
> > 
> > Yes, but I already sent a patch to fix this and your leak as well and
> > Greg merged it.
> 
> My leak? I'm confused.

The one you're fixing I mean.
