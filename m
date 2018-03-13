Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34672 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752274AbeCMLrp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 07:47:45 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH 02/11] media: vsp1: use kernel __packed for structures
To: David Laight <David.Laight@ACULAB.COM>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <cover.50cd35ac550b4477f13fb4f3fbd3ffb6bcccfc8a.1520632434.git-series.kieran.bingham+renesas@ideasonboard.com>
 <767c4c9f6aa4799a58f0979b318208f1d3e27860.1520632434.git-series.kieran.bingham+renesas@ideasonboard.com>
 <b58ff7ec7f7246498325e74b31ba3664@AcuMS.aculab.com>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <8513c264-103f-94c8-cc46-972412d13da5@ideasonboard.com>
Date: Tue, 13 Mar 2018 11:47:39 +0000
MIME-Version: 1.0
In-Reply-To: <b58ff7ec7f7246498325e74b31ba3664@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi David,

On 13/03/18 11:20, David Laight wrote:
> From: Kieran Bingham
>> Sent: 09 March 2018 22:04
>> The kernel provides a __packed definition to abstract away from the
>> compiler specific attributes tag.
>>
>> Convert all packed structures in VSP1 to use it.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>> ---
>>  drivers/media/platform/vsp1/vsp1_dl.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
>> index 37e2c984fbf3..382e45c2054e 100644
>> --- a/drivers/media/platform/vsp1/vsp1_dl.c
>> +++ b/drivers/media/platform/vsp1/vsp1_dl.c
>> @@ -29,19 +29,19 @@
>>  struct vsp1_dl_header_list {
>>  	u32 num_bytes;
>>  	u32 addr;
>> -} __attribute__((__packed__));
>> +} __packed;
>>
>>  struct vsp1_dl_header {
>>  	u32 num_lists;
>>  	struct vsp1_dl_header_list lists[8];
>>  	u32 next_header;
>>  	u32 flags;
>> -} __attribute__((__packed__));
>> +} __packed;
>>
>>  struct vsp1_dl_entry {
>>  	u32 addr;
>>  	u32 data;
>> -} __attribute__((__packed__));
>> +} __packed;
> 
> Do these structures ever actually appear in misaligned memory?
> If they don't then they shouldn't be marked 'packed'.

I believe the declaration is to ensure that the struct definition is not altered
by the compiler as these structures specifically define the layout of how the
memory is read by the VSP1 hardware.

Certainly 2 u32's sequentially stored in a struct are unlikely to be moved or
rearranged by the compiler (though I believe it would be free to do so if it
chose without this attribute), but I think the declaration shows the intent of
the memory structure.

Isn't this a common approach throughout the kernel when dealing with hardware
defined memory structures ?

Regards
--
Kieran


> 
> 	David
> 
