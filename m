Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:35532 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937535AbeFSJpv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Jun 2018 05:45:51 -0400
Date: Tue, 19 Jun 2018 11:45:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-graphics-maintainer@vmware.com, pv-drivers@vmware.com,
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
Subject: Re: [PATCH v4 2/3] locking: Implement an algorithm choice for
 Wound-Wait mutexes
Message-ID: <20180619094500.GL2458@hirez.programming.kicks-ass.net>
References: <20180619082445.11062-1-thellstrom@vmware.com>
 <20180619082445.11062-3-thellstrom@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180619082445.11062-3-thellstrom@vmware.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 19, 2018 at 10:24:44AM +0200, Thomas Hellstrom wrote:
> The current Wound-Wait mutex algorithm is actually not Wound-Wait but
> Wait-Die. Implement also Wound-Wait as a per-ww-class choice. Wound-Wait
> is, contrary to Wait-Die a preemptive algorithm and is known to generate
> fewer backoffs. Testing reveals that this is true if the
> number of simultaneous contending transactions is small.
> As the number of simultaneous contending threads increases, Wait-Wound
> becomes inferior to Wait-Die in terms of elapsed time.
> Possibly due to the larger number of held locks of sleeping transactions.
> 
> Update documentation and callers.
> 
> Timings using git://people.freedesktop.org/~thomash/ww_mutex_test
> tag patch-18-06-15
> 
> Each thread runs 100000 batches of lock / unlock 800 ww mutexes randomly
> chosen out of 100000. Four core Intel x86_64:
> 
> Algorithm    #threads       Rollbacks  time
> Wound-Wait   4              ~100       ~17s.
> Wait-Die     4              ~150000    ~19s.
> Wound-Wait   16             ~360000    ~109s.
> Wait-Die     16             ~450000    ~82s.
> 
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Gustavo Padovan <gustavo@padovan.org>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Sean Paul <seanpaul@chromium.org>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Davidlohr Bueso <dave@stgolabs.net>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Kate Stewart <kstewart@linuxfoundation.org>
> Cc: Philippe Ombredanne <pombredanne@nexb.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-doc@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: linaro-mm-sig@lists.linaro.org
> Co-authored-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
> 
> ---
>  Documentation/locking/ww-mutex-design.txt |  57 +++++++++--
>  drivers/dma-buf/reservation.c             |   2 +-
>  drivers/gpu/drm/drm_modeset_lock.c        |   2 +-
>  include/linux/ww_mutex.h                  |  17 ++-
>  kernel/locking/locktorture.c              |   2 +-
>  kernel/locking/mutex.c                    | 165 +++++++++++++++++++++++++++---
>  kernel/locking/test-ww_mutex.c            |   2 +-
>  lib/locking-selftest.c                    |   2 +-
>  8 files changed, 213 insertions(+), 36 deletions(-)

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
