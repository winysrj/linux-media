Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-eopbgr700043.outbound.protection.outlook.com ([40.107.70.43]:26006
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S936193AbeFOMHg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 08:07:36 -0400
Subject: Re: [PATCH 1/2] locking: Implement an algorithm choice for Wound-Wait
 mutexes
To: Peter Zijlstra <peterz@infradead.org>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
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
References: <20180613074745.14750-1-thellstrom@vmware.com>
 <20180613074745.14750-2-thellstrom@vmware.com>
 <20180613095012.GW12198@hirez.programming.kicks-ass.net>
 <69f3dee9-4782-bc90-3ee2-813ac6835c4a@vmware.com>
 <20180613131000.GX12198@hirez.programming.kicks-ass.net>
 <9afd482d-7082-fa17-5e34-179a652376e5@vmware.com>
 <20180614105151.GY12198@hirez.programming.kicks-ass.net>
 <dd0c5e50-ac14-912c-d31c-c2341fdd2864@vmware.com>
 <20180614144254.GB12198@hirez.programming.kicks-ass.net>
 <5a1076ad-3c26-d78a-5542-9e767d81c4a6@vmware.com>
 <20180614185139.GG12198@hirez.programming.kicks-ass.net>
From: Thomas Hellstrom <thellstrom@vmware.com>
Message-ID: <ecffbeae-a6ca-4dd4-47f9-0e8d5321695b@vmware.com>
Date: Fri, 15 Jun 2018 14:07:18 +0200
MIME-Version: 1.0
In-Reply-To: <20180614185139.GG12198@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/14/2018 08:51 PM, Peter Zijlstra wrote:
> On Thu, Jun 14, 2018 at 06:43:40PM +0200, Thomas Hellstrom wrote:
>> Overall, I think this looks fine. I'll just fix up the FLAG_WAITERS setting
>> and affected comments and do some torture testing on it.
> Thanks!
>
>> Are you OK with adding the new feature and the cleanup in the same patch?
> I suppose so, trying to untangle that will be a bit of a pain. But if
> you feel so inclined I'm not going to stop you :-)

OK, I did some untangling. Sending out the resulting two patches. There 
are very minor changes in comments and naming, mostly trying to avoid 
"wound" where we really mean "die".

The only functional change is that I've moved the waiter-wounding-owner 
path to *after* we actually set the FLAG_WAITER so that we make sure a 
valid owner pointer remains valid while we hold the spinlock. This also 
means we can replace an smp_mb() with smp_mb__after_atomic().

Sending the patches as separate emails. Please let me know if you're OK 
with them and also the author / co-author info, and if so, I'll send out 
the full series again.

Thanks,

/Thomas
