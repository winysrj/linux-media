Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f178.google.com ([209.85.160.178]:62885 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbaAaGrd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jan 2014 01:47:33 -0500
MIME-Version: 1.0
In-Reply-To: <52E29051.3070906@samsung.com>
References: <1389238094-19386-1-git-send-email-shaik.ameer@samsung.com>
	<1389238094-19386-5-git-send-email-shaik.ameer@samsung.com>
	<52E29051.3070906@samsung.com>
Date: Fri, 31 Jan 2014 15:47:33 +0900
Message-ID: <CAOD6ATq1U1o4MVxM9g6rqfO7k2eebb_BzPO4JOtU3y4H=YHh9w@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] [media] exynos-scaler: Add DT bindings for SCALER driver
From: Shaik Ameer Basha <shaik.samsung@gmail.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Pawel Osciak <posciak@google.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the review.
Will consider all your comments in the next version of patch series.

Regards,
Shaik Ameer Basha

On Sat, Jan 25, 2014 at 1:09 AM, Tomasz Figa <t.figa@samsung.com> wrote:
> Hi Shaik,
>
>
> On 09.01.2014 04:28, Shaik Ameer Basha wrote:
>>
>> This patch adds the DT binding documentation for the
>> Exynos5420/5410 based SCALER device driver.
>>
>> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
>> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> ---
>>   .../devicetree/bindings/media/exynos5-scaler.txt   |   22
>> ++++++++++++++++++++
>>   1 file changed, 22 insertions(+)
>>   create mode 100644
>> Documentation/devicetree/bindings/media/exynos5-scaler.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/exynos5-scaler.txt
>> b/Documentation/devicetree/bindings/media/exynos5-scaler.txt
>> new file mode 100644
>> index 0000000..9328e7d
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/exynos5-scaler.txt
>> @@ -0,0 +1,22 @@
>> +* Samsung Exynos5 SCALER device
>> +
>> +SCALER is used for scaling, blending, color fill and color space
>> +conversion on EXYNOS[5420/5410] SoCs.
>> +
>> +Required properties:
>> +- compatible: should be "samsung,exynos5420-scaler" or
>> +                       "samsung,exynos5410-scaler"
>> +- reg: should contain SCALER physical address location and length
>> +- interrupts: should contain SCALER interrupt number
>
>
> s/number/specifier/
>
>
>> +- clocks: should contain the SCALER clock specifier, from the
>> +                       common clock bindings
>
>
> s/specifier/phandle and specifier pair for each clock listed in clock-names
> property/
>
> s/from/according to/
>
>
>> +- clock-names: should be "scaler"
>
>
> should contain exactly one entry:
>  - "scaler" - IP bus clock.
>
> Also this patch should be first in the series to let the driver added in
> further patches use already present bindings.
>
> Best regards,
> Tomasz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc"
> in
>
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
