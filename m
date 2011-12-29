Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299Ab1L2UM1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Dec 2011 15:12:27 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBTKCQB3004236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 29 Dec 2011 15:12:26 -0500
Received: from [10.3.230.209] (vpn-230-209.phx2.redhat.com [10.3.230.209])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id pBTKCNMT002500
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 29 Dec 2011 15:12:26 -0500
Message-ID: <4EFCC9A7.9050907@redhat.com>
Date: Thu, 29 Dec 2011 18:12:23 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: RFC: dvbzap application based on DVBv5 API
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to test the large chunk of patches I've made those days, I wrote
a dvbzap application using DVBv5 API, based on tzap.

It is at my experimental v4l-utils tree, at branch dvb-utils:
	http://git.linuxtv.org/mchehab/experimental-v4l-utils.git/shortlog/refs/heads/dvb-utils

in order to test, please use:
	git clone git://linuxtv.org/mchehab/experimental-v4l-utils.git

While I tested it only with ISDB-T, it will likely work with DVB-T, ATSC and DVB-C,
if CA is not needed.

TODO:
- Add proper support for Satellite delivery systems. It will likely
  recognize a DVB-S zap file, but it won't work, as polarization setting were not
  implemented, nor any DISEqC commands;
- Add support for CA;
- Be more flexible with regards to the channels.conf files.

One of the changes I'm experimenting with this tool is to define a new format to
show DVBv5 channels/transponders.

As you likely know, the current formats on the existing DVBv3 tools are 
standard-dependent. Even the existing DVBv5 applications I'm aware of currently
write the channels file on a DVBv3, due to compatibility issues.

So, a new format for channels is needed.

The current code has one function to write on a new format. I lacks a parser for it
(it shouldn't be hard to write one - a few hours should be enough for doing that).

The format I'm thinking is to use:

[channel name]
	property = value
...
	property = value

This allows the same format to be used by any DVBv5 supported delivery system. 
It will even allow to mix channels from different delivery systems on the same file.
This could be useful for devices like DRX-K, that supports multiple delivery
systems with different parameters.

As an example, this is what it produces from a DVB-T zap file:

[TV Brasil SD]
        VIDEO_PID = 769
        AUDIO_PID = 513
        SERVICE_ID = 16161
        DELIVERY_SYSTEM = DVBT
        FREQUENCY = 479142857
        INVERSION = AUTO
        BANDWIDTH_HZ = 6000000
        CODE_RATE_HP = AUTO
        CODE_RATE_LP = AUTO
        MODULATION = QAM/AUTO
        TRANSMISSION_MODE = AUTO
        GUARD_INTERVAL = AUTO
        HIERARCHY = NONE

The same entry without audio/video/service ID's (like the ones used 
by scan) would look like:

[CHANNEL]
        DELIVERY_SYSTEM = DVBT
        FREQUENCY = 479142857
        INVERSION = AUTO
        BANDWIDTH_HZ = 6000000
        CODE_RATE_HP = AUTO
        CODE_RATE_LP = AUTO
        MODULATION = QAM/AUTO
        TRANSMISSION_MODE = AUTO
        GUARD_INTERVAL = AUTO
        HIERARCHY = NONE

My next steps with regards to this tool are to:

1) convert a scan tool to use the same libraries as dvbzap is
   using, in order to generate an output file for scan with the same format;

2) to implement a parser for the new format (this should be easy, so maybe
   I'll start with this).

Comments, ideas, patches, etc are welcome.

Regards,
Mauro
