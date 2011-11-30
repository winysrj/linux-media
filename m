Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:54350 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab1K3SCm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 13:02:42 -0500
Message-ID: <4ED66FBC.5090504@linuxtv.org>
Date: Wed, 30 Nov 2011 19:02:36 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Abylay Ospan <aospan@netup.ru>, linux-media@vger.kernel.org
Subject: Re: LinuxTV ported to Windows
References: <4ED65C46.20502@netup.ru> <CAGoCfiwShvPSgAPHKaxj=sMG-Fs9RdH0_3mLHYWuY96Z33AOag@mail.gmail.com>
In-Reply-To: <CAGoCfiwShvPSgAPHKaxj=sMG-Fs9RdH0_3mLHYWuY96Z33AOag@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30.11.2011 18:23, Devin Heitmueller wrote:
> 2011/11/30 Abylay Ospan <aospan@netup.ru>:
>> Hello,
>>
>> We have ported linuxtv's cx23885+CAM en50221+Diseq to Windows OS (Vista, XP,
>> win7 tested). Results available under GPL and can be checkout from git
>> repository:
>> https://github.com/netup/netup-dvb-s2-ci-dual

That's nice to hear, Abylay!

>> Binary builds (ready to install) available in build directory. Currently
>> NetUP Dual DVB-S2 CI card supported (
>> http://www.netup.tv/en-EN/dual_dvb-s2-ci_card.php ).
>>
>> Driver based on Microsoft BDA standard, but some features (DiSEqC, CI)
>> supported by custom API, for more details see netup_bda_api.h file.
>>
>> Any comments, suggestions are welcome.
>>
>> --
>> Abylai Ospan<aospan@netup.ru>
>> NetUP Inc.
> 
> Am I the only one who thinks this is a legally ambigious grey area?
> Seems like this could be a violation of the GPL as the driver code in
> question links against a proprietary kernel.

Devin, please! Are you implying that the windows kernel becomes a
derived work of the driver, or that it's generally impossible to publish
windows drivers under the terms of the GPL?

> I don't want to start a flame war, but I don't see how this is legal.
> And you could definitely question whether it goes against the
> intentions of the original authors to see their GPL driver code being
> used in non-free operating systems.

The GPL doesn't cover such intentions.

Regards,
Andreas

P.S.: "The licenses for most software are designed to take away your
freedom to share and change it.  By contrast, the GNU General Public
License is intended to guarantee your freedom to share and change free
software--to make sure the software is free for all its users."
