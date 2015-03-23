Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:33297 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbbCWPhV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2015 11:37:21 -0400
Received: by iecvj10 with SMTP id vj10so38666034iec.0
        for <linux-media@vger.kernel.org>; Mon, 23 Mar 2015 08:37:20 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 23 Mar 2015 17:37:20 +0200
Message-ID: <CAAZRmGwVRj2kH9toTFex9S=7+opD8v4LqbdEz+Ge-h5AzTsUHw@mail.gmail.com>
Subject: [v4l-utils] dvbv5-scan stores incorrect channel data for DVB-S
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
