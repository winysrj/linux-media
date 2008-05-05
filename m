Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from viefep27-int.chello.at ([62.179.121.47])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rscheidegger_lists@hispeed.ch>) id 1Jt1HE-0005kT-RR
	for linux-dvb@linuxtv.org; Mon, 05 May 2008 16:02:49 +0200
Message-ID: <481F1365.50808@hispeed.ch>
Date: Mon, 05 May 2008 16:02:13 +0200
From: Roland Scheidegger <rscheidegger_lists@hispeed.ch>
MIME-Version: 1.0
To: Ruediger Dohmhardt <ruediger.dohmhardt@freenet.de>
References: <481B7D43.2050200@hispeed.ch> <481CD27A.9080300@freenet.de>
In-Reply-To: <481CD27A.9080300@freenet.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] mantis crash...
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

Ruediger Dohmhardt wrote:
> Roland Scheidegger schrieb:
>> This was reported before, the current mantis driver will cause a
>> page fault in mantis_dvb_start_feed.
>> 
> Dear Roland,
> 
> I applied your patch to the code I got from
> 
> http://jusst.de/hg/mantis
> 
> Now the mantis driver (for 2033) works fine for me.
> 
> Setup: 2.6.22.19 vdr-1.5.18/xineliboutput
> 
> Unfortunately, as soon as I insert the CAM module, the driver
> crashes. According to the logfile, it looks that "vdr" still gets the
> information about the CAM and tries to access it. Then the driver
> crashes.  Maybe  someone  still has an idea how to dig into this.
Yes, the crash is due to the same (or similar) bogus hif reads/writes as
that fixed in the patch obviously - that code gets only used with a CAM.
There are mmreads/mmwrites to MANTIS_GPIF_HIFADDR, MANTIS_GPIF_HIFDIN
and MANTIS_GPIF_HIFDOUT - I'm sure all of them will blow up (they are
all the exact same value anyway).
But I wouldn't know how to fix this - I suspect those values are
actually masks which you'd or with some other values for accessing
values not directly accessible in registers. That's just speculation
however, I don't even have a clue what "HIF" stands for (well I guess
something with interface?). Fixing it would require a chip datasheet at
least (or (working) example code), or reverse engeneering or whatever.
Even if this particular hif read/write issue was fixed I'd highly doubt
though the cam code would actually work in its current state -
apparently it was never tested nor working. So Manu Abraham needs to fix
it I suspect - unfortunately there were no updates for over two weeks now.

Roland


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
