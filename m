Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41882 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbeC2E0E (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Mar 2018 00:26:04 -0400
Date: Thu, 29 Mar 2018 06:25:58 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Inki Dae <inki.dae@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Brian Warner <brian.warner@samsung.com>
Subject: Re: [PATCH for v3.18 00/18] Backport CVE-2017-13166 fixes to Kernel
 3.18
Message-ID: <20180329042558.GA9003@kroah.com>
References: <CGME20180328181304epcas4p2593efec8fcccbf6bf30ed30d9b5f0093@epcas4p2.samsung.com>
 <cover.1522260310.git.mchehab@s-opensource.com>
 <5ABC23A0.20907@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ABC23A0.20907@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 29, 2018 at 08:22:08AM +0900, Inki Dae wrote:
> Really thanks for doing this. :) There would be many users who use
> Linux-3.18 for their products yet.

For new products?  They really should not be.  The kernel is officially
end-of-life, but I'm keeping it alive for a short while longer just
because too many people seem to still be using it.  However, they are
not actually updating the kernel in their devices, so I don't think I
will be doing many more new 3.18.y releases.

It's a problem when people ask for support, and then don't use the
releases given to them :(

What is keeping you on 3.18.y and not allowing you to move to a newer
kernel version?

thanks,

greg k-h
