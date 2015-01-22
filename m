Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:58822 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbbAVIrF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2015 03:47:05 -0500
Message-id: <54C0B905.3010002@samsung.com>
Date: Thu, 22 Jan 2015 09:47:01 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
	cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH/RFC v10 17/19] DT: Add documentation for exynos4-is
 'flashes' property
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-18-git-send-email-j.anaszewski@samsung.com>
 <54BFD4B9.8030707@samsung.com>
In-reply-to: <54BFD4B9.8030707@samsung.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 01/21/2015 05:32 PM, Sylwester Nawrocki wrote:
> Hi,
>
> On 09/01/15 16:23, Jacek Anaszewski wrote:
>> This patch adds a description of 'flashes' property
>> to the samsung-fimc.txt.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>
>> ---
>>   .../devicetree/bindings/media/samsung-fimc.txt     |    7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
>> index 922d6f8..22a6b2f 100644
>> --- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
>> +++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
>> @@ -40,6 +40,12 @@ should be inactive. For the "active-a" state the camera port A must be activated
>>   and the port B deactivated and for the state "active-b" it should be the other
>>   way around.
>>
>> +Optional properties:
>> +
>> +- flashes - Array of phandles to flash LED devices, or their sub-nodes
>> +	    representing sub-leds.
>> +	    (see Documentation/devicetree/bindings/leds/common.txt)
>
> How about renaming this to "illuminators" or something else more generic?
> The "torch" LED (for video recording illumination?) is not really a flash.

OK, currently I can't think of a better substitute for 'illuminators'.

Since it has been agreed that a discrete LED component requires a child
node in a LED device binding, even if there is only one current output
exposed by the LED device, this description has to be modified as follows:

- illuminators - Array of phandles to the child nodes of a flash LED
	device related binding.
	(see Documentation/devicetree/bindings/leds/common.txt).


-- 
Best Regards,
Jacek Anaszewski
