Return-path: <mchehab@pedra>
Received: from smtp01.frii.com ([216.17.135.167]:39637 "EHLO smtp01.frii.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139Ab1BFX2B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Feb 2011 18:28:01 -0500
Date: Sun, 6 Feb 2011 16:28:00 -0700
From: Mark Zimmerman <markzimm@frii.com>
To: Dave Johansen <davejohansen@gmail.com>
Cc: v4l-dvb Mailing List <linux-media@vger.kernel.org>
Subject: Re: Tuning channels with DViCO FusionHDTV7 Dual Express
Message-ID: <20110206232800.GA83692@io.frii.com>
References: <AANLkTin8Rjch6o7aU-9S9m8f5aBYVeSwxSaVhyEfM5q9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin8Rjch6o7aU-9S9m8f5aBYVeSwxSaVhyEfM5q9@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, Feb 06, 2011 at 03:46:59PM -0700, Dave Johansen wrote:
> I am trying to resurrect my MythBuntu system with a DViCO FusionHDTV7
> Dual Express. I had previously had some issues with trying to get
> channels working in MythTV (
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg03846.html
> ), but now it locks up with MythBuntu 10.10 when I scan for channels
> in MythTV and also with the scan command line utility.
> 
> Here's the output from scan:
> 
> scan /usr/share/dvb/atsc/us-ATSC-
> center-frequencies-8VSB
> scanning us-ATSC-center-frequencies-8VSB
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> >>> tune to: 189028615:8VSB
> WARNING: filter timeout pid 0x0000
> WARNING: filter timeout pid 0x1ffb
> 
> Any ideas/suggestions on how I can get this to work?

Check your dmesg to see if yout firmware loads.


