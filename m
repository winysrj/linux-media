Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39174 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933968AbdCWNcJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Mar 2017 09:32:09 -0400
Date: Thu, 23 Mar 2017 14:31:53 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Eddie Youseph <psyclone@iinet.net.au>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: radio-bcm2048: fixed bare use of unsigned int
Message-ID: <20170323133153.GB22558@kroah.com>
References: <20170322133339.70e47a367c6d9ca907bd7931@iinet.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170322133339.70e47a367c6d9ca907bd7931@iinet.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 22, 2017 at 01:33:39PM +1100, Eddie Youseph wrote:
> Fixed checkpatch WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
> 
> Signed-off-by: Eddie Youseph <psyclone@iinet.net.au>
> ---
> Changes in v2:
> 	- Added changelog

Did you actually build this change?

Please do so...

thanks,

greg k-h
