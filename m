Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:52483 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750732AbeC2Oaa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Mar 2018 10:30:30 -0400
Date: Thu, 29 Mar 2018 11:30:24 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Inki Dae <inki.dae@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Brian Warner <brian.warner@samsung.com>
Subject: Re: [PATCH for v3.18 00/18] Backport CVE-2017-13166 fixes to Kernel
 3.18
Message-ID: <20180329113024.6cc18340@vento.lan>
In-Reply-To: <5ABC23A0.20907@samsung.com>
References: <CGME20180328181304epcas4p2593efec8fcccbf6bf30ed30d9b5f0093@epcas4p2.samsung.com>
        <cover.1522260310.git.mchehab@s-opensource.com>
        <5ABC23A0.20907@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 29 Mar 2018 08:22:08 +0900
Inki Dae <inki.dae@samsung.com> escreveu:

> Hi Mauro,
> 
> 2018년 03월 29일 03:12에 Mauro Carvalho Chehab 이(가) 쓴 글:
> > Hi Greg,
> > 
> > Those are the backports meant to solve CVE-2017-13166 on Kernel 3.18.
> > 
> > It contains two v4l2-ctrls fixes that are required to avoid crashes
> > at the test application.
> > 
> > I wrote two patches myself for Kernel 3.18 in order to solve some
> > issues specific for Kernel 3.18 with aren't needed upstream.
> > one is actually a one-line change backport. The other one makes
> > sure that both 32-bits and 64-bits version of some ioctl calls
> > will return the same value for a reserved field.
> > 
> > I noticed an extra bug while testing it, but the bug also hits upstream,
> > and should be backported all the way down all stable/LTS versions.
> > So, I'll send it the usual way, after merging upsream.  
> 
> Really thanks for doing this. :) There would be many users who use Linux-3.18 for their products yet.

Anytime!

Please let me know if you find any issues with those backports.

Regards,
Mauro
