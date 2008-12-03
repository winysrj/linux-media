Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linuxtv@hotair.fastmail.co.uk>) id 1L7uZp-0008QR-Nj
	for linux-dvb@linuxtv.org; Wed, 03 Dec 2008 17:27:50 +0100
Received: from compute2.internal (compute2.internal [10.202.2.42])
	by out1.messagingengine.com (Postfix) with ESMTP id 5BFE51CA7D3
	for <linux-dvb@linuxtv.org>; Wed,  3 Dec 2008 11:27:45 -0500 (EST)
Message-Id: <1228321665.3335.1288060499@webmail.messagingengine.com>
From: "petercarm" <linuxtv@hotair.fastmail.co.uk>
To: "linux-dvb" <linux-dvb@linuxtv.org>
Content-Disposition: inline
MIME-Version: 1.0
References: <412bdbff0811200714j5fcd3d62nb2cd46e49a350ce0@mail.gmail.com>
	<1228152690.22348.1287628393@webmail.messagingengine.com>
	<412bdbff0812011054j21fe1831hcf6b6bc2c0f77bff@mail.gmail.com>
	<1228162425.30518.1287666879@webmail.messagingengine.com>
	<1228164038.5106.1287670679@webmail.messagingengine.com>
	<500CD7A3A0%linux@youmustbejoking.demon.co.uk>
	<1228239571.26312.1287857857@webmail.messagingengine.com>
	<1228254543.23353.1287906941@webmail.messagingengine.com>
	<412bdbff0812021413s52ddcf3r8595b55182b798bf@mail.gmail.com>
	<1228318254.21892.1288048961@webmail.messagingengine.com>
	<412bdbff0812030734y56e908dfp793faf94238e24d3@mail.gmail.com>
In-Reply-To: <412bdbff0812030734y56e908dfp793faf94238e24d3@mail.gmail.com>
Date: Wed, 03 Dec 2008 16:27:45 +0000
Subject: Re: [linux-dvb] dib0700 remote control support fixed
Reply-To: linuxtv@hotair.fastmail.co.uk
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


On Wed, 3 Dec 2008 10:34:02 -0500, "Devin Heitmueller"
<devin.heitmueller@gmail.com> said:
> On Wed, Dec 3, 2008 at 10:30 AM, petercarm
> <linuxtv@hotair.fastmail.co.uk> wrote:
> > More testing.
> >
> > Moving on from the riser card issue, I've now got a fairly predictable
> > case where warm restart of the box results in endless mt2060 i2c errors.
> >
> 
> Hello Peter,
> 
> Just to be clear, this is in a box that doesn't have the riser card?
> 
> Does it happen even before you start streaming video?  Or does it
> occur when you do the first tune?
> 
> Can you please provide a detailed explanation regarding what that
> "fairly predictable case" is?
> 
> Thanks,
> 
> Devin

This is the case without the riser.  The log showed the failure 8
seconds after the driver initialized.  Mythtv backend may have started
in the meantime, but had no current jobs.  It may be related to EIT
scanning.

So far three times out of four it has failed on issuing "reboot".  It
has worked every time with a power down before restarting.  I'm doing a
clean rebuild of the complete test environment to eliminate any cached
results, just in case.  This will take about 8 hours.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
