Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757709Ab2IJScO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Sep 2012 14:32:14 -0400
Message-ID: <504E3275.8010806@redhat.com>
Date: Mon, 10 Sep 2012 20:33:25 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] libv4lconvert: pac7302-devices: remove unneeded flag
 V4LCONTROL_WANTS_WB
References: <1347215768-9843-1-git-send-email-fschaefer.oss@googlemail.com> <1347215768-9843-2-git-send-email-fschaefer.oss@googlemail.com> <504D08F8.3070104@redhat.com> <504E0A13.2050305@googlemail.com>
In-Reply-To: <504E0A13.2050305@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09/10/2012 05:41 PM, Frank Schäfer wrote:
> Am 09.09.2012 23:24, schrieb Hans de Goede:
>> Hi,
>>
>> On 09/09/2012 08:36 PM, Frank Schäfer wrote:
>>> The gspca_pac7302 driver already provides this control.
>>>
>>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>>> ---
>>>    lib/libv4lconvert/control/libv4lcontrol.c |   12 ++++--------
>>>    1 files changed, 4 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/lib/libv4lconvert/control/libv4lcontrol.c
>>> b/lib/libv4lconvert/control/libv4lcontrol.c
>>> index 1272256..3d7a816 100644
>>> --- a/lib/libv4lconvert/control/libv4lcontrol.c
>>> +++ b/lib/libv4lconvert/control/libv4lcontrol.c
>>> @@ -202,14 +202,10 @@ static const struct v4lcontrol_flags_info
>>> v4lcontrol_flags[] = {
>>>        { 0x145f, 0x013a, 0,    NULL, NULL, V4LCONTROL_WANTS_WB, 1500 },
>>>        { 0x2001, 0xf115, 0,    NULL, NULL, V4LCONTROL_WANTS_WB, 1500 },
>>>        /* Pac7302 based devices */
>>> -    { 0x093a, 0x2620, 0x0f, NULL, NULL,
>>> -        V4LCONTROL_ROTATED_90_JPEG | V4LCONTROL_WANTS_WB, 1500 },
>>> -    { 0x06f8, 0x3009, 0,    NULL, NULL,
>>> -        V4LCONTROL_ROTATED_90_JPEG | V4LCONTROL_WANTS_WB, 1500 },
>>> -    { 0x06f8, 0x301b, 0,    NULL, NULL,
>>> -        V4LCONTROL_ROTATED_90_JPEG | V4LCONTROL_WANTS_WB, 1500 },
>>> -    { 0x145f, 0x013c, 0,    NULL, NULL,
>>> -        V4LCONTROL_ROTATED_90_JPEG | V4LCONTROL_WANTS_WB, 1500 },
>>> +    { 0x093a, 0x2620, 0x0f, NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
>>> +    { 0x06f8, 0x3009, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
>>> +    { 0x06f8, 0x301b, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
>>> +    { 0x145f, 0x013c, 0,    NULL, NULL, V4LCONTROL_ROTATED_90_JPEG },
>>>        /* Pac7311 based devices */
>>>        { 0x093a, 0x2600, 0x0f, NULL, NULL, V4LCONTROL_WANTS_WB },
>>>        /* sq905 devices */
>>>
>>
>> WANTS_WB does not add a whitebalance control, which these cameras indeed
>> already have, it adds a (software) autowhitebalance control, which
>> enables
>> libv4lconvert doing software whitebalance correction. Although your
>> kernel patch for the pac7302 driver to pick a better default whitebalance
>> value, probably helps a lot to get the colors less screwed up, in the end
>> we still need some sort of awb to adjust to changing lightning
>> conditions,
>> that is what this flag adds, as the pac7302 driver lacks awb.
>
> Ok, so WANTS_WB is actually WANTS_AUTOWB. ;)
> But... IIRC... the software AWB control is always there, even without
> this flag !?
> Or is it just about switching AWB on by default ?

Correct, also note that the awb control will only show up for devices which
have non standard formats, since those need to always go through libv4lconvert
anyways, it does not get added to standard cams unless specifically enabled
through a quirk list entry.

> And if AWB is on, the WB control should be disabled, right ?

No, the software AWB works by applying software rgb gains, so the hardware
control is still useful, as the better the color balance of the input,
the better the end-result will be.

Regards,

Hans
