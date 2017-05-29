Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:58032 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750846AbdE2R3j (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 May 2017 13:29:39 -0400
Subject: Re: [PATCH v7 00/34] i.MX Media Driver
To: Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk, mchehab@kernel.org,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
References: <1495672189-29164-1-git-send-email-steve_longerbeam@mentor.com>
 <dd82968a-4c0b-12a4-f43b-7e63a255812d@xs4all.nl>
 <85c134d0-80f1-4313-2028-61bdad37903e@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <22f7f479-c319-1358-f209-021f95537d86@xs4all.nl>
Date: Mon, 29 May 2017 19:29:33 +0200
MIME-Version: 1.0
In-Reply-To: <85c134d0-80f1-4313-2028-61bdad37903e@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/29/2017 07:23 PM, Steve Longerbeam wrote:
> Hi Hans, thanks for the reply...
> 
> 
> On 05/29/2017 06:46 AM, Hans Verkuil wrote:
>> Hi Steve,
>>
>> On 05/25/2017 02:29 AM, Steve Longerbeam wrote:
>>> In version 7:
>>>
>>>
>>
>> What is the status as of v7?
>>
>>  From what I can tell patch 2/34 needs an Ack from Rob Herring,
> 
> 
> Yes still missing that Ack. I think the issue is likely the Synopsys DW
> mipi csi-2 bindings. Someone earlier noted that there is another driver
> under devel for this Synopsys core, with another set of bindings.
> But it was determined that in fact this is a different device with a
> different register set.
> 
>   From what I remember of dealing with Synopsys cores in the past,
> these cores are highly configurable using their coreBuilder tools. So
> while the other device might stem from the same initial core from
> Synopsys, it was probably built with different design parameters
> compared to the core that exists in the i.MX6. So in essence it is a
> different device.
> 
> 
>> patches
>> 4-14 are out of scope for the media subsystem,
> 
> Ok. I did submit patches 4-14 to the right set of folks. Should I just
> drop this set in the next submission if they have not changed?

No, please keep them. Just make a note in the cover letter that they go
through a different tree. I like seeing the whole set :-)

>> patches 20-25 and 27-34
>> are all staging (so fine to be merged from my point of view).
>>
>> I'm not sure if patch 26 (defconfig) should be applied while the imx
>> driver is in staging. I would suggest that this patch is moved to the end
>> of the series.
> 
> Ok.
> 
>>
>> That leaves patches 15-19. I replied to patch 15 with a comment, patches
>> 16-18 look good to me, although patches 17 and 18 should be combined
>> to one
>> patch since patch 17 won't compile otherwise. Any idea when the
>> multiplexer is
>> expected to be merged? (just curious)
> 
> Philipp replied separately.
> 
>>
>> I would really like to get this merged for 4.13, so did I miss anything?
>>  From what I can tell it is really just an Ack for patch 2/34.
> 
> Agreed.

Can you split off the TODO file in its own patch? It was buried in the
big patch and I missed it because of that.

Take a look at Sakari's comment from today about another TODO item that
probably should be in the TODO file.

Regards,

	Hans

Regards,

	Hans
