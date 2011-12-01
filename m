Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:56342 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882Ab1LAQbC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Dec 2011 11:31:02 -0500
Message-ID: <4ED7ABC0.4010003@linuxtv.org>
Date: Thu, 01 Dec 2011 17:30:56 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Hamad Kadmany <hkadmany@codeaurora.org>
CC: linux-media@vger.kernel.org
Subject: Re: Support for multiple section feeds with same PIDs
References: <001101ccae6d$9900b350$cb0219f0$@org> <4ED782E2.9060004@linuxtv.org> <000301ccb030$dfaa71f0$9eff55d0$@org> <4ED787D5.203@linuxtv.org> <000401ccb034$a8ec2ce0$fac486a0$@org> <4ED78F85.7020005@linuxtv.org> <000501ccb041$f3f08210$dbd18630$@org>
In-Reply-To: <000501ccb041$f3f08210$dbd18630$@org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01.12.2011 16:57, Hamad Kadmany wrote:
> Hello Andreas
>  
>> On 01.12.2011 16:30, Andreas Oberritter wrote:
> 
>> Yes. Feel free to enhance the demux API to your needs in order to fully
>> support the features of your hardware.
> 
> I have another question in that regard: Actually, multiple filter with same
> PID is assumed to be possible in case we have one filter for TS packets (for
> DVR device) and another for video PES (for playback). So it seems there's
> such assumption in this regard but not for sections. Is my understanding
> correct?

The in-kernel software demux ("dvb_demux") receives TS packets and
strips off headers as requested in order to convert TS to PES or
sections. If you're implementing a driver, you can choose to either
extend the software demux by overwriting its
{allocate,release}_{ts,section}_feed function pointers or you can
replace the software demux completely, using your own functions.

That said, the software demux supports multiple filters of any type
simultaneously on the same PID, so whether it will work for you will
eventually depend on your implementation.

It's definitely easier to extend the sofware demux, but replacing it may
possibly allow you use your hardware more efficiently.

I think the av7110 driver also implements section filters, as a further
example.

Regards,
Andreas
