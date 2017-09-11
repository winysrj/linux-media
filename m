Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39449 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750969AbdIKVPO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 17:15:14 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v2 8/8] v4l: vsp1: Reduce display list body size
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
References: <cover.4457988ad8b64b5c7636e35039ef61d507af3648.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
 <fa078611769415d7adbad208f1299d05bee3bda8.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
 <3704707.T2fvHgbeUE@avalon>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <af16106d-4a56-c022-49cf-8d5e5b143f80@ideasonboard.com>
Date: Mon, 11 Sep 2017 22:15:10 +0100
MIME-Version: 1.0
In-Reply-To: <3704707.T2fvHgbeUE@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17/08/17 17:11, Laurent Pinchart wrote:
> Hi Kieran,
> 
> Thank you for the patch.
> 
> On Monday 14 Aug 2017 16:13:31 Kieran Bingham wrote:
>> The display list originally allocated a body of 256 entries to store all
>> of the register lists required for each frame.
>>
>> This has now been separated into fragments for constant stream setup, and
>> runtime updates.
>>
>> Empirical testing shows that the body0 now uses a maximum of 41
>> registers for each frame, for both DRM and Video API pipelines thus a
>> rounded 64 entries provides a suitable allocation.
> 
> Didn't you mention in patch 7/8 that one of the fragments uses exactly 64 
> entries ? Which one is it, and is there a risk it could use more ? 

No, that referred to the fragments(bodies) which had been attached. This change
refers only to the body0 allocation which has a maximum of 41 entries written.

The fragment and partition allocations which reach 64 entries, are allocated
with room for 128 currently...

< yes, this can be revisited >

>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>> ---
>>  drivers/media/platform/vsp1/vsp1_dl.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c
>> b/drivers/media/platform/vsp1/vsp1_dl.c index 176a258146ac..b3f5eb2f9a4f
>> 100644
>> --- a/drivers/media/platform/vsp1/vsp1_dl.c
>> +++ b/drivers/media/platform/vsp1/vsp1_dl.c
>> @@ -21,7 +21,7 @@
>>  #include "vsp1.h"
>>  #include "vsp1_dl.h"
>>
>> -#define VSP1_DL_NUM_ENTRIES		256
>> +#define VSP1_DL_NUM_ENTRIES		64

This now only defines the size of the body0 which is the defacto list of entries
in a display list.

This too could / should be removed at somepoint I believe, leaving allocations
only where they are needed.
>>  #define VSP1_DLH_INT_ENABLE		(1 << 1)
>>  #define VSP1_DLH_AUTO_START		(1 << 0)
> 
