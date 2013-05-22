Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:40197 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab3EVLhs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 May 2013 07:37:48 -0400
Date: Wed, 22 May 2013 13:37:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	x86@kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, robclark@gmail.com,
	rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu,
	linux-media@vger.kernel.org, Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH v3 2/3] mutex: add support for wound/wait style locks, v3
Message-ID: <20130522113736.GO18810@twins.programming.kicks-ass.net>
References: <20130428165914.17075.57751.stgit@patser>
 <20130428170407.17075.80082.stgit@patser>
 <20130430191422.GA5763@phenom.ffwll.local>
 <519CA976.9000109@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519CA976.9000109@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Are there any issues left? I included the patch you wrote for injecting -EDEADLK too
> in my tree. The overwhelming silence makes me think there are either none, or
> nobody cared enough to review it. :(

It didn't manage to reach my inbox it seems,.. I can only find a debug
patch in this thread.
