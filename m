Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:41951 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755162Ab2HNIx5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 04:53:57 -0400
Message-ID: <502A1221.8020804@gmx.de>
Date: Tue, 14 Aug 2012 10:53:53 +0200
From: Reinhard Nissl <rnissl@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: STV0299: reading property DTV_FREQUENCY -- what am I expected to
 get?
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

it seems that my 9 years old LNBs got some drift over time, as 
tuning takes quite a while until I get a lock. So I thought I 
could compensate this offset by adjusting VDR's diseqc.conf.

Therefore I first hacked some logging into VDR's tuner code to 
read and output the above mentioned property once it got a lock 
after tuning. As VDR's EPG scanner travels over all transponders 
when idle, I get offset values for all transponders and can then 
try to find some average offset to put into diseqc.conf.

So here are several "travel" results for a single transponder 
ordered by Delta:

Sat.	Pol.	Band	Freq (MHz) Set	Freq (MHz) Get	Delta (MHz)
S13,0E	H	H	11938	11930,528	-7,472
S13,0E	H	H	11938	11936,294	-1,706
S13,0E	H	H	11938	11938,917	0,917
S13,0E	H	H	11938	11939,158	1,158
S13,0E	H	H	11938	11939,906	1,906
S13,0E	H	H	11938	11939,965	1,965
S13,0E	H	H	11938	11940,029	2,029
S13,0E	H	H	11938	11940,032	2,032
S13,0E	H	H	11938	11940,103	2,103
S13,0E	H	H	11938	11940,112	2,112
S13,0E	H	H	11938	11940,167	2,167
S13,0E	H	H	11938	11941,736	3,736
S13,0E	H	H	11938	11941,736	3,736
S13,0E	H	H	11938	11941,736	3,736
S13,0E	H	H	11938	11942,412	4,412
S13,0E	H	H	11938	11943,604	5,604
S13,0E	H	H	11938	11943,604	5,604
S13,0E	H	H	11938	11943,604	5,604
S13,0E	H	H	11938	11945,472	7,472
S13,0E	H	H	11938	11945,472	7,472
S13,0E	H	H	11938	11945,472	7,472
S13,0E	H	H	11938	11945,472	7,472
S13,0E	H	H	11938	11945,472	7,472
S13,0E	H	H	11938	11945,472	7,472
S13,0E	H	H	11938	11945,472	7,472
S13,0E	H	H	11938	11945,777	7,777
S13,0E	H	H	11938	11945,777	7,777
S13,0E	H	H	11938	11945,777	7,777
S13,0E	H	H	11938	11945,777	7,777

I really wonder why Delta varies that much, and there are other 
transponders in the same band which have no larger deltas then 3 MHz.

So is it at all possible to determine LNB drift in that way?

My other device, a STB0899, always reports the set frequency. So 
it seems driver dependent whether it reports the actually locked 
frequency found by the zig-zag-algorithm or just the set 
frequency to tune to.

Thanks in advance for any replies.

Bye.
-- 
Dipl.-Inform. (FH) Reinhard Nissl
mailto:rnissl@gmx.de
