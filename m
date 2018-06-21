Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:52352 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754178AbeFUK4O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Jun 2018 06:56:14 -0400
Date: Thu, 21 Jun 2018 12:56:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-graphics-maintainer@vmware.com, pv-drivers@vmware.com,
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
Subject: Re: [PATCH v4 0/4] locking,drm: Fix ww mutex naming / algorithm
 inconsistency
Message-ID: <20180621105610.GA28688@gmail.com>
References: <20180619082445.11062-1-thellstrom@vmware.com>
 <20180619094554.GM2458@hirez.programming.kicks-ass.net>
 <f07c53d9-a22e-41c9-59a4-71ef6f7d96bb@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f07c53d9-a22e-41c9-59a4-71ef6f7d96bb@vmware.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


* Thomas Hellstrom <thellstrom@vmware.com> wrote:

> On 06/19/2018 11:45 AM, Peter Zijlstra wrote:
> > I suspect you want this through the DRM tree? Ingo are you OK with that?
> 
> 
> Yes, I can ask Dave to pull this. Ingo?

Sure, no problem if it's tested and all:

  Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
