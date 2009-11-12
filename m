Return-path: <linux-media-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.189]:2387 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbZKLUPx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2009 15:15:53 -0500
Received: by gv-out-0910.google.com with SMTP id r4so380418gve.37
        for <linux-media@vger.kernel.org>; Thu, 12 Nov 2009 12:15:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.0911120429020.15764@ybpnyubfg.ybpnyqbznva>
References: <f19975e80911111012v444f85b7t108b70539a428792@mail.gmail.com>
	 <alpine.DEB.2.01.0911120429020.15764@ybpnyubfg.ybpnyqbznva>
Date: Thu, 12 Nov 2009 21:15:58 +0100
Message-ID: <f19975e80911121215s293b7780ne6b0543136c59996@mail.gmail.com>
Subject: Re: problems receiving channels with technotrend S-3200
From: Stefan <chouffe1@gmail.com>
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 12, 2009 at 4:41 AM, BOUWSMA Barry
<freebeer.bouwsma@gmail.com> wrote:
> On Wed, 11 Nov 2009, Stefan wrote:
>
>> I'v problems with receiving dvb-s channels especially all the bbc
>> channels on freesat (Astra 28.2) .
>> The card is working fine for all the dutch channels (canaal digitaal)
>> and in windows i have no problem receiving bbc hd
>>
>> But as soon as i tune in to for example bbchd or bbc1 i do get a lock
>> but no data.
>>
>> # dvbstream -f 10847000 -p v -s 22000 -v 5500 -a 5501 -o > bbchd.mpg
>
>> tuning DVB-S to Freq: 1097000, Pol:V Srate=22000000, 22kHz tone=off, LNB: 0
>
>> When i try to record bvn (a fta channel)
>
> But not found on the same satellite...
>
>
>> # dvbstream -f 12574000 -p h -s 22000 -v 515 -a 96 -o > bvn.mpg
>
>> tuning DVB-S to Freq: 1974000, Pol:H Srate=22000000, 22kHz tone=off, LNB: 0
>
>
> These indicate you are attempting to stream from the same DiSEqC
> LNB number.  Your BVN is found at Astra 19E2 while the BBC
> domestic services are broadcast at Astra 28E2.
>
> You need to add a `-D #' to indicate which LNB position your
> Astra 28E2 can be received, which is obviously not the default
> (A or 1/2 or 1/4 or whatever) in your DiSEqC switch, as part of
> your commandline.
>
> Also note that you may need to record more of the stream in
> order to properly decode and play the BBC HD file than just
> the video payload.  The particular values I used last time I
> looked (the BSkyB/Freesat services have a habit of changing
> for no good reason) were 0  258  5500  5502  5503  5504  5501
> if that helps, including subtitles and all.
>
> Note that there is an active DVB-S transponder at the same
> frequency on Astra 19E2, last time I checked (more than a year
> ago, sorry) explaining why you are able to lock successfully
> on the wrong satellite position for the Freesat services.
>
>
> thanks
> barry bouwsma
>

Hi Barry,

thanks for clearing that up for me.

I'm getting a better view of it. And i have a scan now which include BBC HD.

Thanks and kind regards,

Stefan
