Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42403 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752209AbeCMWeO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 18:34:14 -0400
Subject: Re: [PATCH 02/11] media: vsp1: use kernel __packed for structures
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <cover.50cd35ac550b4477f13fb4f3fbd3ffb6bcccfc8a.1520632434.git-series.kieran.bingham+renesas@ideasonboard.com>
 <767c4c9f6aa4799a58f0979b318208f1d3e27860.1520632434.git-series.kieran.bingham+renesas@ideasonboard.com>
 <b58ff7ec7f7246498325e74b31ba3664@AcuMS.aculab.com>
 <8513c264-103f-94c8-cc46-972412d13da5@ideasonboard.com>
 <554b73e9ee2d43b19ac42ee380b7d160@AcuMS.aculab.com>
 <8ecfb374-e979-a54d-74d9-d65dfbb5c3ef@ideasonboard.com>
Reply-To: kieran.bingham@ideasonboard.com
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <a7a5de70-1042-e819-f3b8-52287348397f@ideasonboard.com>
Date: Tue, 13 Mar 2018 23:34:07 +0100
MIME-Version: 1.0
In-Reply-To: <8ecfb374-e979-a54d-74d9-d65dfbb5c3ef@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi David,

Just for reference here, I've posted a v2 of this patch now titled:
[PATCH v2 02/11] media: vsp1: Remove packed attributes from aligned structures

which removes the attributes instead of modifying them.

Thanks for the pointers!

Regards

Kieran

On 13/03/18 15:03, Kieran Bingham wrote:
> Hi David,
> 
> On 13/03/18 13:38, David Laight wrote:
>> From: Kieran Bingham [mailto:kieran.bingham+renesas@ideasonboard.com]
>>> On 13/03/18 11:20, David Laight wrote:
>>>> From: Kieran Bingham
>>>>> Sent: 09 March 2018 22:04
>>>>> The kernel provides a __packed definition to abstract away from the
>>>>> compiler specific attributes tag.
>>>>>
>>>>> Convert all packed structures in VSP1 to use it.
>>>>>
>>>>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>>>> ---
>>>>>  drivers/media/platform/vsp1/vsp1_dl.c | 6 +++---
>>>>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
>>>>> index 37e2c984fbf3..382e45c2054e 100644
>>>>> --- a/drivers/media/platform/vsp1/vsp1_dl.c
>>>>> +++ b/drivers/media/platform/vsp1/vsp1_dl.c
>>>>> @@ -29,19 +29,19 @@
>>>>>  struct vsp1_dl_header_list {
>>>>>  	u32 num_bytes;
>>>>>  	u32 addr;
>>>>> -} __attribute__((__packed__));
>>>>> +} __packed;
>>>>>
>>>>>  struct vsp1_dl_header {
>>>>>  	u32 num_lists;
>>>>>  	struct vsp1_dl_header_list lists[8];
>>>>>  	u32 next_header;
>>>>>  	u32 flags;
>>>>> -} __attribute__((__packed__));
>>>>> +} __packed;
>>>>>
>>>>>  struct vsp1_dl_entry {
>>>>>  	u32 addr;
>>>>>  	u32 data;
>>>>> -} __attribute__((__packed__));
>>>>> +} __packed;
>>>>
>>>> Do these structures ever actually appear in misaligned memory?
>>>> If they don't then they shouldn't be marked 'packed'.
>>>
>>> I believe the declaration is to ensure that the struct definition is not altered
>>> by the compiler as these structures specifically define the layout of how the
>>> memory is read by the VSP1 hardware.
>>
>> The C language and ABI define structure layouts.
>>
>>> Certainly 2 u32's sequentially stored in a struct are unlikely to be moved or
>>> rearranged by the compiler (though I believe it would be free to do so if it
>>> chose without this attribute), but I think the declaration shows the intent of
>>> the memory structure.
>>
>> The language requires the fields be in order and the ABI stops the compiler
>> adding 'random' padding.
>>
>>> Isn't this a common approach throughout the kernel when dealing with hardware
>>> defined memory structures ?
>>
>> Absolutely not.
>> __packed tells the compiler that the structure might be on any address boundary.
>> On many architectures this means the compiler must use byte accesses with shifts
>> and ors for every access.
>> The most a hardware defined structure will have is a compile-time assert
>> that it is the correct size (to avoid silly errors from changes).
> 
> 
> 
> Ok - interesting, I see what you're saying - and certainly don't want the
> compiler to be performing byte accesses on the structures unnecessarily.
> 
> I'm trying to distinguish the difference here. Is the single point that
>  __packed
> 
> causes byte-access, where as
> 
> __attribute__((__packed__));
> 
> does not?
> 
> Looking at the GCC docs [0]: I see that  __attribute__((__packed__)) tells the
> compiler that the "structure or union is placed to minimize the memory required".
> 
> However, the keil compiler docs[1] do certainly declare that __packed causes
> byte alignment.
> 
> I was confused/thrown off here by the Kernel defining __packed as
> __attribute__((packed)) at [2].
> 
> Do __attribute__((packed)) and __attribute__((__packed__)) differ ?
> 
> In which case, from what I've read so far I wish "__packed" was "__unaligned"...
> 
> 
> [0]
> https://gcc.gnu.org/onlinedocs/gcc/Common-Type-Attributes.html#index-packed-type-attribute
> 
> [1] http://www.keil.com/support/man/docs/armcc/armcc_chr1359124230195.htm
> 
> [2]
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/compiler-gcc.h?h=v4.16-rc5#n92
> 
> 
> Regards
> 
> Kieran
> 
> 
>> 	David
>>
