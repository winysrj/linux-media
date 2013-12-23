Return-path: <linux-media-owner@vger.kernel.org>
Received: from multi.imgtec.com ([194.200.65.239]:59636 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756990Ab3LWNSI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Dec 2013 08:18:08 -0500
Message-ID: <52B837F7.7060501@imgtec.com>
Date: Mon, 23 Dec 2013 13:17:43 +0000
From: James Hogan <james.hogan@imgtec.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: <linux-media@vger.kernel.org>
Subject: Re: [PATCH 04/11] media: rc: img-ir: add hardware decoder driver
References: <1386947579-26703-1-git-send-email-james.hogan@imgtec.com> <1386947579-26703-5-git-send-email-james.hogan@imgtec.com> <20131222114036.3faef8f0@samsung.com>
In-Reply-To: <20131222114036.3faef8f0@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 22/12/13 13:40, Mauro Carvalho Chehab wrote:
> Em Fri, 13 Dec 2013 15:12:52 +0000
> James Hogan <james.hogan@imgtec.com> escreveu:
> 
>> Add remote control input driver for the ImgTec Infrared block hardware
>> decoder, which is set up with timings for a specific protocol and
>> supports mask/value filtering and wake events.
>>
>> The hardware decoder timing values, raw data to scan code conversion
>> function and scan code filter to raw data filter conversion function are
>> provided as separate modules for each protocol which this part of the
>> driver can use. The scan code filter value and mask (and the same again
>> for wake from sleep) are specified via sysfs files in
>> /sys/class/rc/rcX/.
> 
> We should discuss a little more about those new sysfs controls.

Yes I thought so. For reference there was some mention of this in an old
thread ([RFC] What are the goals for the architecture of an in-kernel IR
system), but I didn't go into any details back then:
http://thread.gmane.org/gmane.linux.kernel.input/9747
(search for my name)

> There are two separate questions here:
> 
> 1) are those new sysfs controls really device specific? If not, then it
> makes sense to add support for it at rc-core.

I would say no, although at least wakeup filters is dependent on
hardware support. I've attempted to make them fairly generic (i.e. they
deal with scancodes rather than raw data, so the filter could certainly
be done in software) but they do implicitly assume only a single
protocol being enabled at a time (in fact the values reset if the
protocol is changed). I suppose it could just be expected that matches
on any enabled protocol would be reported.

> I suspect that a wakeup scancode is something that should be part of the
> RC core, as other devices may have it too.
> 
> Also, the RC core currently supports a scancode mask. Not sure if it is
> the same concept as the one used on your hardware. Could you please
> explain it better?

Okay. The hardware provides a data valid interrupt (indicating that data
was received which conforms to the programmed timings), and a data match
interrupt (indicating that the valid data matches a certain value - with
a mask of bits which are compared).

By default the data valid interrupt is used to trigger input events, and
wake-on-interrupt is disabled.

After ...
echo 0x1fc00 > filter
echo 0xffff00 > filter_mask

... the data match interrupt is used to trigger input events, and the
value and mask are transformed into raw IR data value and mask and
programmed into HW. In this case only extended-NEC IR codes (NEC is
current protocol, extended because the filter value has 0xff0000 bits
set) with an address field of 0x01fc will trigger input events, but the
command code (in scancode bits 0x0000ff) isn't matched so any button on
the remote triggers input events.

As well as reducing the irrelevant input events, this prevents the
driver switching to repeat code timings until the timeout is hit for
codes that aren't actually interesting anyway.

The wakeup_* files behave identically, except they apply only during
suspend and a match triggers a wakeup. So after the following ...
echo 0x1fc00 > wakeup_filter
echo 0xffffff > wakeup_filter_mask

... when suspend takes place the wakeup specific value/mask is
programmed, and the wake only occurs if the whole address and command
code matches, i.e. only the power button of this specific remote
triggers a wake.

Note that wakeup_filter[_mask] currently does not have to be a subset of
filter[_mask].

> 2) Where those new sysfs nodes will be documented.
> 
> With regards to (2), we currently lack a chapter at the Linux Media
> Documentation/DocBook or at Documentation/ABI/ for the existing sysfs
> interface, but let's not increase the gap, please.
> I'll see if I can find some time to write such documentation, probably
> at Documentation/ABI/testing.
> 
> So, if we come to the conclusion that those interfaces should be part
> of the rc core, we'll need them to be documented at
> Documentation/ABI/testing too.
> 
> Otherwise, if we decide to add some of those as private API, please
> add a README for this device, under Documentation/remote-controllers.

Okay.

> The patch itself (and patches 1-3) look OK to me. I'll be reviewing
> the other patches on separate emails.

Thanks very much for taking the time to review it.

Cheers
James

