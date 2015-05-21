Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9266 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbbEUJKx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 05:10:53 -0400
Message-id: <555DA119.9030904@samsung.com>
Date: Thu, 21 May 2015 11:10:49 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, s.nawrocki@samsung.com,
	devicetree@vger.kernel.org, sre@kernel.org
Subject: Re: [PATCH v8 8/8] DT: samsung-fimc: Add examples for
 samsung,flash-led property
References: <1432131015-22397-1-git-send-email-j.anaszewski@samsung.com>
 <1432131015-22397-9-git-send-email-j.anaszewski@samsung.com>
 <20150520220018.GE8601@valkosipuli.retiisi.org.uk>
In-reply-to: <20150520220018.GE8601@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 05/21/2015 12:00 AM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Wed, May 20, 2015 at 04:10:15PM +0200, Jacek Anaszewski wrote:
>> This patch adds examples for samsung,flash-led property to the
>> samsung-fimc.txt.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Cc: devicetree@vger.kernel.org
>> ---
>>   .../devicetree/bindings/media/samsung-fimc.txt     |    4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
>> index 922d6f8..57edffa 100644
>> --- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
>> +++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
>> @@ -126,6 +126,8 @@ Example:
>>   			clocks = <&camera 1>;
>>   			clock-names = "mclk";
>>
>> +			samsung,flash-led = <&front_cam_flash>;
>> +
>>   			port {
>>   				s5k6aa_ep: endpoint {
>>   					remote-endpoint = <&fimc0_ep>;
>> @@ -147,6 +149,8 @@ Example:
>>   			clocks = <&camera 0>;
>>   			clock-names = "mclk";
>>
>> +			samsung,flash-led = <&rear_cam_flash>;
>> +
>>   			port {
>>   				s5c73m3_1: endpoint {
>>   					data-lanes = <1 2 3 4>;
>
> Oops. I missed this property would have ended to the sensor's DT node. I
> don't think we should have properties here that are parsed by another
> driver --- let's discuss this tomorrow.

exynos4-is driver already parses sensor nodes (at least their 'port'
sub-nodes).

> There are two main options that I can think of --- either put the property
> under the bridge (ISP) driver's device node as a temporary solution that
> works on a few ISP drivers, or think how sensor modules should be modelled,
> in which case we'd have some idea how lens device would be taken into
> account.
>
> Cc Sebastian.
>


-- 
Best Regards,
Jacek Anaszewski
