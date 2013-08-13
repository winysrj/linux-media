Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:65197 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141Ab3HMVOf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Aug 2013 17:14:35 -0400
Message-ID: <520AA1AF.1010606@gmail.com>
Date: Tue, 13 Aug 2013 23:14:23 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Arun Kumar K <arun.kk@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org, s.nawrocki@samsung.com,
	hverkuil@xs4all.nl, a.hajda@samsung.com, sachin.kamat@linaro.org,
	shaik.ameer@samsung.com, kilyeon.im@samsung.com,
	arunkk.samsung@gmail.com, Rob Herring <rob.herring@calxeda.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [RFC v3 02/13] [media] exynos5-fimc-is: Add Exynos5 FIMC-IS device
 tree bindings documentation
References: <1375455762-22071-1-git-send-email-arun.kk@samsung.com> <1375455762-22071-3-git-send-email-arun.kk@samsung.com> <51FD7925.2010604@gmail.com> <51FFD892.5000708@wwwdotorg.org> <5200292E.1000505@gmail.com> <520400EB.7000808@wwwdotorg.org>
In-Reply-To: <520400EB.7000808@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

W dniu 2013-08-08 22:34, Stephen Warren pisze:
> On 08/05/2013 04:37 PM, Sylwester Nawrocki wrote:
>> On 08/05/2013 06:53 PM, Stephen Warren wrote:
>>> On 08/03/2013 03:41 PM, Sylwester Nawrocki wrote:
>>>> On 08/02/2013 05:02 PM, Arun Kumar K wrote:
>>>>> The patch adds the DT binding documentation for Samsung
>>>>> Exynos5 SoC series imaging subsystem (FIMC-IS).
>>>
>>>>> diff --git
>>>>> a/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
>>>>> b/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
>>>>> new file mode 100644
>>>>> index 0000000..49a373a
>>>>> --- /dev/null
>>>>> +++ b/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
>>>>> @@ -0,0 +1,52 @@
>>>>> +Samsung EXYNOS5 SoC series Imaging Subsystem (FIMC-IS)
>>>>> +------------------------------------------------------
>>>>> +
>>>>> +The camera subsystem on Samsung Exynos5 SoC has some changes relative
>>>>> +to previous SoC versions. Exynos5 has almost similar MIPI-CSIS and
>>>>> +FIMC-LITE IPs but has a much improved version of FIMC-IS which can
>>>>> +handle sensor controls and camera post-processing operations. The
>>>>> +Exynos5 FIMC-IS has a dedicated ARM Cortex A5 processor, many
>>>>> +post-processing blocks (ISP, DRC, FD, ODC, DIS, 3DNR) and two
>>>>> +dedicated scalers (SCC and SCP).
>>>
>>> So there are a lot of blocks mentioned there, yet the binding doesn't
>>> seem to describe most of it. Is the binding complete?
>>
>> Thanks for the review Stephen.
>>
>> No, the binding certainly isn't complete, it doesn't describe the all
>> available IP blocks. There are separate MMIO address regions for each
> ...
>> So while we could list all the devices, we decided not to do so.
>> Because it is not needed by the current software and we may miss some
>> details for case where the whole subsystem is controlled by the host
>> CPU (however such scenario is extremely unlikely AFAICT) which then
>> would be impossible or hard to change.
>
> Yes, that's probably a good approach.
>
>> I guess we should list all available devices, similarly as it's done
>> in Documentation/devicetree/bindings/gpu/nvidia,tegra20-host1x.txt.
>>
>> And then should they just be disabled through the status property
>> if they are not needed in the Linux driver ? I guess it is more
>> sensible than marking them as optional and then not listing them
>> in dts at all ?
>
> If you can define complete bindings for those nodes, it might make sense
> to do that. If the devices are perhaps complex to represent and hence
> you might not be able to come up with complete bindings for them right
> now, it may indeed be better to simply not mention the devices you don't
> care about for now.

We would prefer to start with a minimal binding, this would minimize
possible issues in future IMHO, as the subsystem is pretty complex.
Then, if detailed H/W description is required the firmware would need
to be updated, which would have been backward compatible.
We could probably come up with a complete binding, but there is a good
chance something could be done wrong, as that couldn't be actually
tested. It's not trivial to make this all work on the host CPU while
most of the detailed H/W knowledge stays on the firmware teams side.

>>>>> +pmu subnode
>>>>> +-----------
>>>>> +
>>>>> +Required properties:
>>>>> + - reg : should contain PMU physical base address and size of the
>>>>> memory
>>>>> +         mapped registers.
>>>
>>> I think you need a compatible value for this. How else is the node
>>> identified? The node name probably should not be used for identification.
>>
>> Of course the node name is currently used for identification. There is no
>> compatible property because this pmu node is used to get hold of only part
>> of the Power Management Unit registers, specific to the FIMC-IS.
>> The PMU has more registers that also other drivers would be interested in,
>> e.g. clocks or USB.
>
> I believe the correct way to solve this is for there to be a standalone
> PMU node at the appropriate location in DT, and for the FIMC bindings to
> reference that other node by phandle.
>
> Right now, the FIMC driver SW can manually follow the phandle, look at
> the reg property, and map that itself. Later down the road, you could
> instantiate a true PMU driver, and have the FIMC driver look up that
> driver, and call APIs on it. This change can be made without requiring
> any changes to the DT binding. That way, you aren't introducing a fake
> PMU node into the FIMC bindings just to satisfy internal Linux driver
> details.

That sounds reasonable. It lets us to keep the DT binding stable and
at the same move forward with the FIMC-IS while the PMU part is being
worked on. Thanks.
