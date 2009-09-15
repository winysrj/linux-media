Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197]:48097 "EHLO
	mta2.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbZIONeN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 09:34:13 -0400
Received: from mbpwifi.kernelscience.com
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta2.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KQ0006FFLOX9GL1@mta2.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Tue, 15 Sep 2009 09:34:09 -0400 (EDT)
Date: Tue, 15 Sep 2009 09:34:09 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: HVR-2200 Australia DVB-T
In-reply-to: <CED52FAC-4C8D-416C-B00E-5662F1F63E85@receptiveit.com.au>
To: Alex Ferrara <alex@receptiveit.com.au>
Cc: linux-media@vger.kernel.org
Message-id: <4AAF97D1.8030905@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <CED52FAC-4C8D-416C-B00E-5662F1F63E85@receptiveit.com.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> WIN TV
> Canberra:767500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_3_4:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:33:36:1


> root@kaylee:~/.tzap# tzap "WIN TV Canberra"
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> reading channels from file '/root/.tzap/channels.conf'
> tuning to 767500000 Hz
> video pid 0x0021, audio pid 0x0024
> status 00 | signal a9a9 | snr 002e | ber 0000ffff | unc 00000000 |
> status 00 | signal ffff | snr 0000 | ber 0000ffff | unc 00000000 |
> status 00 | signal ffff | snr 0000 | ber 0000ffff | unc 00000000 |
> status 00 | signal ffff | snr 0000 | ber 0000ffff | unc 00000000 |
>
> Any help would be appreciated.

Sounds like a tuning issue. Either the Antenna is bad or the channels.conf 
doesn't represent the actual center frequency or the channel or the tuner / 
demod code is buggy.

Other people are having success with DVB-T HVR2200 so it's either a bug that 
gets exposed by your environment or something else. mkrufky has some tuner 
improvements pending for merge which are not in the saa7164 tree yet, you might 
want to hold for a few days for these.

The other thing to double check is that the freqs in your channels conf do 
actually represent the center of the DVB-T channel. I suspect they do, but 
double check for good measure using the official Australian DVB-T antenna docs.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
