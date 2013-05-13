Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:57791 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab3EMLlH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 07:41:07 -0400
Message-ID: <5190D14A.7050904@canonical.com>
Date: Mon, 13 May 2013 13:40:58 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
MIME-Version: 1.0
To: Inki Dae <inki.dae@samsung.com>
CC: 'Rob Clark' <robdclark@gmail.com>,
	'Daniel Vetter' <daniel@ffwll.ch>,
	'DRI mailing list' <dri-devel@lists.freedesktop.org>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	'linux-fbdev' <linux-fbdev@vger.kernel.org>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	"'myungjoo.ham'" <myungjoo.ham@samsung.com>,
	'YoungJun Cho' <yj44.cho@samsung.com>
Subject: Re: Introduce a new helper framework for buffer synchronization
References: <CAAQKjZNNw4qddo6bE5OY_CahrqDtqkxdO7Pm9RCguXyj9F4cMQ@mail.gmail.com> <51909DB4.2060208@canonical.com> <025201ce4fbb$363d0390$a2b70ab0$%dae@samsung.com> <5190B7D8.3010803@canonical.com> <027a01ce4fcc$5e7c7320$1b755960$%dae@samsung.com>
In-Reply-To: <027a01ce4fcc$5e7c7320$1b755960$%dae@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Op 13-05-13 13:24, Inki Dae schreef:
>> and can be solved with userspace locking primitives. No need for the
>> kernel to get involved.
>>
> Yes, that is how we have synchronized buffer between CPU and DMA device
> until now without buffer synchronization mechanism. I thought that it's best
> to make user not considering anything: user can access a buffer regardless
> of any DMA device controlling and the buffer synchronization is performed in
> kernel level. Moreover, I think we could optimize graphics and multimedia
> hardware performance because hardware can do more works: one thread accesses
> a shared buffer and the other controls DMA device with the shared buffer in
> parallel. Thus, we could avoid sequential processing and that is my
> intention. Aren't you think about that we could improve hardware utilization
> with such way or other? of course, there could be better way.
>
If you don't want to block the hardware the only option is to allocate a temp bo and blit to/from it using the hardware.
OpenGL already does that when you want to read back, because otherwise the entire pipeline can get stalled.
The overhead of command submission for that shouldn't be high, if it is you should really try to optimize that first
before coming up with this crazy scheme.

In that case you still wouldn't give userspace control over the fences. I don't see any way that can end well.
What if userspace never signals? What if userspace gets killed by oom killer. Who keeps track of that?

~Maarten
