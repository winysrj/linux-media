Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:44325 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280Ab0AEDpW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jan 2010 22:45:22 -0500
Subject: Re: [RESEND] Re: DViCO FusionHDTV DVB-T Dual Digital 4 (rev 1)
 tuning  regression
From: Andy Walls <awalls@radix.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Robert Lowery <rglowery@exemail.com.au>, mchehab@redhat.com,
	Vincent McIntyre <vincent.mcintyre@gmail.com>,
	terrywu2009@gmail.com, linux-media@vger.kernel.org
In-Reply-To: <829197381001041913k1e2b2d18la03999762e1d69e1@mail.gmail.com>
References: <33305.64.213.30.2.1259216241.squirrel@webmail.exetel.com.au>
	 <702870ef0911260137r35f1784exc27498d0db3769c2@mail.gmail.com>
	 <56069.115.70.135.213.1259234530.squirrel@webmail.exetel.com.au>
	 <46566.64.213.30.2.1259278557.squirrel@webmail.exetel.com.au>
	 <702870ef0912010118r1e5e3been840726e6364d991a@mail.gmail.com>
	 <829197380912020657v52e42690k46172f047ebd24b0@mail.gmail.com>
	 <36364.64.213.30.2.1260252173.squirrel@webmail.exetel.com.au>
	 <1328.64.213.30.2.1260920972.squirrel@webmail.exetel.com.au>
	 <2088.115.70.135.213.1262579258.squirrel@webmail.exetel.com.au>
	 <1262658469.3054.48.camel@palomino.walls.org>
	 <829197381001041913k1e2b2d18la03999762e1d69e1@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 04 Jan 2010 22:43:34 -0500
Message-Id: <1262663014.3054.90.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-01-04 at 22:13 -0500, Devin Heitmueller wrote:
> Hey Andy,
> 
> On Mon, Jan 4, 2010 at 9:27 PM, Andy Walls <awalls@radix.net> wrote:
> > The changes in question (mostly authored by me) are based on
> > documentation on what offsets are to be used with the firmware for
> > various DVB bandwidths and demodulators.  The change was tested by Terry
> > on a Leadtek DVR 3100 H Analog/DVB-T card (CX23418, ZL10353, XC3028) and
> > some other cards I can't remember, using a DVB-T pattern generator for 7
> > and 8 MHz in VHF and UHF, and live DVB-T broadcasts in UHF for 6 MHz.
> >
> > (Devin,
> >  Maybe you can double check on the offsets in tuner-xc2028.c with any
> >  documentation you have available to you?)
> 
> At this point the extent to which I've looked in to the issue was
> validating that, for a given frequency, the change resulted in a
> crappy SNR with lots of BER/UNC errors, and after reverting the change
> the signal looked really good with zero BER/UNC.  I haven't dug into
> *why* it is an issue, but I examined the traces and looked at the
> testing methodology and can confirm that there was definitely a
> regression and Robert narrowed it down to the patch in question.
> 
> I was kind of hoping that one of the people that helped introduce the
> regression would take on some of responsibility to help with the
> debugging.  ;-)

I take responsiblity for the change.  However, if fixing a known problem
unmasks another problem, then is that a regression?


I puzzled over the docs for a while until I had the "Aha!" moment and
understood what they were saying.  I'm really confident about the freq
offset changes - especially since using the wrong center freq in
channels.conf is an easy way to mask incorrect freq offsets in the
driver module.

I'm less confident about the xc3028 firmware segments as extracted and
repackaged for linux.  I was not involved in that development and I
conveniently (for me) assume it is correct -- although that may be an
assumption worth challenging.

I also do not know the source of the commanded DTV freq's that are in
use in the reported problem case.  Using the wrong DTV center freq can
cause the same problem symptoms as moving the offset used in the
tuner-xc2028 module (two wrongs making a right).  I just found a nice
authoritative Australian source on DTV freq licensees (see my other
foloow-up email), so hopefully Robert can double check that.

Of course testing with a DVB-T generator instead of a broadcaster's
signal would eliminate any doubt about the center freq in use.


> I think I have one of the boards that will demonstrate the issue (a
> Terratec board with xc3028/zl10353), and will try to find some time
> with the generator once I wrap up the xc4000 work for the PCTV 340e.

OK, thanks.  I have no hardware with which to test.

Regards,
Andy

> Devin


