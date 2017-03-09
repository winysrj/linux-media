Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41932 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754822AbdCIQry (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Mar 2017 11:47:54 -0500
Date: Thu, 9 Mar 2017 17:45:41 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: simran singhal <singhalsimran0@gmail.com>
Cc: mchehab@kernel.org, devel@driverdev.osuosl.org,
        outreachy-kernel@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/7] staging: media: Remove unnecessary typecast of c90
 int constant
Message-ID: <20170309164541.GA12365@kroah.com>
References: <1488484322-5928-1-git-send-email-singhalsimran0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1488484322-5928-1-git-send-email-singhalsimran0@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 03, 2017 at 01:21:56AM +0530, simran singhal wrote:
> This patch removes unnecessary typecast of c90 int constant.
> 
> WARNING: Unnecessary typecast of c90 int constant
> 
> Signed-off-by: simran singhal <singhalsimran0@gmail.com>
> ---
>  drivers/staging/media/atomisp/i2c/gc2235.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

The subject needs to say which driver is being touched here.  So this
would be:
	 [PATCH 1/7] staging: gc2235: Remove unnecessary typecast of c90 int constant

Please fix up for all of these and resend.

thanks,

greg k-h
