Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:35576 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756608AbeFSJq0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Jun 2018 05:46:26 -0400
Date: Tue, 19 Jun 2018 11:45:54 +0200
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
Subject: Re: [PATCH v4 0/4] locking,drm: Fix ww mutex naming / algorithm
 inconsistency
Message-ID: <20180619094554.GM2458@hirez.programming.kicks-ass.net>
References: <20180619082445.11062-1-thellstrom@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180619082445.11062-1-thellstrom@vmware.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I suspect you want this through the DRM tree? Ingo are you OK with that?
