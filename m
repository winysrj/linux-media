Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway32.websitewelcome.com ([192.185.145.108]:41164 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932175AbeDWTLF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 15:11:05 -0400
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id 100BF428699
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2018 14:11:05 -0500 (CDT)
Subject: Re: [PATCH 01/11] media: tm6000: fix potential Spectre variant 1
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1524499368.git.gustavo@embeddedor.com>
 <3d4973141e218fb516422d3d831742d55aaa5c04.1524499368.git.gustavo@embeddedor.com>
 <20180423152455.363d285c@vento.lan>
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <3ab9c4c9-0656-a08e-740e-394e2e509ae9@embeddedor.com>
Date: Mon, 23 Apr 2018 14:11:02 -0500
MIME-Version: 1.0
In-Reply-To: <20180423152455.363d285c@vento.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 04/23/2018 01:24 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 23 Apr 2018 12:38:03 -0500
> "Gustavo A. R. Silva" <gustavo@embeddedor.com> escreveu:
> 
>> f->index can be controlled by user-space, hence leading to a
>> potential exploitation of the Spectre variant 1 vulnerability.
>>
>> Smatch warning:
>> drivers/media/usb/tm6000/tm6000-video.c:879 vidioc_enum_fmt_vid_cap() warn: potential spectre issue 'format'
>>
>> Fix this by sanitizing f->index before using it to index
>> array _format_
>>
>> Notice that given that speculation windows are large, the policy is
>> to kill the speculation on the first load and not worry if it can be
>> completed with a dependent load/store [1].
>>
>> [1] https://marc.info/?l=linux-kernel&m=152449131114778&w=2
>>
>> Cc: stable@vger.kernel.org
>> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>> ---
>>   drivers/media/usb/tm6000/tm6000-video.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
>> index b2399d4..d701027 100644
>> --- a/drivers/media/usb/tm6000/tm6000-video.c
>> +++ b/drivers/media/usb/tm6000/tm6000-video.c
>> @@ -26,6 +26,7 @@
>>   #include <linux/kthread.h>
>>   #include <linux/highmem.h>
>>   #include <linux/freezer.h>
>> +#include <linux/nospec.h>
>>   
>>   #include "tm6000-regs.h"
>>   #include "tm6000.h"
>> @@ -875,6 +876,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
>>   	if (f->index >= ARRAY_SIZE(format))
>>   		return -EINVAL;
>>   
>> +	f->index = array_index_nospec(f->index, ARRAY_SIZE(format));
> 
> Please enlighten me: how do you think this could be exploited?
> 
> When an application calls VIDIOC_ENUM_FMT from a /dev/video0 device,
> it will just enumerate a hardware functionality, with is constant
> for a given hardware piece.
> 
> The way it works is that userspace do something like:
> 
> 	int ret = 0;
> 
> 	for (i = 0; ret == 0; i++) {
> 		ret = ioctl(VIDIOC_ENUM_FMT, ...);
> 	}
> 
> in order to read an entire const table.
> 
> Usually, it doesn't require any special privilege to call this ioctl,
> but, even if someone changes its permission to 0x400, a simple lsusb
> output is enough to know what hardware model is there. A lsmod
> or cat /proc/modules) also tells that the tm6000 module was loaded,
> with is a very good hint that the tm6000 is there or was there in the
> past.
> 
> In the specific case of tm6000, all hardware supports exactly the
> same formats, as this is usually defined per-driver. So, a quick look
> at the driver is enough to know exactly what the ioctl would answer.
> Also, the net is full of other resources that would allow anyone
> to get the supported formats for a piece of hardware.
> 
> Even assuming that the OS doesn't have lsusb, that /proc is not
> mounted, that /dev/video0 require special permissions, that the
> potential attacker doesn't have physical access to the equipment (in
> order to see if an USB board is plugged), etc... What possible harm
> he could do by identifying a hardware feature?
> 
> Similar notes for the other patches to drivers/media in this
> series: let's not just start adding bloatware where not needed.
> 
> Please notice that I'm fine if you want to submit potential
> Spectre variant 1 fixups, but if you're willing to do so,
> please provide an explanation about the potential threat scenarios
> that you're identifying at the code.
> 
> Dan,
> 
> It probably makes sense to have somewhere at smatch a place where
> we could explicitly mark the false-positives, in order to avoid
> use to receive patches that would just add an extra delay where
> it is not needed.
> 
I see I've missed some obvious things that you've pointed out here. I'll 
mark these warnings as False Positives and take your points into account 
for the analysis of the rest of the Spectre issues reported by Smatch.

Sorry for the noise and thanks for the feedback.

Thanks
--
Gustavo
