Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:44482 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125AbcBZNsK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2016 08:48:10 -0500
Subject: Re: [RFC] Representing hardware connections via MC
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	LMML <linux-media@vger.kernel.org>
References: <20160226091317.5a07c374@recife.lan> <56D051DC.5070900@xs4all.nl>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Message-ID: <56D0578C.3000904@osg.samsung.com>
Date: Fri, 26 Feb 2016 10:47:56 -0300
MIME-Version: 1.0
In-Reply-To: <56D051DC.5070900@xs4all.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

On 02/26/2016 10:23 AM, Hans Verkuil wrote:
> On 02/26/2016 01:13 PM, Mauro Carvalho Chehab wrote:

[snip]

>>
>> #define MEDIA_ENT_F_INPUT_RF		(MEDIA_ENT_F_BASE + 10001)
>> #define MEDIA_ENT_F_INPUT_SVIDEO	(MEDIA_ENT_F_BASE + 10002)
>> #define MEDIA_ENT_F_INPUT_COMPOSITE	(MEDIA_ENT_F_BASE + 10003)
>>
>> The MEDIA_ENT_F_INPUT_RF and MEDIA_ENT_F_INPUT_COMPOSITE will have
>> just one sink PAD each, as they carry just one signal. As we're
>> describing the logical input, it doesn't matter the physical
>> connector type. So, except for re-naming the define, nothing
>> changes for them.
>
> What if my device has an SVIDEO output (e.g. ivtv)? 'INPUT' denotes
> the direction, and I don't think that's something you want in the
> define for the connector entity.
>
> As was discussed on irc we are really talking about signals received
> or transmitted by/from a connector. I still prefer F_SIG_ or F_SIGNAL_
> or F_CONN_SIG_ or something along those lines.
>
> I'm not sure where F_INPUT came from, certainly not from the irc
> discussion.
>

Indeed, I missed that when reviewing the proposal.

>> Devices with S-Video input will have one MEDIA_ENT_F_INPUT_SVIDEO
>> per each different S-Video input. Each one will have two sink pads,
>> one for the Y signal and another for the C signal.
>>
>> So, a device like Terratec AV350, that has one Composite and one
>> S-Video input[1] would be represented as:
>> 	https://mchehab.fedorapeople.org/terratec_av350-modified.png
>>
>>
>> [1] Physically, it has a SCART connector that could be enabled
>> via a physical switch, but logically, the device will still switch
>> from S-Video over SCART or composite over SCART.
>>
>> More complex devices would be represented like:
>> 	https://hverkuil.home.xs4all.nl/adv7604.png
>> 	https://hverkuil.home.xs4all.nl/adv7842.png
>>
>> NOTE:
>>
>> The labels at the PADs currently can't be represented, but the
>> idea is adding it as a property via the upcoming properties API.
>
> I think this is a separate discussion. It's not needed for now.
> When working on the adv7604/7842 examples I realized that pad names help
> understand the topology a lot better, but they are not needed for the actual
> functionality.
>

It's true that is a separate discussion but it would be good to agree
on it at least before the G_TOPOLOGY ioctl is available since we may
need to add a label/name field to struct media_v2_pad, that is filled
by the kernel and copied to user-space so it can't be changed later.

>>
>> Anyone disagree?
>
> I agree except for the naming.
>
> Regards,
>
> 	Hans
>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
