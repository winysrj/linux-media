Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44060 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751772AbeDDPdX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Apr 2018 11:33:23 -0400
Date: Wed, 4 Apr 2018 17:33:08 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Brian Warner <brian.warner@samsung.com>
Subject: Re: [PATCH for v3.18 00/18] Backport CVE-2017-13166 fixes to Kernel
 3.18
Message-ID: <20180404153308.GA20086@kroah.com>
References: <cover.1522260310.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1522260310.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 28, 2018 at 03:12:19PM -0300, Mauro Carvalho Chehab wrote:
> Hi Greg,
> 
> Those are the backports meant to solve CVE-2017-13166 on Kernel 3.18.
> 
> It contains two v4l2-ctrls fixes that are required to avoid crashes
> at the test application.
> 
> I wrote two patches myself for Kernel 3.18 in order to solve some
> issues specific for Kernel 3.18 with aren't needed upstream.
> one is actually a one-line change backport. The other one makes
> sure that both 32-bits and 64-bits version of some ioctl calls
> will return the same value for a reserved field.
> 
> I noticed an extra bug while testing it, but the bug also hits upstream,
> and should be backported all the way down all stable/LTS versions.
> So, I'll send it the usual way, after merging upsream.

I've queued these all up now, thanks.

greg k-h
