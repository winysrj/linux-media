Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62335 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab2GZDqb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jul 2012 23:46:31 -0400
Received: by vcbfk26 with SMTP id fk26so1277246vcb.19
        for <linux-media@vger.kernel.org>; Wed, 25 Jul 2012 20:46:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <501065F5.9060004@gmail.com>
References: <1343219191-3969-1-git-send-email-shaik.ameer@samsung.com>
	<1343219191-3969-6-git-send-email-shaik.ameer@samsung.com>
	<501065F5.9060004@gmail.com>
Date: Thu, 26 Jul 2012 09:16:31 +0530
Message-ID: <CAOD6ATpXTXQbGGJ2qpn5oeVJ4XKnqOXtFzTsHa9uz=gt+gGCFg@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] media: gscaler: Add Makefile for G-Scaler Driver
From: Shaik Ameer Basha <shaik.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>,
	linux-media@vger.kernel.org, sungchun.kang@samsung.com,
	khw0178.kim@samsung.com, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com, sy0816.kang@samsung.com,
	s.nawrocki@samsung.com, posciak@google.com, alim.akhtar@gmail.com,
	prashanth.g@samsung.com, joshi@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thu, Jul 26, 2012 at 3:02 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> On 07/25/2012 02:26 PM, Shaik Ameer Basha wrote:
>>
>> This patch adds the Makefile for G-Scaler driver.
>>
>> Signed-off-by: Shaik Ameer Basha<shaik.ameer@samsung.com>
>> ---
>>   drivers/media/video/Kconfig             |    8 ++++++++
>>   drivers/media/video/Makefile            |    2 ++
>>   drivers/media/video/exynos-gsc/Makefile |    3 +++
>>   3 files changed, 13 insertions(+), 0 deletions(-)
>>   create mode 100644 drivers/media/video/exynos-gsc/Makefile
>>
>> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
>> index 99937c9..47ec55a 100644
>> --- a/drivers/media/video/Kconfig
>> +++ b/drivers/media/video/Kconfig
>> @@ -1215,4 +1215,12 @@ config VIDEO_MX2_EMMAPRP
>>             memory to memory. Operations include resizing and format
>>             conversion.
>>
>> +config VIDEO_SAMSUNG_EXYNOS_GSC
>> +        tristate "Samsung Exynos GSC driver"
>
>
> s/GSC/Gscaler ?
>

Ok. As per you previous review comments I am following "G-Scaler". I
will change that.

>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>
> --
>
> Regards,
> Sylwester

Regards,
Shaik Ameer Basha
