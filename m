Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:61039 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933270AbaH0NOC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Aug 2014 09:14:02 -0400
Received: by mail-oa0-f44.google.com with SMTP id eb12so132958oac.31
        for <linux-media@vger.kernel.org>; Wed, 27 Aug 2014 06:14:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53FDD718.3020202@xs4all.nl>
References: <1409143986-13990-1-git-send-email-jean-michel.hautbois@vodalys.com>
 <53FDD718.3020202@xs4all.nl>
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Date: Wed, 27 Aug 2014 15:13:46 +0200
Message-ID: <CAL8zT=hhyLpotLP+O+xP36JuNrVeaMr0uKq_kqiLo4otrvU9yg@mail.gmail.com>
Subject: Re: [PATCH] Add support for definition of register maps in DT in ADV7604
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2014-08-27 15:03 GMT+02:00 Hans Verkuil <hverkuil@xs4all.nl>:
> On 08/27/14 14:53, jean-michel.hautbois@vodalys.com wrote:
>> From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
>>
>> This patch adds support for DT parsing of register maps adresses.
>> This allows multiple adv76xx devices on the same bus.
>>
>> Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
>> ---
>>  .../devicetree/bindings/media/i2c/adv7604.txt      | 12 ++++
>>  drivers/media/i2c/adv7604.c                        | 71 ++++++++++++++++++----
>>  2 files changed, 71 insertions(+), 12 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
>> index c27cede..33881fb 100644
>> --- a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
>> +++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
>> @@ -32,6 +32,18 @@ The digital output port node must contain at least one endpoint.
>>  Optional Properties:
>>
>>    - reset-gpios: Reference to the GPIO connected to the device's reset pin.
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
>
>         Hans
>

I can replace all -page- by -addr- if it seems better... I used page
as this is also the name defined in the source code but you are
probably right, it is an address, not a page... :)

JM
