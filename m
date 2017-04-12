Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:35928 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752671AbdDLOER (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Apr 2017 10:04:17 -0400
Subject: Re: [RFC PATCH 3/3] encoder-tpd12s015: keep the ls_oe_gpio on while
 the phys_addr is valid
To: Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-media@vger.kernel.org
References: <1461922746-17521-1-git-send-email-hverkuil@xs4all.nl>
 <1461922746-17521-4-git-send-email-hverkuil@xs4all.nl>
 <5731C7D2.4090807@ti.com> <5b6f679c-69dd-78be-a398-30aa4b4da1db@xs4all.nl>
 <1d801302-388b-1d00-f0be-18aaef8cf80f@ti.com>
 <5d47b07d-1866-f832-0d06-e834e7e2aebb@xs4all.nl>
 <fc682c3d-3ab3-0d0f-3bb7-f6dc62f477f6@ti.com>
Cc: dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <54a864cd-00b8-3e5f-94d6-ceee1248cd53@xs4all.nl>
Date: Wed, 12 Apr 2017 16:04:09 +0200
MIME-Version: 1.0
In-Reply-To: <fc682c3d-3ab3-0d0f-3bb7-f6dc62f477f6@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/12/2017 03:21 PM, Tomi Valkeinen wrote:
> On 12/04/17 16:03, Hans Verkuil wrote:
> 
>> I noticed while experimenting with this that tpd_disconnect() in
>> drivers/gpu/drm/omapdrm/displays/encoder-tpd12s015.c isn't called when
>> I disconnect the HDMI cable. Is that a bug somewhere?
>>
>> I would expect that tpd_connect and tpd_disconnect are balanced. The tpd_enable
>> and tpd_disable calls are properly balanced and I see the tpd_disable when I
>> disconnect the HDMI cable.
> 
> The connect/disconnect naming there is legacy... It's not about cable
> connect, it's about the initial "connect" of the drivers in the video
> pipeline. It's done just once when starting omapdrm.

Ah, good to know.

>> The key to keeping CEC up and running, even when there is no HPD is to keep
>> the hdmi.vdda_reg regulator enabled. Also the HDMI_IRQ_CORE should always be
>> on, otherwise I won't get any CEC interrupts.
> 
> At the moment there's no way to enable the pipeline without enabling the
> video.
> 
>> So if the omap4 CEC support is enabled in the kernel config, then always enable
>> this regulator and irq, and otherwise keep the current code.
> 
> Well, I have no clue about how CEC is used, but don't we have some
> userspace components using it? I presume there's an open() or something
> similar that signals that the userspace is interested in CEC. That
> should be the trigger to enable the HW required for CEC.

Why didn't I think of that. I did a quick implementation to test this and it
works.

> So is some other driver supporting this already? Or is the omap4 the
> first platform you're trying this on?

No, there are quite a few CEC drivers by now, but typically the CEC block is
a totally independent IP block with its own power, irq, etc. The omap4 is by far
the most complex one to set up with various GPIO pins, interrupts, regulators,
etc. to deal with.

Normally it takes about 2 days to make a new CEC driver, but the omap4 is much
more work :-(

Regards,

	Hans
