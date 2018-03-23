Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36852 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751595AbeCWVQT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 17:16:19 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v6] ARM: dts: wheat: Fix ADV7513 address usage
To: Simon Horman <horms@verge.net.au>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>
References: <1521754240-10470-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
 <20180323085140.g3golwdtpezo7fhi@verge.net.au>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <a771042b-f63a-d00f-73a1-91a7e6089fe4@ideasonboard.com>
Date: Fri, 23 Mar 2018 21:16:13 +0000
MIME-Version: 1.0
In-Reply-To: <20180323085140.g3golwdtpezo7fhi@verge.net.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Simon,

On 23/03/18 08:51, Simon Horman wrote:
> On Thu, Mar 22, 2018 at 09:30:40PM +0000, Kieran Bingham wrote:
>> The r8a7792 Wheat board has two ADV7513 devices sharing a single I2C
>> bus, however in low power mode the ADV7513 will reset it's slave maps to
>> use the hardware defined default addresses.
>>
>> The ADV7511 driver was adapted to allow the two devices to be registered
>> correctly - but it did not take into account the fault whereby the
>> devices reset the addresses.
>>
>> This results in an address conflict between the device using the default
>> addresses, and the other device if it is in low-power-mode.
>>
>> Repair this issue by moving both devices away from the default address
>> definitions.
> 
> Hi Kierean,
> 
> as this is a fix
> a) Does it warrant a fixes tag?
>    Fixes: f6eea82a87db ("ARM: dts: wheat: add DU support")
> b) Does it warrant being posted as a fix for v4.16;
> c) or v4.17?

Tricky one, yes it could but this DTS fix, will only actually 'fix' the issue if
the corresponding driver updates to allow secondary addresses to be parsed are
also backported.

It should be safe to back port the dts fix without the driver updates, but the
addresses specified by this patch will simply be ignored.

Thus if this is marked with the fixes tag the corresponding patch "drm: adv7511:
Add support for i2c_new_secondary_device" should also be marked.

It looks like that patch has yet to be picked up by the DRM subsystem, so how
about I bundle both of these two patches together in a repost along with the
fixes tag.

In fact, I don't think the ADV7511 dt-bindings update has made any progress
either. (dt-bindings: adv7511: Extend bindings to allow specifying slave map
addresses). The media tree variants for the adv7604 have already been picked up
by Mauro I believe though.

I presume it would be acceptable for this dts patch (or rather all three patches
mentioned) to get integrated through the DRM tree ?

--
Kieran
