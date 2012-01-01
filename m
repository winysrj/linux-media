Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38615 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab2AAPi0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Jan 2012 10:38:26 -0500
Received: by eekc4 with SMTP id c4so14751797eek.19
        for <linux-media@vger.kernel.org>; Sun, 01 Jan 2012 07:38:25 -0800 (PST)
Message-ID: <4F007DED.4070201@gmail.com>
Date: Sun, 01 Jan 2012 16:38:21 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"HeungJun, Kim" <riverful.kim@samsung.com>,
	linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, kyungmin.park@samsung.com,
	Hans de Goede <hdegoede@redhat.com>,
	Luca Risolia <luca.risolia@studio.unibo.it>
Subject: Re: [RFC PATCH 1/4] v4l: Add V4L2_CID_PRESET_WHITE_BALANCE menu control
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com> <1325053428-2626-2-git-send-email-riverful.kim@samsung.com> <4EFB1B04.6060305@gmail.com> <201112281451.39399.laurent.pinchart@ideasonboard.com> <20111229233406.GU3677@valkosipuli.localdomain> <4EFD8F0F.6060505@gmail.com> <20111230204144.GX3677@valkosipuli.localdomain>
In-Reply-To: <20111230204144.GX3677@valkosipuli.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 12/30/2011 09:41 PM, Sakari Ailus wrote:
> On Fri, Dec 30, 2011 at 11:14:39AM +0100, Sylwester Nawrocki wrote:
>> On 12/30/2011 12:34 AM, Sakari Ailus wrote:
>>> On Wed, Dec 28, 2011 at 02:51:38PM +0100, Laurent Pinchart wrote:
>>>> On Wednesday 28 December 2011 14:35:00 Sylwester Nawrocki wrote:
>>>>> On 12/28/2011 07:23 AM, HeungJun, Kim wrote:
>>>>>> It adds the new CID for setting White Balance Preset. This CID is
>>>>>> provided as menu type using the following items:
>>>>>> 0 - V4L2_WHITE_BALANCE_INCANDESCENT,
>>>>>> 1 - V4L2_WHITE_BALANCE_FLUORESCENT,
>>>>>> 2 - V4L2_WHITE_BALANCE_DAYLIGHT,
>>>>>> 3 - V4L2_WHITE_BALANCE_CLOUDY,
>>>>>> 4 - V4L2_WHITE_BALANCE_SHADE,
>>>>>
>>>>> I have been also investigating those white balance presets recently and
>>>>> noticed they're also needed for the pwc driver. Looking at
>>>>> drivers/media/video/pwc/pwc-v4l2.c there is something like:
>>>>>
>>>>> const char * const pwc_auto_whitebal_qmenu[] = {
>>>>> 	"Indoor (Incandescant Lighting) Mode",
>>>>> 	"Outdoor (Sunlight) Mode",
>>>>> 	"Indoor (Fluorescent Lighting) Mode",
>>>>> 	"Manual Mode",
>>>>> 	"Auto Mode",
>>>>> 	NULL
>>>>> };
>>>>>
>>>>> static const struct v4l2_ctrl_config pwc_auto_white_balance_cfg = {
>>>>> 	.ops	= &pwc_ctrl_ops,
>>>>> 	.id	= V4L2_CID_AUTO_WHITE_BALANCE,
>>>>> 	.type	= V4L2_CTRL_TYPE_MENU,
>>>>> 	.max	= awb_auto,
>>>>> 	.qmenu	= pwc_auto_whitebal_qmenu,
>>>>> };
>>>>>
>>>>> ...
>>>>>
>>>>> 	cfg = pwc_auto_white_balance_cfg;
>>>>> 	cfg.name = v4l2_ctrl_get_name(cfg.id);
>>>>> 	cfg.def = def;
>>>>> 	pdev->auto_white_balance = v4l2_ctrl_new_custom(hdl, &cfg, NULL);
>>>>>
>>>>> So this driver re-defines V4L2_CID_AUTO_WHITE_BALANCE as a menu control
>>>>> with custom entries. That's interesting... However it works in practice
>>>>> and applications have access to what's provided by hardware.
>>>>> Perhaps V4L2_CID_AUTO_WHITE_BALANCE_TEMPERATURE would be a better fit for
>>>>> that :)
>>>>>
>>>>> Nevertheless, redefining standard controls in particular drivers sounds
>>>>> a little dubious. I wonder if this is a generally agreed approach ?
>>>>
>>>> No agreed with me at least :-)
>>>>
>>>>> Then, how does your V4L2_CID_PRESET_WHITE_BALANCE control interact with
>>>>> V4L2_CID_AUTO_WHITE_BALANCE control ? Does V4L2_CID_AUTO_WHITE_BALANCE need
>>>>> to be set to false for V4L2_CID_PRESET_WHITE_BALANCE to be effective ?
>>>>
>>>> Is the preset a fixed white balance setting, or is it an auto white balance 
>>>> with the algorithm tuned for a particular configuration ? In the first case, 
>>>> does it correspond to a fixed white balance temperature value ?
>>>
>>> While I'm waiting for a final answer to this, I guess it's the second. There
>>> are three things involved here:
>>>
>>> - V4L2_CID_WHITE_BALANCE_TEMPERATURE: relatively low level control telling
>>>   the colour temperature of the light source. Setting a value for this
>>>   essentially means using manual white balance.
>>>
>>> - V4L2_CID_AUTO_WHITE_BALANCE: automatic white balance enabled or disabled.
>>
>> Was the third thing the V4L2_CID_DO_WHITE_BALANCE control that you wanted to
>> say ? It's also quite essential functionality, to be able to fix white balance
>> after pointing camera to a white object. And I would expect
>> V4L2_CID_WHITE_BALANCE_PRESET control's documentation to state how an
>> interaction with V4L2_CID_DO_WHITE_BALANCE looks like.
> 
> I expected the new control to be the third thing as configuration for the
> awb algorithm, which it turned out not to be.
> 
> I don't quite understand the purpose of the do_white_balance; the automatic
> white balance algorithm is operational until it's disabled, and after
> disabling it the white balance shouldn't change. What is the extra
> functionality that the do_white_balance control implements?

Maybe DO_WHITE_BALANCE was inspired by some hardware's behaviour, I don't
know. I have nothing against this control. It allows you to perform one-shot
white balance in a given moment in time. Simple and clear.

> If we agree white_balance_preset works at the same level as
> white_balance_temerature control, this becomes more simple. I guess no
> driver should implement both.

Yes, AFAIU those presets are just WB temperature, with names instead
of numbers. Thus it doesn't make much sense to expose both at the driver.

But in manual white balance mode camera could be switched to new WB value,
with component gain/balance controls, DO_WHITE_BALANCE or whatever, rendering
the preset setting invalid. Should we then have an invalid/unknown item in
the presets menu ? This would be only allowed to set by driver, i.e. read-only
for applications. If device provide multiple means for setting white balance
it is quite likely that at some point wb might not match any preset.

Having auto, manual and presets in one menu control wouldn't require that,
but we rather can't just change the V4L2_CID_WHITE_BALANCE control type now.

>>> The new control proposed by HeungJun is input for the automatic white
>>> balance algorithm unless I'm mistaken. Whether or not the value is static,
>>> however, might be considered of secondary importance: it is a name instead
>>> of a number and clearly intended to be used as a high level control. I'd
>>> still expect it to be a hint for the algorithm.
>>>
>>> The value of the new control would have an effect as long as automatic white
>>> balance is enabled.
>>
>> The idea to treat the preset as a hint to the algorithm is interesting, however
>> as it turns out this are just static values (R/B balance) in manual WB mode.
> 
> Agreed, if there's a device doing this we will add another control at that
> time.

Ack.

>> I expect some parameters for adjusting auto WB algorithm (WB (R/G/B) gain bias
>> or something similar) to be present in sensor's ISP as well. If I remember well
>> I've seen something like this in one of sensor's documentations.
> 
> Sounds reasonable.
> 
>>>>>> diff --git a/Documentation/DocBook/media/v4l/controls.xml
>>>>>> b/Documentation/DocBook/media/v4l/controls.xml index c0422c6..350c138
>>>>>> 100644
>>>>>> --- a/Documentation/DocBook/media/v4l/controls.xml
>>>>>> +++ b/Documentation/DocBook/media/v4l/controls.xml
>>>>>> @@ -2841,6 +2841,44 @@ it one step further. This is a write-only
>>>>>> control.</entry>
>>>>>>
>>>>>>  	  </row>
>>>>>>  	  <row><entry></entry></row>
>>>>>>
>>>>>> +	  <row id="v4l2-preset-white-balance">
>>>>>> +	    <entry
>>>>>> spanname="id"><constant>V4L2_CID_PRESET_WHITE_BALANCE</constant>&nbsp;</
>>>>>> entry>
>>>>>
>>>>> Wouldn't V4L2_CID_WHITE_BALANCE_PRESET be better ?
>>>>
>>>> That's what I was about to say.
>>>
>>> And the menu items would contain the same prefix with CID_ removed. They're
>>> going to be long, but I don't see that as an issue for menu items.
>>
>> Should we call it V4L2_CID_WB_PRESET then ?
>>
>> Anyway V4L2_WHITE_BALANCE_PRESET_INCADESCENT for example is not that long,
>> we have control names that almost reach 80 characters :)
> 
> I'd prefer the long one but I have no strong opinion either way.

Ok, let's keep the long one then.


Happy New Year! :)

S.
