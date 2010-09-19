Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:43475 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752357Ab0ISUUw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Sep 2010 16:20:52 -0400
Subject: Re: HVR 1600 Distortion
From: Andy Walls <awalls@md.metrocast.net>
To: Josh Borke <joshborke@gmail.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
In-Reply-To: <AANLkTinB+zE67UOaqEGkuHhy0RXYX9Ziyr_smOLcn7w5@mail.gmail.com>
References: <7u86hyrdbdphf9wmevbnab4n.1284911677723@email.android.com>
	 <AANLkTinB+zE67UOaqEGkuHhy0RXYX9Ziyr_smOLcn7w5@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Sep 2010 16:20:55 -0400
Message-ID: <1284927655.2079.115.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 2010-09-19 at 15:10 -0400, Josh Borke wrote:
> On Sun, Sep 19, 2010 at 11:54 AM, Andy Walls <awalls@md.metrocast.net> wrote:
> > Try a DTV STB or VCR with an RF out on channel 3.  Your card might not be bad.
> > Your signal looks overdriven from the new MPEG you sent. 

> > R,
> > Andy
> >
> > Josh Borke <joshborke@gmail.com> wrote:
> >

> >>I plugged it in to a windows machine and it has the same effect :(
> >>I'm going to say the card is fubar and I'll need to find a
> >>replacement.

> 
> I tried with the output from a SNES (most convenient thing) and it
> comes out with the same distortion :(

Yeah, the analog tuner assembly is dying or part of the analog front end
of the CX23418 is bad.

You can still use the card for ATSC/QAM digital TV and analog base band
(CVBS and S-Video) capture.

Regards,
Andy

> Thanks,
> -josh


