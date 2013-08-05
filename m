Return-path: <linux-media-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:48104 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab3HERAQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 13:00:16 -0400
Message-ID: <51FFD892.5000708@wwwdotorg.org>
Date: Mon, 05 Aug 2013 10:53:38 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
CC: Arun Kumar K <arun.kk@samsung.com>, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
	s.nawrocki@samsung.com, hverkuil@xs4all.nl, a.hajda@samsung.com,
	sachin.kamat@linaro.org, shaik.ameer@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com,
	Rob Herring <rob.herring@calxeda.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [RFC v3 02/13] [media] exynos5-fimc-is: Add Exynos5 FIMC-IS device
 tree bindings documentation
References: <1375455762-22071-1-git-send-email-arun.kk@samsung.com> <1375455762-22071-3-git-send-email-arun.kk@samsung.com> <51FD7925.2010604@gmail.com>
In-Reply-To: <51FD7925.2010604@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/03/2013 03:41 PM, Sylwester Nawrocki wrote:
> On 08/02/2013 05:02 PM, Arun Kumar K wrote:
>> The patch adds the DT binding documentation for Samsung
>> Exynos5 SoC series imaging subsystem (FIMC-IS).

>> diff --git
>> a/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
>> b/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
>> new file mode 100644
>> index 0000000..49a373a
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
>> @@ -0,0 +1,52 @@
>> +Samsung EXYNOS5 SoC series Imaging Subsystem (FIMC-IS)
>> +------------------------------------------------------
>> +
>> +The camera subsystem on Samsung Exynos5 SoC has some changes relative
>> +to previous SoC versions. Exynos5 has almost similar MIPI-CSIS and
>> +FIMC-LITE IPs but has a much improved version of FIMC-IS which can
>> +handle sensor controls and camera post-processing operations. The
>> +Exynos5 FIMC-IS has a dedicated ARM Cortex A5 processor, many
>> +post-processing blocks (ISP, DRC, FD, ODC, DIS, 3DNR) and two
>> +dedicated scalers (SCC and SCP).

So there are a lot of blocks mentioned there, yet the binding doesn't
seem to describe most of it. Is the binding complete?

>> +pmu subnode
>> +-----------
>> +
>> +Required properties:
>> + - reg : should contain PMU physical base address and size of the memory
>> +         mapped registers.

I think you need a compatible value for this. How else is the node
identified? The node name probably should not be used for identification.

>> +
>> +i2c-isp (ISP I2C bus controller) nodes
>> +------------------------------------------
>> +
>> +Required properties:
>> +
>> +- compatible    : should be "samsung,exynos4212-i2c-isp" for Exynos4212,
>> +          Exynos4412 and Exynos5250 SoCs;
>> +- reg        : physical base address and length of the registers set;
>> +- clocks    : must contain gate clock specifier for this controller;
>> +- clock-names    : must contain "i2c_isp" entry.
>> +
>> +For the above nodes it is required to specify a pinctrl state named "default",

Is "above nodes" both pmu, i2c-isp? It might make sense to be more
explicit re: which nodes this comment applies to.

>> +according to the pinctrl bindings defined in ../pinctrl/pinctrl-bindings.txt.
>> +
>> +Device tree nodes of the image sensors' controlled directly by the FIMC-IS

s/'// ?

>> +firmware must be child nodes of their corresponding ISP I2C bus controller node.
>> +The data link of these image sensors must be specified using the common video
>> +interfaces bindings, defined in video-interfaces.txt.

