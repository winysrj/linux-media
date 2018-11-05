Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:54127 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387422AbeKFB3P (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 20:29:15 -0500
Subject: Re: [RFC PATCH 00/11] Convert last remaining g/s_crop/cropcap
 drivers
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, niklas.soderlund+renesas@ragnatech.se,
        tfiga@chromium.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <8ae1b917-d7c4-7ba1-80f6-d41a854b8c11@samsung.com>
Date: Mon, 05 Nov 2018 17:08:34 +0100
MIME-version: 1.0
In-reply-to: <058d84c9-38fd-3fb8-83bd-fb31e1e79042@xs4all.nl>
Content-type: text/plain; charset="utf-8"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <20181005074911.47574-1-hverkuil@xs4all.nl>
        <CAB_H8ru9KzstY4-qByAdfNKeDW23U93e0TRc71-knmrDOike4g@mail.gmail.com>
        <CGME20181105131305epcas3p3213e3d7d74e2315eca4daf7983749985@epcas3p3.samsung.com>
        <058d84c9-38fd-3fb8-83bd-fb31e1e79042@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 11/05/2018 02:12 PM, Hans Verkuil wrote:
> Thank you for the review. One question: have you also tested this with at least
> one of the affected drivers?
> 
> I'd like to have at least one Tested-by line.

I just tested it now - video playback on Exynos4210 Trats2 so it covers 
the s5p-mfc and exynos4-is (fimc-m2m) drivers. Well done, I couldn't see 
any breakage.

You can add "Tested-by: Sylwester Nawrocki <s.nawrocki@samsung.com>" 
to patches: 1, 2, 3, 7, 8, 10.

-- 
Regards,
Sylwester
