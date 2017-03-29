Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35234 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753391AbdC2HDy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 03:03:54 -0400
Date: Wed, 29 Mar 2017 09:03:38 +0200
From: Greg KH <greg@kroah.com>
To: vaibhavddit@gmail.com
Cc: mchehab@kernel.org, devel@driverdev.osuosl.org,
        rvarsha016@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] staging: media: atomisp: i2c: removed unnecessary white
 space before comma in memset()
Message-ID: <20170329070338.GA9327@kroah.com>
References: <1490614949-30985-1-git-send-email-vaibhavddit@gmail.com>
 <1490679166-13479-1-git-send-email-vaibhavddit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1490679166-13479-1-git-send-email-vaibhavddit@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 28, 2017 at 11:02:45AM +0530, vaibhavddit@gmail.com wrote:
> From: Vaibhav Kothari <vaibhavddit@gmail.com>
> 
> Removed extra space before comma in memset() as a part of
> checkpatch.pl fix-up.
> 
> Signed-off-by: Vaibhav Kothari <vaibhavddit@gmail.com>
> ---
>  drivers/staging/media/atomisp/i2c/gc2235.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

What changed from your prior emails with the same subject?  Always
version your patches, as SubmittingPatches describes how to do.

Please fix up and resend.

thanks,

greg k-h
