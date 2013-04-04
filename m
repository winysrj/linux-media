Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:38042 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763488Ab3DDQ7L (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Apr 2013 12:59:11 -0400
Received: by mail-ie0-f169.google.com with SMTP id qd14so3287724ieb.14
        for <linux-media@vger.kernel.org>; Thu, 04 Apr 2013 09:59:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365093516.2609.109.camel@laptop>
References: <20130228102452.15191.22673.stgit@patser>
	<20130228102502.15191.14146.stgit@patser>
	<1364900432.18374.24.camel@laptop>
	<515AF1C1.7080508@canonical.com>
	<1364921954.20640.22.camel@laptop>
	<1365076908.2609.94.camel@laptop>
	<20130404133123.GW2228@phenom.ffwll.local>
	<1365093516.2609.109.camel@laptop>
Date: Thu, 4 Apr 2013 18:59:10 +0200
Message-ID: <CAKMK7uEV=Q4hnzfbQbDqRPqpcrzG=4B=knPk26Lfkenv+mmQ+Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mutex: add support for reservation style locks, v2
From: Daniel Vetter <daniel@ffwll.ch>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	linux-arch@vger.kernel.org, x86@kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	rob clark <robclark@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 4, 2013 at 6:38 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2013-04-04 at 15:31 +0200, Daniel Vetter wrote:
>> Hm, I guess your aim with the TASK_DEADLOCK wakeup is to bound the
>> wait
>> times of older task.
>
> No, imagine the following:
>
> struct ww_mutex A, B;
> struct mutex C;
>
>         task-O  task-Y  task-X
>                 A
>                 B
>                         C
>                 C
>         B
>
> At this point O finds that Y owns B and thus we want to make Y 'yield'
> B to make allow B progress. Since Y is blocked, we'll send a wakeup.
> However Y is blocked on a different locking primitive; one that doesn't
> collaborate in the -EDEADLK scheme therefore we don't want the wakeup to
> succeed.

Yeah, I've thought about this some more and the special sleep state
seems to be only required to ensure we don't cause spurious wakeups
for other any other reasons a task blocks. But I think we can use that
kick-current-holder approach to ensure that older tasks get the lock
in a more timely fashion than the current code. I've tried to detail
it a bit with another 3 task example - that seems to be the point
where the fun starts ;-)
-Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
