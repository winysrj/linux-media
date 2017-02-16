Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:37773 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752649AbdBPJds (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Feb 2017 04:33:48 -0500
Date: Thu, 16 Feb 2017 09:33:45 +0000
From: Sean Young <sean@mess.org>
To: dc@cako.io
Cc: linux-media@vger.kernel.org, jarod@wilsonet.com, mchehab@kernel.org
Subject: Re: [PATCH] staging: media: use octal permissions
Message-ID: <20170216093345.GA15532@gofer.mess.org>
References: <20170215162701.Horde.XvDp43m8Ix1AzjBYbMccaA7@ocean.mxroute.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170215162701.Horde.XvDp43m8Ix1AzjBYbMccaA7@ocean.mxroute.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 15, 2017 at 04:27:01PM -0600, dc@cako.io wrote:
> Replace all instances of permission macros with octal permissions
> 
> Signed-off-by: David Cako <dc@cako.io>
> ---
>  drivers/staging/media/lirc/lirc_parallel.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/media/lirc/lirc_parallel.c

lirc_parallel has been dropped, I'm afraid so the patch no longer applies.

Thanks
Sean
