Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40795 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750729AbeBGXkG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Feb 2018 18:40:06 -0500
Subject: Re: [PATCH 2/2] drm: adv7511: Add support for
 i2c_new_secondary_device
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: Archit Taneja <architt@codeaurora.org>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        David Airlie <airlied@linux.ie>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        John Stultz <john.stultz@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Inki Dae <inki.dae@samsung.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
References: <1516625389-6362-1-git-send-email-kieran.bingham@ideasonboard.com>
 <1516625389-6362-3-git-send-email-kieran.bingham@ideasonboard.com>
 <e42ec168-5aff-8b8b-2307-d57a662dd395@codeaurora.org>
 <5890b343-e908-688b-ba03-84c1f76411f3@ideasonboard.com>
Message-ID: <2484af34-4688-9ac6-f433-1e6ef03a2416@ideasonboard.com>
Date: Wed, 7 Feb 2018 23:40:00 +0000
MIME-Version: 1.0
In-Reply-To: <5890b343-e908-688b-ba03-84c1f76411f3@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Archit,

On 07/02/18 12:33, Kieran Bingham wrote:
> Hi Archit,
> 
> Thank you for your review,
> 

<snip>

>>>       unsigned int val;
>>>       int ret;
>>>   @@ -1153,24 +1151,35 @@ static int adv7511_probe(struct i2c_client *i2c,
>>> const struct i2c_device_id *id)
>>>       if (ret)
>>>           goto uninit_regulators;
>>>   -    regmap_write(adv7511->regmap, ADV7511_REG_EDID_I2C_ADDR, edid_i2c_addr);
>>> -    regmap_write(adv7511->regmap, ADV7511_REG_PACKET_I2C_ADDR,
>>> -             main_i2c_addr - 0xa);
> 
> 
> Packet address here is written as an offset of -0x0a, which gives 0x2f or 0x33 ... ?
> 
> I think these current offsets are platform specific to a specific platform :)

I appear to be using platform specific maths specific to a non-conforming
platform or universe :-)

Sorry for the incorrect assertion here. - I mixed up 8bit and 7bit values.

The offsets are valid (when calculated correctly) - however - as per my reply to
Laurent - I believe the patch which determined the offsets was using the wrong
base :).

Also - due to a hardware issue on the ADV7511 - the Wheat (as the only known
user of two chips on the same bus) will need to be updated to ensure the current
assignments don't conflict.

--
Kieran
