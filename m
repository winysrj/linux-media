Return-path: <linux-media-owner@vger.kernel.org>
Received: from pmta2.delivery4.ore.mailhop.org ([54.200.247.200]:20563 "HELO
	pmta2.delivery4.ore.mailhop.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751003AbbFGWMj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Jun 2015 18:12:39 -0400
Message-ID: <5574BE16.8030906@transmitter.com>
Date: Sun, 07 Jun 2015 14:56:38 -0700
From: Doug Lung <dlung@transmitter.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: dlung0@gmail.com
Subject: Obtain both Si2157 and LGDT3306A signal stats from Hauppauge HVR955Q?
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello! this is my first post here, although I've benefited from all
the work of the contributors over the year. Thanks!

I'm looking for help getting similar signal statistics from the new
Hauppauge HVR955Q (Si2157, LGDT3306A, CX23102) USB ATSC tuner that
I'm now getting from the Hauppauge Aero-M (MxL111SF, LGDT3305). I'm
currently using DVBv3 API but am open to switching to DVBv5 API if
necessary.

I applied Antti Palosaari's "si2157: implement signal strength stats"
patch to the media_build.  With the patch, dvb-fe-tool with dvbv5-zap
returns relatively accurate RSSI data in dBm in 1 dB steps from the
HVR955Q but no SNR or packet error data. dvb-fe-tool provides a full
set of data (unformatted) from the Aero-M but only Lock and RSSI
(formatted in dBm) from the HVR955Q.

The SNR and packet error data is available from the HVR955Q in raw
form in DVBv3 applications like femon. The Si2157 RSSI in dBm is not.
The DVBv3 apps show the "signal quality" data from lgdt3306a.c based
on SNR margin above threshold.

Any suggestions on how to modify the HVR955Q driver to provide RSSI
(unformatted is okay) from the Si2157 in its DVBv3 statistics? That's
preferred since it will work with the programs I wrote with ZapLib
and pyZap bindings for use with the Aero-M.

Alternatively, is there a way to obtain full DVBv5 API compliant signal
quality data (RSSI, SNR, uncorrected packets) from the HVR955Q's
LGDT3306A so I can modify my programs to use the linuxdvb.py API v5.1
bindings? That would be the best long term solution, although more work
for me and perhaps the LGDT3306A maintainer.

       ...Doug
