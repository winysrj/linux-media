Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36507 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752170AbdCDVvI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 4 Mar 2017 16:51:08 -0500
Date: Sun, 5 Mar 2017 10:43:19 +1300
From: Derek Robson <robsonde@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        swarren@wwwdotorg.org, lee@kernel.org, eric@anholt.net,
        f.fainelli@gmail.com, rjui@broadcom.com, sbranden@broadcom.com,
        arnd@arndb.de, mzoran@crowfest.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] Staging: media: platform: bcm2835 - Style fix
Message-ID: <20170304214319.GA15368@bigbird>
References: <20170304013120.24949-1-robsonde@gmail.com>
 <20170304113548.GA4386@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170304113548.GA4386@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Mar 04, 2017 at 02:57:22PM +0300, Dan Carpenter wrote:
> Copy a patch prefix that everyone else has been using:
> 
> git log --oneline drivers/staging/media/platform/bcm2835/
> 
> The subject is too vague as well.

Is this what you are looking for?

[patch] Staging: bcm2835: fixed style of block comments

And should I just re-send as a V2 with new subject?

Thanks
