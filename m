Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:58062 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794Ab3CFSFw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Mar 2013 13:05:52 -0500
Message-ID: <513785C5.8040702@schinagl.nl>
Date: Wed, 06 Mar 2013 19:07:01 +0100
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Linux Media <linux-media@vger.kernel.org>
Subject: Re: TerraTec Cinergy T PCIe Dual not working
References: <20130306142713.6a68179a@endymion.delvare> <51374B6D.9010805@schinagl.nl> <20130306160335.01cc5cd4@endymion.delvare>
In-Reply-To: <20130306160335.01cc5cd4@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/06/13 16:03, Jean Delvare wrote:
> Hi Oliver,
>
> Thanks for your fast reply.
>
> On Wed, 06 Mar 2013 14:58:05 +0100, Oliver Schinagl wrote:
>> I have the same card, and have not much problems. I have some reception
>> issues, but I don't think it's to blame on the card (yet). I do use
>> tvheadend however.
>>
>> In anycase, can you use w_scan or dvb-scan?
>
> I have neither but I have "scan" from package "dvb" which does work.
> This gave me the idea to re-run scan with different frequency files and
> different antennas.
>
> It turns out that my problem is the antenna. I was using the antenna I
> have been using with my previous card, which is an internal DVB-T
> antenna with amplification (external power supply.) I get zero signal
> with that. But using the Terratec-provided cheap "stick" antenna, I get
> signal again, with reasonable quality (although not as stable as with
> the old card and the powered antenna.) I also get signal (but not all
> channels) with my original antenna _unpowered_ (thus signal not
> amplified.)
>
> I admit I don't quite understand. I would understand that a bad,
> unpowered antenna causes no signal to be sensed. But how is it possible
> that a supposedly better, powered antenna causes that kind of issue?
>
> Oliver, out of curiosity, what antenna are you using? The
> Terratec-provided one, or another one?
>
Right now, I use 11cm stripped coax :) But that's because I live 600 
meters from the broadcasting tower. This actually gives me the best 
reception. The mini antenna that came with the thing worked quite well, 
but the wire was a bit short.

Besides that I did use a powered antenna for a while, without the power 
connected, because it actually dampens the signal. That worked quite 
well for a while. Using it powered, with an external power source, 
actually made it much worse.

