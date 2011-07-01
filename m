Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:19327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274Ab1GASsj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2011 14:48:39 -0400
Message-ID: <4E0E1683.8080002@redhat.com>
Date: Fri, 01 Jul 2011 15:48:35 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: hvaibhav@ti.com
CC: linux-media@vger.kernel.org
Subject: Re: [GIT PULL for v3.0] OMAP_VOUT bug fixes and code cleanup
References: <1308771169-10741-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <1308771169-10741-1-git-send-email-hvaibhav@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 22-06-2011 16:32, hvaibhav@ti.com escreveu:
> The following changes since commit af0d6a0a3a30946f7df69c764791f1b0643f7cd6:
>   Linus Torvalds (1):
>         Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip
> 
> are available in the git repository at:
> 
>   git://arago-project.org/git/people/vaibhav/ti-psp-omap-video.git for-linux-media
> 

> Archit Taneja (3):
>       OMAP_VOUT: CLEANUP: Move generic functions and macros to common files
>       OMAP_VOUT: CLEANUP: Make rotation related helper functions more descriptive
>       OMAP_VOUT: Create separate file for VRFB related API's

Those are cleanup patches. NACK for 3.0. Cleanups should be sent to -next kernel (3.1).

> Vaibhav Hiremath (2):
>       OMAP_VOUT: Change hardcoded device node number to -1
>       omap_vout: Added check in reqbuf & mmap for buf_size allocation
> 
> Vladimir Pantelic (1):
>       OMAP_VOUTLIB: Fix wrong resizer calculation

The 3 above patches are ok for 3.0. Added.

Thanks,
Mauro.
