Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from sd-green-bigip-145.dreamhost.com ([208.97.132.145]
	helo=randymail-a9.g.dreamhost.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb-list@krp.org.uk>) id 1JQuRj-0006xm-5y
	for linux-dvb@linuxtv.org; Mon, 18 Feb 2008 02:05:27 +0100
From: Kevin Page <linux-dvb-list@krp.org.uk>
To: Darren Salt <linux@youmustbejoking.demon.co.uk>
In-Reply-To: <4F6CC20A90%linux@youmustbejoking.demon.co.uk>
References: <1199589299.3373.22.camel@localhost.localdomain>
	<4F630EFE68%linux@youmustbejoking.demon.co.uk>
	<1201368697.3089.19.camel@localhost.localdomain>
	<4F6CC20A90%linux@youmustbejoking.demon.co.uk>
Date: Mon, 18 Feb 2008 01:05:14 +0000
Message-Id: <1203296714.3141.21.camel@localhost.localdomain>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Nova-t remote stopped working (budget_ci	rc5_device
	not set?)
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

On Sat, 2008-01-26 at 18:07 +0000, Darren Salt wrote:
> Odd... the 34-key version should be showing up as 0x1F and the 45-key
> version as 0x1E. (Or at least that's what happens with mine.)

As far as I can tell I haven't gone entirely mad... however it seems I
have schizophrenic remote control.

I was in the middle of using the remote and it stopped working again - I
was pressing buttons at the time.

Given my previous experience, I again checked it's rc5_device value.
This now appears to be 2! Setting rc5_device to 2 in modprobe.conf
restores the remote control to a working state.

This is a little odd, to say the least. I left the remote for a day with
it's batteries remove; I have fully powered down the PC to ensure a
cold-reload of the Nova-T firmware: the change in rc5_device value has
endured both.

I presume it's most likely to be a fault with the remote, rather than a
problem elsewhere?

In hindsight, it seems likely that the remote was previously identified
as (the default) 0x1F before it decided to adopt 0x1A. However, the
information added to the wiki would still seem to be useful, even if
just for others with cranky remotes...


Regards,

kev.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
