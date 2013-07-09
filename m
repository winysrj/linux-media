Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f171.google.com ([209.85.128.171]:53638 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab3GILm7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jul 2013 07:42:59 -0400
Received: by mail-ve0-f171.google.com with SMTP id b10so4549947vea.16
        for <linux-media@vger.kernel.org>; Tue, 09 Jul 2013 04:42:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201306260915.54258.hverkuil@xs4all.nl>
References: <1370005408-10853-1-git-send-email-arun.kk@samsung.com>
	<1370005408-10853-7-git-send-email-arun.kk@samsung.com>
	<201306260915.54258.hverkuil@xs4all.nl>
Date: Tue, 9 Jul 2013 17:12:58 +0530
Message-ID: <CALt3h7-9cuBZGQVGs24Xq58Mrw5M8ecFVrmYM3Csz+k6V5DX2A@mail.gmail.com>
Subject: Re: [RFC v2 06/10] exynos5-fimc-is: Adds isp subdev
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	kilyeon.im@samsung.com, shaik.ameer@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, Jun 26, 2013 at 12:45 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Fri May 31 2013 15:03:24 Arun Kumar K wrote:
>> fimc-is driver takes video data input from the ISP video node
>> which is added in this patch. This node accepts Bayer input
>> buffers which is given from the IS sensors.
>>
>> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>> Signed-off-by: Kilyeon Im <kilyeon.im@samsung.com>
>> ---
>>  drivers/media/platform/exynos5-is/fimc-is-isp.c |  438 +++++++++++++++++++++++
>>  drivers/media/platform/exynos5-is/fimc-is-isp.h |   89 +++++
>>  2 files changed, 527 insertions(+)
>>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-isp.c
>>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-isp.h
>>
>
> The same comments I made for the scaler subdev apply here as well.
>
> Regards,
>
>         Hans


Yes will take care of it in next patchset.

Thanks & Regards
Arun
