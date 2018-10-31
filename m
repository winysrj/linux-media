Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:38416 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727436AbeJaS5v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Oct 2018 14:57:51 -0400
Subject: Re: [PATCH 4/4] SoC camera: Tidy the header
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org
References: <20181029230029.14630-1-sakari.ailus@linux.intel.com>
 <20181029230029.14630-5-sakari.ailus@linux.intel.com>
 <20181030090618.2a62d2d4@coco.lan>
 <20181031092945.csl5vifvstd5ds5g@paasikivi.fi.intel.com>
 <20181031064030.35cd5f8d@coco.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b0ca8b6c-ca15-dc42-2425-fef60249c280@xs4all.nl>
Date: Wed, 31 Oct 2018 11:00:22 +0100
MIME-Version: 1.0
In-Reply-To: <20181031064030.35cd5f8d@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/31/2018 10:40 AM, Mauro Carvalho Chehab wrote:
> Em Wed, 31 Oct 2018 11:29:45 +0200
> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> 
>> Hi Mauro,
>>
>> On Tue, Oct 30, 2018 at 09:06:18AM -0300, Mauro Carvalho Chehab wrote:
>>> Em Tue, 30 Oct 2018 01:00:29 +0200
>>> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
>>>   
>>>> Clean up the SoC camera framework header. It only exists now to keep board
>>>> code compiling. The header can be removed once the board code dependencies
>>>> to it has been removed.
>>>>
>>>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>>>> ---
>>>>  include/media/soc_camera.h | 335 ---------------------------------------------
>>>>  1 file changed, 335 deletions(-)
>>>>
>>>> diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
>>>> index b7e42a1b0910..14d19da6052a 100644
>>>> --- a/include/media/soc_camera.h
>>>> +++ b/include/media/soc_camera.h
>>>> @@ -22,172 +22,6 @@
>>>>  #include <media/v4l2-ctrls.h>
>>>>  #include <media/v4l2-device.h>  
>>>
>>> That doesn't make any sense. soc_camera.h should have the same fate
>>> as the entire soc_camera infrastructure: either be removed or moved
>>> to staging, and everything else that doesn't have the same fate
>>> should get rid of this header.  
>>
>> We can't just remove this; there is board code that depends on it.
>>
>> The intent is to remove the board code as well but presuming that the board
>> code would be merged through a different tree, it'd be less hassle to wait
>> a bit; hence the patch removing any unnecessary stuff here.
> 
> Then we need *first* to remove board code, wait for those changes to be
> applied and *then* remove soc_camera (and not the opposite).

Please note that the camera support for all the remaining boards using
soc_camera has been dead for years. The soc_camera drivers that they depended
on have been removed a long time ago.

So all they depend on are the header. We can safely remove soc_camera without
loss of functionality (and thus prevent others from basing new drivers on
soc_camera), while we work to update the board files so we can remove this last
header.

I have modified some board files here:

https://git.linuxtv.org/hverkuil/media_tree.git/commit/?h=rm-soc-camera&id=d7ae2fcf6e447022f0780bb86a2b63d5c7cf4d35

Only arch/arm/mach-imx/mach-imx27_visstrim_m10.c hasn't been fixed yet in that
patch (ENOTIME).

The problem is just lack of time to clean this up and figure out who should
take these board patches.

So I think it is a nice solution to just replace the header with a dummy version
so the board files still compile, and then we can delete the dead soc_camera
driver. It's probably easier as well to push through the board file changes once
soc_camera is removed since you can just point out that the framework it depended
on is gone.

Regards,

	Hans
