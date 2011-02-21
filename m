Return-path: <mchehab@pedra>
Received: from xenotime.net ([184.105.210.51]:38064 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755154Ab1BUQoG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Feb 2011 11:44:06 -0500
Received: from chimera.site ([173.50.240.230]) by xenotime.net for <linux-media@vger.kernel.org>; Mon, 21 Feb 2011 08:33:59 -0800
Date: Mon, 21 Feb 2011 08:33:58 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: David Cohen <dacohen@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
	linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 0/1] Fix linux/wait.h header file
Message-Id: <20110221083358.3a941b4e.rdunlap@xenotime.net>
In-Reply-To: <1298299131-17695-1-git-send-email-dacohen@gmail.com>
References: <1298299131-17695-1-git-send-email-dacohen@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 21 Feb 2011 16:38:50 +0200 David Cohen wrote:

> Hi,
> 
> OMAP2 camera driver compilation is broken due to problems on linux/wait.h header
> file:
> 
> drivers/media/video/omap24xxcam.c: In function 'omap24xxcam_vbq_complete':
> drivers/media/video/omap24xxcam.c:414: error: 'TASK_NORMAL' undeclared (first use in this function)
> drivers/media/video/omap24xxcam.c:414: error: (Each undeclared identifier is reported only once
> drivers/media/video/omap24xxcam.c:414: error: for each function it appears in.)
> make[3]: *** [drivers/media/video/omap24xxcam.o] Error 1
> make[2]: *** [drivers/media/video] Error 2
> make[1]: *** [drivers/media] Error 2
> make: *** [drivers] Error 2
> 
> This file defines macros wake_up*() which use TASK_* defined on linux/sched.h.
> But sched.h cannot be included on wait.h due to a circular dependency between
> both files. This patch fixes such compilation and the circular dependency
> problem.
> 
> Br,
> 
> David
> ---
> 
> David Cohen (1):
>   headers: fix circular dependency between linux/sched.h and
>     linux/wait.h
> 
>  include/linux/sched.h      |   58 +-----------------------------------------
>  include/linux/task_state.h |   61 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/wait.h       |    1 +
>  3 files changed, 63 insertions(+), 57 deletions(-)
>  create mode 100644 include/linux/task_state.h
> 
> -- 

and please drop patch 0/1.  All of this info can be included in patch 1/1,
either above the first "---" line (for commit info) or after it (for
background info).

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
