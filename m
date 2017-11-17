Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57045 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933397AbdKQNka (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 08:40:30 -0500
Subject: Re: [PATCH v2 6/8] v4l: vsp1: Adapt entities to configure into a body
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
References: <cover.4457988ad8b64b5c7636e35039ef61d507af3648.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
 <1807083.ZJnR2iqIOD@avalon>
 <112c0f66-4918-40d0-d2dd-17f9bbd03f12@ideasonboard.com>
 <4353515.cR2bnzc1Fq@avalon>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <6dffaedc-75b4-f817-d91c-304f7cd54f1f@ideasonboard.com>
Date: Fri, 17 Nov 2017 13:40:26 +0000
MIME-Version: 1.0
In-Reply-To: <4353515.cR2bnzc1Fq@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 12/09/17 20:18, Laurent Pinchart wrote:
> Hi Kieran,
> 
> On Tuesday, 12 September 2017 00:42:09 EEST Kieran Bingham wrote:
>> On 17/08/17 18:58, Laurent Pinchart wrote:
>>> On Monday 14 Aug 2017 16:13:29 Kieran Bingham wrote:
>>>> Currently the entities store their configurations into a display list.
>>>> Adapt this such that the code can be configured into a body fragment
>>>> directly, allowing greater flexibility and control of the content.
>>>>
>>>> All users of vsp1_dl_list_write() are removed in this process, thus it
>>>> too is removed.
>>>>
>>>> A helper, vsp1_dl_list_body() is provided to access the internal body0
>>>> from the display list.
>>>>
>>>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>>> ---
>>>>
>>>>  drivers/media/platform/vsp1/vsp1_bru.c    | 22 ++++++------
>>>>  drivers/media/platform/vsp1/vsp1_clu.c    | 22 ++++++------
>>>>  drivers/media/platform/vsp1/vsp1_dl.c     | 12 ++-----
>>>>  drivers/media/platform/vsp1/vsp1_dl.h     |  2 +-
>>>>  drivers/media/platform/vsp1/vsp1_drm.c    | 14 +++++---
>>>>  drivers/media/platform/vsp1/vsp1_entity.c | 16 ++++-----
>>>>  drivers/media/platform/vsp1/vsp1_entity.h | 12 ++++---
>>>>  drivers/media/platform/vsp1/vsp1_hgo.c    | 16 ++++-----
>>>>  drivers/media/platform/vsp1/vsp1_hgt.c    | 18 +++++-----
>>>>  drivers/media/platform/vsp1/vsp1_hsit.c   | 10 +++---
>>>>  drivers/media/platform/vsp1/vsp1_lif.c    | 13 +++----
>>>>  drivers/media/platform/vsp1/vsp1_lut.c    | 21 ++++++------
>>>>  drivers/media/platform/vsp1/vsp1_pipe.c   |  4 +-
>>>>  drivers/media/platform/vsp1/vsp1_pipe.h   |  3 +-
>>>>  drivers/media/platform/vsp1/vsp1_rpf.c    | 43 +++++++++++-------------
>>>>  drivers/media/platform/vsp1/vsp1_sru.c    | 14 ++++----
>>>>  drivers/media/platform/vsp1/vsp1_uds.c    | 24 +++++++------
>>>>  drivers/media/platform/vsp1/vsp1_uds.h    |  2 +-
>>>>  drivers/media/platform/vsp1/vsp1_video.c  | 11 ++++--
>>>>  drivers/media/platform/vsp1/vsp1_wpf.c    | 42 ++++++++++++-----------
>>>>  20 files changed, 168 insertions(+), 153 deletions(-)
>>>
>>> This is quite intrusive, and it bothers me slightly that we need to pass
>>> both the DL and the DLB to the configure function in order to add
>>> fragments to the DL in the CLU and LUT modules. Wouldn't it be simpler to
>>> add a pointer to the current body in the DL structure, and modify
>>> vsp1_dl_list_write() to write to the current fragment ?
>>
>> No doubt about it, 168+, 153- is certainly intrusive.
>>
>> Yes, now I'm looking back at this, I think this does look like this part is
>> not quite the right approach.
>>
>> Which otherwise stalls the series until I have time to reconsider. I will
>> likely repost the work I have done on the earlier patches, including the
>> 's/fragment/body/g' changes and ready myself for a v4 which will contain the
>> heavier reworks.
> 
> Fine with me. Could you make sure to mention the open issues in the cover 
> letter ? I want to avoid commenting on them if you know already that you will 
> rework them later.

I've been trying to tackle this today, but I think I've come up a bit stuck on a
key part.

The reason for this patch, is to allow the functions to configure directly into
a display list body, even when that body *is not part* of a display list.

So - converting vsp1_dl_list_write() to configure into the 'current' body (was
fragment) of a display list would not work for writing to the cached objects -
which do not have a display list. They are simply body objects.

It seems a bit extraneous to create holding display lists to contain a single
body, when the display list itself will never be used, but I can't think of an
alternative.

Would you prefer this 'container display list' approach? or do you have another
idea?

--
Regards

Kieran
