Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:61564 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758336AbZC3VrB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 17:47:01 -0400
Received: by fg-out-1718.google.com with SMTP id e12so794065fga.17
        for <linux-media@vger.kernel.org>; Mon, 30 Mar 2009 14:46:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3731df090903301437k49c310bbha71946ab14c0d6c9@mail.gmail.com>
References: <3731df090903301437k49c310bbha71946ab14c0d6c9@mail.gmail.com>
Date: Mon, 30 Mar 2009 17:46:58 -0400
Message-ID: <37219a840903301446o36d61b0end913c5e2c10806b6@mail.gmail.com>
Subject: Re: Correct signal strength and SNR output for DViCO FusionHDTV7 Dual
	Express?
From: Michael Krufky <mkrufky@linuxtv.org>
To: Dave Johansen <davejohansen@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 30, 2009 at 5:37 PM, Dave Johansen <davejohansen@gmail.com> wrote:
> I am trying to get a MythTV setup working with a DViCO FusionHDTV7
> Dual Express using Mythbuntu 8.10 and I have been able to generate a
> channels.conf file using the latest v4l-dvb source code and the scan
> utility that comes with the dvb-utils in Mythbuntu (the dvbscan
> utility in latest dvb-apps source code give me the error "Unable to
> query frontend status"). I am also able to watch channels using
> mplayer, but the the problem is that MythTV does not identify any
> channels. I am able to watch channels using MythTV, but I have to
> manually enter the channel data since the tuning is not working.
>
> The belief is that the signal strength and SNR output must be
> incorrect and that is causing the problem with MythTV. I would like to
> help get this fixed, so others don't have the problems that I have run
> into, so what can I do to help get the signal strength and SNR outputs
> working?
>
> If it's helpful, I have attached an example output using azap with one
> of the channels that I can watch with mplayer:
>
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> tuning to 503028615 Hz
> video pid 0x0011, audio pid 0x0014
> status 01 | signal e000 | snr e450 | ber 00000000 | unc 00000000 |
> status 1f | signal 00ff | snr 00ff | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 00ff | snr 00ff | ber 00000ab7 | unc 00000ab7 | FE_HAS_LOCK
> status 1f | signal 00fa | snr 00fa | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 00fa | snr 00fa | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 00fa | snr 00fa | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 00fa | snr 00fa | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 00fa | snr 00fa | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 00fa | snr 00fa | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 00fa | snr 00fa | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>
> Thanks,
> Dave

That is a great signal reading.  0xfa = 25.0 dB , 0xff = 25.5 dB  ...
 so, you're teetering between 25.0 and 25.5 -- you have a great
signal.

SNR is reported in 0.1 dB by the driver that your device uses.

Ignore what mythtv says about signal status -- userspace cant read
kernelspace signal statistics properly yet.

Regards,

Mike
