Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:7988 "EHLO
        mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754387AbdDKJXo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Apr 2017 05:23:44 -0400
Date: Tue, 11 Apr 2017 11:23:35 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
cc: Smitha T Murthy <smitha.t@samsung.com>,
        Julia Lawall <julia.lawall@lip6.fr>, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kbuild-all@01.org
Subject: Re: [Patch v3 10/11] [media] s5p-mfc: Add support for HEVC encoder
 (fwd)
In-Reply-To: <8fc9940e-3cb5-3ca7-f15d-0bf6284433a5@samsung.com>
Message-ID: <alpine.DEB.2.20.1704111121510.3384@hadrien>
References: <CGME20170403060045epcas2p215a1d85248b47cc389e20ff877505b09@epcas2p2.samsung.com> <alpine.DEB.2.20.1704030758540.2170@hadrien> <1491200242.24095.23.camel@smitha-fedora> <8fc9940e-3cb5-3ca7-f15d-0bf6284433a5@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Tue, 11 Apr 2017, Sylwester Nawrocki wrote:

> Hi,
>
> On 04/03/2017 08:17 AM, Smitha T Murthy wrote:
> > On Mon, 2017-04-03 at 08:00 +0200, Julia Lawall wrote:
> > > See line 2101
> > >
> > > julia
> > >
> > Thank you for bringing it to my notice, I had not checked on this git.
> > I will upload the next version of patches soon corresponding to this
> > git.
>
> In general please use the media master branch as a base for your patches
> (git://linuxtv.org/media_tree.git master). Or latest branch in my
> git repository, currently it's "for-v4.12/media/next-2" as can be seen
> here: https://git.linuxtv.org/snawrocki/samsung.git

I'm not making the patch.  It comes to me from kbuild.  If you would
prefer some tree not to be included, you can notify Fengguang about this:

fengguang.wu@intel.com

julia

>
> --
> Thanks,
> Sylwester
>
