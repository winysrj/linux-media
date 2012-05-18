Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58047 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759986Ab2ERNBl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 May 2012 09:01:41 -0400
Message-ID: <4FB64833.2040206@iki.fi>
Date: Fri, 18 May 2012 16:01:39 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Niklas Brunlid <prefect47@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: PCTV 290e with DVB-C on Fedora 16?
References: <CABXDEG=PgB9bYUBN8XTPipEz1QJ__t4O8xTNH8kbfnD+fqhOgg@mail.gmail.com>
In-Reply-To: <CABXDEG=PgB9bYUBN8XTPipEz1QJ__t4O8xTNH8kbfnD+fqhOgg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18.05.2012 11:38, Niklas Brunlid wrote:

That whole issues is related of MFE (multi-frontend) => SFE 
(single-frontend) change.
And there is still known issues like only one frontend parameters, as we 
still have three different delivery systems.... Due to that currently 
applications should not trust parameters frontend is advertising. Only 
valid parameter is supported delivery systems.

Needless to say it took about one week for me to fix all cxd2820r bugs 
after that...

> As seen in mythtv-users
> (http://www.gossamer-threads.com/lists/mythtv/users/514948?search_string=290e;#514948)
> and mythtv-dev (http://www.gossamer-threads.com/lists/mythtv/dev/514946?search_string=290e;#514946),
> I'm trying to figure out why my PCTV 290e (which I use for DVB-C only)
> stopped working when I upgraded to Fedora 16. It was most likely with
> the switch to the new API (5.x)?
>
> Some highlights from the thread(s):
>
> ---- begin cut ----
>
> $ w_scan -A2 -fc -cSE -G -X |tee .czap/channels.conf
> w_scan version 20120112 (compiled for DVB API 5.3)

w_scan version 20120112 (compiled for DVB API 5.3)

> using settings for SWEDEN
> DVB cable
> DVB-C
> scan type CABLE, channellist 7
> output format czap/tzap/szap/xine
> WARNING: could not guess your codepage. Falling back to 'UTF-8'
> output charset 'UTF-8', use -C<charset>  to override
> Info: using DVB adapter auto detection.
> /dev/dvb/adapter0/frontend0 ->  CABLE "Sony CXD2820R": very good :-))
>
> Using CABLE frontend (adapter /dev/dvb/adapter0/frontend0)
> -_-_-_-_ Getting frontend capabilities-_-_-_-_
> Using DVB API 5.5
> frontend 'Sony CXD2820R' supports
> DVB-C2
> INVERSION_AUTO
> QAM_AUTO
> FEC_AUTO
> FREQ (45.00MHz ... 864.00MHz)
> This dvb driver is *buggy*: the symbol rate limits are undefined - please
> report to linuxtv.org
> -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
> 73000: sr6900 (time: 00:00) sr6875 (time: 00:05)

w_scan works? At least for me.

> After trying dvb-fe-tool to force the card to DVB-C:
>
> ---- begin cut ----
>
> Didn't help, unfortunately - mythtvsetup still complains:
>
> 2012-05-13 17:25:32.385665 E  FE_GET_INFO ioctl failed
> (/dev/dvb/adapter0/frontend0)
>    eno: No such device (19)

I looked frontend code and I do not see where that error is coming.
Maybe there is no such file at all?

> 2012-05-13 17:25:33.865334 E  FE_GET_INFO ioctl failed
> (/dev/dvb/adapter_290e/frontend0) eno: No such device (19)

"/adapter_290e/" something unusual.

> The backend says:
>
> 2012-05-13 17:33:23.922804 I [9042/9059] TVRecEvent tv_rec.cpp:1014
> (HandleStateChange) - TVRec(24): Changing from None to WatchingLiveTV
> 2012-05-13 17:33:23.926627 I [9042/9059] TVRecEvent tv_rec.cpp:3456
> (TuningCheckForHWChange) - TVRec(24): HW Tuner: 24->24
> 2012-05-13 17:33:23.960061 N [9042/9042] CoreContext
> autoexpire.cpp:263 (CalcParams) - AutoExpire: CalcParams(): Max
> required Free Space: 2.0 GB w/freq: 14 min
> 2012-05-13 17:33:24.171394 E [9042/9164] DVBRead
> dvbstreamhandler.cpp:626 (Open) -
> PIDInfo(/dev/dvb/adapter_290e/frontend0): Failed to set TS filter (pid
> 0x0)
>
>
> dvb-fe-tol says:
>
> # dvb-fe-tool
> Device Sony CXD2820R (/dev/dvb/adapter0/frontend0) capabilities:
>          CAN_2G_MODULATION CAN_FEC_1_2 CAN_FEC_2_3 CAN_FEC_3_4
> CAN_FEC_5_6 CAN_FEC_7_8 CAN_FEC_AUTO CAN_GUARD_INTERVAL_AUTO
> CAN_HIERARCHY_AUTO CAN_INVERSION_AUTO CAN_MUTE_TS CAN_QAM_16
> CAN_QAM_32 CAN_QAM_64 CAN_QAM_128 CAN_QAM_256 CAN_QAM_AUTO CAN_QPSK
> CAN_TRANSMISSION_MODE_AUTO
> DVB API Version 5.5, Current v5 delivery system: DVBC/ANNEX_A
> Supported delivery systems: DVBT DVBT2 [DVBC/ANNEX_A]
>
> ...so the card should be set to DVB-C already, or at least a variant
> of DVB-C. Is it possible that the kernel module simply doesn't
> understand the v3 API? Or is v5 backwards compatible?
>
> ---- end cut ----

I am using Fedora 16 and latest development Kernel. VLC, czap, w_scan, 
etc. are working fine.

regards
Antti
-- 
http://palosaari.fi/
