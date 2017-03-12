Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46740 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755742AbdCLNzH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Mar 2017 09:55:07 -0400
Date: Sun, 12 Mar 2017 14:54:23 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: simran singhal <singhalsimran0@gmail.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com
Subject: Re: [PATCH v1] staging: media: Remove unused function
 atomisp_set_stop_timeout()
Message-ID: <20170312135423.GA911@kroah.com>
References: <20170310133504.GA18916@singhal-Inspiron-5558>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170310133504.GA18916@singhal-Inspiron-5558>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 10, 2017 at 07:05:05PM +0530, simran singhal wrote:
> The function atomisp_set_stop_timeout on being called, simply returns
> back. The function hasn't been mentioned in the TODO and doesn't have
> FIXME code around. Hence, atomisp_set_stop_timeout and its calls have been
> removed.
> 
> This was done using Coccinelle.
> 
> @@
> identifier f;
> @@
> 
> void f(...) {
> 
> -return;
> 
> }
> 
> Signed-off-by: simran singhal <singhalsimran0@gmail.com>
> ---
>  v1:
>    -Change Subject to include name of function
>    -change commit message to include the coccinelle script

You should also cc: the developers doing all of the current work on this
driver, Alan Cox, to get their comment if this really is something that
can be removed or not.

thanks,

greg k-h
