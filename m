Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:47979 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751554AbdFIRgc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Jun 2017 13:36:32 -0400
Subject: Re: [Patch v4 00/12] Add MFC v10.10 support
To: Smitha T Murthy <smitha.t@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <95f6389c-4535-75c0-dcc9-6076b76777a0@samsung.com>
Date: Fri, 09 Jun 2017 19:36:22 +0200
MIME-version: 1.0
In-reply-to: <1491459105-16641-1-git-send-email-smitha.t@samsung.com>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <CGME20170406060957epcas1p36f883512ccfaf24359d1b31a6d199d87@epcas1p3.samsung.com>
        <1491459105-16641-1-git-send-email-smitha.t@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/06/2017 08:11 AM, Smitha T Murthy wrote:
> This patch series adds MFC v10.10 support. MFC v10.10 is used in some
> of Exynos7 variants.
> 
> This adds support for following:
> 
> * Add support for HEVC encoder and decoder
> * Add support for VP9 decoder
> * Update Documentation for control id definitions
> * Update computation of min scratch buffer size requirement for V8 onwards
Smitha, do you have any updates on this?  IIRC, there were few things
which needed corrections but we were rather close to the final version.

--
Thanks,
Sylwester
