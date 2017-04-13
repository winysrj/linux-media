Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:60192 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756118AbdDMJNF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Apr 2017 05:13:05 -0400
Subject: Re: [RFC PATCH 3/3] encoder-tpd12s015: keep the ls_oe_gpio on while
 the phys_addr is valid
To: Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-media@vger.kernel.org
References: <1461922746-17521-1-git-send-email-hverkuil@xs4all.nl>
 <1461922746-17521-4-git-send-email-hverkuil@xs4all.nl>
 <5731C7D2.4090807@ti.com> <5b6f679c-69dd-78be-a398-30aa4b4da1db@xs4all.nl>
 <1d801302-388b-1d00-f0be-18aaef8cf80f@ti.com>
 <5d47b07d-1866-f832-0d06-e834e7e2aebb@xs4all.nl>
 <fc682c3d-3ab3-0d0f-3bb7-f6dc62f477f6@ti.com>
 <54a864cd-00b8-3e5f-94d6-ceee1248cd53@xs4all.nl>
 <d4b49cb9-7147-c2f4-7e14-99dce1a05708@ti.com>
Cc: dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f139d50e-c186-5f00-2a84-a09bf32ab5f6@xs4all.nl>
Date: Thu, 13 Apr 2017 11:12:59 +0200
MIME-Version: 1.0
In-Reply-To: <d4b49cb9-7147-c2f4-7e14-99dce1a05708@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/13/2017 10:43 AM, Tomi Valkeinen wrote:
> On 12/04/17 17:04, Hans Verkuil wrote:
> 
>>> So is some other driver supporting this already? Or is the omap4 the
>>> first platform you're trying this on?
>>
>> No, there are quite a few CEC drivers by now, but typically the CEC block is
>> a totally independent IP block with its own power, irq, etc. The omap4 is by far
>> the most complex one to set up with various GPIO pins, interrupts, regulators,
>> etc. to deal with.
>>
>> Normally it takes about 2 days to make a new CEC driver, but the omap4 is much
>> more work :-(
> 
> Ok.
> 
> I mentioned the omapdrm restructuring that we've planned to do, I think
> after that this will be easier to implement in a nice way.
> 
> For now, I think more or less what you have now is an acceptable
> solution. We can hack the tpd12s015 to keep the level shifter always
> enabled, and, afaics, everything else can be handled inside the hdmi4
> driver, right?

Right.

> Generally speaking, what are the "dependencies" for CEC? It needs to
> access EDID? Does CEC care about HPD? Does it care if the cable is
> connected or not? For Panda, the level shifter of tpd12s015 is obviously
> one hard dendency.
> 
> Is there anything else CEC needs to access or control (besides the CEC
> IP itself)?

The CEC framework needs to be informed about the physical address contained
in the EDID (part of the CEA-861 block). And when the HPD goes down it needs
to be informed as well (same call, but with CEC_PHYS_ADDR_INVALID as argument).

And it needs to stay powered up even if the HPD is down.

That's all.

Regards,

	Hans
