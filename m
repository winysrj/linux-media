Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:37526 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751921AbdDKLYz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Apr 2017 07:24:55 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OO800V3AT1H2ZC0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 11 Apr 2017 20:24:53 +0900 (KST)
Subject: Re: [Patch v3 10/11] [media] s5p-mfc: Add support for HEVC encoder
 (fwd)
From: Smitha T Murthy <smitha.t@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kbuild-all@01.org
In-reply-to: <8fc9940e-3cb5-3ca7-f15d-0bf6284433a5@samsung.com>
Date: Tue, 11 Apr 2017 16:56:14 +0530
Message-id: <1491909974.11549.5.camel@smitha-fedora>
MIME-version: 1.0
Content-transfer-encoding: 7bit
Content-type: text/plain; charset=utf-8
References: <CGME20170403060045epcas2p215a1d85248b47cc389e20ff877505b09@epcas2p2.samsung.com>
 <alpine.DEB.2.20.1704030758540.2170@hadrien>
 <1491200242.24095.23.camel@smitha-fedora>
 <8fc9940e-3cb5-3ca7-f15d-0bf6284433a5@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-04-11 at 11:00 +0200, Sylwester Nawrocki wrote:
> Hi,
> 
> On 04/03/2017 08:17 AM, Smitha T Murthy wrote:
> > On Mon, 2017-04-03 at 08:00 +0200, Julia Lawall wrote:
> >> See line 2101
> >>
> >> julia
> >>
> > Thank you for bringing it to my notice, I had not checked on this git.
> > I will upload the next version of patches soon corresponding to this
> > git.
> 
> In general please use the media master branch as a base for your patches
> (git://linuxtv.org/media_tree.git master). Or latest branch in my
> git repository, currently it's "for-v4.12/media/next-2" as can be seen
> here: https://git.linuxtv.org/snawrocki/samsung.git
> 
I have submitted the next version(v4) of mfcv10.10 patches based on
git://linuxtv.org/snawrocki/samsung.git for-v4.12/media/next. But I will
keep this in mind next time I submit fresh patches. Thank you for the
information :)

Regards,
Smitha
