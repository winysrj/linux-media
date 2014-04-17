Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:54651 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754755AbaDQNAX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 09:00:23 -0400
Message-ID: <534FD05F.6060106@codethink.co.uk>
Date: Thu, 17 Apr 2014 14:00:15 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v2 48/48] adv7604: Add endpoint properties to DT bindings
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com> <1394493359-14115-49-git-send-email-laurent.pinchart@ideasonboard.com> <534FB855.1020702@samsung.com> <1791575.2krcfHqYT1@avalon>
In-Reply-To: <1791575.2krcfHqYT1@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17/04/14 13:45, Laurent Pinchart wrote:
> Hi Sylwester,
>
> On Thursday 17 April 2014 13:17:41 Sylwester Nawrocki wrote:
>> On 11/03/14 00:15, Laurent Pinchart wrote:
>>> Add support for the hsync-active, vsync-active and pclk-sample
>>> properties to the DT bindings and control BT.656 mode implicitly.
>>>
>>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>> ---
>>>
>>>   .../devicetree/bindings/media/i2c/adv7604.txt      | 13 +++++++++
>>>   drivers/media/i2c/adv7604.c                        | 31
>>>   ++++++++++++++++++++-- 2 files changed, 42 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
>>> b/Documentation/devicetree/bindings/media/i2c/adv7604.txt index
>>> 0845c50..2b62c06 100644
>>> --- a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
>>> +++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
>>>
>>> @@ -30,6 +30,19 @@ Optional Properties:
>>>     - adi,disable-cable-reset: Boolean property. When set disables the HDMI
>>>
>>>       receiver automatic reset when the HDMI cable is unplugged.
>>>
>>> +Optional Endpoint Properties:
>>> +
>>> +  The following three properties are defined in video-interfaces.txt and
>>> are +  valid for source endpoints only.
>>> +
>>> +  - hsync-active: Horizontal synchronization polarity. Defaults to active
>>> low. +  - vsync-active: Vertical synchronization polarity. Defaults to
>>> active low. +  - pclk-sample: Pixel clock polarity. Defaults to output on
>>> the falling edge. +
>>> +  If none of hsync-active, vsync-active and pclk-sample is specified the
>>> +  endpoint will use embedded BT.656 synchronization.
>>> +
>>> +
>>>
>>>   Example:
>>>   	hdmi_receiver@4c {
>>>
>>> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
>>> index 95cc911..2a92099 100644
>>> --- a/drivers/media/i2c/adv7604.c
>>> +++ b/drivers/media/i2c/adv7604.c
>>> @@ -41,6 +41,7 @@
>>>
>>>   #include <media/v4l2-ctrls.h>
>>>   #include <media/v4l2-device.h>
>>>   #include <media/v4l2-dv-timings.h>
>>>
>>> +#include <media/v4l2-of.h>
>>>
>>>   static int debug;
>>>   module_param(debug, int, 0644);
>>>
>>> @@ -2643,11 +2644,39 @@ MODULE_DEVICE_TABLE(of, adv7604_of_id);
>>>
>>>   static int adv7604_parse_dt(struct adv7604_state *state)
>>>   {
>>>
>>> +	struct v4l2_of_endpoint bus_cfg;
>>> +	struct device_node *endpoint;
>>>
>>>   	struct device_node *np;
>>>
>>> +	unsigned int flags;
>>>
>>>   	int ret;
>>>   	
>>>   	np = state->i2c_clients[ADV7604_PAGE_IO]->dev.of_node;
>>>
>>> +	/* Parse the endpoint. */
>>> +	endpoint = v4l2_of_get_next_endpoint(np, NULL);
>>> +	if (!endpoint)
>>> +		return -EINVAL;
>>
>> Perhaps we should document this binding requires at least one endpoint
>> node ? I guess there is no point in not having any endpoint node ?
>
> I think that's pretty much implied, otherwise the device will not be connected
> to anything and will be unusable. I will document ports node usage though,
> that's currently missing in the DT bindings documentation.

Doesn't the v4l2 helper code have standard parsing for the
endpoint sync configurations?


-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
