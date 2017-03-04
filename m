Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21343 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751858AbdCDL7u (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 4 Mar 2017 06:59:50 -0500
Date: Sat, 4 Mar 2017 14:57:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Derek Robson <robsonde@gmail.com>
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        swarren@wwwdotorg.org, lee@kernel.org, eric@anholt.net,
        f.fainelli@gmail.com, rjui@broadcom.com, sbranden@broadcom.com,
        arnd@arndb.de, mzoran@crowfest.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] Staging: media: platform: bcm2835 - Style fix
Message-ID: <20170304113548.GA4386@mwanda>
References: <20170304013120.24949-1-robsonde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170304013120.24949-1-robsonde@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Copy a patch prefix that everyone else has been using:

git log --oneline drivers/staging/media/platform/bcm2835/

The subject is too vague as well.

regards,
dan carpenter
