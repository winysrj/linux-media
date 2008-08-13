Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.171])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sparkmaul@gmail.com>) id 1KT8z1-0000MV-ES
	for linux-dvb@linuxtv.org; Wed, 13 Aug 2008 07:33:20 +0200
Received: by wf-out-1314.google.com with SMTP id 27so2472756wfd.17
	for <linux-dvb@linuxtv.org>; Tue, 12 Aug 2008 22:33:14 -0700 (PDT)
Message-ID: <8e5b27790808122233r539e6404y777e2bade7c78b47@mail.gmail.com>
Date: Tue, 12 Aug 2008 22:33:14 -0700
From: "Paul Marks" <paul@pmarks.net>
To: linux-dvb@linuxtv.org
In-Reply-To: <8e5b27790808120058o52c4c6bcw21152364b2613c39@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <8e5b27790808120058o52c4c6bcw21152364b2613c39@mail.gmail.com>
Subject: Re: [linux-dvb] FusionHDTV5 IR not working.
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

On Tue, Aug 12, 2008 at 12:58 AM, Paul Marks <paul@pmarks.net> wrote:
> I have a DViCO FusionHDTV5 RT Gold, with an IR sensor that connects to
> the back of the card.  The remote is a "Fusion Remote MCE".  The video
> capture stuff works just fine, but I've had no such luck with the
> remote.

Just to confirm some things:
- The remote control works using DViCO's software on Windows Vista x64.
- The remote is not detected in Ubuntu 8.04.1

I normally run Gentoo with kernel 2.6.26, but I tested with an Ubuntu
Live CD, to be sure I wasn't forgetting some trivial kernel module.

Is there anything I can run in Windows to determine how the driver is
communicating with the IR sensor?  I managed to get Dscaler's
RegSpy.exe running, and it did show a bit of activity, but nothing
that correlated with my remote button presses.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
