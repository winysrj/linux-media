Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:53619 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387398AbeKFBaE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Nov 2018 20:30:04 -0500
Subject: Re: [RFC PATCH 00/11] Convert last remaining g/s_crop/cropcap drivers
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund+renesas@ragnatech.se,
        tfiga@chromium.org
References: <20181005074911.47574-1-hverkuil@xs4all.nl>
 <CAB_H8ru9KzstY4-qByAdfNKeDW23U93e0TRc71-knmrDOike4g@mail.gmail.com>
 <CGME20181105131305epcas3p3213e3d7d74e2315eca4daf7983749985@epcas3p3.samsung.com>
 <058d84c9-38fd-3fb8-83bd-fb31e1e79042@xs4all.nl>
 <8ae1b917-d7c4-7ba1-80f6-d41a854b8c11@samsung.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b7b54545-6e10-18c7-c465-0c21ff74eb79@xs4all.nl>
Date: Mon, 5 Nov 2018 17:09:38 +0100
MIME-Version: 1.0
In-Reply-To: <8ae1b917-d7c4-7ba1-80f6-d41a854b8c11@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/05/2018 05:08 PM, Sylwester Nawrocki wrote:
> Hi Hans,
> 
> On 11/05/2018 02:12 PM, Hans Verkuil wrote:
>> Thank you for the review. One question: have you also tested this with at least
>> one of the affected drivers?
>>
>> I'd like to have at least one Tested-by line.
> 
> I just tested it now - video playback on Exynos4210 Trats2 so it covers 
> the s5p-mfc and exynos4-is (fimc-m2m) drivers. Well done, I couldn't see 
> any breakage.
> 
> You can add "Tested-by: Sylwester Nawrocki <s.nawrocki@samsung.com>" 
> to patches: 1, 2, 3, 7, 8, 10.
> 

Fantastic, I'll see if I can make a pull request for this series this week.

Regards,

	Hans
