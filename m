Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:49819 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbZKLDlf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2009 22:41:35 -0500
Received: by ey-out-2122.google.com with SMTP id 9so452859eyd.19
        for <linux-media@vger.kernel.org>; Wed, 11 Nov 2009 19:41:40 -0800 (PST)
Date: Thu, 12 Nov 2009 04:41:14 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Stefan <chouffe1@gmail.com>
cc: linux-media@vger.kernel.org
Subject: Re: problems receiving channels with technotrend S-3200
In-Reply-To: <f19975e80911111012v444f85b7t108b70539a428792@mail.gmail.com>
Message-ID: <alpine.DEB.2.01.0911120429020.15764@ybpnyubfg.ybpnyqbznva>
References: <f19975e80911111012v444f85b7t108b70539a428792@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 11 Nov 2009, Stefan wrote:

> I'v problems with receiving dvb-s channels especially all the bbc
> channels on freesat (Astra 28.2) .
> The card is working fine for all the dutch channels (canaal digitaal)
> and in windows i have no problem receiving bbc hd
> 
> But as soon as i tune in to for example bbchd or bbc1 i do get a lock
> but no data.
> 
> # dvbstream -f 10847000 -p v -s 22000 -v 5500 -a 5501 -o > bbchd.mpg

> tuning DVB-S to Freq: 1097000, Pol:V Srate=22000000, 22kHz tone=off, LNB: 0

> When i try to record bvn (a fta channel)

But not found on the same satellite...


> # dvbstream -f 12574000 -p h -s 22000 -v 515 -a 96 -o > bvn.mpg

> tuning DVB-S to Freq: 1974000, Pol:H Srate=22000000, 22kHz tone=off, LNB: 0


These indicate you are attempting to stream from the same DiSEqC
LNB number.  Your BVN is found at Astra 19E2 while the BBC
domestic services are broadcast at Astra 28E2.

You need to add a `-D #' to indicate which LNB position your
Astra 28E2 can be received, which is obviously not the default
(A or 1/2 or 1/4 or whatever) in your DiSEqC switch, as part of
your commandline.

Also note that you may need to record more of the stream in
order to properly decode and play the BBC HD file than just
the video payload.  The particular values I used last time I
looked (the BSkyB/Freesat services have a habit of changing
for no good reason) were 0  258  5500  5502  5503  5504  5501
if that helps, including subtitles and all.

Note that there is an active DVB-S transponder at the same
frequency on Astra 19E2, last time I checked (more than a year
ago, sorry) explaining why you are able to lock successfully
on the wrong satellite position for the Freesat services.


thanks
barry bouwsma
