Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:38643 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbbDCQLv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2015 12:11:51 -0400
Received: by igbqf9 with SMTP id qf9so97834377igb.1
        for <linux-media@vger.kernel.org>; Fri, 03 Apr 2015 09:11:51 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 3 Apr 2015 19:11:50 +0300
Message-ID: <CAAZRmGwHjjVy6ecUe5oGiu4X3f0McVacu_RvAxop_NYqGEdedA@mail.gmail.com>
Subject: Re: [v4l-utils] dvbv5-scan stores incorrect channel data for DVB-S
From: Olli Salonen <olli.salonen@iki.fi>
To: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti & Mauro,

It seems that dvbv5-scan makes a scan of channels, set the parameters
it gets in the initial scan file, but then reads in the frequency from
the driver before writing the channel file. It seems to get a much
lower frequency (I understand this is the LNB frequency) from the
driver:

Scanning frequency #1 11265000
FREQUENCY = 11265000
...
Got parameters for DVBS2:
FREQUENCY = 1515000

Now the question is, is the issue in the driver side or in the
dvbv5-scan side? You two probably have the best insight into this as
you wrote the driver and the dvbv5-scan utility.

Thanks,
-olli



---------- Earlier message ----------
From: Olli Salonen <olli.salonen@iki.fi>
Date: 23 March 2015 at 17:37
Subject: [v4l-utils] dvbv5-scan stores incorrect channel data for DVB-S
To: linux-media <linux-media@vger.kernel.org>


Hi,

I noticed that when doing a channel scan using dvbv5-scan the scan
results in a bogus dvb_channel.conf file.

During the scan the correct frequency is printed out:

Scanning frequency #1 11265000
Service Viasat History HD, provider (null): reserved
Service TV6 HD Sweden, provider (null): reserved
Service Viasat Explore HD, provider (null): reserved
Service Viasat 4  HD, provider (null): reserved
Service Viasat Nature/Crime HD, provider (null): reserved
Service TV3 HD Danmark, provider (null): reserved

But in the dvb_channels.conf all channels have wrong frequencies, example:

[Viasat History HD]
SERVICE_ID = 2600
VIDEO_PID = 2601
AUDIO_PID = 2602 2603 2604 2605 2606
PID_06 = 106 105 104 103 102 101 100
SAT_NUMBER = 0
LNB = UNIVERSAL
FREQUENCY = 1515000
INVERSION = OFF
SYMBOL_RATE = 30000000
INNER_FEC = 3/4
MODULATION = PSK/8
PILOT = ON
ROLLOFF = 25
POLARIZATION = HORIZONTAL
STREAM_ID = 0
DELIVERY_SYSTEM = DVBS2

olli@dl160:~$ dvbv5-scan --version
dvbv5-scan version 1.6.2

olli@dl160:~$ dvbv5-scan -l UNIVERSAL -S 0
~/documents/dvb/initial_scan_data/dvbs/s4e8.conf > ~/output.txt

Initial scan file: http://paste.ubuntu.com/10661471/
Resulting output.txt: http://paste.ubuntu.com/10661520/
Resulting dvb_channel.conf: http://paste.ubuntu.com/10661485/
Same scan, this time with very verbose
settings:http://paste.ubuntu.com/10661568/

Cheers,
-olli
