Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:39964 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760574Ab3DBK42 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Apr 2013 06:56:28 -0400
Received: from dhcp-089-099-019-018.chello.nl ([89.99.19.18] helo=dyad.programming.kicks-ass.net)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1UMyt9-0003JY-86
	for linux-media@vger.kernel.org; Tue, 02 Apr 2013 10:56:27 +0000
Message-ID: <1364900174.18374.19.camel@laptop>
Subject: Re: [PATCH v2 2/3] mutex: add support for reservation style locks,
 v2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	daniel.vetter@ffwll.ch, x86@kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	robclark@gmail.com, tglx@linutronix.de, mingo@elte.hu,
	linux-media@vger.kernel.org
Date: Tue, 02 Apr 2013 12:56:14 +0200
In-Reply-To: <20130228102502.15191.14146.stgit@patser>
References: <20130228102452.15191.22673.stgit@patser>
	 <20130228102502.15191.14146.stgit@patser>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2013-02-28 at 11:25 +0100, Maarten Lankhorst wrote:
> +mutex_reserve_lock_slow and mutex_reserve_lock_intr_slow:
> +  Similar to mutex_reserve_lock, except it won't backoff with
> -EAGAIN.
> +  This is useful when mutex_reserve_lock failed with -EAGAIN, and you
> +  unreserved all reservation_locks so no deadlock can occur.
> +

I don't particularly like these function names, with lock
implementations the _slow post-fix is typically used for slow path
implementations, not API type interfaces.



