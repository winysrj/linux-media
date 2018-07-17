Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:55822 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731595AbeGQPeX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 11:34:23 -0400
Reply-To: kieran.bingham+renesas@ideasonboard.com
Subject: Re: [PATCH v4 08/11] media: vsp1: Add support for extended display
 list headers
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org
References: <cover.bd2eb66d11f8094114941107dbc78dc02c9c7fdd.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
 <4341947.2iR8IN8nZS@avalon>
 <9f8d828c-3e44-a62e-a0a7-8631dc3c7baa@ideasonboard.com>
 <3014394.qGWeGfuQTI@avalon>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <98df718c-096d-7bf5-50a3-77bfb07e65a9@ideasonboard.com>
Date: Tue, 17 Jul 2018 16:01:14 +0100
MIME-Version: 1.0
In-Reply-To: <3014394.qGWeGfuQTI@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 17/07/18 11:53, Laurent Pinchart wrote:
> Hi Kieran,
> 
> On Monday, 16 July 2018 20:14:55 EEST Kieran Bingham wrote:
>> On 24/05/18 12:44, Laurent Pinchart wrote:
>>> On Thursday, 3 May 2018 16:36:19 EEST Kieran Bingham wrote:
>>>> Extended display list headers allow pre and post command lists to be
>>>> executed by the VSP pipeline. This provides the base support for
>>>> features such as AUTO_FLD (for interlaced support) and AUTO_DISP (for
>>>> supporting continuous camera preview pipelines.
>>>>
>>>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>>>
>>>> ---
>>>>
>>>> v2:
>>>>  - remove __packed attributes
>>>>
>>>> ---
>>>>
>>>>  drivers/media/platform/vsp1/vsp1.h      |  1 +-
>>>>  drivers/media/platform/vsp1/vsp1_dl.c   | 83 +++++++++++++++++++++++++-
>>>>  drivers/media/platform/vsp1/vsp1_dl.h   | 29 ++++++++-
>>>>  drivers/media/platform/vsp1/vsp1_drv.c  |  7 +-
>>>>  drivers/media/platform/vsp1/vsp1_regs.h |  5 +-
>>>>  5 files changed, 116 insertions(+), 9 deletions(-)
> 
> [snip]
> 
>>>> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c
>>>> b/drivers/media/platform/vsp1/vsp1_dl.c index 56514cd51c51..b64d32535edc
>>>> 100644
>>>> --- a/drivers/media/platform/vsp1/vsp1_dl.c
>>>> +++ b/drivers/media/platform/vsp1/vsp1_dl.c
> 
> [snip]
> 
>>>> +struct vsp1_dl_ext_header {
>>>> +	u32 reserved0;		/* alignment padding */
>>>> +
>>>> +	u16 pre_ext_cmd_qty;
>>>
>>> Should this be called pre_ext_dl_num_cmd to match the datasheet ?
>>
>> Yes, renamed.
>>
>>>> +	u16 flags;
>>>
>>> Aren't the flags supposed to come before the pre_ext_dl_num_cmd field ?
>>
>> These are out-of-order to account for the fact that they are 16bit values.
> 
> Ah OK. It makes sense, but is a bit confusing when reading the datasheet.

Yes, I agree. Realising the byte-ordering was off was a bit of a pain
point when I was testing too :D

> 
>> I felt that keeping them described in the struct was cleaner than shifts
>> and masks - but clearly this stands out, due to the byte-ordering.
>>
>> Would you prefer I re-write this as 32 bit accesses (or even 64bit),
>> with shifts? Or is a comment sufficient here ?
> 
> If it doesn't make the code too ugly, using larger accesses would be better I 
> think. Otherwise a comment would do I suppose.
> 
>> If we rewrite to be 32 bit accesses, would you be happy with the
>> following naming:
>>
>> 	u32 reserved0;
>> 	u32 pre_ext_dl_num_cmd; /* Also stores command flags. */
>> 	u32 pre_ext_dl_plist;
>> 	u32 post_ext_dl_num_cmd;
>> 	u32 post_ext_dl_plist;
>>
>> (Technically the flags are for the whole header, not the just the
>> pre_ext, which is why I wanted it separated)
>>
>>
>> Actually - now I write that - the 'number of commands' is sort of a flag
>> or a parameter? so maybe the following is just as appropriate?:
>>
>> 	u32 reserved0;
> 
> Maybe "u32 zero;" or "u32 padding;" ? The datasheet states this is padding for 
> alignment purpose.

I've used "padding".


> 
>> 	u32 pre_ext_dl_flags;
>> 	u32 pre_ext_dl_plist;
>> 	u32 post_ext_dl_flags;
>> 	u32 post_ext_dl_plist;
>>
>> Or they could be named 'options', or parameters?
>>
>> Any comments before I hack that in?
>>
>> The annoying part is that the 'flags' aren't part of the pre_ext cmds,
>> they declare whether the pre or post cmd should be executed (or both I
>> presume, we are yet to see post-cmd usage)
> 
> I agree with you, having a separate flag field would be nicer, as the flags 
> are shared. I'll chose the easy option of letting you decide what you like 
> best :-) All the above options are equally good to me, provided you add a 
> comment explaining why the flag comes after the num_cmd field if you decide to 
> keep it as a separate field.

I've added a comment to explain why the flags must be after num_cmd. I
feel it's better to keep the flags separated as they are not specific to
the pre_cmd.


> 
>>>> +	u32 pre_ext_cmd_plist;
>>>
>>> And pre_ext_dl_plist ?
>>>
>>>> +
>>>> +	u32 post_ext_cmd_qty;
>>>> +	u32 post_ext_cmd_plist;
>>>
>>> Similar comments for these variables.
>>
>> Renamed.
>>
>>>> +};
>>>> +
>>>> +struct vsp1_dl_header_extended {
>>>> +	struct vsp1_dl_header header;
>>>> +	struct vsp1_dl_ext_header ext;
>>>> +};
>>>> +
>>>>  struct vsp1_dl_entry {
>>>>  	u32 addr;
>>>>  	u32 data;
>>>>  };
>>>>
>>>> +struct vsp1_dl_ext_cmd_header {
>>>
>>> Isn't this referred to in the datasheet as a body entry, not a header ?
>>> How about naming it vsp1_dl_ext_cmd_entry ? Or just vsp1_dl_ext_cmd (in
>>> which case the other structure that goes by the same name would need to be
>>> renamed) ?
>>
>> I think I was getting too creative. The reality is this part is really a
>> 'header' describing the data in the body, but yes - it should be named
>> to match a "Pre Extended Display List Body"
>>
>>   s/vsp1_dl_ext_cmd_header/vsp1_pre_ext_dl_body/
> 
> Sounds good to me.
> 
>> This will then leave "struct vsp1_dl_ext_cmd" which represents the
>> object instance within the VSP1 driver only.
>>
>>>> +	u32 cmd;
>>
>> This should really have been opcode then too :)
> 
> Good point.

Renamed


> 
>>>> +	u32 flags;
>>>> +	u32 data;
>>>> +	u32 reserved;
>>>
>>> The datasheet documents this as two 64-bit fields, shouldn't we handle the
>>> structure the same way ?
>>
>> I was trying to separate out the fields for clarity.
>>
>> In this instance (unlike the 16bit handling above), the byte ordering of
>> a 64 bit value works in our favour, and the ordering of the 4 u32s,
>> follows the order of the datasheet.
>>
>> If you'd prefer to handle them as 64bit with mask and shift, I'll
>> update, and rename this to contain two fields :
>>      u64 ext_dl_cmd;
>>      u64 ext_dl_data;
>>
>> But this is working well with the 32 bit definitions.
> 
> Up to you, I'm OK with both.

Great, in this instance - and because it works cleanly - I prefer the
split, with named field accesses.

I'll add a documenting comment along side it that it is listed as a
64-bit access, but the storage order is the same.

> 
>>>> +};
> 
> [snip]
> 
