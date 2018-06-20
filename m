Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-eopbgr720066.outbound.protection.outlook.com ([40.107.72.66]:35767
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750968AbeFTFSF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 01:18:05 -0400
Subject: Re: [PATCH v4 0/4] locking,drm: Fix ww mutex naming / algorithm
 inconsistency
To: Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
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
References: <20180619082445.11062-1-thellstrom@vmware.com>
 <20180619094554.GM2458@hirez.programming.kicks-ass.net>
From: Thomas Hellstrom <thellstrom@vmware.com>
Message-ID: <f07c53d9-a22e-41c9-59a4-71ef6f7d96bb@vmware.com>
Date: Wed, 20 Jun 2018 07:17:42 +0200
MIME-Version: 1.0
In-Reply-To: <20180619094554.GM2458@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/19/2018 11:45 AM, Peter Zijlstra wrote:
> I suspect you want this through the DRM tree? Ingo are you OK with that?


Yes, I can ask Dave to pull this. Ingo?

Thanks,

Thomas
