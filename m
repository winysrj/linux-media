Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-eopbgr730082.outbound.protection.outlook.com ([40.107.73.82]:26019
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756600AbeFSIZx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Jun 2018 04:25:53 -0400
From: Thomas Hellstrom <thellstrom@vmware.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org
Cc: linux-graphics-maintainer@vmware.com, pv-drivers@vmware.com,
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
Subject: [PATCH v4 0/4] locking,drm: Fix ww mutex naming / algorithm inconsistency
Date: Tue, 19 Jun 2018 10:24:42 +0200
Message-Id: <20180619082445.11062-1-thellstrom@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a small fallout from a work to allow batching WW mutex locks and
unlocks.

Our Wound-Wait mutexes actually don't use the Wound-Wait algorithm but
the Wait-Die algorithm. One could perhaps rename those mutexes tree-wide to
"Wait-Die mutexes" or "Deadlock Avoidance mutexes". Another approach suggested
here is to implement also the "Wound-Wait" algorithm as a per-WW-class
choice, as it has advantages in some cases. See for example

http://www.mathcs.emory.edu/~cheung/Courses/554/Syllabus/8-recv+serial/deadlock-compare.html

Now Wound-Wait is a preemptive algorithm, and the preemption is implemented
using a lazy scheme: If a wounded transaction is about to go to sleep on
a contended WW mutex, we return -EDEADLK. That is sufficient for deadlock
prevention. Since with WW mutexes we also require the aborted transaction to
sleep waiting to lock the WW mutex it was aborted on, this choice also provides
a suitable WW mutex to sleep on. If we were to return -EDEADLK on the first
WW mutex lock after the transaction was wounded whether the WW mutex was
contended or not, the transaction might frequently be restarted without a wait,
which is far from optimal. Note also that with the lazy preemption scheme,
contrary to Wait-Die there will be no rollbacks on lock contention of locks
held by a transaction that has completed its locking sequence.

The modeset locks are then changed from Wait-Die to Wound-Wait since the
typical locking pattern of those locks very well matches the criterion for
a substantial reduction in the number of rollbacks. For reservation objects,
the benefit is more unclear at this point and they remain using Wait-Die.

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: David Airlie <airlied@linux.ie>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Kate Stewart <kstewart@linuxfoundation.org>
Cc: Philippe Ombredanne <pombredanne@nexb.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-doc@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: linaro-mm-sig@lists.linaro.org

v2:
  Updated DEFINE_WW_CLASS() API, minor code- and comment fixes as
  detailed in each patch.
v3:
  Included cleanup patch from Peter Zijlstra. Documentation fixes and
  a small correctness fix.
v4:
  Reworked the correctness fix.
