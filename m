Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18679 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750892AbdITN4Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 09:56:25 -0400
Date: Wed, 20 Sep 2017 16:56:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] [media] Siano: Use common error handling code in
 smsusb_init_device()
Message-ID: <20170920135605.sneukaioeabalkud@mwanda>
References: <be0003e5-d8e0-bff6-2205-7e88270ba2b4@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be0003e5-d8e0-bff6-2205-7e88270ba2b4@users.sourceforge.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 20, 2017 at 02:40:28PM +0200, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 20 Sep 2017 14:30:55 +0200
> 
> Add a jump target so that a bit of exception handling can be better
> reused at the end of this function.
> 
> This refactoring might fix also an error situation where the
> function "kfree" was not called after a software failure
> was noticed in two cases.
> 

No.  It doesn't fix a leak, it introduces a double free.  If
smscore_register_device() succeeds then mdev is freed when we call
smsusb_term_device(intf);  The call tree is:

smsusb_term_device()
 -> smscore_unregister_device()
    -> smscore_notify_clients()
       -> smsdvb_onremove()
          -> smsdvb_unregister_client()
             -> smsdvb_media_device_unregister()
                -> kfree(coredev->media_dev);

regards,
dan carpenter
