Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47880 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752673AbdCFMvl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Mar 2017 07:51:41 -0500
Date: Mon, 6 Mar 2017 13:51:29 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Derek Robson <robsonde@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, mchehab@kernel.org,
        swarren@wwwdotorg.org, lee@kernel.org, eric@anholt.net,
        f.fainelli@gmail.com, rjui@broadcom.com, sbranden@broadcom.com,
        arnd@arndb.de, mzoran@crowfest.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] Staging: media: platform: bcm2835 - Style fix
Message-ID: <20170306125129.GA26115@kroah.com>
References: <20170304013120.24949-1-robsonde@gmail.com>
 <20170304113548.GA4386@mwanda>
 <20170304214319.GA15368@bigbird>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170304214319.GA15368@bigbird>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 05, 2017 at 10:43:19AM +1300, Derek Robson wrote:
> On Sat, Mar 04, 2017 at 02:57:22PM +0300, Dan Carpenter wrote:
> > Copy a patch prefix that everyone else has been using:
> > 
> > git log --oneline drivers/staging/media/platform/bcm2835/
> > 
> > The subject is too vague as well.
> 
> Is this what you are looking for?
> 
> [patch] Staging: bcm2835: fixed style of block comments

Yes.

> And should I just re-send as a V2 with new subject?

Yes.

thanks,

greg k-h
