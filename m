Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam01on0089.outbound.protection.outlook.com ([104.47.32.89]:64766
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933912AbeFMIe1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Jun 2018 04:34:27 -0400
Subject: Re: [PATCH 1/2] locking: Implement an algorithm choice for Wound-Wait
 mutexes
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
        linux-doc@vger.kernel.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org
References: <20180613074745.14750-1-thellstrom@vmware.com>
 <20180613074745.14750-2-thellstrom@vmware.com>
 <20180613075411.GA17681@kroah.com>
From: Thomas Hellstrom <thellstrom@vmware.com>
Message-ID: <c4d005b7-4b5a-3d21-79ba-99e24fb68f4f@vmware.com>
Date: Wed, 13 Jun 2018 10:34:02 +0200
MIME-Version: 1.0
In-Reply-To: <20180613075411.GA17681@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/13/2018 09:54 AM, Greg Kroah-Hartman wrote:
> On Wed, Jun 13, 2018 at 09:47:44AM +0200, Thomas Hellstrom wrote:
>>   -----
>>   
>> +The algorithm (Wait-Die vs Wound-Wait) is chosen using the _is_wait_die
>> +argument to DEFINE_WW_CLASS(). As a rough rule of thumb, use Wound-Wait iff you
>> +typically expect the number of simultaneous competing transactions to be small,
>> +and the rollback cost can be substantial.
>> +
>>   Three different ways to acquire locks within the same w/w class. Common
>>   definitions for methods #1 and #2:
>>   
>> -static DEFINE_WW_CLASS(ww_class);
>> +static DEFINE_WW_CLASS(ww_class, false);
> Minor nit on the api here.  Having a "flag" is a royal pain.  You have
> to go and look up exactly what that "true/false" means every time you
> run across it in code to figure out what it means.  Don't do that if at
> all possible.
>
> Make a new api:
> 	DEFINE_WW_CLASS_DIE(ww_class);
> instead that then wraps that boolean internally to switch between the
> different types.  That way the api is "self-documenting" and we all know
> what is going on without having to dig through a header file.
>
> thanks,
>
> greg k-h

Good point. I'll update in a v2.

Thanks,

Thomas
