Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40292 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751256AbeC2HAu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Mar 2018 03:00:50 -0400
Date: Thu, 29 Mar 2018 09:00:45 +0200
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
Message-ID: <20180329070045.GA8759@kroah.com>
References: <CGME20180328181304epcas4p2593efec8fcccbf6bf30ed30d9b5f0093@epcas4p2.samsung.com>
 <cover.1522260310.git.mchehab@s-opensource.com>
 <5ABC23A0.20907@samsung.com>
 <20180329042558.GA9003@kroah.com>
 <5ABC8A3A.5030602@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5ABC8A3A.5030602@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 29, 2018 at 03:39:54PM +0900, Inki Dae wrote:
> 2018년 03월 29일 13:25에 Greg KH 이(가) 쓴 글:
> > On Thu, Mar 29, 2018 at 08:22:08AM +0900, Inki Dae wrote:
> >> Really thanks for doing this. :) There would be many users who use
> >> Linux-3.18 for their products yet.
> > 
> > For new products?  They really should not be.  The kernel is officially
> 
> Really no. Old products would still be using Linux-3.18 kernel without
> kernel upgrade. For new product, most of SoC vendors will use
> Linux-4.x including us.
> Actually, we are preparing for kernel upgrade for some devices even
> some old devices (to Linux-4.14-LTS) and almost done.

That is great to hear.

> > What is keeping you on 3.18.y and not allowing you to move to a newer
> > kernel version?
> 
> We also want to move to latest kernel version. However, there is a case that we cannot upgrade the kernel.
> In case that SoC vendor never share firmwares and relevant data
> sheets, we cannot upgrade the kernel. However, we have to resolve the
> security issues for users of this device.

It sounds like you need to be getting those security updates from those
SoC vendors, as they are the ones you are paying for support for that
kernel version that they are forcing you to stay on.

good luck!

greg k-h
