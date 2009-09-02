Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:37917 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbZIBRMA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Sep 2009 13:12:00 -0400
Date: Wed, 2 Sep 2009 19:11:54 +0200 (CEST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Thomas Rokamp <thomas@rokamp.dk>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Problems with Hauppauge Nova-T USB2
In-Reply-To: <41138.1251890451@rokamp.dk>
Message-ID: <alpine.LRH.1.10.0909021905001.3802@pub6.ifh.de>
References: <41138.1251890451@rokamp.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thomas,

On Wed, 2 Sep 2009, Thomas Rokamp wrote:
> Using 'scan' I have come to a channel.conf file, out of which I have added just one line to channels.conf:
> X:722000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_5_6:FEC_5_6:QAM_64:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:513:644:905
>
> Using the above channels.conf file as input to tzap, I get the following lines:
>
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> reading channels from file '.tzap/channels.conf'
> tuning to 722000000 Hz
> video pid 0x0201, audio pid 0x0284
> status 1f | signal 7bd3 | snr 0000 | ber 001fffff | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 7b94 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 7b7d | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 7b77 | snr 0000 | ber 00000090 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 7b79 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
> status 1f | signal 7b70 | snr 0000 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
>
> As you can see from above, the signal-to-noise ratio is, well... bad. I was hoping (according to my readings) a value much higher.

Ignore the SNR value. It is forced to 0000 even if the SNR is good 
(enough). This is a missing feature in the DiBx000-drivers (x < 8).

Beside that, everything looks fine: locks are there, signal is mid-range 
(~60 dBm I would estimate). ber = 0 and unc = 0, that means no problem on 
the demodulator side.

How did you get the channels.conf? How do you know the video and audio PID 
is correct?

Did you try to run scan or w_scan?

> [..[
> This 'test.mpg' output file, however, shows no video at all, despite it actually containing data. VLC reports 'nothing to play'.

What's the size of this file? (Should be ~1MB per second max on a very 
good MPEG2-stream) Maybe you're receiving H264... then it can be more and 
some versions of mplayer and vlc may not play it, because they are not 
able to detect that it is H264 + AAC without stream-meta-data (PAT, PMT).

regards,
--

Patrick Boettcher - Kernel Labs
http://www.kernellabs.com/
