Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f48.google.com ([209.85.216.48]:57891 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab3HZMUr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Aug 2013 08:20:47 -0400
MIME-Version: 1.0
In-Reply-To: <521932FA.20801@gmail.com>
References: <1376909932-23644-1-git-send-email-shaik.ameer@samsung.com>
	<1376909932-23644-5-git-send-email-shaik.ameer@samsung.com>
	<033401ce9cdb$af145800$0d3d0800$%dae@samsung.com>
	<521932FA.20801@gmail.com>
Date: Mon, 26 Aug 2013 17:50:46 +0530
Message-ID: <CAOD6ATqNkN4Nqroi0miUpWFgPqTK5gfYX-G7mLTxuDau3iAdVw@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] [media] exynos-mscl: Add DT bindings for M-Scaler driver
From: Shaik Ameer Basha <shaik.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Inki Dae <inki.dae@samsung.com>,
	Shaik Ameer Basha <shaik.ameer@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc@vger.kernel.org, cpgs@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	posciak@google.com, Arun Kumar K <arun.kk@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks for the comments.
Please find the response inline...

Actually, I am waiting for your comments only :)
are you also reviewing the driver code? If yes, I can delay the next
version until your post your comments.


On Sun, Aug 25, 2013 at 3:56 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> On 08/19/2013 02:57 PM, Inki Dae wrote:
>>>
>>> -----Original Message-----
>>> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>>> owner@vger.kernel.org] On Behalf Of Shaik Ameer Basha
>>> Sent: Monday, August 19, 2013 7:59 PM
>>> To: linux-media@vger.kernel.org; linux-samsung-soc@vger.kernel.org
>>> Cc: s.nawrocki@samsung.com; posciak@google.com; arun.kk@samsung.com;
>>> shaik.ameer@samsung.com
>>> Subject: [PATCH v2 4/5] [media] exynos-mscl: Add DT bindings for M-Scaler
>>> driver
>>>
>>> This patch adds the DT binding documentation for the exynos5
>
>
> You may want to say to which specific SoC it applies.

Ok. will update this.
Only 5410 and 5420 has this IP as of now.

>
>
>>> based M-Scaler device driver.
>>>
>>> Signed-off-by: Shaik Ameer Basha<shaik.ameer@samsung.com>
>>> ---
>>>   .../devicetree/bindings/media/exynos5-mscl.txt     |   34
>>> ++++++++++++++++++++
>>>   1 file changed, 34 insertions(+)
>>>   create mode 100644 Documentation/devicetree/bindings/media/exynos5-
>>> mscl.txt
>>>
>>> diff --git a/Documentation/devicetree/bindings/media/exynos5-mscl.txt
>>> b/Documentation/devicetree/bindings/media/exynos5-mscl.txt
>>> new file mode 100644
>>> index 0000000..5c9d1b1
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/media/exynos5-mscl.txt
>>> @@ -0,0 +1,34 @@
>>> +* Samsung Exynos5 M-Scaler device
>>> +
>>> +M-Scaler is used for scaling, blending, color fill and color space
>>> +conversion on EXYNOS5 SoCs.
>>> +
>>> +Required properties:
>>> +- compatible: should be "samsung,exynos5-mscl"
>
>
> What is an exact name of this IP in the datasheet ?

It is named as "SCALER". But when i got the Initial doc, it was also
known as memory to memory scaler.
so, i am using M-Scaler.

Can i change this name to SCALER instead ?

>
>
>> If Exynos5410/5420 have same IP,
>> "samsung,exynos5410-mscl" for M Scaler IP in Exynos5410/5420"
>>
>> Else,
>> Compatible: should be one of the following:
>> (a) "samsung,exynos5410-mscl" for M Scaler IP in Exynos5410"
>> (b) "samsung,exynos5420-mscl" for M Scaler IP in Exynos5420"
>
>
> Yes, except I suspect "mscl" is incorrect. It sounds like an unclear
> abbreviation of real name of the IP. It likely should be "mscaler".
>
>
>>> +- reg: should contain M-Scaler physical address location and length.
>>> +- interrupts: should contain M-Scaler interrupt number
>>> +- clocks: should contain the clock number according to CCF
>
>
> Hmm, this sounds like a Linux specific term in the binding. Perhaps:
>
>  - clocks: should contain the M-Scaler clock specifier, from the common
>            clock bindings
>
>
> ?
>>>
>>> +- clock-names: should be "mscl"
>>> +
>>> +Example:
>>> +
>>> +       mscl_0: mscl@0x12800000 {
>
>
> s/0x//

Ok. Like this?
mscl_0: mscl@12800000 {

>
>
>>> +               compatible = "samsung,exynos5-mscl";
>>
>>
>> "samsung,exynos5410-mscl";
>>
>>> +               reg =<0x12800000 0x1000>;
>>> +               interrupts =<0 220 0>;
>>> +               clocks =<&clock 381>;
>>> +               clock-names = "mscl";
>>> +       };
>>> +
>>> +Aliases:
>>> +Each M-Scaler node should have a numbered alias in the aliases node,
>>> +in the form of msclN, N = 0...2. M-Scaler driver uses these aliases
>>> +to retrieve the device IDs using "of_alias_get_id()" call.
>
>
> So except in debug logs and for selecting variant data (which is same for
> all IP instances) are the aliases used for anything else ?
> I suspect you could do without these aliases. Device name includes start
> address of the IP register region, so that could be used to identify the
> M-Scaler instance in the logs.

Ok. I will check more.
If it is only used for logs, then i will remove the aliases.


Regards,
Shaik Ameer Basha

>
> --
> Regards,
> Sylwester
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
