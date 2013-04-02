Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:41037 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758411Ab3DBK6G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Apr 2013 06:58:06 -0400
Received: from dhcp-089-099-019-018.chello.nl ([89.99.19.18] helo=dyad.programming.kicks-ass.net)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1UMyuj-0003eD-Im
	for linux-media@vger.kernel.org; Tue, 02 Apr 2013 10:58:05 +0000
Message-ID: <1364900274.18374.21.camel@laptop>
Subject: Re: [PATCH v2 2/3] mutex: add support for reservation style locks,
 v2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	daniel.vetter@ffwll.ch, x86@kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	robclark@gmail.com, tglx@linutronix.de, mingo@elte.hu,
	linux-media@vger.kernel.org
Date: Tue, 02 Apr 2013 12:57:54 +0200
In-Reply-To: <20130228102502.15191.14146.stgit@patser>
References: <20130228102452.15191.22673.stgit@patser>
	 <20130228102502.15191.14146.stgit@patser>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2013-02-28 at 11:25 +0100, Maarten Lankhorst wrote:
> +struct ticket_mutex {
> +       struct mutex base;
> +       atomic_long_t reservation_id;
> +};

I'm not sure this is a good name, esp. due to the potential confusion
vs the ticket spinlocks we have. 

