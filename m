Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpq3.gn.mail.iss.as9143.net ([212.54.34.166]:43681 "EHLO
	smtpq3.gn.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752262Ab2D2HZ7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Apr 2012 03:25:59 -0400
Message-ID: <4F9CE796.2030004@grumpydevil.homelinux.org>
Date: Sun, 29 Apr 2012 09:02:46 +0200
From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
MIME-Version: 1.0
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	stoth@kernellabs.com
Subject: Re: HVR-1600 QAM recordings with slight glitches in them
References: <jn2ibp$pot$1@dough.gmane.org>  <1335307344.8218.11.camel@palomino.walls.org>  <jn7pph$qed$1@dough.gmane.org> <1335624964.2665.37.camel@palomino.walls.org> <4F9C38BE.3010301@interlinx.bc.ca> <4F9C559E.6010208@interlinx.bc.ca> <4F9C6D68.3090202@interlinx.bc.ca>
In-Reply-To: <4F9C6D68.3090202@interlinx.bc.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 29-04-12 00:21, Brian J. Murrell wrote:
> On 12-04-28 04:39 PM, Brian J. Murrell wrote:
>> I typically have one more splitter downstream from that 3 way splitter
>> which is a 4 way splitter to feed all of the tuners on my Mythtv box and
>> introducing that splitter reduces the SNR at the HVR-1600 to between
>> "13c" and "13e" (31.6 - 31.8 dB).
> Interestingly enough, I moved the Myth backend to it's usual home, in
> the basement, right next to the incoming cable signal and replaced that
> 25' run that I had going to where it was temporarily with a smaller, say
> 10' run (of RG-59 so still room for improvement) and my SNR at the
> HVR-1600, even after all of the splitters is now "015c" or 34.8 dB.
>
> I'm still going to go replacing all of that RG-59 with shorter, custom
> made lengths of RG6 cables.  I can't go "too short" when making those
> can I or would even a 6-12 inch cable be perfectly fine?  I'm thinking
> of the runs between that last 4 way splitter and the tuners in the Myth
> backend.
>
> b.
>
Brian,

There is no minimum cable length for RF. Although for practical reasons 
i rarely go below 30 cm (1 ').
It should be possible for you to buy "drop cables" which have a length 
of 1m5 (about 5') and are commonly used in HE to connect equipment.

screw-on F-connectors are another source of problems. Crimping 
F-connectors are best, but those need a fitting crimp tool.

Cheers,


Rudy
