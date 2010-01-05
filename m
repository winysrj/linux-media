Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:63919 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab0AEDNI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jan 2010 22:13:08 -0500
Received: by fxm25 with SMTP id 25so9366204fxm.21
        for <linux-media@vger.kernel.org>; Mon, 04 Jan 2010 19:13:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1262658469.3054.48.camel@palomino.walls.org>
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
Date: Mon, 4 Jan 2010 22:13:04 -0500
Message-ID: <829197381001041913k1e2b2d18la03999762e1d69e1@mail.gmail.com>
Subject: Re: [RESEND] Re: DViCO FusionHDTV DVB-T Dual Digital 4 (rev 1) tuning
	regression
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@radix.net>
Cc: Robert Lowery <rglowery@exemail.com.au>, mchehab@redhat.com,
	Vincent McIntyre <vincent.mcintyre@gmail.com>,
	terrywu2009@gmail.com, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey Andy,

On Mon, Jan 4, 2010 at 9:27 PM, Andy Walls <awalls@radix.net> wrote:
> The changes in question (mostly authored by me) are based on
> documentation on what offsets are to be used with the firmware for
> various DVB bandwidths and demodulators.  The change was tested by Terry
> on a Leadtek DVR 3100 H Analog/DVB-T card (CX23418, ZL10353, XC3028) and
> some other cards I can't remember, using a DVB-T pattern generator for 7
> and 8 MHz in VHF and UHF, and live DVB-T broadcasts in UHF for 6 MHz.
>
> (Devin,
>  Maybe you can double check on the offsets in tuner-xc2028.c with any
>  documentation you have available to you?)

At this point the extent to which I've looked in to the issue was
validating that, for a given frequency, the change resulted in a
crappy SNR with lots of BER/UNC errors, and after reverting the change
the signal looked really good with zero BER/UNC.  I haven't dug into
*why* it is an issue, but I examined the traces and looked at the
testing methodology and can confirm that there was definitely a
regression and Robert narrowed it down to the patch in question.

I was kind of hoping that one of the people that helped introduce the
regression would take on some of responsibility to help with the
debugging.  ;-)

I think I have one of the boards that will demonstrate the issue (a
Terratec board with xc3028/zl10353), and will try to find some time
with the generator once I wrap up the xc4000 work for the PCTV 340e.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
