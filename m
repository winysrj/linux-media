Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31130 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751317AbdIMJK2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 05:10:28 -0400
Date: Wed, 13 Sep 2017 12:10:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Allen Pais <allen.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v3] drivers/staging:[media]atomisp:use ARRAY_SIZE()
 instead of open coding.
Message-ID: <20170913091000.3dtzrx3rr4g5rql3@mwanda>
References: <1505293073-27622-1-git-send-email-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1505293073-27622-1-git-send-email-allen.lkml@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 13, 2017 at 02:27:53PM +0530, Allen Pais wrote:
> Signed-off-by: Allen Pais <allen.lkml@gmail.com>

Sorry, the patch is right, but the commit is still totally messed up.

bad:  [PATCH v3] drivers/staging:[media]atomisp:use ARRAY_SIZE() instead of open coding.
good: [PATCH v4] [media] atomisp: use ARRAY_SIZE() instead of open coding.

Please, copy the "[media] atomisp: " prefix exactly as I wrote it.  Then
the commit message can say something like:

The array_length() macro just duplicates ARRAY_SIZE() so we can delete
it.

> Signed-off-by: Allen Pais <allen.lkml@gmail.com>
> ---
  ^^^

Then under the --- line put:
v4: Update the commit message.

regards,
dan carpenter
