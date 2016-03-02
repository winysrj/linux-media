Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:51368 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755167AbcCBL2J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Mar 2016 06:28:09 -0500
Subject: Re: [RFC] Representing hardware connections via MC
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <20160226091317.5a07c374@recife.lan> <1753279.MBUKgSvGQl@avalon>
 <20160302081323.36eddba5@recife.lan> <1736605.4kGg8lYGrV@avalon>
Cc: LMML <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Javier Martinez Canillas <javier@osg.samsung.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56D6CE4A.1000208@xs4all.nl>
Date: Wed, 2 Mar 2016 12:28:10 +0100
MIME-Version: 1.0
In-Reply-To: <1736605.4kGg8lYGrV@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/02/16 12:16, Laurent Pinchart wrote:
> Hi Mauro,
> 
> On Wednesday 02 March 2016 08:13:23 Mauro Carvalho Chehab wrote:
>> Em Wed, 02 Mar 2016 12:34:42 +0200 Laurent Pinchart escreveu:
>>> On Friday 26 February 2016 09:13:17 Mauro Carvalho Chehab wrote:
> 
> [snip]
> 
>>>> NOTE:
>>>>
>>>> The labels at the PADs currently can't be represented, but the
>>>> idea is adding it as a property via the upcoming properties API.
>>>
>>> Whether to add labels to pads, and more generically how to differentiate
>>> them from userspace, is an interesting question. I'd like to decouple it
>>> from the connectors entities discussion if possible, in such a way that
>>> using labels wouldn't be required to leave the discussion open on that
>>> topic. If we foresee a dependency on labels for pads then we should open
>>> that discussion now.
>>
>> We can postpone such discussion. PAD labels are not needed for
>> what we have so far (RF, Composite, S-Video). Still, I think that
>> we'll need it by the time we add connector support for more complex
>> connector types, like HDMI.
> 
> If we don't add pad labels now then they should be optional for future 
> connectors too, including HDMI. If you think that HDMI connectors will require 
> them then we should discuss them now.
> 

Pad labels are IMHO only useful for producing human readable output. For complex
designs that helps a lot to understand what is going on.

But for kernel/applications all you need are #defines with the pad numbers (e.g.
HDMI_PAD_TMDS, HDMI_PAD_CEC, HDMI_PAD_ARC) to use for connectors.

Regards,

	Hans
