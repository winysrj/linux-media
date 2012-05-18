Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62731 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab2ERU2N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 May 2012 16:28:13 -0400
Received: by yenm10 with SMTP id m10so3245805yen.19
        for <linux-media@vger.kernel.org>; Fri, 18 May 2012 13:28:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FB64833.2040206@iki.fi>
References: <CABXDEG=PgB9bYUBN8XTPipEz1QJ__t4O8xTNH8kbfnD+fqhOgg@mail.gmail.com>
 <4FB64833.2040206@iki.fi>
From: Niklas Brunlid <prefect47@gmail.com>
Date: Fri, 18 May 2012 22:27:52 +0200
Message-ID: <CABXDEGm4Ret0x1oWdA2Mmzhf2z8ry3CE9B8rJvg6G_HM5+h4sA@mail.gmail.com>
Subject: Re: PCTV 290e with DVB-C on Fedora 16?
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18 May 2012 15:01, Antti Palosaari <crope@iki.fi> wrote:
> On 18.05.2012 11:38, Niklas Brunlid wrote:
>
> That whole issues is related of MFE (multi-frontend) => SFE
> (single-frontend) change.

Yes, that I have understood. But from the threads on the MythTV lists
below, it seems at least one user has one or more 290e sticks running
fine in DVB-T (or T2) mode. Although that was on Ubuntu IIRC.

> And there is still known issues like only one frontend parameters, as we
> still have three different delivery systems.... Due to that currently
> applications should not trust parameters frontend is advertising. Only valid
> parameter is supported delivery systems.
>
> Needless to say it took about one week for me to fix all cxd2820r bugs after
> that...
>
>
>> As seen in mythtv-users
>>
>> (http://www.gossamer-threads.com/lists/mythtv/users/514948?search_string=290e;#514948)
>> and mythtv-dev
>> (http://www.gossamer-threads.com/lists/mythtv/dev/514946?search_string=290e;#514946),
>> I'm trying to figure out why my PCTV 290e (which I use for DVB-C only)
>> stopped working when I upgraded to Fedora 16. It was most likely with
>> the switch to the new API (5.x)?
>>
>> Some highlights from the thread(s):
>>
>> ---- begin cut ----
>>
>> $ w_scan -A2 -fc -cSE -G -X |tee .czap/channels.conf
>> w_scan version 20120112 (compiled for DVB API 5.3)
>
>
> w_scan version 20120112 (compiled for DVB API 5.3)
>
>> using settings for SWEDEN
>> DVB cable
>> DVB-C
>> scan type CABLE, channellist 7
>> output format czap/tzap/szap/xine
>> WARNING: could not guess your codepage. Falling back to 'UTF-8'
>> output charset 'UTF-8', use -C<charset>  to override
>> Info: using DVB adapter auto detection.
>> /dev/dvb/adapter0/frontend0 ->  CABLE "Sony CXD2820R": very good :-))
>>
>> Using CABLE frontend (adapter /dev/dvb/adapter0/frontend0)
>> -_-_-_-_ Getting frontend capabilities-_-_-_-_
>> Using DVB API 5.5
>> frontend 'Sony CXD2820R' supports
>> DVB-C2
>> INVERSION_AUTO
>> QAM_AUTO
>> FEC_AUTO
>> FREQ (45.00MHz ... 864.00MHz)
>> This dvb driver is *buggy*: the symbol rate limits are undefined - please
>> report to linuxtv.org
>> -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
>> 73000: sr6900 (time: 00:00) sr6875 (time: 00:05)
>
>
> w_scan works? At least for me.

It was some time since I actually ran it. I'll have to try again
tomorrow as the backend is currently recording, and MythTV seems to
tie up the device even though it is not connected with any input in
mythtvsetup...

>
>
>> After trying dvb-fe-tool to force the card to DVB-C:
>>
>> ---- begin cut ----
>>
>> Didn't help, unfortunately - mythtvsetup still complains:
>>
>> 2012-05-13 17:25:32.385665 E  FE_GET_INFO ioctl failed
>> (/dev/dvb/adapter0/frontend0)
>>   eno: No such device (19)
>
>
> I looked frontend code and I do not see where that error is coming.
> Maybe there is no such file at all?

The file is there, as seen in the ls output I posted. And dvb-fe-tool
complains when mythbackend is running:

# dvb-fe-tool
Device or resource busy while opening /dev/dvb/adapter0/frontend0

# lsusb
...
Bus 006 Device 002: ID 2013:024f Unknown (Pinnacle?)
...

# dmesg:
...
[    1.996623] usb 6-1: Product: PCTV 290e
[    1.996625] usb 6-1: Manufacturer: PCTV Systems
[    1.996627] usb 6-1: SerialNumber: 00000006LG6C
...
[    3.130872] Linux video capture interface: v2.00
...
[    3.136301] em28xx: New device PCTV Systems PCTV 290e @ 480 Mbps
(2013:024f, interface 0, class 0)
[    3.136304] em28xx: DVB interface 0 found
[    3.137792] em28xx #0: chip ID is em28174
...
[    3.436262] em28xx #0: Identified as PCTV nanoStick T2 290e (card=78)
...
[    3.460535] Registered IR keymap rc-pinnacle-pctv-hd
[    3.460579] input: em28xx IR (em28xx #0) as
/devices/pci0000:00/0000:00:1c.4/0000:03:00.0/usb6/6-1/rc/rc0/input13
[    3.460613] rc0: em28xx IR (em28xx #0) as
/devices/pci0000:00/0000:00:1c.4/0000:03:00.0/usb6/6-1/rc/rc0
[    3.461994] em28xx #0: v4l2 driver version 0.1.3
...
[    3.477657] em28xx #0: V4L2 video device registered as video0
[    3.478407] usbcore: registered new interface driver em28xx
[    3.480313] tea5767 1-0060: type set to Philips TEA5767HN FM Radio
...

[    3.772161] DVB: registering new adapter (em28xx #0)
[    3.772165] DVB: registering adapter 0 frontend 0 (Sony CXD2820R)...
[    3.772623] em28xx #0: Successfully loaded em28xx-dvb
[    3.772627] Em28xx: Initialized (Em28xx dvb Extension) extension
[    3.987489] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
...

The system also has a Hauppauhe PVR350 and a Hauppage Nova-T 500, in
case that's relevant. The Nova works fine, although the reception is
poor (70%) which is why I got the 290e for DVB-C. :)

BTW, I see firmware being loaded for the Hauppauge devices. Is the
same needed for the PCTV 290e?


>> 2012-05-13 17:25:33.865334 E  FE_GET_INFO ioctl failed
>> (/dev/dvb/adapter_290e/frontend0) eno: No such device (19)
>
>
> "/adapter_290e/" something unusual.

It's created by my udev rules:

# Create a symlink to the DVB-C tuners of the PCTV 290e
SUBSYSTEM=="dvb", ATTRS{manufacturer}=="PCTV Systems",
ATTRS{product}=="PCTV 290e", ATTRS{serial}=="00000006LG6C",\
 PROGRAM="/bin/sh -c 'K=%k; K=$${K#dvb}; printf dvb/adapter_290e/%%s
$${K#*.}'",\
 SYMLINK+="%c"

I use this since I have multiple DVB devices which can move around at
reboot, which confuses mythbackend somewhat. :)

>
>
>> The backend says:
>>
>> 2012-05-13 17:33:23.922804 I [9042/9059] TVRecEvent tv_rec.cpp:1014
>> (HandleStateChange) - TVRec(24): Changing from None to WatchingLiveTV
>> 2012-05-13 17:33:23.926627 I [9042/9059] TVRecEvent tv_rec.cpp:3456
>> (TuningCheckForHWChange) - TVRec(24): HW Tuner: 24->24
>> 2012-05-13 17:33:23.960061 N [9042/9042] CoreContext
>> autoexpire.cpp:263 (CalcParams) - AutoExpire: CalcParams(): Max
>> required Free Space: 2.0 GB w/freq: 14 min
>> 2012-05-13 17:33:24.171394 E [9042/9164] DVBRead
>> dvbstreamhandler.cpp:626 (Open) -
>> PIDInfo(/dev/dvb/adapter_290e/frontend0): Failed to set TS filter (pid
>> 0x0)
>>
>>
>> dvb-fe-tol says:
>>
>> # dvb-fe-tool
>> Device Sony CXD2820R (/dev/dvb/adapter0/frontend0) capabilities:
>>         CAN_2G_MODULATION CAN_FEC_1_2 CAN_FEC_2_3 CAN_FEC_3_4
>> CAN_FEC_5_6 CAN_FEC_7_8 CAN_FEC_AUTO CAN_GUARD_INTERVAL_AUTO
>> CAN_HIERARCHY_AUTO CAN_INVERSION_AUTO CAN_MUTE_TS CAN_QAM_16
>> CAN_QAM_32 CAN_QAM_64 CAN_QAM_128 CAN_QAM_256 CAN_QAM_AUTO CAN_QPSK
>> CAN_TRANSMISSION_MODE_AUTO
>> DVB API Version 5.5, Current v5 delivery system: DVBC/ANNEX_A
>> Supported delivery systems: DVBT DVBT2 [DVBC/ANNEX_A]
>>
>> ...so the card should be set to DVB-C already, or at least a variant
>> of DVB-C. Is it possible that the kernel module simply doesn't
>> understand the v3 API? Or is v5 backwards compatible?
>>
>> ---- end cut ----
>
>
> I am using Fedora 16 and latest development Kernel. VLC, czap, w_scan, etc.
> are working fine.
>
> regards
> Antti
> --
> http://palosaari.fi/
