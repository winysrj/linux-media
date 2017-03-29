Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53964 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753890AbdC2HfN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 03:35:13 -0400
Date: Wed, 29 Mar 2017 09:34:56 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Eddie Youseph <psyclone@iinet.net.au>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v3] Revert "staging: radio-bcm2048: fixed bare use of
 unsigned int"
Message-ID: <20170329073456.GA8789@kroah.com>
References: <20170327172029.5d0c1c13b5c656b768ecbe10@iinet.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170327172029.5d0c1c13b5c656b768ecbe10@iinet.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 27, 2017 at 05:20:29PM +1100, Eddie Youseph wrote:
> This reverts previous changes to checkpatch warning:
> WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
> ---
> Changes in v2:
> 	- Added changelog
> 
> Changes in v3:
> 	- Revert changes to using bare unsigned

I don't understand, this patch fails to apply.  What are you making it
aginst?

confused,

greg k-h
