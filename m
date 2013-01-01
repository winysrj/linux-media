Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:60087 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301Ab3AAXOX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jan 2013 18:14:23 -0500
Received: from mailout-eu.gmx.com ([10.1.101.216]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MZic4-1TbFOz1WBi-00LVtI for
 <linux-media@vger.kernel.org>; Wed, 02 Jan 2013 00:09:19 +0100
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: AverTV_A918R (af9035-af9033-tda18218) / patch proposal
References: <op.wp845xcf4bfdfw@quantal> <50E36298.3040009@iki.fi>
 <op.wp88epxu4bfdfw@quantal>
Date: Wed, 02 Jan 2013 00:09:17 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: Diorser <diorser@gmx.fr>
Message-ID: <op.wp889rso4bfdfw@quantal>
In-Reply-To: <op.wp88epxu4bfdfw@quantal>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for your so fast reply.
Unfortunately, scanning output is always empty with 100% signal strength   
(external antenna)
I also use a AverTV super_007 with the same external antenna on a  another  
PC with Kaffeine =Signal = 100%.

I also tried different dvb-usb-af9035-02.fw  firmware with different   
LINK/OFDM value (I don't understand but just tried.).
Never got any PID or channel.
Scanning and tuning work (or seem to with w_scan or kaffeine), but no   
data output.

I've noticed that videobuf_dvb and videobuf_dma_sg modules are need by a   
saa7134 card, and not by AF9035. (no videobuf / dvb_usb_af9035
dependency).
Don't know if it is normal or not.

A bit frustrating to be so close to the end, but also a bit pessimistic   
because really reaching the limit of my skills.
Anyway, I will stay tuned in case some values need to be modified in the   
source for test, or any updates I will try.

Many thanks.
Diorser.

On Tue, 01 Jan 2013 23:26:32 +0100, Antti Palosaari <crope@iki.fiwrote

> Patch looks correct.
>>
> If you are talking of that error I saw wiki you mentioned it is not  
> error. You cannot use dvbsnoop like that. You have to tune to channel  
> first and only after device is tuned successfully pidscan is possible.
>>
>  # dvbsnoop -s pidscan
>  dvbsnoop V1.4.50 -- http://dvbsnoop.sourceforge.net/
>  Transponder PID-Scan...
>  Error(22): DMX_SET_PES_FILTER: Invalid argument
>>
> If you are really sure your antenna is good (not that small antenna  
> bundled) and it does not work then there is some bug. I bet some GPIO is  
> wrong. Maybe you should take some sniffs using SniffUSB2.0 and look  
> there...
>
> regards
> Antti
