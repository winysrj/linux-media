Return-path: <linux-media-owner@vger.kernel.org>
Received: from icp-osb-irony-out2.external.iinet.net.au ([203.59.1.155]:54681
        "EHLO icp-osb-irony-out2.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751394AbdC0GFn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 02:05:43 -0400
Date: Mon, 27 Mar 2017 17:08:28 +1100
From: Eddie Youseph <psyclone@iinet.net.au>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: radio-bcm2048: fixed bare use of unsigned
 int
Message-Id: <20170327170828.98bd4cce571e90711ad2f32b@iinet.net.au>
In-Reply-To: <20170323133153.GB22558@kroah.com>
References: <20170322133339.70e47a367c6d9ca907bd7931@iinet.net.au>
        <20170323133153.GB22558@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 23 Mar 2017 14:31:53 +0100
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Wed, Mar 22, 2017 at 01:33:39PM +1100, Eddie Youseph wrote:
> > Fixed checkpatch WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
> > 
> > Signed-off-by: Eddie Youseph <psyclone@iinet.net.au>
> > ---
> > Changes in v2:
> > 	- Added changelog
> 
> Did you actually build this change?
> 
> Please do so...
> 
> thanks,
> 
> greg k-h

I recompiled and was faced with many errors.
I will need to revert the changes.

I "wasn't getting errors" the first time around because I forgot I did a 
"make oldconfig" before, and bcm2048 wasn't being included 
in the build.

regards,

eddie youseph
