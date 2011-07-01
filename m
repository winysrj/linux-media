Return-path: <mchehab@pedra>
Received: from arroyo.ext.ti.com ([192.94.94.40]:35071 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756864Ab1GAWuG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2011 18:50:06 -0400
Message-ID: <4E0E4F14.1080007@ti.com>
Date: Fri, 1 Jul 2011 15:49:56 -0700
From: Archit Taneja <a0393947@ti.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL for v3.0] OMAP_VOUT bug fixes and code cleanup
References: <1308771169-10741-1-git-send-email-hvaibhav@ti.com> <4E0E1683.8080002@redhat.com>
In-Reply-To: <4E0E1683.8080002@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Friday 01 July 2011 11:48 AM, Mauro Carvalho Chehab wrote:
> Em 22-06-2011 16:32, hvaibhav@ti.com escreveu:
>> The following changes since commit af0d6a0a3a30946f7df69c764791f1b0643f7cd6:
>>    Linus Torvalds (1):
>>          Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip
>>
>> are available in the git repository at:
>>
>>    git://arago-project.org/git/people/vaibhav/ti-psp-omap-video.git for-linux-media
>>
>
>> Archit Taneja (3):
>>        OMAP_VOUT: CLEANUP: Move generic functions and macros to common files
>>        OMAP_VOUT: CLEANUP: Make rotation related helper functions more descriptive
>>        OMAP_VOUT: Create separate file for VRFB related API's
>
> Those are cleanup patches. NACK for 3.0. Cleanups should be sent to -next kernel (3.1).

The first 2 patches are pre-requisite cleanup patches required for the 
3rd patch. The third patch adds functionality, it prevents the driver 
using VRFB for OMAP4, and forces the use of SDMA buffers.

So the patch set as a whole is not only cleanup, and I guess we could 
push it for 3.0.

Archit

>
>> Vaibhav Hiremath (2):
>>        OMAP_VOUT: Change hardcoded device node number to -1
>>        omap_vout: Added check in reqbuf&  mmap for buf_size allocation
>>
>> Vladimir Pantelic (1):
>>        OMAP_VOUTLIB: Fix wrong resizer calculation
>
> The 3 above patches are ok for 3.0. Added.
>
> Thanks,
> Mauro.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

