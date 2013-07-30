Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1417 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab3G3QRb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jul 2013 12:17:31 -0400
Message-ID: <51F7E712.40103@xs4all.nl>
Date: Tue, 30 Jul 2013 18:17:22 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Question about v4l2-compliance: cap->readbuffers
References: <CAPybu_1kw0CjtJxt-ivMheJSeSEi95ppBbDcG1yXOLLRaR4tRg@mail.gmail.com> <201307301545.51529.hverkuil@xs4all.nl> <CAPybu_13HCY1i=tH1krdKGOSbJNgek-X4gt1cGmo_oB=AqTxKg@mail.gmail.com> <201307301729.26053.hverkuil@xs4all.nl> <CAPybu_2TivP9Pui2O5N8QofT-07tdxYMnOsC2Nvo7Ods0PuX7w@mail.gmail.com>
In-Reply-To: <CAPybu_2TivP9Pui2O5N8QofT-07tdxYMnOsC2Nvo7Ods0PuX7w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

On 07/30/2013 05:46 PM, Ricardo Ribalda Delgado wrote:
> Hello
> 
> I have a camera that works on two modes: Mono and colour. On color
> mode it has 3 gains, on mono mode it has 1 gain.
> 
> When the user sets the output to mono I disable the color controls
> (and the other way around).
> 
> Also on color mode the hflip and vflip do not work, therefore I dont show them.
> 
> I could return -EINVAL, but I rather not show the controls to the user.
> 
> What would be the proper way to do this?

Use the INACTIVE flag, that's the way it is typically done. You can still set
such controls, but the new value won't be active until you switch back to a
mode where they do work.

Using INACTIVE will show such controls as disabled in a GUI like qv4l2. I highly
recommend using qv4l2 for testing this since it is the reference implementation
of how GUIs should interpret control flags.

Regards,

	Hans

> 
> 
> Thanks gain.
> 
> 
> 
> 
> 
> On Tue, Jul 30, 2013 at 5:29 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On Tue 30 July 2013 17:18:58 Ricardo Ribalda Delgado wrote:
>>> Thanks for the explanation Hans!
>>>
>>> I finaly manage to pass that one ;)
>>>
>>> Just one more question. Why the compliance test checks if the DISABLED
>>> flag is on on for qctrls?
>>>
>>> http://git.linuxtv.org/v4l-utils.git/blob/3ae390e54a0ba627c9e74953081560192b996df4:/utils/v4l2-compliance/v4l2-test-controls.cpp#l137
>>>
>>>  137         if (fl & V4L2_CTRL_FLAG_DISABLED)
>>>  138                 return fail("DISABLED flag set\n");
>>>
>>> Apparently that has been added on:
>>> http://git.linuxtv.org/v4l-utils.git/commit/0a4d4accea7266d7b5f54dea7ddf46cce8421fbb
>>>
>>> But I have failed to find a reason
>>
>> It shouldn't be used anymore in drivers. With the control framework there is
>> no longer any reason to use the DISABLED flag.
>>
>> If something has a valid use case for it, then I'd like to know what it is.
>>
>> Regards,
>>
>>         Hans
> 
> 
> 
