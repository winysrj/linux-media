Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:48223 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757295Ab2INH7I (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 03:59:08 -0400
Message-ID: <5052E3BD.9040502@iki.fi>
Date: Fri, 14 Sep 2012 10:58:53 +0300
From: Timo Kokkonen <timo.t.kokkonen@iki.fi>
MIME-Version: 1.0
To: Sean Young <sean@mess.org>
CC: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	Sakari Ailus <sakari.ailus@iki.fi>, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCHv3 2/9] ir-rx51: Handle signals properly
References: <1346349271-28073-1-git-send-email-timo.t.kokkonen@iki.fi> <1346349271-28073-3-git-send-email-timo.t.kokkonen@iki.fi> <20120901171420.GC6638@valkosipuli.retiisi.org.uk> <50437328.9050903@iki.fi> <504375FA.1030209@iki.fi> <20120902152027.GA5236@itanic.dhcp.inet.fi> <20120902194110.GA6834@valkosipuli.retiisi.org.uk> <5043BCB4.1040308@iki.fi> <20120903123653.GA7218@pequod.mess.org>
In-Reply-To: <20120903123653.GA7218@pequod.mess.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/03/12 15:36, Sean Young wrote:
> On Sun, Sep 02, 2012 at 11:08:20PM +0300, Timo Kokkonen wrote:
>> On 09/02/12 22:41, Sakari Ailus wrote:
>>> On Sun, Sep 02, 2012 at 06:20:27PM +0300, Timo Kokkonen wrote:
>>>> On 09.02 2012 18:06:34, Sakari Ailus wrote:
>>>>> Heippa,
>>>>>
>>>>> Timo Kokkonen wrote:
>>>>>> Terve,
>>>>>>
>>>>>> On 09/01/12 20:14, Sakari Ailus wrote:
>>>>>>> Moi,
>>>>>>>
>>>>>>> On Thu, Aug 30, 2012 at 08:54:24PM +0300, Timo Kokkonen wrote:
>>>>>>>> @@ -273,9 +281,18 @@ static ssize_t lirc_rx51_write(struct file *file, const char *buf,
>>>>>>>>
>>>>>>>>   	/*
>>>>>>>>   	 * Don't return back to the userspace until the transfer has
>>>>>>>> -	 * finished
>>>>>>>> +	 * finished. However, we wish to not spend any more than 500ms
>>>>>>>> +	 * in kernel. No IR code TX should ever take that long.
>>>>>>>> +	 */
>>>>>>>> +	i = wait_event_timeout(lirc_rx51->wqueue, lirc_rx51->wbuf_index < 0,
>>>>>>>> +			HZ / 2);
>>>>>>>
>>>>>>> Why such an arbitrary timeout? In reality it might not bite the user space
>>>>>>> in practice ever, but is it (and if so, why) really required in the first
>>>>>>> place?
>>>>>>
>>>>>> Well, I can think of two cases:
>>>>>>
>>>>>> 1) Something goes wrong. Such before I converted the patch to use the up
>>>>>> to date PM QoS implementation, the transmitting could take very long
>>>>>> time because the interrupts were not waking up the MPU. Now that this is
>>>>>> sorted out only unknown bugs can cause transmitting to hang indefinitely.
>>>>>>
>>>>>> 2) User is (intentionally?) doing something wrong. For example by
>>>>>> feeding in an IR code that has got very long pulses, he could end up
>>>>>> having the lircd process hung in kernel unkillable for long time. That
>>>>>> could be avoided quite easily by counting the pulse lengths and
>>>>>> rejecting any IR codes that are obviously too long. But since I'd like
>>>>>> to also protect against 1) case, I think this solution works just fine.
>>>>>>
>>>>>> In the end, this is just safety measure that this driver behaves well.
>>>>>
>>>>> In that case I think you should use wait_event_interruptible() instead. 
>>>>
>>>> Well, that's what I had there in the first place. With interruptible
>>>> wait we are left with problem with signals. I was told by Sean Young
>>>> that the lirc API expects the write call to finish only after the IR
>>>> code is transmitted.
>>>>
>>>>> It's not the driver's job to decide what the user can do with the 
>>>>> hardware and what not, is it?
>>>>
>>>> Yeah, policy should be decided by the user space. However, kernel
>>>> should not leave any objvious denial of service holes open
>>>> either. Allowing a process to get stuck unkillable within kernel for
>>>> long time sounds like one to me.
> 
> It's not elegant, but this can't be used as a denial of service attack.
> The driver waits for a maximum of a half a second after which signals
> are serviced as normal.
> 
>>> It's interruptible, so the user space can interrupt that wait if it chooses
>>> so. Besides, if you call this denial of service, then capturing video on
>>> V4L2 is, too, since others can't use the device in the meantime. :-)
>>>
>>
>> Well, of course there is no problem if we use interruptible waits. But I
>> was told by Sean that the lirc API expects the IR TX to be finished
>> always when the write call returns.
> 
> This is part of the ABI. The lircd deamon might want to do gap calculation
> if there are large spaces in the IR code being sent. Maybe others can
> enlighten us why such an ABI was choosen.
> 
>> I guess the assumption is to avoid
>> breaking the transmission in the middle in case the process is signaled.
>> And that's why we shouldn't use interruptible waits.
>>
>> However, if we allow simply breaking the transmitting in case the
>> process is signaled any way during the transmission, then the handling
>> would be trivial in the driver. That is, if someone for example kills or
>> stops the lirc daemon process, then the IR code just wouldn't finish ever.
>>
>> Sean, do you have an opinion how this should or is allowed to work?
> 
> You want to know when the hardware is done sending the IR. If you return
> EINTR to user space, how would user space know how much IR has been sent, 
> if any?
> 
> This ABI is not particularily elegant so there are proposals for a better
> interface which would obsolete the lirc interface. David Hardeman has
> worked on this:
> 
> http://patchwork.linuxtv.org/patch/11411/
> 

It appears that all "modern" lirc drivers are now using the rc-core
functionalities to implement the common stuff. When the rx51 lirc driver
was first written, the core was not in place yet. Therefore it is
implementing the file operations in the driver, which other rc drivers
won't do today.

So, I think it would make sense to modify the rx51 driver to use the rc
core functionality. But if there is an ABI change ongoing, I could wait
until you have that done before I start working on the change?

Considering this patch set, I think it makes sense still to apply these
as they improve the existing code base. I'll just squash the one patch
to the misc fixes, as pointed by Sakari, and then re-send the set.

-Timo

>>>> Anyway, we are trying to cover some rare corner cases here, I'm not
>>>> sure how it should work exactly..
>>>
>>> If there was a generic maximum timeout for sending a code, wouldn't it make
>>> sense to enforce that in the LIRC framework instead?
>>>
>>
>> Yes, I agree it makes sense to leave unrestricted. But in that case we
>> definitely have to use interruptible waits in case user space is doing
>> something stupid and regrets it later :)
> 
> Only for 500ms. 
> 
> 
> Sean
> 

