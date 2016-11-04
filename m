Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:43318 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758706AbcKDIJS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Nov 2016 04:09:18 -0400
Subject: Re: [PATCH 3/3] [media] au0828-video: Move two assignments in
 au0828_init_isoc()
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        linux-media@vger.kernel.org
References: <c6a37822-c0f9-1f1e-6ebe-a1c88c6d9d0a@users.sourceforge.net>
 <1ab6b168-3c69-97c2-d02e-cd64b7fa222f@users.sourceforge.net>
 <4e6e77af-1b2c-33a6-1bc3-058ac5ecc038@xs4all.nl>
 <65b399e5-8c18-45a4-643d-527dd3bbff3d@users.sourceforge.net>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?Q?Rafael_Louren=c3=a7o_de_Lima_Chehab?=
        <chehabrafael@gmail.com>, Shuah Khan <shuah@kernel.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <82833c3a-0af0-a427-0e99-78ca5a6e9f68@xs4all.nl>
Date: Fri, 4 Nov 2016 09:09:15 +0100
MIME-Version: 1.0
In-Reply-To: <65b399e5-8c18-45a4-643d-527dd3bbff3d@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/11/16 20:56, SF Markus Elfring wrote:
>>> From: Markus Elfring <elfring@users.sourceforge.net>
>>> Date: Mon, 24 Oct 2016 22:44:02 +0200
>>>
>>> Move the assignment for the data structure members "isoc_copy"
>>> and "num_bufs" behind the source code for memory allocations
>>> by this function.
>>
>> I don't see the point,
>
> Another explanation try …
>
>
>> dropping this patch.
>
> I proposed that these assignments should only be performed after the required
> memory allocations succeeded. Is this detail worth for further considerations?

I understand why you think it is better, but I disagree :-) I prefer the 
current
approach, that way I know as a reviewer that these fields are correctly 
set and
I can forget about them. Not worth spending more time on this.

Regards,

	Hans

>
>
>>> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
>>> ---
>>>  drivers/media/usb/au0828/au0828-video.c | 5 ++---
>>>  1 file changed, 2 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
>>> index b5c88a7..5ebda64 100644
>>> --- a/drivers/media/usb/au0828/au0828-video.c
>>> +++ b/drivers/media/usb/au0828/au0828-video.c
>>> @@ -218,9 +218,6 @@ static int au0828_init_isoc(struct au0828_dev *dev, int max_packets,
>>>      int rc;
>>>
>>>      au0828_isocdbg("au0828: called au0828_prepare_isoc\n");
>>> -
>>> -    dev->isoc_ctl.isoc_copy = isoc_copy;
>>> -    dev->isoc_ctl.num_bufs = num_bufs;
>>>      dev->isoc_ctl.urb = kcalloc(num_bufs,
>>>                      sizeof(*dev->isoc_ctl.urb),
>>>                      GFP_KERNEL);
>>> @@ -240,6 +237,7 @@ static int au0828_init_isoc(struct au0828_dev *dev, int max_packets,
>>>      dev->isoc_ctl.buf = NULL;
>>>
>>>      sb_size = max_packets * dev->isoc_ctl.max_pkt_size;
>>> +    dev->isoc_ctl.num_bufs = num_bufs;
>>>
>>>      /* allocate urbs and transfer buffers */
>>>      for (i = 0; i < dev->isoc_ctl.num_bufs; i++) {
>>> @@ -276,6 +274,7 @@ static int au0828_init_isoc(struct au0828_dev *dev, int max_packets,
>>>              k += dev->isoc_ctl.max_pkt_size;
>>>          }
>>>      }
>>> +    dev->isoc_ctl.isoc_copy = isoc_copy;
>>>
>>>      /* submit urbs and enables IRQ */
>>>      for (i = 0; i < dev->isoc_ctl.num_bufs; i++) {
>>>
>
