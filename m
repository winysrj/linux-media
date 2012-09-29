Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55984 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142Ab2I2Tev (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Sep 2012 15:34:51 -0400
Received: by obbuo13 with SMTP id uo13so3901890obb.19
        for <linux-media@vger.kernel.org>; Sat, 29 Sep 2012 12:34:50 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?Q?Ladislav_J=C3=B3zsa?= <l.jozsa@gmail.com>
Date: Sat, 29 Sep 2012 21:34:30 +0200
Message-ID: <CAJEuUsudgQHSktrDwHfELcUC0PMiRHmSw8S8buLcOGUFBqJ9Jw@mail.gmail.com>
Subject: DiBcom 7000PC: Not able to scan for services on Raspberry Pi
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm having issues with tvheadend with Pinnacle PCTV 73e (DiBcom
7000PC), firmware dvb-usb-dib0700-1.20.fw. I'm trying to run it on
Raspberry Pi, I have cloned the latest compose from git. When scanning
for services I'm getting errors

Sep 29 18:37:45 [ERROR]:dvb: "/dev/dvb/adapter0" tuning to "586,000
kHz" -- Front configuration failed -- No such device, frequency:
586000000
Sep 29 18:38:05 [DEBUG]:dvb: "/dev/dvb/adapter0" tuning to "570,000
kHz" (Initial autoscan)
Sep 29 18:38:05 [ERROR]:dvb: "/dev/dvb/adapter0" tuning to "570,000
kHz" -- Front configuration failed -- No such device, frequency:
570000000
Sep 29 18:38:25 [DEBUG]:dvb: "/dev/dvb/adapter0" tuning to "562,000
kHz" (Initial autoscan)
Sep 29 18:38:25 [ERROR]:dvb: "/dev/dvb/adapter0" tuning to "562,000
kHz" -- Front configuration failed -- No such device, frequency:
562000000
Sep 29 18:38:45 [DEBUG]:dvb: "/dev/dvb/adapter0" tuning to "538,000
kHz" (Initial autoscan)
Sep 29 18:38:45 [ERROR]:dvb: "/dev/dvb/adapter0" tuning to "538,000
kHz" -- Front configuration failed -- No such device, frequency:
538000000

root@raspbmc:~# uname -a
Linux raspbmc 3.2.27 #1 PREEMPT Fri Sep 28 19:36:30 UTC 2012 armv6l GNU/Linux

According to tvheadebd developers this might be bug in the driver.
Relevant output from strace:

rt_sigprocmask(SIG_BLOCK, [CHLD], ~[INT KILL TERM STOP RTMIN RT_1], 8) = 0
nanosleep({1, 0}, Sep 29 21:31:26 [NOTICE]:dvb: New mux "522,000 kHz"
created by built-in configuration from "dvb-t_sk_Bratislava"
0xbeca85a0)           = 0
wait4(-1, 0xbeca85a4, WNOHANG, NULL)    = -1 ECHILD (No child processes)
gettimeofday({1348947087, 490961}, NULL) = 0
gettimeofday({1348947087, 492256}, NULL) = 0
gettimeofday({1348947087, 493494}, NULL) = 0
futex(0x7e77c, FUTEX_CMP_REQUEUE_PRIVATE, 1, 2147483647, 0x7e758, 20) = 1
futex(0x7e758, FUTEX_WAKE_PRIVATE, 1)   = 1
ioctl(4, 0x40246f4c, 0xbeca8518)        = -1 ENODEV (No such device)
gettimeofday({1348947087, 500534}, NULL) = 0
send(5, "<27>Sep 29 21:31:27 tvheadend[26"..., 155, MSG_NOSIGNAL) = 155
gettimeofday({1348947087, 506172}, NULL) = 0
write(2, "\33[31mSep 29 21:31:27 [ERROR]:dvb"..., 152Sep 29 21:31:27
[ERROR]:dvb: "/dev/dvb/adapter0" tuning to "522,000 kHz" -- Front
configuration failed -- No such device, frequency: 522000000
) = 152
gettimeofday({1348947087, 509301}, NULL) = 0
stat64("/home", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
stat64("/home/pi", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
stat64("/home/pi/.hts", {st_mode=S_IFDIR|0700, st_size=4096, ...}) = 0
stat64("/home/pi/.hts/tvheadend", {st_mode=S_IFDIR|0700, st_size=4096, ...}) = 0
stat64("/home/pi/.hts/tvheadend/dvbmuxes", {st_mode=S_IFDIR|0700,
st_size=4096, ...}) = 0
stat64("/home/pi/.hts/tvheadend/dvbmuxes/_dev_dvb_adapter0_DiBcom_7000PC",
{st_mode=S_IFDIR|0700, st_size=4096, ...}) = 0
open("/home/pi/.hts/tvheadend/dvbmuxes/_dev_dvb_adapter0_DiBcom_7000PC/_dev_dvb_adapter0_DiBcom_7000PC522000000.tmp",
O_RDWR|O_CREAT|O_TRUNC|O_LARGEFILE, 0700) = 8
fcntl64(8, F_GETFD)                     = 0
fcntl64(8, F_SETFD, FD_CLOEXEC)         = 0
write(8, "{\n\t\"quality\": 100,\n\t\"enabled\": 0"..., 292) = 292
close(8)                                = 0
rename("/home/pi/.hts/tvheadend/dvbmuxes/_dev_dvb_adapter0_DiBcom_7000PC/_dev_dvb_adapter0_DiBcom_7000PC522000000.tmp",
"/home/pi/.hts/tvheadend/dvbmuxes/_dev_dvb_adapter0_DiBcom_7000PC/_dev_dvb_adapter0_DiBcom_7000PC522000000")
= 0
rt_sigprocmask(SIG_BLOCK, [CHLD], ~[INT KILL TERM STOP RTMIN RT_1], 8) = 0
nanosleep({1, 0}, 0xbeca85a0)           = 0
wait4(-1, 0xbeca85a4, WNOHANG, NULL)    = -1 ECHILD (No child processes)
gettimeofday({1348947088, 552736}, NULL) = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], ~[INT KILL TERM STOP RTMIN RT_1], 8) = 0
nanosleep({1, 0}, 0xbeca85a0)           = 0
wait4(-1, 0xbeca85a4, WNOHANG, NULL)    = -1 ECHILD (No child processes)
gettimeofday({1348947089, 558271}, NULL) = 0
gettimeofday({1348947089, 559518}, NULL) = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], ~[INT KILL TERM STOP RTMIN RT_1], 8) = 0
nanosleep({1, 0}, ^C <unfinished ...>

Additionally after termination of tvheadend I got following output on console:

pi@raspbmc:~$ Sep 29 21:31:30 [INFO]:epgdb: saved
Sep 29 21:31:30 [INFO]:epgdb:   brands     0
Sep 29 21:31:30 [INFO]:epgdb:   seasons    0
Sep 29 21:31:30 [INFO]:epgdb:   episodes   0
Sep 29 21:31:30 [INFO]:epgdb:   broadcasts 0
Sep 29 21:31:30 [NOTICE]:STOP: Exiting HTS Tvheadend

Message from syslogd@raspbmc at Sep 29 21:31:30 ...
 kernel:Internal error: Oops: 80000005 [#1] PREEMPT

Message from syslogd@raspbmc at Sep 29 21:31:30 ...
 kernel:Process tvheadend (pid: 2632, stack limit = 0xc2daa268)

Message from syslogd@raspbmc at Sep 29 21:31:30 ...
 kernel:Stack: (0xc2dabe80 to 0xc2dac000)

Message from syslogd@raspbmc at Sep 29 21:31:30 ...
 kernel:be80: bf01aca0 c77c50e8 00000008 c65fb940 00000000 c74cb5d8
c2dabedc c2dabea8

Message from syslogd@raspbmc at Sep 29 21:31:30 ...
 kernel:bea0: c00a29d8 bf01acac 00000000 00000000 c2dabef4 c65fb940
c7a74d60 00000000

Message from syslogd@raspbmc at Sep 29 21:31:30 ...
 kernel:bec0: 00000010 c7a74d60 c2daa000 00000000 c2dabefc c2dabee0
c009ef70 c00a2920

Message from syslogd@raspbmc at Sep 29 21:31:30 ...
 kernel:bee0: c65fb940 00000000 00c0cfff c7a74d68 c2dabf24 c2dabf00
c00269a0 c009ef10

Message from syslogd@raspbmc at Sep 29 21:31:30 ...
 kernel:bf00: c7a74d60 c7b9fd60 40519774 000000f8 c000efe8 c2daa000
c2dabf3c c2dabf28

Message from syslogd@raspbmc at Sep 29 21:31:30 ...
 kernel:bf20: c0028054 c0026930 00000000 00000000 c2dabf7c c2dabf40
c0028738 c0027fec

Message from syslogd@raspbmc at Sep 29 21:31:30 ...
 kernel:bf40: c2daa000 00000100 c2dabf6c 00000001 c03d7788 c03d70f4
60000013 00000000

Message from syslogd@raspbmc at Sep 29 21:31:30 ...
 kernel:bf60: c2dabf7c c2dabf70 c03d77d8 000000f8 c2dabf94 c2dabf80
c0028930 c002806c

Message from syslogd@raspbmc at Sep 29 21:31:30 ...
 kernel:bf80: 00089884 40519774 c2dabfa4 c2dabf98 c00289d0 c00288f8
00000000 c2dabfa8

Message from syslogd@raspbmc at Sep 29 21:31:30 ...
 kernel:bfa0: c000efb8 c00289c4 00089884 40519774 00000000 00089864
00000008 00000000

Message from syslogd@raspbmc at Sep 29 21:31:30 ...
 kernel:bfc0: 00089884 40519774 40519774 000000f8 00000000 00000000
4008f000 00000000

Message from syslogd@raspbmc at Sep 29 21:31:30 ...
 kernel:bfe0: ffffffff beca86b0 4042b294 40491814 60000010 00000000
4020b148 4020ab24

Message from syslogd@raspbmc at Sep 29 21:31:30 ...
 kernel:Code: bad PC value
^C

Running the same on my x86_64 machine works and tvheadend sees
multiplexes. What else information do you need from me in order to
track the problem?

Thanks,
Ladislav
