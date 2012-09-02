Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:41379 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251Ab2IBOyg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Sep 2012 10:54:36 -0400
Message-ID: <50437328.9050903@iki.fi>
Date: Sun, 02 Sep 2012 17:54:32 +0300
From: Timo Kokkonen <timo.t.kokkonen@iki.fi>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCHv3 2/9] ir-rx51: Handle signals properly
References: <1346349271-28073-1-git-send-email-timo.t.kokkonen@iki.fi> <1346349271-28073-3-git-send-email-timo.t.kokkonen@iki.fi> <20120901171420.GC6638@valkosipuli.retiisi.org.uk>
In-Reply-To: <20120901171420.GC6638@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Terve,

On 09/01/12 20:14, Sakari Ailus wrote:
> Moi,
> 
> On Thu, Aug 30, 2012 at 08:54:24PM +0300, Timo Kokkonen wrote:
>> @@ -273,9 +281,18 @@ static ssize_t lirc_rx51_write(struct file *file, const char *buf,
>>  
>>  	/*
>>  	 * Don't return back to the userspace until the transfer has
>> -	 * finished
>> +	 * finished. However, we wish to not spend any more than 500ms
>> +	 * in kernel. No IR code TX should ever take that long.
>> +	 */
>> +	i = wait_event_timeout(lirc_rx51->wqueue, lirc_rx51->wbuf_index < 0,
>> +			HZ / 2);
> 
> Why such an arbitrary timeout? In reality it might not bite the user space
> in practice ever, but is it (and if so, why) really required in the first
> place?

Well, I can think of two cases:

1) Something goes wrong. Such before I converted the patch to use the up
to date PM QoS implementation, the transmitting could take very long
time because the interrupts were not waking up the MPU. Now that this is
sorted out only unknown bugs can cause transmitting to hang indefinitely.

2) User is (intentionally?) doing something wrong. For example by
feeding in an IR code that has got very long pulses, he could end up
having the lircd process hung in kernel unkillable for long time. That
could be avoided quite easily by counting the pulse lengths and
rejecting any IR codes that are obviously too long. But since I'd like
to also protect against 1) case, I think this solution works just fine.

In the end, this is just safety measure that this driver behaves well.

-Timo
