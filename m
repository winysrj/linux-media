Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60674 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752084AbdDHLD4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Apr 2017 07:03:56 -0400
Date: Sat, 8 Apr 2017 13:03:45 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Manny Vindiola <mannyv@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add blank line after declarations
Message-ID: <20170408110345.GA9180@kroah.com>
References: <1491568871-22111-1-git-send-email-mannyv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1491568871-22111-1-git-send-email-mannyv@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 07, 2017 at 08:41:11AM -0400, Manny Vindiola wrote:
> Add blank line after variable declarations as part of checkpatch.pl style fixup.
> 
> Signed-off-by: Manny Vindiola <mannyv@gmail.com>
> ---
>  drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c | 1 +
>  1 file changed, 1 insertion(+)

Your subject line needs a lot of work, please read the reference
material I sent you for your last patch...

thanks,

greg k-h
