Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:46704 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751458AbdGYFRB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Jul 2017 01:17:01 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20170725051659epoutp015c68c9076b9cf699cde31aa130dcf3e4~UewD41jEG1917319173epoutp019
        for <linux-media@vger.kernel.org>; Tue, 25 Jul 2017 05:16:59 +0000 (GMT)
Subject: Re: [Patch v5 12/12] Documention: v4l: Documentation for HEVC CIDs
From: Smitha T Murthy <smitha.t@samsung.com>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com
In-Reply-To: <54ad8901-ccd0-4b0b-bb3f-23779d3534e8@linaro.org>
Date: Tue, 25 Jul 2017 10:23:13 +0530
Message-ID: <1500958393.16819.3282.camel@smitha-fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
References: <1497849055-26583-1-git-send-email-smitha.t@samsung.com>
        <CGME20170619052521epcas5p36a0bc384d10809dcfe775e6da87ed37b@epcas5p3.samsung.com>
        <1497849055-26583-13-git-send-email-smitha.t@samsung.com>
        <617cb1c5-074c-3f47-0096-fe7568dab8be@linaro.org>
        <1500290336.16819.6.camel@smitha-fedora>
        <54ad8901-ccd0-4b0b-bb3f-23779d3534e8@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2017-07-20 at 18:46 +0300, Stanimir Varbanov wrote:
> Hi,
> 
> >>> +
> >>> +    * - ``V4L2_MPEG_VIDEO_HEVC_PROFILE_MAIN``
> >>> +      - Main profile.
> >>
> >> MAIN10?
> >>
> > No just MAIN.
> 
> I haven't because the MFC does not supported it?
> 
> If so, I think we have to add MAIN10 for completeness and because other
> drivers could have support for it.
> 
MFC supports Main and Main Still profile for encoder. Main, Main10, Main
Still for decoder. I will add both Main and Main10 in the next patch
series.
Thank you for the review.

Regards,
Smitha
