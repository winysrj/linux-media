Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:48113 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755582Ab1FVLhn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 07:37:43 -0400
Message-ID: <4E01D405.6090200@iki.fi>
Date: Wed, 22 Jun 2011 14:37:41 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: mutoid <mutoid@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: impossible to tune card, but I can watch TV :?
References: <BANLkTi=73UGtcMTE5dUWSQEeyke8T-HB8Q@mail.gmail.com>
In-Reply-To: <BANLkTi=73UGtcMTE5dUWSQEeyke8T-HB8Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

No exactly knowledge, but I cannot see where you define used bandwidth. 
Frequency and bandwidth are generally needed by every DVB-T tuner as 
param. Maybe those just are defaulted to different defaults or no 
default at all.

Antti

On 06/22/2011 01:05 PM, mutoid wrote:
> Hello,
>
> I have an Avermedia Super 007, installed in a headless Linux machine to
> multicast some TV channels.
>
> I use "mumudvb" and works fine, without problem. I can stream 4 TV channels
> and 4 radios at once
>
> But now I need to extract EPG data, using dbvtune and tv_grab_dvb
>
> I tried 2 configurations:
>
> * Kworld USB DVB-T + dvbtune + tv_grab_dvb = works fine
>
> ~# dvbtune -c 1 -f 770000
> Using DVB card "Afatech AF9013 DVB-T"
> tuning DVB-T (in United Kingdom) to 770000000 Hz
> polling....
> Getting frontend event
> FE_STATUS:
> polling....
> Getting frontend event
> FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI
> FE_HAS_SYNC
> Event:  Frequency: 780600000
>          SymbolRate: 0
>          FEC_inner:  2
>
> Bit error rate: 0
> Signal strength: 51993
> SNR: 120
> FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI
> FE_HAS_SYNC
>
>
> * Avermedia Super 007 + dvbtune = no working
>
> ~# dvbtune -c 0 -f 770000
> Using DVB card "Philips TDA10046H DVB-T"
> tuning DVB-T (in United Kingdom) to 770000000 Hz
> polling....
> Getting frontend event
> FE_STATUS:
> polling....
> polling....
> polling....
> polling....
>
> Why can I use dvbtune with one USB card but not with a PCI card?
>
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
http://palosaari.fi/
