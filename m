Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56026 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755270AbeFSJou (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Jun 2018 05:44:50 -0400
Date: Tue, 19 Jun 2018 11:44:09 +0200
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
Subject: Re: [PATCH 1/3] locking: WW mutex cleanup
Message-ID: <20180619094409.GK2458@hirez.programming.kicks-ass.net>
References: <20180619082445.11062-1-thellstrom@vmware.com>
 <20180619082445.11062-2-thellstrom@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180619082445.11062-2-thellstrom@vmware.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 19, 2018 at 10:24:43AM +0200, Thomas Hellstrom wrote:
> From: Peter Ziljstra <peterz@infradead.org>
> 
> Make the WW mutex code more readable by adding comments, splitting up
> functions and pointing out that we're actually using the Wait-Die
> algorithm.
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
> Co-authored-by: Thomas Hellstrom <thellstrom@vmware.com>
> Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
> ---
>  Documentation/locking/ww-mutex-design.txt |  12 +-
>  include/linux/ww_mutex.h                  |  28 ++---
>  kernel/locking/mutex.c                    | 202 ++++++++++++++++++------------
>  3 files changed, 145 insertions(+), 97 deletions(-)

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
