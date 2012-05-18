Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61470 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933136Ab2ERIjJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 May 2012 04:39:09 -0400
Received: by yenm10 with SMTP id m10so2590866yen.19
        for <linux-media@vger.kernel.org>; Fri, 18 May 2012 01:39:08 -0700 (PDT)
MIME-Version: 1.0
From: Niklas Brunlid <prefect47@gmail.com>
Date: Fri, 18 May 2012 10:38:48 +0200
Message-ID: <CABXDEG=PgB9bYUBN8XTPipEz1QJ__t4O8xTNH8kbfnD+fqhOgg@mail.gmail.com>
Subject: PCTV 290e with DVB-C on Fedora 16?
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

As seen in mythtv-users
(http://www.gossamer-threads.com/lists/mythtv/users/514948?search_string=290e;#514948)
and mythtv-dev (http://www.gossamer-threads.com/lists/mythtv/dev/514946?search_string=290e;#514946),
I'm trying to figure out why my PCTV 290e (which I use for DVB-C only)
stopped working when I upgraded to Fedora 16. It was most likely with
the switch to the new API (5.x)?

Some highlights from the thread(s):

---- begin cut ----

$ w_scan -A2 -fc -cSE -G -X |tee .czap/channels.conf
w_scan version 20120112 (compiled for DVB API 5.3)
using settings for SWEDEN
DVB cable
DVB-C
scan type CABLE, channellist 7
output format czap/tzap/szap/xine
WARNING: could not guess your codepage. Falling back to 'UTF-8'
output charset 'UTF-8', use -C <charset> to override
Info: using DVB adapter auto detection.
/dev/dvb/adapter0/frontend0 -> CABLE "Sony CXD2820R": very good :-))

Using CABLE frontend (adapter /dev/dvb/adapter0/frontend0)
-_-_-_-_ Getting frontend capabilities-_-_-_-_
Using DVB API 5.5
frontend 'Sony CXD2820R' supports
DVB-C2
INVERSION_AUTO
QAM_AUTO
FEC_AUTO
FREQ (45.00MHz ... 864.00MHz)
This dvb driver is *buggy*: the symbol rate limits are undefined - please
report to linuxtv.org
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
73000: sr6900 (time: 00:00) sr6875 (time: 00:05)


# modinfo cxd2820r
filename:
/lib/modules/3.3.2-6.fc16.x86_64/kernel/drivers/media/dvb/frontends/cxd2820r.ko
license: GPL
description: Sony CXD2820R demodulator driver
author: Antti Palosaari <crope [at] iki>
depends: i2c-core,dvb-core
intree: Y
vermagic: 3.3.2-6.fc16.x86_64 SMP mod_unload
parm: debug:Turn on/off frontend debugging (default:off). (int)

# uname -a
Linux u033 3.3.2-6.fc16.x86_64 #1 SMP Sat Apr 21 12:43:20 UTC 2012 x86_64
x86_64 x86_64 GNU/Linux

# ls -l /dev/dvb/adapter_290e/
total 0
lrwxrwxrwx 1 root root 18 May 1 15:32 demux0 -> ../adapter0/demux0
lrwxrwxrwx 1 root root 16 May 1 15:32 dvr0 -> ../adapter0/dvr0
lrwxrwxrwx 1 root root 21 May 1 15:32 frontend0 -> ../adapter0/frontend0
lrwxrwxrwx 1 root root 16 May 1 15:32 net0 -> ../adapter0/net0

# ls -l /dev/dvb/adapter0
total 0
crw-rw----+ 1 root video 212, 5 May 1 15:32 demux0
crw-rw----+ 1 root video 212, 6 May 1 15:32 dvr0
crw-rw----+ 1 root video 212, 4 May 1 15:32 frontend0
crw-rw----+ 1 root video 212, 7 May 1 15:32 net0

---- endcut ----




After trying dvb-fe-tool to force the card to DVB-C:

---- begin cut ----

Didn't help, unfortunately - mythtvsetup still complains:

2012-05-13 17:25:32.385665 E  FE_GET_INFO ioctl failed
(/dev/dvb/adapter0/frontend0)
  eno: No such device (19)
2012-05-13 17:25:33.865334 E  FE_GET_INFO ioctl failed
(/dev/dvb/adapter_290e/frontend0) eno: No such device (19)

The backend says:

2012-05-13 17:33:23.922804 I [9042/9059] TVRecEvent tv_rec.cpp:1014
(HandleStateChange) - TVRec(24): Changing from None to WatchingLiveTV
2012-05-13 17:33:23.926627 I [9042/9059] TVRecEvent tv_rec.cpp:3456
(TuningCheckForHWChange) - TVRec(24): HW Tuner: 24->24
2012-05-13 17:33:23.960061 N [9042/9042] CoreContext
autoexpire.cpp:263 (CalcParams) - AutoExpire: CalcParams(): Max
required Free Space: 2.0 GB w/freq: 14 min
2012-05-13 17:33:24.171394 E [9042/9164] DVBRead
dvbstreamhandler.cpp:626 (Open) -
PIDInfo(/dev/dvb/adapter_290e/frontend0): Failed to set TS filter (pid
0x0)


dvb-fe-tol says:

# dvb-fe-tool
Device Sony CXD2820R (/dev/dvb/adapter0/frontend0) capabilities:
        CAN_2G_MODULATION CAN_FEC_1_2 CAN_FEC_2_3 CAN_FEC_3_4
CAN_FEC_5_6 CAN_FEC_7_8 CAN_FEC_AUTO CAN_GUARD_INTERVAL_AUTO
CAN_HIERARCHY_AUTO CAN_INVERSION_AUTO CAN_MUTE_TS CAN_QAM_16
CAN_QAM_32 CAN_QAM_64 CAN_QAM_128 CAN_QAM_256 CAN_QAM_AUTO CAN_QPSK
CAN_TRANSMISSION_MODE_AUTO
DVB API Version 5.5, Current v5 delivery system: DVBC/ANNEX_A
Supported delivery systems: DVBT DVBT2 [DVBC/ANNEX_A]

...so the card should be set to DVB-C already, or at least a variant
of DVB-C. Is it possible that the kernel module simply doesn't
understand the v3 API? Or is v5 backwards compatible?

---- end cut ----

BR,
/ Niklas
