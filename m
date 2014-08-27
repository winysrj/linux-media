Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-167.synserver.de ([212.40.185.167]:1040 "EHLO
	smtp-out-167.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933583AbaH0ON2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Aug 2014 10:13:28 -0400
Message-ID: <53FDE5AA.2040805@metafoo.de>
Date: Wed, 27 Aug 2014 16:05:30 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: jean-michel.hautbois@vodalys.com, linux-media@vger.kernel.org,
	Wolfram Sang <w.sang@pengutronix.de>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH] Add support for definition of register maps in DT in
 ADV7604
References: <1409143986-13990-1-git-send-email-jean-michel.hautbois@vodalys.com> <53FDD718.3020202@xs4all.nl>
In-Reply-To: <53FDD718.3020202@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/27/2014 03:03 PM, Hans Verkuil wrote:
> On 08/27/14 14:53, jean-michel.hautbois@vodalys.com wrote:
>> From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
>>
>> This patch adds support for DT parsing of register maps adresses.
>> This allows multiple adv76xx devices on the same bus.
>>
>> Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
>> ---
>>   .../devicetree/bindings/media/i2c/adv7604.txt      | 12 ++++
>>   drivers/media/i2c/adv7604.c                        | 71 ++++++++++++++++++----
>>   2 files changed, 71 insertions(+), 12 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
>> index c27cede..33881fb 100644
>> --- a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
>> +++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
>> @@ -32,6 +32,18 @@ The digital output port node must contain at least one endpoint.
>>   Optional Properties:
>>
>>     - reset-gpios: Reference to the GPIO connected to the device's reset pin.
>> +  - adv7604-page-avlink: Programmed address for avlink register map
>> +  - adv7604-page-cec: Programmed address for cec register map
>> +  - adv7604-page-infoframe: Programmed address for infoframe register map
>> +  - adv7604-page-esdp: Programmed address for esdp register map
>> +  - adv7604-page-dpp: Programmed address for dpp register map
>> +  - adv7604-page-afe: Programmed address for afe register map
>> +  - adv7604-page-rep: Programmed address for rep register map
>> +  - adv7604-page-edid: Programmed address for edid register map
>> +  - adv7604-page-hdmi: Programmed address for hdmi register map
>> +  - adv7604-page-test: Programmed address for test register map
>> +  - adv7604-page-cp: Programmed address for cp register map
>> +  - adv7604-page-vdp: Programmed address for vdp register map
>
> Might adv7604-addr-avlink be a better name? Other than that it looks good
> to me.

Those properties need at least a vendor prefix. But to be honest I'd rather see 
generic support for multiple addresses in the I2C core. This is not a feature 
that is specific to this particular device. And for example similar things work 
already fine for other buses like for example MMIO devices.

E.g. something like

reg = <0x12 0x34 0x56 0x78 ...>
reg-names = "main", "avlink", "cec", "infoframe", ...

Ideally accessing those other addresses will be hidden in the I2C core by a 
helper function that allows you to create a dummy device for a particular 
sub-address.

- Lars
