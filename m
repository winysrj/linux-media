Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41084 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754567AbdERNiL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 09:38:11 -0400
Date: Thu, 18 May 2017 15:38:00 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Mark Railton <mark@markrailton.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ATOMISP: Tidies up code warnings and errors in file
Message-ID: <20170518133800.GA20779@kroah.com>
References: <1494282355-1926-1-git-send-email-mark@markrailton.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1494282355-1926-1-git-send-email-mark@markrailton.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 08, 2017 at 11:25:55PM +0100, Mark Railton wrote:
> Cleared up some errors and warnings in
> drivers/staging/media/atomisp/i2c/ap1302.c
> 
> Signed-off-by: Mark Railton <mark@markrailton.com>
> ---
>  drivers/staging/media/atomisp/i2c/ap1302.c | 83 ++++++++++++++++++------------
>  1 file changed, 50 insertions(+), 33 deletions(-)

Always be specific as to what exactly you are doing, and don't do
multiple different things in a single patch like you did here (hint,
"all warnings/errors isn't one thing".

thanks,

greg k-h
