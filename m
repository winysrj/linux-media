Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:40494 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755390AbeFNOr2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 10:47:28 -0400
Date: Thu, 14 Jun 2018 16:46:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Matthew Wilcox <willy@infradead.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Gustavo Padovan <gustavo@padovan.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        David Airlie <airlied@linux.ie>,
        Davidlohr Bueso <dave@stgolabs.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH v2 1/2] locking: Implement an algorithm choice for
 Wound-Wait mutexes
Message-ID: <20180614144659.GC12198@hirez.programming.kicks-ass.net>
References: <20180614072922.8114-1-thellstrom@vmware.com>
 <20180614072922.8114-2-thellstrom@vmware.com>
 <20180614113604.GZ12198@hirez.programming.kicks-ass.net>
 <7eb10c22-57b3-1472-0a77-7f787f612217@vmware.com>
 <20180614132905.GA7841@bombadil.infradead.org>
 <425f4d5b-d414-de46-f388-55f1e6821ba6@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <425f4d5b-d414-de46-f388-55f1e6821ba6@vmware.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 14, 2018 at 03:43:04PM +0200, Thomas Hellstrom wrote:
> It's intended to be enforced by storing the algorithm choice in the
> WW_MUTEX_CLASS which must be common for an acquire context and the
> ww_mutexes it acquires. However, I don't think there is a check that that
> holds. I guess we could add it as a DEBUG_MUTEX test in ww_mutex_lock().

There is ww_mutex_lock_acquired():

	DEBUG_LOCKS_WARN_ON(ww_ctx->ww_class != ww->ww_class)

which should trigger if you try and be clever.
