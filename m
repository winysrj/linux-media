Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:49513 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752861AbcKNSVl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 13:21:41 -0500
Subject: Re: [PATCH v4 3/8] media: adv7180: add support for NEWAVMODE
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Steve Longerbeam <slongerbeam@gmail.com>, <lars@metafoo.de>
References: <1470247430-11168-1-git-send-email-steve_longerbeam@mentor.com>
 <1470247430-11168-4-git-send-email-steve_longerbeam@mentor.com>
 <c759906e-e04f-2ccd-f175-e46367879890@xs4all.nl>
CC: <mchehab@kernel.org>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <c1881a76-2440-7014-18c8-45b369f8f107@mentor.com>
Date: Mon, 14 Nov 2016 10:21:33 -0800
MIME-Version: 1.0
In-Reply-To: <c759906e-e04f-2ccd-f175-e46367879890@xs4all.nl>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 11/14/2016 03:28 AM, Hans Verkuil wrote:
> On 08/03/2016 08:03 PM, Steve Longerbeam wrote:
>> Parse the optional v4l2 endpoint DT node. If the bus type is
>> V4L2_MBUS_BT656 and the endpoint node specifies "newavmode",
>> configure the BT.656 bus in NEWAVMODE.
>>
>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>>
>> ---
>>
>> v4: no changes
>> v3:
>> - the newavmode endpoint property is now private to adv7180.
>> ---
>>   .../devicetree/bindings/media/i2c/adv7180.txt      |  4 ++
>>   drivers/media/i2c/adv7180.c                        | 46 ++++++++++++++++++++--
>>   2 files changed, 47 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7180.txt b/Documentation/devicetree/bindings/media/i2c/adv7180.txt
>> index 0d50115..6c175d2 100644
>> --- a/Documentation/devicetree/bindings/media/i2c/adv7180.txt
>> +++ b/Documentation/devicetree/bindings/media/i2c/adv7180.txt
>> @@ -15,6 +15,10 @@ Required Properties :
>>   		"adi,adv7282"
>>   		"adi,adv7282-m"
>>   
>> +Optional Endpoint Properties :
>> +- newavmode: a boolean property to indicate the BT.656 bus is operating
>> +  in Analog Device's NEWAVMODE. Valid for BT.656 busses only.
> This is too vague.
>
> Based on the ADV7280/ADV7281/ADV7282/ADV7283 Hardware Reference Manual I
> would say something like this:
>
> - newavmode: a boolean property to indicate the BT.656 bus is operating
>    in Analog Device's NEWAVMODE. Valid for BT.656 busses only. When enabled
>    the generated EAV/SAV codes are suitable for Analog Devices encoders.
>    Otherwise these codes are setup according to <some standard?>
>    See bit 4 of user sub map register 0x31 in the Hardware Reference Manual.
>
> I may have asked this before, but do you actually have hardware that needs
> this? If so, it may be useful to give it as an example and explain why it
> is needed.
>
> If not, then I wonder if this cannot be dropped until we DO see hardware
> that needs it.

Hi Hans, thanks for reviewing this, but at least for imx6, I don't
need this patch anymore.

Recently I dug deeper into the current bt.656 programming in
adv7180.c. The driver manually configures the bus to have 21
blank lines in odd fields, and 22 blank lines in even fields (via
NVEND register) for NTSC.

That leaves 525 - (21 +22) = 482 active lines in NTSC.

After configuring the imx6 host bridge to crop those extra 2 lines,
it is capturing good 720x480 NTSC images now.

So I no longer need this patch to enable NEWAVMODE.

However I still see some issues.

First, adv7180.c attempts to enable  BT.656-4 mode, but according
to the datasheet, that cannot be enabled without first enabling
NEWAVMODE. So the attempt to enable BT.656-4 mode is a no-op,
it is currently doing nothing. So I suggest removing that attempt.

Second, it is wrong for the host bridge to have to make an assumption
about cropping for a sensor. The adv7180 needs to communicate to
hosts about the number of field blanking lines it has configured, maybe
via get_selection. I.e., report full sensor frame via get_fmt, and 720x482
via get_selection.


Steve

