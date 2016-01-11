Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:52422 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757645AbcAKJP1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 04:15:27 -0500
Subject: Re: [RFC] ADV7604: VGA support
To: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
References: <CAH-u=81zwkTxjYEsO8rNLf687-nGuj3DdJNeF6bmnxSUSVYQQg@mail.gmail.com>
 <561B89FD.4010802@xs4all.nl>
 <CAH-u=814zPmoMZ6JxChkk7KEXXP8AaX4tfao2urv+=sf44La9w@mail.gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <569372A9.40504@xs4all.nl>
Date: Mon, 11 Jan 2016 10:15:21 +0100
MIME-Version: 1.0
In-Reply-To: <CAH-u=814zPmoMZ6JxChkk7KEXXP8AaX4tfao2urv+=sf44La9w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/07/2016 06:20 PM, Jean-Michel Hautbois wrote:
> Hi Hans,
> 
> 2015-10-12 12:22 GMT+02:00 Hans Verkuil <hverkuil@xs4all.nl>:
>> On 10/04/2015 06:17 PM, Jean-Michel Hautbois wrote:
>>> Hi,
>>>
>>> I had another look into the ADV7604 HW manual, and I understand that
>>> in automatic mode, there is 4 AIN_SEL values possible, determining the
>>> connection on AIN pins.
>>> Now, having a look at the current ADV76xx files, I can see that two
>>> pads are there :
>>> ADV7604_PAD_VGA_RGB and ADV7604_PAD_VGA_COMP.
>>>
>>> According to the manual, my understanding is that we should have four
>>> HDMI pads and four analog pads. The latter would be configured as RGB
>>> or component, which allows four analog inputs as described in the HW
>>> manual.
>>
>> When I wrote the driver we only needed one VGA input receiving either RGB
>> or YCbCr. Hence there is only one analog input and two pads. I wouldn't have
>> been able to test the additional analog inputs anyway.
>>
>> I chose to use pads to select between the two modes, but that's something
>> that can be changed (it's not something you can autodetect, unfortunately).
>>
>> If you want to add support for all four analog inputs, then feel free to
>> do so.
> 
> OK, I don't have anything to test the additional inputs either...
> Something else so, the adv7604_state struct constains two fields,
> .ain_sel and .bus_order.
> Should those be parsed from DT (I think so) ? If so, how should it be
> named in the port{} node ?

Do you need to change this from the current default? If not, then I would
leave it as is.

If you do have to change this, then you would indeed have to add it to the DT.
ain_sel is Analog Devices specific, so just check that whatever you propose
is OK for the adv7842 as well.

Regarding bus order: this is probably something that can be more generic. I
have a deja vu feeling that I saw a patch adding support for this recently,
but I can't find it. Does it ring a bell for someone else?

Regards,

	Hans
