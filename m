Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f192.google.com ([209.85.212.192]:36120 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab0AAMHK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jan 2010 07:07:10 -0500
Received: by vws30 with SMTP id 30so4364633vws.33
        for <linux-media@vger.kernel.org>; Fri, 01 Jan 2010 04:07:09 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 1 Jan 2010 23:07:09 +1100
Message-ID: <a556718c1001010407j4b94af6sff50d00909fc2211@mail.gmail.com>
Subject: TV tunes ok but my DVB cards won't tune
From: Matthew Smith <yo.checkit@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I hope this is the right place to try and troubleshoot my DVB setup. I
have a Conexant based tuner that used to work with the cx88 driver and
an Avermedia USB tuner. I have moved house and can't get either of
these cards to tune using the scan or dvbscan utilities.

Mythtv is able to pick up the channels when it scans but it can't tune
to them later when I try to watch live tv.  As it tunes, I briefly see
mythtv reporting signal strengths around 40%

My TV is using the same antenna (with a splitter) and it picks up the
channels and reports 30-33% signal strength and 100% signal quality.

Also, I'm not sure I have the right channel file as I live in country
Victoria and the closest city is Melbourne so I'm using that file.  I
would expect to at least tune the major channels.

Is this just a case of needing a better antenna or is there something
else I can try? (I am already using a signal amplifier at the wall
socket.)

Regards

Matt

$ scan /usr/share/dvb/dvb-t/au-Melbourne
scanning /usr/share/dvb/dvb-t/au-Melbourne
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 226500000 1 3 9 3 1 1 0
initial transponder 177500000 1 3 9 3 1 1 0
initial transponder 191625000 1 3 9 3 1 1 0
initial transponder 219500000 1 3 9 3 1 1 0
initial transponder 536625000 1 2 9 3 1 2 0
>>> tune to: 226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 191625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 191625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 219500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 219500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.
