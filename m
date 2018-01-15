Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:45980 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755790AbeAOQGw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Jan 2018 11:06:52 -0500
Received: by mail-lf0-f68.google.com with SMTP id y71so13940521lfd.12
        for <linux-media@vger.kernel.org>; Mon, 15 Jan 2018 08:06:51 -0800 (PST)
Subject: Re: [PATCH v2] vsp1: fix video output on R8A77970
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20171226211424.870595086@cogentembedded.com>
 <2210461.kXqmUypRF2@avalon>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <e79c992b-0448-0f65-9696-634ad4ce43fb@cogentembedded.com>
Date: Mon, 15 Jan 2018 19:06:48 +0300
MIME-Version: 1.0
In-Reply-To: <2210461.kXqmUypRF2@avalon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

On 01/15/2018 03:51 PM, Laurent Pinchart wrote:

> On Tuesday, 26 December 2017 23:14:12 EET Sergei Shtylyov wrote:
>> Laurent has added support for the VSP2-D found on R-Car V3M (R8A77970) but
> 
> I'm not sure there's a need to state my name in the commit message.

    You were the author of the patch this one has in the Fixes: tag, so I 
thought that was appropriate. I can remove that if you don't want you name 
mentioned...

>> the video  output that VSP2-D sends to DU has a greenish garbage-like line
> 
> Why does the text in your patches (commit message, comments, ...) sometime
> have double spaces between words ?

    The text looks more pleasant (at least to me). Can remove them if you want...

>> repeated every 8 or so screen rows.
> 
> Is it every "8 or so" rows, or exactly every 8 rows ?

    You really want me to count the pixels?

>> It turns out that V3M has a teeny LIF register (at least it's documented!)
>> that you need to set to some kind of a  magic value for the LIF to work
>> correctly...
>>
>> Based on the original (and large) patch by Daisuke Matsushita
>> <daisuke.matsushita.ns@hitachi.com>.
> 
> What else is in the big patch ? Is it available somewhere ?

    Assorted changes gathered together only because they all bring the support 
for R8A77970. If you're really curious, here you are:

https://github.com/CogentEmbedded/meta-rcar/blob/v2.12.0/meta-rcar-gen3/recipes-kernel/linux/linux-renesas/0030-arm64-renesas-r8a7797-Add-Renesas-R8A7797-SoC-suppor.patch

>> Fixes: d455b45f8393 ("v4l: vsp1: Add support for new VSP2-BS, VSP2-DL and
>> VSP2-D instances")
>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>>
>> ---
>> This patch is against the 'media_tree.git' repo's 'master' branch.
>>
>> Changes in version 2:
>> - added a  comment before the V3M SoC check;
>> - fixed indetation in that check;
>> - reformatted  the patch description.
>>
>>   drivers/media/platform/vsp1/vsp1_lif.c  |   12 ++++++++++++
>>   drivers/media/platform/vsp1/vsp1_regs.h |    5 +++++
>>   2 files changed, 17 insertions(+)
>>
>> Index: media_tree/drivers/media/platform/vsp1/vsp1_lif.c
>> ===================================================================
>> --- media_tree.orig/drivers/media/platform/vsp1/vsp1_lif.c
>> +++ media_tree/drivers/media/platform/vsp1/vsp1_lif.c
>> @@ -155,6 +155,18 @@ static void lif_configure(struct vsp1_en
>>   			(obth << VI6_LIF_CTRL_OBTH_SHIFT) |
>>   			(format->code == 0 ? VI6_LIF_CTRL_CFMT : 0) |
>>   			VI6_LIF_CTRL_REQSEL | VI6_LIF_CTRL_LIF_EN);
>> +
>> +	/*
>> +	 * R-Car V3M has the buffer attribute register you absolutely need
>> +	 * to write kinda magic value to  for the LIF to work correctly...
>> +	 */
> 
> I'm not sure about the "kinda" magic value. 1536 is very likely a buffer size.

    Well, that's only guessing. The manual doesn't say anything about what the 
number is.

> How about the following text ?
> 
> 	/*
> 	 * On V3M the LBA register has to be set to a non-default value to

    I'd then spell its full name, LIF0 Buffer Attribute register.

> 	 * guarantee proper operation (otherwise artifacts may appear on the
> 	 * output). The value required by the datasheet is not documented but
> 	 * is likely a buffer size or threshold.
> 	 */
 >

    OK,  can change that (modulo the name).

> The commit message should also be updated to feel a bit less magic.

    I'll see about it.

>> +	if ((entity->vsp1->version &
>> +	     (VI6_IP_VERSION_MODEL_MASK | VI6_IP_VERSION_SOC_MASK)) ==
>> +	    (VI6_IP_VERSION_MODEL_VSPD_V3 | VI6_IP_VERSION_SOC_V3M)) {
>> +		vsp1_lif_write(lif, dl, VI6_LIF_LBA,
>> +			       VI6_LIF_LBA_LBA0 |
>> +			       (1536 << VI6_LIF_LBA_LBA1_SHIFT));
>> +	}
>>   }
> 
> The datasheet documents the register as being present on both V3M and M3-W
> (and the test I've just run on H3 shows that the register is present there as
> well). Should we program it on M3-W or leave it to the default value that
> should be what is recommended by the datasheet for that SoC ?

    If the default value matches what's recommended by the manual, then I'd 
leave the register alone. But my task was R8A77970 support only anyway...


[..]

MBR, Sergei
