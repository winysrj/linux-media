Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:54912 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751240AbeECMgz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2018 08:36:55 -0400
Date: Thu, 3 May 2018 15:36:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: niklas.soderlund+renesas@ragnatech.se
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [bug report] media: rcar-vin: add group allocator functions
Message-ID: <20180503123630.GA19539@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Niklas Söderlund,

The patch 3bb4c3bc85bf: "media: rcar-vin: add group allocator
functions" from Apr 14, 2018, leads to the following static checker
warning:

	drivers/media/platform/rcar-vin/rcar-core.c:346 rvin_group_put()
	error: potential NULL dereference 'vin->group'.

drivers/media/platform/rcar-vin/rcar-core.c
   339  static void rvin_group_put(struct rvin_dev *vin)
   340  {
   341          mutex_lock(&vin->group->lock);
   342  
   343          vin->group = NULL;
                ^^^^^^^^^^^^^^^^^
Set to NULL.

   344          vin->v4l2_dev.mdev = NULL;
   345  
   346          if (WARN_ON(vin->group->vin[vin->id] != vin))
                            ^^^^^^^^^^^^^^^^^^^^^^^^
   347                  goto out;
   348  
   349          vin->group->vin[vin->id] = NULL;
                ^^^^^^^^^^^^^^^^^^^^^^^^
   350  out:
   351          mutex_unlock(&vin->group->lock);
                              ^^^^^^^^^^^^^^^^
   352  
   353          kref_put(&vin->group->refcount, rvin_group_release);
                          ^^^^^^^^^^^^^^^^^^^^

There are a bunch of NULL dereferences here...

   354  }

regards,
dan carpenter
