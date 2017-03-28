Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59978 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752696AbdC1FXx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Mar 2017 01:23:53 -0400
Date: Tue, 28 Mar 2017 07:23:36 +0200
From: Greg KH <greg@kroah.com>
To: vaibhavddit@gmail.com
Cc: mchehab@kernel.org, devel@driverdev.osuosl.org,
        rvarsha016@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] staging: media: atomisp: i2c: removed unnecessary white
 space before comma in memset()
Message-ID: <20170328052336.GA27784@kroah.com>
References: <1490614949-30985-1-git-send-email-vaibhavddit@gmail.com>
 <1490678084-12740-1-git-send-email-vaibhavddit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1490678084-12740-1-git-send-email-vaibhavddit@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 28, 2017 at 10:44:44AM +0530, vaibhavddit@gmail.com wrote:
> gc2235.c

Why is this file name here?

> 
>  Removed extra space before comma in memset() as a part of
>  checkpatch.pl fix-up.

Why the extra space at the beginning of the line?

> Signed-off-by: Vaibhav Kothari <vaibhavddit@gmail.com>

This doesn't match your "From:" line above :(

Please fix up.

thanks,

greg k-h
