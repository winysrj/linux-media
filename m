Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:57609 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751685AbdDLNDY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Apr 2017 09:03:24 -0400
Subject: Re: [RFC PATCH 3/3] encoder-tpd12s015: keep the ls_oe_gpio on while
 the phys_addr is valid
To: Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-media@vger.kernel.org
References: <1461922746-17521-1-git-send-email-hverkuil@xs4all.nl>
 <1461922746-17521-4-git-send-email-hverkuil@xs4all.nl>
 <5731C7D2.4090807@ti.com> <5b6f679c-69dd-78be-a398-30aa4b4da1db@xs4all.nl>
 <1d801302-388b-1d00-f0be-18aaef8cf80f@ti.com>
Cc: dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5d47b07d-1866-f832-0d06-e834e7e2aebb@xs4all.nl>
Date: Wed, 12 Apr 2017 15:03:17 +0200
MIME-Version: 1.0
In-Reply-To: <1d801302-388b-1d00-f0be-18aaef8cf80f@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomi,

On 04/10/2017 01:59 PM, Tomi Valkeinen wrote:
> On 08/04/17 13:11, Hans Verkuil wrote:
> 
>> So, this is a bit of a blast from the past since the omap4 CEC development
>> has been on hold for almost a year. But I am about to resume my work on this
>> now that the CEC framework was merged.
>>
>> The latest code is here, if you are interested:
>>
>> https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=panda-cec
>>
>> It's pretty much unchanged from the version I posted a year ago, just rebased.
>>
>> But before I continue with this I have one question for you. First some
>> background:
>>
>> There is a special corner case (and I wasn't aware of that a year ago!) where
>> it is allowed to send a CEC message when there is *no HPD*.
>>
>> The reason is that some displays turn off the hotplug detect pin when they go
>> into standby or when another input is active. The only way to communicate with
>> such displays is via CEC.
>>
>> The problem is that without a HPD there is no EDID and basically no way for an
>> HDMI transmitter to detect that something is connected at all, unless you are
>> using CEC.
>>
>> What this means is that if we want to implement this on the omap4 the CEC support
>> has to be on all the time.
>>
>> We have seen modern displays that behave like this, so this is a real issue. And
>> this corner case is specifically allowed by the CEC specification: the Poll,
>> Image/Text View On and the Active Source messages can be sent to a TV even when
>> there is no HPD in order to turn on the display if it was in standby and to make
>> us the active input.
>>
>> The CEC framework in the kernel supports this starting with 4.12 (this code is
>> in the panda-cec branch above).
>>
>> If this *can't* be supported by the omap4, then I will likely have to add a CEC
>> capability to signal to the application that this specific corner case is not
>> supported.
>>
>> I just did some tests with omap4 and I my impression is that this can't be
>> supported: when the HPD goes away it seems like most/all of the HDMI blocks are
>> all powered off and any attempt to even access the CEC registers will fail.
>>
>> Changing this looks to be non-trivial if not impossible.
>>
>> Can you confirm that that isn't possible? If you think this can be done, then
>> I'd appreciate if you can give me a few pointers.
> 
> HPD doesn't control the HW, it's all in the SW. So while I don't know
> much at all about CEC and haven't looked at this particular use case, I
> believe it's doable. HPD going off will make the DRM connector to be in
> "disconnected" state, which on omapdrm will cause everything about HDMI
> to be turned off.
> 
> Does it work on some other DRM driver? I'm wondering if there's
> something in the DRM framework side that also has to be changed, in
> addition to omapdrm changes.
> 
> It could require larger SW redesigns, though... Which makes me think
> that the work shouldn't be done until we have changed the omapdrm's
> driver model to DRM's common bridge driver model, and then all this
> could possibly be done in a more generic manner.
> 
> Well, then again, I think the hdmi driver's internal power state
> handling could be improved even before that. Currently it's not very
> versatile. We should have ways to partially enable the IP for just the
> required parts.

I noticed while experimenting with this that tpd_disconnect() in
drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c isn't called when
I disconnect the HDMI cable. Is that a bug somewhere?

I would expect that tpd_connect and tpd_disconnect are balanced. The tpd_enable
and tpd_disable calls are properly balanced and I see the tpd_disable when I
disconnect the HDMI cable.

The key to keeping CEC up and running, even when there is no HPD is to keep
the hdmi.vdda_reg regulator enabled. Also the HDMI_IRQ_CORE should always be
on, otherwise I won't get any CEC interrupts.

So if the omap4 CEC support is enabled in the kernel config, then always enable
this regulator and irq, and otherwise keep the current code.

Does that look sensible to you?

Regards,

	Hans
