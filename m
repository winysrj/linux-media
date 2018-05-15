Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753189AbeEOMyk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 08:54:40 -0400
Date: Tue, 15 May 2018 14:54:23 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Oliver Neukum <oneukum@suse.com>
Cc: mchehab@s-opensource.com, ben.hutchings@codethink.co.uk,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] usbtv: Fix refcounting mixup
Message-ID: <20180515125423.GA7303@kroah.com>
References: <20180515115137.27724-1-oneukum@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180515115137.27724-1-oneukum@suse.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 15, 2018 at 01:51:37PM +0200, Oliver Neukum wrote:
> The premature free in the error path is blocked by V4L
> refcounting, not USB refcounting. Thanks to
> Ben Hutchings for review.
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> Fixes: 50e704453553 ("media: usbtv: prevent double free in error case")

Please add:
Cc: stable <stable@vger.kernel.org>

to this patch as well so I pick up the fix in the stable trees.

And a "Reported-by:" line would be nice as well to give credit to Ben :)

thanks,

greg k-h
