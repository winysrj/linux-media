Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:46492 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755123AbeFNLtw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 07:49:52 -0400
Received: by mail-wr0-f194.google.com with SMTP id v13-v6so6078447wrp.13
        for <linux-media@vger.kernel.org>; Thu, 14 Jun 2018 04:49:51 -0700 (PDT)
Date: Thu, 14 Jun 2018 13:49:44 +0200
From: Andrea Parri <andrea.parri@amarulasolutions.com>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20180614114944.GA18651@andrea>
References: <20180614072922.8114-1-thellstrom@vmware.com>
 <20180614072922.8114-2-thellstrom@vmware.com>
 <20180614103852.GA18216@andrea>
 <b84a5ef9-6cd1-7dc9-a51d-cb195cdea83c@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b84a5ef9-6cd1-7dc9-a51d-cb195cdea83c@vmware.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[...]

> >>+		/*
> >>+		 * wake_up_process() paired with set_current_state() inserts
> >>+		 * sufficient barriers to make sure @owner either sees it's
> >>+		 * wounded or has a wakeup pending to re-read the wounded
> >>+		 * state.
> >IIUC, "sufficient barriers" = full memory barriers (here).  (You may
> >want to be more specific.)
> 
> Thanks for reviewing!
> OK. What about if someone relaxes that in the future?

This is actually one of my main concerns ;-)  as, IIUC, those barriers are
not only sufficient but also necessary: anything "less than a full barrier"
(in either wake_up_process() or set_current_state()) would _not_ guarantee
the "condition" above unless I'm misunderstanding it.

But am I misunderstanding it?  Which barriers/guarantee do you _need_ from
the above mentioned pairing? (hence my comment...)

  Andrea
