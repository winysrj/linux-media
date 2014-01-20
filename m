Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:35443 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaATOek (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jan 2014 09:34:40 -0500
MIME-Version: 1.0
In-Reply-To: <2542868.mVreZlxTcT@amdc1032>
References: <1389238094-19386-1-git-send-email-shaik.ameer@samsung.com>
	<1389238094-19386-5-git-send-email-shaik.ameer@samsung.com>
	<2542868.mVreZlxTcT@amdc1032>
Date: Mon, 20 Jan 2014 23:34:39 +0900
Message-ID: <CAOD6ATofW_M+z5vb7doOnjf=wsbZ7vcdjf9qMJpN0o9oz4_8fg@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] [media] exynos-scaler: Add DT bindings for SCALER driver
From: Shaik Ameer Basha <shaik.samsung@gmail.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
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

Hi Bartlomiej,

Thanks for the review.

Yes you are right. I didn't add the users for this driver.
Once the driver gets merged, I will send more patches with the users.
Already this driver merge is pending on DT maintainers ack and  I
don't want to complex it more by adding DT patches :)

Definitely, I will send the users patches once the driver gets merged.
And I will address all your comments in next version of patch series.


Regards,
Shaik Ameer Basha

On Thu, Jan 9, 2014 at 6:20 PM, Bartlomiej Zolnierkiewicz
<b.zolnierkie@samsung.com> wrote:
>
> Hi,
>
> On Thursday, January 09, 2014 08:58:14 AM Shaik Ameer Basha wrote:
>> This patch adds the DT binding documentation for the
>> Exynos5420/5410 based SCALER device driver.
>>
>> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
>> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> ---
>>  .../devicetree/bindings/media/exynos5-scaler.txt   |   22 ++++++++++++++++++++
>>  1 file changed, 22 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/exynos5-scaler.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/exynos5-scaler.txt b/Documentation/devicetree/bindings/media/exynos5-scaler.txt
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
>> +                     "samsung,exynos5410-scaler"
>> +- reg: should contain SCALER physical address location and length
>> +- interrupts: should contain SCALER interrupt number
>> +- clocks: should contain the SCALER clock specifier, from the
>> +                     common clock bindings
>> +- clock-names: should be "scaler"
>> +
>> +Example:
>> +     scaler_0: scaler@12800000 {
>> +             compatible = "samsung,exynos5420-scaler";
>> +             reg = <0x12800000 0x1000>;
>> +             interrupts = <0 220 0>;
>> +             clocks = <&clock 381>;
>> +             clock-names = "scaler";
>> +     };
>
> Your patchset adds support for EXYNOS5 SCALER but doesn't add any real
> users of it yet.  Could you please explain why?
>
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
