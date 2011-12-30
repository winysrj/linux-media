Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62512 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab1L3Kaj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 05:30:39 -0500
Received: by wgbdr13 with SMTP id dr13so24174114wgb.1
        for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 02:30:38 -0800 (PST)
Message-ID: <4EFD92C9.1030704@gmail.com>
Date: Fri, 30 Dec 2011 11:30:33 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: "HeungJun, Kim" <riverful.kim@samsung.com>
CC: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, sakari.ailus@iki.fi, kyungmin.park@samsung.com,
	'Hans de Goede' <hdegoede@redhat.com>
Subject: Re: [RFC PATCH 1/4] v4l: Add V4L2_CID_PRESET_WHITE_BALANCE menu control
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com> <1325053428-2626-2-git-send-email-riverful.kim@samsung.com> <4EFB1B04.6060305@gmail.com> <201112281451.39399.laurent.pinchart@ideasonboard.com> <001101ccc5e7$d9f48620$8ddd9260$%kim@samsung.com>
In-Reply-To: <001101ccc5e7$d9f48620$8ddd9260$%kim@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi HeungJun,

On 12/29/2011 06:08 AM, HeungJun, Kim wrote:
>> -----Original Message-----
>> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>> owner@vger.kernel.org] On Behalf Of Laurent Pinchart
>> Sent: Wednesday, December 28, 2011 10:52 PM
>> To: Sylwester Nawrocki
>> Cc: HeungJun, Kim; linux-media@vger.kernel.org; mchehab@redhat.com;
>> hverkuil@xs4all.nl; sakari.ailus@iki.fi; kyungmin.park@samsung.com; Hans de
>> Goede
>> Subject: Re: [RFC PATCH 1/4] v4l: Add V4L2_CID_PRESET_WHITE_BALANCE menu
>> control
>>
>> Hi,
>>
>> On Wednesday 28 December 2011 14:35:00 Sylwester Nawrocki wrote:
>>> On 12/28/2011 07:23 AM, HeungJun, Kim wrote:
>>>> It adds the new CID for setting White Balance Preset. This CID is
>>>> provided as menu type using the following items:
>>>> 0 - V4L2_WHITE_BALANCE_INCANDESCENT,
>>>> 1 - V4L2_WHITE_BALANCE_FLUORESCENT,
>>>> 2 - V4L2_WHITE_BALANCE_DAYLIGHT,
>>>> 3 - V4L2_WHITE_BALANCE_CLOUDY,
>>>> 4 - V4L2_WHITE_BALANCE_SHADE,
>>>
>>> I have been also investigating those white balance presets recently and
>>> noticed they're also needed for the pwc driver. Looking at
>>> drivers/media/video/pwc/pwc-v4l2.c there is something like:
>>>
>>> const char * const pwc_auto_whitebal_qmenu[] = {
>>> 	"Indoor (Incandescant Lighting) Mode",
>>> 	"Outdoor (Sunlight) Mode",
>>> 	"Indoor (Fluorescent Lighting) Mode",
>>> 	"Manual Mode",
>>> 	"Auto Mode",
>>> 	NULL
>>> };
>>>
>>> static const struct v4l2_ctrl_config pwc_auto_white_balance_cfg = {
>>> 	.ops	= &pwc_ctrl_ops,
>>> 	.id	= V4L2_CID_AUTO_WHITE_BALANCE,
>>> 	.type	= V4L2_CTRL_TYPE_MENU,
>>> 	.max	= awb_auto,
>>> 	.qmenu	= pwc_auto_whitebal_qmenu,
>>> };
>>>
>>> ...
>>>
>>> 	cfg = pwc_auto_white_balance_cfg;
>>> 	cfg.name = v4l2_ctrl_get_name(cfg.id);
>>> 	cfg.def = def;
>>> 	pdev->auto_white_balance = v4l2_ctrl_new_custom(hdl, &cfg, NULL);
>>>
>>> So this driver re-defines V4L2_CID_AUTO_WHITE_BALANCE as a menu control
>>> with custom entries. That's interesting... However it works in practice
>>> and applications have access to what's provided by hardware.
>>> Perhaps V4L2_CID_AUTO_WHITE_BALANCE_TEMPERATURE would be a better fit for
>>> that :)
>>>
>>> Nevertheless, redefining standard controls in particular drivers sounds
>>> a little dubious. I wonder if this is a generally agreed approach ?
>>
>> No agreed with me at least :-)
>
> I guess the WBP menu controls of pwc driver is probably defined in the other
> headers, for users being well known the PWC hardware. So it should be managed
> separately to videodev2.h. Is it right? Even if the way might be slightly
> different, it can't avoid to be "managed separately".
> 
> It means the users being not well known the specific hardware like PWC,
> have difficulty to use that driver well.
> And, at least, It doesn't looks generic API for me.
> In this case, the unfamiliar user with such unique hardware, can use
> whatever he wants to use finally, after finding & looking around the headers.

Applications can query drivers for supported controls and populate user control
panels dynamically, based on information from VIDIOC_QUERYCTRL and VIDIOC_QUERYMENU
ioctls. Not needing to rely on menu items definition in videodev2.h.
I had a feeling you weren't considering such case. :)

Perhaps it's uncommon in embedded systems though.

--

Regards,
Sylwester
