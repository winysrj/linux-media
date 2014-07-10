Return-path: <linux-media-owner@vger.kernel.org>
Received: from dub004-omc4s25.hotmail.com ([157.55.2.100]:59191 "EHLO
	DUB004-OMC4S25.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751784AbaGJHzb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jul 2014 03:55:31 -0400
Message-ID: <DUB123-W287472B410B715719CA9D3ED0E0@phx.gbl>
From: Lukas Tribus <luky-37@hotmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: Troubleshooting problematic DVB-T reception
Date: Thu, 10 Jul 2014 09:50:21 +0200
In-Reply-To: <CAGoCfix6uWem_gXqXH--TisQYmyxjXvwqkz8Ah2m=KVH9O1ifA@mail.gmail.com>
References: <DUB123-W379FFAE53D93ACCE359F07ED0F0@phx.gbl>,<CAGoCfix6uWem_gXqXH--TisQYmyxjXvwqkz8Ah2m=KVH9O1ifA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin!



----------------------------------------
> Date: Wed, 9 Jul 2014 09:21:02 -0400
> Subject: Re: Troubleshooting problematic DVB-T reception
> From: dheitmueller@kernellabs.com
> To: luky-37@hotmail.com
> CC: linux-media@vger.kernel.org
>
>> I am trying to troubleshoot a (non-linux related) DVB-T issue and I basically
>> want to create statistics about both DVB and MPEG framing, errors, corruption,
>> missing frames, etc.
>>
>> The reason is that I believe there is a problem on the transmitting radio
>> tower, RF is fine between the tower and me, but the actual payload (MPEG) is
>> somehow bogus, errored or sporadically misses frames (due to backhaul problems
>> or whatever).
>>
>> If I would be able to create some statistics confirming that I see all the DVB
>> frames without any errors, but that the actual DVB payload (MPEG) has some
>> problems, I could convince the tower guys to actually fix the issue, instead
>> of blaming my antennas.
>>
>>
>> So, can anyone suggest a tool or method to troubleshoot this issue further?
>>
>>
>> tzap output for example confirms not a single BER error and the tuner keeps
>> full LOCK on the channel while the actual stream is stuttering.
>
> I probably wouldn't rely on the BER stats from tzap. Their
> implementation varies in quality depending on which tuner you have, as
> well as how they are sampled. Almost all demods will set the TEI bit
> on the MPEG frame if it's determined that there was a decoding error -
> I would be much more inclined to look at that.
>
> Your best bet is to record the whole mux for a few minutes, then run
> it through some different tools to see what class of errors you are
> hitting. Tools such as tsreader or StreamEye will give you a better
> idea what's going on. Once you know what class of failure you have
> (e.g. TEI errors, MPEG discontinuities, etc), then you can better
> isolate where in the chain the failure is being introduced.
>
> Having the recording of the mux will also let you analyze in depth the
> actual nature of the problem, rather than trying to analyze an
> ever-changing stream in real-time, where signal conditions can change
> over time.

Thanks for your advice! I agree capturing the whole mux for further analysis
is the best thing todo.



Thanks,

Lukas





 		 	   		  