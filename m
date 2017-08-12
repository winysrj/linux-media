Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:49355 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750761AbdHLJWL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Aug 2017 05:22:11 -0400
Subject: Re: [PATCHv2 0/9] omapdrm: hdmi4: add CEC support
To: Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-media@vger.kernel.org
References: <20170802085408.16204-1-hverkuil@xs4all.nl>
 <bbc92584-71e8-b41e-dd35-5dd0d686cf53@ti.com>
Cc: dri-devel@lists.freedesktop.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2b762160-0b68-d8fc-d4be-82c3dac8acb5@xs4all.nl>
Date: Sat, 12 Aug 2017 11:22:08 +0200
MIME-Version: 1.0
In-Reply-To: <bbc92584-71e8-b41e-dd35-5dd0d686cf53@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/08/17 12:57, Tomi Valkeinen wrote:
> Hi Hans,
> 
> 
> Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
> 
> On 02/08/17 11:53, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> This patch series adds CEC support for the omap4. It is based on
>> the 4.13-rc2 kernel with this patch series applied:
>>
>> http://www.spinics.net/lists/dri-devel/msg143440.html
>>
>> It is virtually identical to the first patch series posted in
>> April:
>>
>> http://www.spinics.net/lists/dri-devel/msg138950.html
>>
>> The only two changes are in the Kconfig due to CEC Kconfig
>> changes in 4.13 (it now selects CEC_CORE instead of depending on
>> CEC_CORE) and a final patch was added adding a lost_hotplug op
>> since for proper CEC support I have to know when the hotplug
>> signal goes away.
>>
>> Tested with my Pandaboard.
> 
> I'm doing some testing with this series on my panda. One issue I see is
> that when I unload the display modules, I get:
> 
> [   75.180206] platform 58006000.encoder: enabled after unload, idling
> [   75.187896] platform 58001000.dispc: enabled after unload, idling
> [   75.198242] platform 58000000.dss: enabled after unload, idling
> 
> So I think something is left enabled, most likely in the HDMI driver. I
> haven't debugged this yet.
> 
> The first time I loaded the modules I also got "operation stopped when
> reading edid", but I haven't seen that since. Possibly not related to
> this series.
> 
> Are there some simple ways to test the CEC? My buildroot fs has
> cec-compliance, cec-ctl and cec-follower commands. Are you familiar with
> those? Can they be used?

I'm very familiar with them since I wrote them :-)

The latest version of those utilities are maintained here:

https://git.linuxtv.org/v4l-utils.git/

But the ones from buildroot should be fine.

To use:

cec-ctl --playback 	# configure the CEC adapter as a playback device
cec-ctl -S 		# Detect and show all CEC devices

Note: all cec utilities use /dev/cec0 as the default device node. Use the
-d option to specify another device node.

So assuming you have the panda connected to a CEC-capable TV you should see
the TV in that list.

You can use cec-compliance to check the CEC compliance of devices:

cec-ctl --playback
cec-follower 		# emulate a CEC playback device follower functionality

In another shell run:

cec-compliance -r0	# Test remote CEC device with logical address 0 (== TV)

Regards,

	Hans
