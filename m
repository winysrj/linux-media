Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f51.google.com ([209.85.216.51]:49527 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539AbaGINVD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jul 2014 09:21:03 -0400
Received: by mail-qa0-f51.google.com with SMTP id j7so6108134qaq.10
        for <linux-media@vger.kernel.org>; Wed, 09 Jul 2014 06:21:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <DUB123-W379FFAE53D93ACCE359F07ED0F0@phx.gbl>
References: <DUB123-W379FFAE53D93ACCE359F07ED0F0@phx.gbl>
Date: Wed, 9 Jul 2014 09:21:02 -0400
Message-ID: <CAGoCfix6uWem_gXqXH--TisQYmyxjXvwqkz8Ah2m=KVH9O1ifA@mail.gmail.com>
Subject: Re: Troubleshooting problematic DVB-T reception
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Lukas Tribus <luky-37@hotmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I am trying to troubleshoot a (non-linux related) DVB-T issue and I basically
> want to create statistics about both DVB and MPEG framing, errors, corruption,
> missing frames, etc.
>
> The reason is that I believe there is a problem on the transmitting radio
> tower, RF is fine between the tower and me, but the actual payload (MPEG) is
> somehow bogus, errored or sporadically misses frames (due to backhaul problems
> or whatever).
>
> If I would be able to create some statistics confirming that I see all the DVB
> frames without any errors, but that the actual DVB payload (MPEG) has some
> problems, I could convince the tower guys to actually fix the issue, instead
> of blaming my antennas.
>
>
> So, can anyone suggest a tool or method to troubleshoot this issue further?
>
>
> tzap output for example confirms not a single BER error and the tuner keeps
> full LOCK on the channel while the actual stream is stuttering.

I probably wouldn't rely on the BER stats from tzap.  Their
implementation varies in quality depending on which tuner you have, as
well as how they are sampled.  Almost all demods will set the TEI bit
on the MPEG frame if it's determined that there was a decoding error -
I would be much more inclined to look at that.

Your best bet is to record the whole mux for a few minutes, then run
it through some different tools to see what class of errors you are
hitting.  Tools such as tsreader or StreamEye will give you a better
idea what's going on.  Once you know what class of failure you have
(e.g. TEI errors, MPEG discontinuities, etc), then you can better
isolate where in the chain the failure is being introduced.

Having the recording of the mux will also let you analyze in depth the
actual nature of the problem, rather than trying to analyze an
ever-changing stream in real-time, where signal conditions can change
over time.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
