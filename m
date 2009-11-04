Return-path: <linux-media-owner@vger.kernel.org>
Received: from kelvin.aketzu.net ([81.22.244.161]:49739 "EHLO
	kelvin.aketzu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803AbZKDRRB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2009 12:17:01 -0500
Date: Wed, 4 Nov 2009 19:08:44 +0200
From: Anssi Kolehmainen <anssi@aketzu.net>
To: henrik@kurelid.se, linux-media@vger.kernel.org
Subject: Firedtv stops working after a while
Message-ID: <20091104170844.GB18091@aketzu.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have Firedtv DVB-C/CI adapter and for some reason it stops working
after a while. Typically it takes something like 5 hours (which makes
debugging fun).  I have vdr 1.7.9 as the dvb viewer (with xine plugin),
kernel 2.6.31 x86_64, latest v4l-dvb drivers from hg and the few
remaining patches from firesat.kurelid.se.

Vdr spews following to syslog [1]:
Nov  4 03:00:42 maxwell vdr: [26241] frontend 0 timed out while tuning to channel 400, tp 266
Nov  4 03:13:35 maxwell vdr: [26242] ERROR: can't set filter (pid=18, tid=40, mask=C0): Input/output error
Nov  4 03:13:36 maxwell vdr: [26241] frontend 0 lost lock on channel 180, tp 322
Nov  4 03:13:37 maxwell vdr: [26242] ERROR: can't set filter (pid=0, tid=00, mask=FF): Input/output error
Nov  4 03:13:39 maxwell vdr: [26241] frontend 0 timed out while tuning to channel 180, tp 322
Nov  4 03:13:40 maxwell vdr: [26241] frontend 0 regained lock on channel 180, tp 322
Nov  4 03:13:52 maxwell vdr: [26242] ERROR: can't set filter (pid=16, tid=40, mask=FF): Device or resource busy
Nov  4 03:13:52 maxwell vdr: [26242] ERROR: can't set filter (pid=3306, tid=02, mask=FF): Device or resource busy
Nov  4 03:13:53 maxwell vdr: [26242] ERROR: can't set filter (pid=3306, tid=02, mask=FF): Device or resource busy

whereas kernel says [2]:
<3>[548957.448338] firedtv 0012870036002e6f-0: FCP response timed out
<3>[548957.448343] firedtv 0012870036002e6f-0: can't set PIDs
<4>[548974.380505] DVB (dvb_dmxdev_filter_start): could not alloc feed
<4>[548974.380864] DVB (dvb_dmxdev_filter_start): could not alloc feed
 + lots of fancy FCP communication debugging thanks to firedtv debug=-1

Kernel-time 548975 corresponds with real time 03:13:35. Computer
start was at 1256748240. I had to log kernel messages to separate file
so it wouldn't eat all space with syslog files.

Trivial workaround is to rmmod firedtv + modprobe firedtv but it is
rather annoying.  The freeze might be connected to vdr doing EPG scan
and trying to check all channels but manually triggering that scan
doesn't cause any malfunctions.

Any ideas what I should try?

1: http://aketzu.net/firedtv-syslog.bz2
2: http://aketzu.net/firedtv-kmsg.bz2 (206M uncompressed, 14M compressed)

-- 
Anssi Kolehmainen
anssi.kolehmainen@iki.fi
040-5085390
