Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:34782 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbcAMNSu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2016 08:18:50 -0500
Received: by mail-oi0-f42.google.com with SMTP id k206so93715642oia.1
        for <linux-media@vger.kernel.org>; Wed, 13 Jan 2016 05:18:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <569372A9.40504@xs4all.nl>
References: <CAH-u=81zwkTxjYEsO8rNLf687-nGuj3DdJNeF6bmnxSUSVYQQg@mail.gmail.com>
 <561B89FD.4010802@xs4all.nl> <CAH-u=814zPmoMZ6JxChkk7KEXXP8AaX4tfao2urv+=sf44La9w@mail.gmail.com>
 <569372A9.40504@xs4all.nl>
From: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Date: Wed, 13 Jan 2016 14:18:30 +0100
Message-ID: <CAH-u=832JmQpT2wQHGczOixGa9Gh7yPz8JMdW6kj_MyakG9dxA@mail.gmail.com>
Subject: Re: [RFC] ADV7604: VGA support
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

2016-01-11 10:15 GMT+01:00 Hans Verkuil <hverkuil@xs4all.nl>:
> On 01/07/2016 06:20 PM, Jean-Michel Hautbois wrote:
>> Hi Hans,
>>
>> 2015-10-12 12:22 GMT+02:00 Hans Verkuil <hverkuil@xs4all.nl>:
>>> On 10/04/2015 06:17 PM, Jean-Michel Hautbois wrote:
>>>> Hi,
>>>>
>>>> I had another look into the ADV7604 HW manual, and I understand that
>>>> in automatic mode, there is 4 AIN_SEL values possible, determining the
>>>> connection on AIN pins.
>>>> Now, having a look at the current ADV76xx files, I can see that two
>>>> pads are there :
>>>> ADV7604_PAD_VGA_RGB and ADV7604_PAD_VGA_COMP.
>>>>
>>>> According to the manual, my understanding is that we should have four
>>>> HDMI pads and four analog pads. The latter would be configured as RGB
>>>> or component, which allows four analog inputs as described in the HW
>>>> manual.
>>>
>>> When I wrote the driver we only needed one VGA input receiving either RGB
>>> or YCbCr. Hence there is only one analog input and two pads. I wouldn't have
>>> been able to test the additional analog inputs anyway.
>>>
>>> I chose to use pads to select between the two modes, but that's something
>>> that can be changed (it's not something you can autodetect, unfortunately).
>>>
>>> If you want to add support for all four analog inputs, then feel free to
>>> do so.
>>
>> OK, I don't have anything to test the additional inputs either...
>> Something else so, the adv7604_state struct constains two fields,
>> .ain_sel and .bus_order.
>> Should those be parsed from DT (I think so) ? If so, how should it be
>> named in the port{} node ?
>
> Do you need to change this from the current default? If not, then I would
> leave it as is.

I think it will have to be modified somehow, as those are global
parameters for the chip.
ain_sel is the same whatever the input is. So if you have both RGB and
YCrCb you should be able to define ain_sel for each one.

> If you do have to change this, then you would indeed have to add it to the DT.
> ain_sel is Analog Devices specific, so just check that whatever you propose
> is OK for the adv7842 as well.

OK.

> Regarding bus order: this is probably something that can be more generic. I
> have a deja vu feeling that I saw a patch adding support for this recently,
> but I can't find it. Does it ring a bell for someone else?

Not to me, but interested :).
JM
