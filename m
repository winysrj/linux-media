Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-eopbgr710067.outbound.protection.outlook.com ([40.107.71.67]:44049
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754966AbeFNMEq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 08:04:46 -0400
Subject: Re: [PATCH v2 1/2] locking: Implement an algorithm choice for
 Wound-Wait mutexes
To: Andrea Parri <andrea.parri@amarulasolutions.com>
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
References: <20180614072922.8114-1-thellstrom@vmware.com>
 <20180614072922.8114-2-thellstrom@vmware.com> <20180614103852.GA18216@andrea>
 <b84a5ef9-6cd1-7dc9-a51d-cb195cdea83c@vmware.com>
 <20180614114944.GA18651@andrea>
From: Thomas Hellstrom <thellstrom@vmware.com>
Message-ID: <d01185f5-8d27-96e7-0875-275beecc21e4@vmware.com>
Date: Thu, 14 Jun 2018 14:04:26 +0200
MIME-Version: 1.0
In-Reply-To: <20180614114944.GA18651@andrea>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/14/2018 01:49 PM, Andrea Parri wrote:
> [...]
>
>>>> +		/*
>>>> +		 * wake_up_process() paired with set_current_state() inserts
>>>> +		 * sufficient barriers to make sure @owner either sees it's
>>>> +		 * wounded or has a wakeup pending to re-read the wounded
>>>> +		 * state.
>>> IIUC, "sufficient barriers" = full memory barriers (here).  (You may
>>> want to be more specific.)
>> Thanks for reviewing!
>> OK. What about if someone relaxes that in the future?
> This is actually one of my main concerns ;-)  as, IIUC, those barriers are
> not only sufficient but also necessary: anything "less than a full barrier"
> (in either wake_up_process() or set_current_state()) would _not_ guarantee
> the "condition" above unless I'm misunderstanding it.
>
> But am I misunderstanding it?  Which barriers/guarantee do you _need_ from
> the above mentioned pairing? (hence my comment...)
>
>    Andrea

No you are probably not misunderstanding me at all. My comment 
originated from the reading of the kerneldoc of set_current_state()

* set_current_state() includes a barrier so that the write of current->state
* is correctly serialised wrt the caller's subsequent test of whether to
* actually sleep:
*
* for (;;) {
* set_current_state(TASK_UNINTERRUPTIBLE);
* if (!need_sleep)
* break;
*
* schedule();
* }
* __set_current_state(TASK_RUNNING);
*
* If the caller does not need such serialisation (because, for instance, the
* condition test and condition change and wakeup are under the same 
lock) then
* use __set_current_state().
*
* The above is typically ordered against the wakeup, which does:
*
* need_sleep = false;
* wake_up_state(p, TASK_UNINTERRUPTIBLE);
*
* Where wake_up_state() (and all other wakeup primitives) imply enough
* barriers to order the store of the variable against wakeup. And with 
ctx->wounded := !need_sleep this exactly matches what's happening in my 
code. So what I was trying to say in the comment was that this above 
contract is sufficient to guarantee the "condition" above, whitout me 
actually knowing exactly what barriers are required. Thanks, Thomas
