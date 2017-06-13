Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:11012 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751921AbdFMFgN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 01:36:13 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20170613053611epoutp0145a8f7c3118a4026a9ca81432103032b~Hl61RnO-o2607626076epoutp01c
        for <linux-media@vger.kernel.org>; Tue, 13 Jun 2017 05:36:11 +0000 (GMT)
Subject: Re: [Patch v4 00/12] Add MFC v10.10 support
From: Smitha T Murthy <smitha.t@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com
In-Reply-To: <95f6389c-4535-75c0-dcc9-6076b76777a0@samsung.com>
Date: Tue, 13 Jun 2017 10:54:11 +0530
Message-ID: <1497331451.22203.8.camel@smitha-fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
References: <CGME20170406060957epcas1p36f883512ccfaf24359d1b31a6d199d87@epcas1p3.samsung.com>
        <1491459105-16641-1-git-send-email-smitha.t@samsung.com>
        <95f6389c-4535-75c0-dcc9-6076b76777a0@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2017-06-09 at 19:36 +0200, Sylwester Nawrocki wrote:
> On 04/06/2017 08:11 AM, Smitha T Murthy wrote:
> > This patch series adds MFC v10.10 support. MFC v10.10 is used in some
> > of Exynos7 variants.
> > 
> > This adds support for following:
> > 
> > * Add support for HEVC encoder and decoder
> > * Add support for VP9 decoder
> > * Update Documentation for control id definitions
> > * Update computation of min scratch buffer size requirement for V8 onwards
> Smitha, do you have any updates on this?  IIRC, there were few things
> which needed corrections but we were rather close to the final version.
> 
> --
> Thanks,
> Sylwester
> 
Hi Sylwester,

Sorry, I am currently held up with some other work. I will try to make
time and work on the next the updated patch series soon.

Regards,
Smitha
