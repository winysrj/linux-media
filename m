Return-path: <linux-media-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:40734
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758291Ab3DBLAo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Apr 2013 07:00:44 -0400
Received: from dhcp-089-099-019-018.chello.nl ([89.99.19.18] helo=dyad.programming.kicks-ass.net)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1UMyxH-00067f-BJ
	for linux-media@vger.kernel.org; Tue, 02 Apr 2013 11:00:43 +0000
Message-ID: <1364900432.18374.24.camel@laptop>
Subject: Re: [PATCH v2 2/3] mutex: add support for reservation style locks,
 v2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	daniel.vetter@ffwll.ch, x86@kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	robclark@gmail.com, tglx@linutronix.de, mingo@elte.hu,
	linux-media@vger.kernel.org
Date: Tue, 02 Apr 2013 13:00:32 +0200
In-Reply-To: <20130228102502.15191.14146.stgit@patser>
References: <20130228102452.15191.22673.stgit@patser>
	 <20130228102502.15191.14146.stgit@patser>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2013-02-28 at 11:25 +0100, Maarten Lankhorst wrote:
> +Reservation type mutexes

> +struct ticket_mutex {

> +extern int __must_check _mutex_reserve_lock(struct ticket_mutex *lock,

That's two different names and two different forms of one (for a total
of 3 variants) for the same scheme.

FAIL...

Also, is there anything in CS literature that comes close to this? I'd
think the DBMS people would have something similar with their
transactional systems. What do they call it?

