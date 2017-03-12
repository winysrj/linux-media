Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47228 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755742AbdCLOUw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Mar 2017 10:20:52 -0400
Date: Sun, 12 Mar 2017 15:20:24 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: simran singhal <singhalsimran0@gmail.com>
Cc: mchehab@kernel.org, devel@driverdev.osuosl.org,
        outreachy-kernel@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v1 1/7] staging: gc2235: Remove unnecessary typecast of
 c90 int constant
Message-ID: <20170312142024.GA5964@kroah.com>
References: <1489099829-1264-1-git-send-email-singhalsimran0@gmail.com>
 <1489099829-1264-2-git-send-email-singhalsimran0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1489099829-1264-2-git-send-email-singhalsimran0@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 10, 2017 at 04:20:23AM +0530, simran singhal wrote:
> This patch removes unnecessary typecast of c90 int constant.
> 
> WARNING: Unnecessary typecast of c90 int constant
> 
> Signed-off-by: simran singhal <singhalsimran0@gmail.com>
> ---
>  drivers/staging/media/atomisp/i2c/gc2235.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

This series doesn't apply to my tree at all, please rebase and resend.

thanks,

greg k-h
