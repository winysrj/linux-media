Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam01on0078.outbound.protection.outlook.com ([104.47.34.78]:63036
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S965682AbeFSKpK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Jun 2018 06:45:10 -0400
Subject: Re: [PATCH 1/3] locking: WW mutex cleanup
To: Peter Zijlstra <peterz@infradead.org>
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
References: <20180619082445.11062-1-thellstrom@vmware.com>
 <20180619082445.11062-2-thellstrom@vmware.com>
 <20180619094409.GK2458@hirez.programming.kicks-ass.net>
From: Thomas Hellstrom <thellstrom@vmware.com>
Message-ID: <8ea67e74-5ed4-2157-8e51-43f15047b3e4@vmware.com>
Date: Tue, 19 Jun 2018 12:44:52 +0200
MIME-Version: 1.0
In-Reply-To: <20180619094409.GK2458@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/19/2018 11:44 AM, Peter Zijlstra wrote:
> On Tue, Jun 19, 2018 at 10:24:43AM +0200, Thomas Hellstrom wrote:
>> From: Peter Ziljstra <peterz@infradead.org>
>>
>> Make the WW mutex code more readable by adding comments, splitting up
>> functions and pointing out that we're actually using the Wait-Die
>> algorithm.
>>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Jonathan Corbet <corbet@lwn.net>
>> Cc: Gustavo Padovan <gustavo@padovan.org>
>> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
>> Cc: Sean Paul <seanpaul@chromium.org>
>> Cc: David Airlie <airlied@linux.ie>
>> Cc: Davidlohr Bueso <dave@stgolabs.net>
>> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>> Cc: Josh Triplett <josh@joshtriplett.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Kate Stewart <kstewart@linuxfoundation.org>
>> Cc: Philippe Ombredanne <pombredanne@nexb.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: linux-doc@vger.kernel.org
>> Cc: linux-media@vger.kernel.org
>> Cc: linaro-mm-sig@lists.linaro.org
>> Co-authored-by: Thomas Hellstrom <thellstrom@vmware.com>
>> Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
>> ---
>>   Documentation/locking/ww-mutex-design.txt |  12 +-
>>   include/linux/ww_mutex.h                  |  28 ++---
>>   kernel/locking/mutex.c                    | 202 ++++++++++++++++++------------
>>   3 files changed, 145 insertions(+), 97 deletions(-)
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Hi Peter,

Do you want to add a SOB, since you're the main author?

Thomas
