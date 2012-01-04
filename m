Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:44944 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab2ADVYn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2012 16:24:43 -0500
Message-ID: <4F04C394.5050302@iki.fi>
Date: Wed, 04 Jan 2012 23:24:36 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sylwester Nawrocki <snjw23@gmail.com>,
	"HeungJun, Kim" <riverful.kim@samsung.com>,
	linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, kyungmin.park@samsung.com,
	Hans de Goede <hdegoede@redhat.com>,
	Luca Risolia <luca.risolia@studio.unibo.it>
Subject: Re: [RFC PATCH 1/4] v4l: Add V4L2_CID_PRESET_WHITE_BALANCE menu control
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com> <4F007DED.4070201@gmail.com> <20120104203933.GJ9323@valkosipuli.localdomain> <201201042157.17040.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201201042157.17040.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> Hi Sakari,
>
> On Wednesday 04 January 2012 21:39:34 Sakari Ailus wrote:
>> On Sun, Jan 01, 2012 at 04:38:21PM +0100, Sylwester Nawrocki wrote:
>>> On 12/30/2011 09:41 PM, Sakari Ailus wrote:
>>>> On Fri, Dec 30, 2011 at 11:14:39AM +0100, Sylwester Nawrocki wrote:
>>>>> On 12/30/2011 12:34 AM, Sakari Ailus wrote:
>>>>>> On Wed, Dec 28, 2011 at 02:51:38PM +0100, Laurent Pinchart wrote:
>>>>>>> On Wednesday 28 December 2011 14:35:00 Sylwester Nawrocki wrote:
>>>>>>>> On 12/28/2011 07:23 AM, HeungJun, Kim wrote:
>>>>>>>>> It adds the new CID for setting White Balance Preset. This CID is
>>>>>>>>> provided as menu type using the following items:
>>>>>>>>> 0 - V4L2_WHITE_BALANCE_INCANDESCENT,
>>>>>>>>> 1 - V4L2_WHITE_BALANCE_FLUORESCENT,
>>>>>>>>> 2 - V4L2_WHITE_BALANCE_DAYLIGHT,
>>>>>>>>> 3 - V4L2_WHITE_BALANCE_CLOUDY,
>>>>>>>>> 4 - V4L2_WHITE_BALANCE_SHADE,
>>>>>>>>
>>>>>>>> I have been also investigating those white balance presets recently
>>>>>>>> and noticed they're also needed for the pwc driver. Looking at
>>>>>>>> drivers/media/video/pwc/pwc-v4l2.c there is something like:
>>>>>>>>
>>>>>>>> const char * const pwc_auto_whitebal_qmenu[] = {
>>>>>>>>
>>>>>>>> 	"Indoor (Incandescant Lighting) Mode",
>>>>>>>> 	"Outdoor (Sunlight) Mode",
>>>>>>>> 	"Indoor (Fluorescent Lighting) Mode",
>>>>>>>> 	"Manual Mode",
>>>>>>>> 	"Auto Mode",
>>>>>>>> 	NULL
>>>>>>>>
>>>>>>>> };
>>>>>>>>
>>>>>>>> static const struct v4l2_ctrl_config pwc_auto_white_balance_cfg = {
>>>>>>>>
>>>>>>>> 	.ops	=&pwc_ctrl_ops,
>>>>>>>> 	.id	= V4L2_CID_AUTO_WHITE_BALANCE,
>>>>>>>> 	.type	= V4L2_CTRL_TYPE_MENU,
>>>>>>>> 	.max	= awb_auto,
>>>>>>>> 	.qmenu	= pwc_auto_whitebal_qmenu,
>>>>>>>>
>>>>>>>> };
>>>>>>>>
>>>>>>>> ...
>>>>>>>>
>>>>>>>> 	cfg = pwc_auto_white_balance_cfg;
>>>>>>>> 	cfg.name = v4l2_ctrl_get_name(cfg.id);
>>>>>>>> 	cfg.def = def;
>>>>>>>> 	pdev->auto_white_balance = v4l2_ctrl_new_custom(hdl,&cfg, NULL);
>>>>>>>>
>>>>>>>> So this driver re-defines V4L2_CID_AUTO_WHITE_BALANCE as a menu
>>>>>>>> control with custom entries. That's interesting... However it
>>>>>>>> works in practice and applications have access to what's provided
>>>>>>>> by hardware. Perhaps V4L2_CID_AUTO_WHITE_BALANCE_TEMPERATURE would
>>>>>>>> be a better fit for that :)
>>>>>>>>
>>>>>>>> Nevertheless, redefining standard controls in particular drivers
>>>>>>>> sounds a little dubious. I wonder if this is a generally agreed
>>>>>>>> approach ?
>>>>>>>
>>>>>>> No agreed with me at least :-)
>>>>>>>
>>>>>>>> Then, how does your V4L2_CID_PRESET_WHITE_BALANCE control interact
>>>>>>>> with V4L2_CID_AUTO_WHITE_BALANCE control ? Does
>>>>>>>> V4L2_CID_AUTO_WHITE_BALANCE need to be set to false for
>>>>>>>> V4L2_CID_PRESET_WHITE_BALANCE to be effective ?
>>>>>>>
>>>>>>> Is the preset a fixed white balance setting, or is it an auto white
>>>>>>> balance with the algorithm tuned for a particular configuration ?
>>>>>>> In the first case, does it correspond to a fixed white balance
>>>>>>> temperature value ?
>>>>>>
>>>>>> While I'm waiting for a final answer to this, I guess it's the
>>>>>> second. There are three things involved here:
>>>>>>
>>>>>> - V4L2_CID_WHITE_BALANCE_TEMPERATURE: relatively low level control
>>>>>> telling
>>>>>>
>>>>>>    the colour temperature of the light source. Setting a value for
>>>>>>    this essentially means using manual white balance.
>>>>>>
>>>>>> - V4L2_CID_AUTO_WHITE_BALANCE: automatic white balance enabled or
>>>>>> disabled.
>>>>>
>>>>> Was the third thing the V4L2_CID_DO_WHITE_BALANCE control that you
>>>>> wanted to say ? It's also quite essential functionality, to be able
>>>>> to fix white balance after pointing camera to a white object. And I
>>>>> would expect
>>>>> V4L2_CID_WHITE_BALANCE_PRESET control's documentation to state how an
>>>>> interaction with V4L2_CID_DO_WHITE_BALANCE looks like.
>>>>
>>>> I expected the new control to be the third thing as configuration for
>>>> the awb algorithm, which it turned out not to be.
>>>>
>>>> I don't quite understand the purpose of the do_white_balance; the
>>>> automatic white balance algorithm is operational until it's disabled,
>>>> and after disabling it the white balance shouldn't change. What is the
>>>> extra functionality that the do_white_balance control implements?
>>>
>>> Maybe DO_WHITE_BALANCE was inspired by some hardware's behaviour, I don't
>>> know. I have nothing against this control. It allows you to perform
>>> one-shot white balance in a given moment in time. Simple and clear.
>>
>> Well, yes, if you have an automatic white balance algorithm which supports
>> "one-shot" mode. Typically it's rather a feedback loop. I guess this means
>> "just run one iteration".
>>
>> Something like this should possibly be used to get the white balance
>> correct by pointing the camera to an object of known colour (white
>> typically, I think). But this isn't it, at least based on the description
>> in the spec.
>
> Then either the spec is incorrect, or I'm mistaken. My understanding of the
> DO_WHITE_BALANCE control is exactly what you described.

This is what the spec says:

"This is an action control. When set (the value is ignored), the device 
will do a white balance and then hold the current setting. Contrast this 
with the boolean V4L2_CID_AUTO_WHITE_BALANCE, which, when activated, 
keeps adjusting the white balance."

I wonder if that should be then changed --- or is it just me who got a 
different idea from the above description?

My understanding is that the operation for getting the white balance 
information from a white object is by far simpler than getting the white 
balance correct without that.

These seem to be only two references to this control in drivers and both 
drivers are grossly misusing it. On one of them the description is 
"white balance background: blue" and on the other it's "night mode".

That makes me wonder in what kind of circumstances this control was 
originally introduced. Whatever it was, it seems to have taken place 
before 16th April in 2005. :-)

I think we could change the description to something more suitable or 
just remove this one...

Regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
