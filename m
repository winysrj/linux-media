Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:58781 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753126Ab2D1V7a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Apr 2012 17:59:30 -0400
Subject: Re: HVR-1600 QAM recordings with slight glitches in them
From: Andy Walls <awalls@md.metrocast.net>
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Cc: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	stoth@kernellabs.com
Date: Sat, 28 Apr 2012 17:57:45 -0400
In-Reply-To: <4F9C38BE.3010301@interlinx.bc.ca>
References: <jn2ibp$pot$1@dough.gmane.org>
	 <1335307344.8218.11.camel@palomino.walls.org>
	 <jn7pph$qed$1@dough.gmane.org>
	 <1335624964.2665.37.camel@palomino.walls.org>
	 <4F9C38BE.3010301@interlinx.bc.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1335650281.2489.43.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2012-04-28 at 14:36 -0400, Brian J. Murrell wrote:
> One more question...
> 
> On 12-04-28 10:56 AM, Andy Walls wrote:
> >
> > So I see SNR values from 0x138 to 0x13c ( 31.2 dB to 31.6 dB ) when you
> > have problems.  For 256-QAM cable signals, I think that is considered
> > marginal.  
> 
> I've never gotten my mind around SNRs and dBs, etc.  Generally speaking,
> am I looking for these "snr" values to go up or down (i.e. closer to 0
> or further away) to make my signal better?

Higher SNR is better:
Higher SNR => lower probability of bit errors
Lower SNR => higher probability of bit errors

SNR in dB = 10 log (S/N)

S : Received signal power in Watts
N : Noise power at measurement point in Watts

A logarithmic scale (dB) is used to express the quantities in values
that are easier for people to comprehend and deal with.  Gains and
losses in dB are additive.

-3 dB corresponds to a drop by a factor of 1/2:  10 * log(1/2) = -3.01
+3 dB corresponds to a gain by a factor of 2:    10 * log(2)   =  3.01

Regards,
Andy

> Cheers,
> b.


