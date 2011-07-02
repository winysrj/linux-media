Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:47045 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab1GBBbq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2011 21:31:46 -0400
Message-ID: <4E0E74F7.5000209@ti.com>
Date: Fri, 1 Jul 2011 18:31:35 -0700
From: Archit Taneja <a0393947@ti.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "Taneja, Archit" <archit@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL for v3.0] OMAP_VOUT bug fixes and code cleanup
References: <1308771169-10741-1-git-send-email-hvaibhav@ti.com> <4E0E1683.8080002@redhat.com> <4E0E4F14.1080007@ti.com> <4E0E5BF8.8000707@redhat.com>
In-Reply-To: <4E0E5BF8.8000707@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Friday 01 July 2011 04:44 PM, Mauro Carvalho Chehab wrote:
> Em 01-07-2011 19:49, Archit Taneja escreveu:
>> Hi,
>>
>> On Friday 01 July 2011 11:48 AM, Mauro Carvalho Chehab wrote:
>>> Em 22-06-2011 16:32, hvaibhav@ti.com escreveu:
>>>> The following changes since commit af0d6a0a3a30946f7df69c764791f1b0643f7cd6:
>>>>     Linus Torvalds (1):
>>>>           Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip
>>>>
>>>> are available in the git repository at:
>>>>
>>>>     git://arago-project.org/git/people/vaibhav/ti-psp-omap-video.git for-linux-media
>>>>
>>>
>>>> Archit Taneja (3):
>>>>         OMAP_VOUT: CLEANUP: Move generic functions and macros to common files
>>>>         OMAP_VOUT: CLEANUP: Make rotation related helper functions more descriptive
>>>>         OMAP_VOUT: Create separate file for VRFB related API's
>>>
>>> Those are cleanup patches. NACK for 3.0. Cleanups should be sent to -next kernel (3.1).
>>
>> The first 2 patches are pre-requisite cleanup patches required for the 3rd patch. The third patch adds functionality, it prevents the driver using VRFB for OMAP4, and forces the use of SDMA buffers.
>>
>> So the patch set as a whole is not only cleanup, and I guess we could push it for 3.0.
>
> Patches that add new functionalities shold also be delayed to -next. Only bug fixes
> are allowed during the -rc cycle. Even patch 3 were a fix, you would need to rebase
> it to not depend on the cleanups, for it to be accepted on a -rc kernel.

Okay, I get it now. I'll ask Vaibhav to queue this for the -next kernel.

Thanks,
Archit
