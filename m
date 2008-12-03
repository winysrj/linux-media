Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1L7uhh-0000vy-Oe
	for linux-dvb@linuxtv.org; Wed, 03 Dec 2008 17:35:58 +0100
Received: by nf-out-0910.google.com with SMTP id g13so2139307nfb.11
	for <linux-dvb@linuxtv.org>; Wed, 03 Dec 2008 08:35:53 -0800 (PST)
Message-ID: <412bdbff0812030835r1044bd3cwc47ebc44a7877657@mail.gmail.com>
Date: Wed, 3 Dec 2008 11:35:53 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: linuxtv@hotair.fastmail.co.uk
In-Reply-To: <1228321665.3335.1288060499@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <412bdbff0811200714j5fcd3d62nb2cd46e49a350ce0@mail.gmail.com>
	<1228162425.30518.1287666879@webmail.messagingengine.com>
	<1228164038.5106.1287670679@webmail.messagingengine.com>
	<500CD7A3A0%linux@youmustbejoking.demon.co.uk>
	<1228239571.26312.1287857857@webmail.messagingengine.com>
	<1228254543.23353.1287906941@webmail.messagingengine.com>
	<412bdbff0812021413s52ddcf3r8595b55182b798bf@mail.gmail.com>
	<1228318254.21892.1288048961@webmail.messagingengine.com>
	<412bdbff0812030734y56e908dfp793faf94238e24d3@mail.gmail.com>
	<1228321665.3335.1288060499@webmail.messagingengine.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] dib0700 remote control support fixed
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Wed, Dec 3, 2008 at 11:27 AM, petercarm
<linuxtv@hotair.fastmail.co.uk> wrote:
>
> On Wed, 3 Dec 2008 10:34:02 -0500, "Devin Heitmueller"
> <devin.heitmueller@gmail.com> said:
>> On Wed, Dec 3, 2008 at 10:30 AM, petercarm
>> <linuxtv@hotair.fastmail.co.uk> wrote:
>> > More testing.
>> >
>> > Moving on from the riser card issue, I've now got a fairly predictable
>> > case where warm restart of the box results in endless mt2060 i2c errors.
>> >
>>
>> Hello Peter,
>>
>> Just to be clear, this is in a box that doesn't have the riser card?
>>
>> Does it happen even before you start streaming video?  Or does it
>> occur when you do the first tune?
>>
>> Can you please provide a detailed explanation regarding what that
>> "fairly predictable case" is?
>>
>> Thanks,
>>
>> Devin
>
> This is the case without the riser.  The log showed the failure 8
> seconds after the driver initialized.  Mythtv backend may have started
> in the meantime, but had no current jobs.  It may be related to EIT
> scanning.
>
> So far three times out of four it has failed on issuing "reboot".  It
> has worked every time with a power down before restarting.  I'm doing a
> clean rebuild of the complete test environment to eliminate any cached
> results, just in case.  This will take about 8 hours.

Ok.  That's good to know.  It's possible that the driver does not
clear out all its state when being initialized and the reboot alone
doesn't cut power to the device so there is something that persists
across the reboot.  This would definitely make sense as to why we see
it with this device and not the USB based dib0700 devices.

There are two things that would be useful here I think:

If you can confirm whether the change on November 16th *really* has
anything to do with the failure (by trying snapshots of the v4l-dvb
tree before and after the change).

Add a call to dump_stack() right after the error line in the code, so
we can see what the stack looks like at the time of failure.

I'm glad it's readily reproducible, which will make it easier to
isolate the problem and validate any fix we come up with.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
