Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:54108 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbZLBN7N (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Dec 2009 08:59:13 -0500
Message-ID: <4B1672B6.3010700@diezwickers.de>
Date: Wed, 02 Dec 2009 14:59:18 +0100
From: Andreas Zwicker <dvb@diezwickers.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: TT S2-3200
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have problems with my new TT S2-3200 DVB-S2 cards. Tuning / scanning 
with scan-s2 / szap-s2 is fine ( well almost ). My two satellite dishes 
are directing towards Astra 19.2E / Astra 28.2E.
I'm using Debian Lenny with a custom build 2.6.31 kernel und dvb-s2 
drivers from the v4l-dvb repository.

The dvb channel scanner in mythtv 0.22 has massive locking problems. 
Most of the found channels are not tunable. Arte works almost, RTL is 
found but is not tunable.

Mythtv contains a so called signalmonitor. This signalmonitor checks 40 
times a second the status of the dvb frontend. I've patched the 
signalmonitor calls from 40 times to 2 times a second. With this patch, 
the channelscanner works und nearly all channels are tunable.

Where is the problem? My old Skystar 2 TV PCI DVB-S cards are running 
with no problem with the same system / software / dishes / coax cable 
and 40 Status calls a second.

thanks in advance for your advice,

Andreas
