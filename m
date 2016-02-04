Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45145 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbcBDQOm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Feb 2016 11:14:42 -0500
Subject: Re: PCTV 292e weirdness
To: Russel Winder <russel@itzinteractive.com>,
	DVB_Linux_Media <linux-media@vger.kernel.org>
References: <1454523447.1970.15.camel@itzinteractive.com>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <56B378F0.6020301@iki.fi>
Date: Thu, 4 Feb 2016 18:14:40 +0200
MIME-Version: 1.0
In-Reply-To: <1454523447.1970.15.camel@itzinteractive.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!

On 02/03/2016 08:17 PM, Russel Winder wrote:
> I am fairly sure I didn't see this before, but then I am not sure I
> have a new kernel, libdvbv5 or dvbtools. Also people are bad witnesses.
> However, if I plug the device in I can either scan with it or tune it,
> but only once thereafter it goes into "won't do anything so there"
> mode. For example:
>
>
> |> dvbv5-zap -c save_channels.conf "BBC NEWS"
> using demux '/dev/dvb/adapter0/demux0'
> reading channels from file 'save_channels.conf'
> service has pid type 05:  7270
> tuning to 490000000 Hz
> video pid 501
>    dvb_set_pesfilter 501
> audio pid 502
>    dvb_set_pesfilter 502
>         (0x00)
> Lock   (0x1f) Signal= -51.00dBm C/N= 23.50dB
> 582 anglides:~/Repositories/Git/Git/Me-TV (git:master)
> |> dvbv5-zap -c save_channels.conf "BBC NEWS"
> using demux '/dev/dvb/adapter0/demux0'
> reading channels from file 'save_channels.conf'
> service has pid type 05:  7270
> tuning to 490000000 Hz
> video pid 501
>    dvb_set_pesfilter 501
> audio pid 502
>    dvb_set_pesfilter 502
>         (0x00) C/N= 23.50dB
>         (0x00) Signal= -67.00dBm C/N= 23.50dB
>         (0x00) Signal= -67.00dBm C/N= 23.50dB
>         (0x00) Signal= -109.00dBm C/N= 23.50dB
>         (0x00) Signal= -109.00dBm C/N= 23.50dB
>         (0x00) Signal= -109.00dBm C/N= 23.50dB
>         (0x00) Signal= -109.00dBm C/N= 23.50dB
>         (0x00) Signal= -109.00dBm C/N= 23.50dB
>         (0x00) Signal= -109.00dBm C/N= 23.50dB
>         (0x00) Signal= -109.00dBm C/N= 23.50dB
>         (0x00) Signal= -109.00dBm C/N= 23.50dB
>
>
> If I use a PCTV 282e this does not happen. As far as I can tell there
> has been no change of firmware either, and yet…

Are you using DVB-T, T2 or C? I quickly tested T and T2 with dvbv5-zap 
and it worked (kernel media 4.5.0-rc1+).

PCTV 282e seems to be dibcom based DVB-T only device, so you are using 
DVB-T?

regards
Antti

-- 
http://palosaari.fi/
