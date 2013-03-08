Return-path: <linux-media-owner@vger.kernel.org>
Received: from imr-ma06.mx.aol.com ([64.12.78.142]:44912 "EHLO
	imr-ma06.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564Ab3CHWnX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 17:43:23 -0500
Message-ID: <513A6968.4070803@netscape.net>
Date: Fri, 08 Mar 2013 19:42:48 -0300
From: =?UTF-8?B?QWxmcmVkbyBKZXPDunMgRGVsYWl0aQ==?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: mb86a20s and cx23885
References: <51054759.7050202@netscape.net> <20130127141633.5f751e5d@redhat.com> <5105A0C9.6070007@netscape.net> <20130128082354.607fae64@redhat.com> <5106E3EA.70307@netscape.net> <511264CF.3010002@netscape.net> <51336331.10205@netscape.net> <20130303134051.6dc038aa@redhat.com> <20130304164234.18df36a7@redhat.com> <51353591.4040709@netscape.net> <20130304233028.7bc3c86c@redhat.com>
In-Reply-To: <20130304233028.7bc3c86c@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

Sorry for late reply, it's because only I can do during my free time.


El 04/03/13 23:30, Mauro Carvalho Chehab escribió:
>> I test, but not work.
>>
>> Before the latest patches, obtained as follows, for example:
>>
>> dmesg
>> [  397.076641] mb86a20s: mb86a20s_read_status:
>> [  397.077129] mb86a20s: mb86a20s_read_status: val = X, status = 0xXX
> I did a cleanup at the printk messages. Also, the debug ones now use
> dynamic_printk. That means that they're disabled by default. They can
> be enabled in runtime (and per-line). If you want to enable all messages,
> you can do:
>
> To enable all debug messages on mb86a20s:
> 	echo "file drivers/media/dvb-frontends/mb86a20s.c +p" > /sys/kernel/debug/dynamic_debug/control
>
> To clean all debug messages
> 	echo "-p" > /sys/kernel/debug/dynamic_debug/control

I think I made something wrong, because I only get this:

/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:2089 
[mb86a20s]mb86a20s_attach =_ "%s called.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:2117 
[mb86a20s]mb86a20s_attach =_ "Frontend revision %d is unknown - 
aborting.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:1970 
[mb86a20s]mb86a20s_read_status_and_stats =_ "%s called.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:327 
[mb86a20s]mb86a20s_read_status =_ "%s: Status = 0x%02x (state = %d)\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:381 
[mb86a20s]mb86a20s_read_signal_strength =_ "%s: signal strength = %d (%d 
< RF=%d < %d)\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:526 
[mb86a20s]mb86a20s_reset_frontend_cache =_ "%s called.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:653 
[mb86a20s]mb86a20s_get_frontend =_ "%s called.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:671 
[mb86a20s]mb86a20s_get_frontend =_ "%s: getting data for layer %c.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:688 
[mb86a20s]mb86a20s_get_frontend =_ "%s: modulation %d.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:694 
[mb86a20s]mb86a20s_get_frontend =_ "%s: FEC %d.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:700 
[mb86a20s]mb86a20s_get_frontend =_ "%s: interleaving %d.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:503 
[mb86a20s]mb86a20s_get_segment_count =_ "%s called.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:516 
[mb86a20s]mb86a20s_get_segment_count =_ "%s: segments: %d.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:641 
[mb86a20s]mb86a20s_layer_bitrate =_ "%s: layer %c bitrate: %d kbps; 
counter = %d (0x%06x)\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:1605 
[mb86a20s]mb86a20s_get_stats =_ "%s called.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:1419 
[mb86a20s]mb86a20s_get_main_CNR =_ "%s: CNR is not available yet.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:1441 
[mb86a20s]mb86a20s_get_main_CNR =_ "%s: CNR is %d.%03d dB (%d)\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:1461 
[mb86a20s]mb86a20s_get_blk_error_layer_CNR =_ "%s called.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:1474 
[mb86a20s]mb86a20s_get_blk_error_layer_CNR =_ "%s: MER measures aren't 
available yet.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:1530 
[mb86a20s]mb86a20s_get_blk_error_layer_CNR =_ "%s: CNR for layer %c is 
%d.%03d dB (MER = %d).\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:829 
[mb86a20s]mb86a20s_get_pre_ber =_ "%s called.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:843 
[mb86a20s]mb86a20s_get_pre_ber =_ "%s: preBER for layer %c is not 
available yet.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:863 
[mb86a20s]mb86a20s_get_pre_ber =_ "%s: bit error before Viterbi for 
layer %c: %d.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:890 
[mb86a20s]mb86a20s_get_pre_ber =_ "%s: bit count before Viterbi for 
layer %c: %d.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:904 
[mb86a20s]mb86a20s_get_pre_ber =_ "%s: updating layer %c preBER counter 
to %d.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:963 
[mb86a20s]mb86a20s_get_post_ber =_ "%s called.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:977 
[mb86a20s]mb86a20s_get_post_ber =_ "%s: post BER for layer %c is not 
available yet.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:997 
[mb86a20s]mb86a20s_get_post_ber =_ "%s: post bit error for layer %c: 
%d.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:1018 
[mb86a20s]mb86a20s_get_post_ber =_ "%s: post bit count for layer %c: 
%d.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:1038 
[mb86a20s]mb86a20s_get_post_ber =_ "%s: updating postBER counter on 
layer %c to %d.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:1090 
[mb86a20s]mb86a20s_get_blk_error =_ "%s called.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:1108 
[mb86a20s]mb86a20s_get_blk_error =_ "%s: block counts for layer %c 
aren't available yet.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:1128 
[mb86a20s]mb86a20s_get_blk_error =_ "%s: block error for layer %c: %d.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:1148 
[mb86a20s]mb86a20s_get_blk_error =_ "%s: block count for layer %c: %d.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:1169 
[mb86a20s]mb86a20s_get_blk_error =_ "%s: updating PER counter on layer 
%c to %d.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:1560 
[mb86a20s]mb86a20s_stats_not_ready =_ "%s called.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:1895 
[mb86a20s]mb86a20s_set_frontend =_ "%s called.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:764 
[mb86a20s]mb86a20s_reset_counters =_ "%s called.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:2061 
[mb86a20s]mb86a20s_tune =_ "%s called.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:1782 
[mb86a20s]mb86a20s_initfe =_ "%s called.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:1840 
[mb86a20s]mb86a20s_initfe =_ "%s: fclk=%d, IF=%d, clock reg=0x%06llx\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:1858 
[mb86a20s]mb86a20s_initfe =_ "%s: IF=%d, IF reg=0x%06llx\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:1885 
[mb86a20s]mb86a20s_initfe =_ "Initialization succeeded.\012"
/home/alfredo/ISDB/Nuevo_Driver/git/media_build/v4l/mb86a20s.c:2076 
[mb86a20s]mb86a20s_release =_ "%s called.\012"

I have read dynamic-debug-howto.txt and I put the beginning on "GRUB!" 
the following:

dyndbg=mb86a20s or
dyndbg_query=mb86a20s or
mb86a20s.dyndbg="QUERY" or
dyndbg="QUERY"

But no change. Something I'm misinterpreting.

> To enable just the *ber* or *BER* ones:
> 	
> 	for i in $(cat /sys/kernel/debug/dynamic_debug/control|grep mb86a20s.c|grep -i ber|cut -d' ' -f 1|cut -d: -f2); do
> 		echo "file drivers/media/dvb-frontends/mb86a20s.c line $i +p" > /sys/kernel/debug/dynamic_debug/control
> 	done
>
>
>> and now, I don't get anything. But if I use VLC I get this:
>>
>>
>> dtvdebug: frontend status: 0x00
>>
>> dtvdebug: frontend status: 0x03
>>
>> dtvdebug: frontend status: 0x07
>>
>> dtvdebug: frontend status: 0x01
> Ok, that means that it is trying to sync Viterbi. You're better served if you
> use dvbv5-scan[1], instead, as it will provide you more information (eventually
> CNR - if it can keep status = 0x07 for a while, or if you have a zap file:
>
> $ dvbv5-zap -I zap  -c ~/isdb_channel.conf "globo 1seg"
> using demux '/dev/dvb/adapter0/demux0'
> reading channels from file '/home/mchehab/isdb_channel.conf'
> tuning to 485142857 Hz
> video pid 529
>    dvb_set_pesfilter 529
> audio pid 530
>    dvb_set_pesfilter 530
> RF     (0x01) Signal= 0.00%
> RF     (0x01) Signal= 0.00%
> RF     (0x01) Signal= 0.00%
> Carrier(0x03) Signal= 0.00%
> RF     (0x01) Signal= 0.00%
> RF     (0x01) Signal= 0.00%
> Lock   (0x1f) Quality= Poor Signal= 6.25% C/N= 15.57dB UCB= 96965 postBER= 0 preBER= 3.08x10^-3 PER= 1.00
> 	  Layer A: Quality= Poor C/N= 15.52dB UCB= 4064 postBER= 0 preBER= 3.08x10^-3 PER= 1.00
> 	  Layer B: C/N= 30.00dB

I get this:

alfredo@linux-puon:~> dvbv5-zap -I zap  -c ~/channels.conf "Encuentro"
using demux '/dev/dvb/adapter0/demux0'
reading channels from file '/home/alfredo/channels.conf'
CODE_RATE_HP (36) command not found during store
CODE_RATE_LP (37) command not found during store
MODULATION (4) command not found during store
HIERARCHY (40) command not found during store
tuning to 521142857 Hz
video pid 272
audio pid 273
status 01 | signal 0000 | snr ffff | ber 00000000 | unc 0000ffff |
status 01 | signal 0000 | snr ffff | ber 00000000 | unc 0000ffff |
status 01 | signal 0000 | snr ffff | ber 00000000 | unc 0000ffff |
status 07 | signal 0000 | snr ffff | ber 00000000 | unc 0000ffff |
status 01 | signal 0000 | snr ffff | ber 00000000 | unc 0000ffff |
status 01 | signal 0000 | snr ffff | ber 00000000 | unc 0000ffff |
status 01 | signal 0000 | snr ffff | ber 00000000 | unc 0000ffff |
status 01 | signal 0000 | snr ffff | ber 00000000 | unc 0000ffff |
status 01 | signal 0000 | snr ffff | ber 00000000 | unc 0000ffff |
status 03 | signal 0000 | snr ffff | ber 00000000 | unc 0000ffff |
status 01 | signal 0000 | snr ffff | ber 00000000 | unc 0000ffff |
status 01 | signal 0000 | snr ffff | ber 00000000 | unc 0000ffff |
status 01 | signal 0000 | snr ffff | ber 00000000 | unc 0000ffff |
status 01 | signal 0000 | snr ffff | ber 00000000 | unc 0000ffff |
status 01 | signal 0000 | snr ffff | ber 00000000 | unc 0000ffff |
status 01 | signal 0000 | snr ffff | ber 00000000 | unc 0000ffff |
^C
not good.
> I think I asked it already, but eventually, it is just antenna.

My antenna have visual contact with tower of transmission, is only 2 km 
away.

>
> The easiest way to discover is to enable the mb86a20s debug:
>
> [ 1443.564782] i2c i2c-3: mb86a20s_initfe: fclk=32571428, IF=4000000, clock reg=0x00ff80
> [ 1443.566781] i2c i2c-3: mb86a20s_initfe: IF=4000000, IF reg=0x3ee08f
>
> The IF here come from the tuner, via ops.get_if_frequency().
>
>
I made the following tests:

rmmod cx23885
rmmod mb86a20s
modprobe cx23885

and see the traffic of i2c. I made it five times, and got this:

1rm= first rmmod-modprobe
2rm= second rmmod-modprobe
...

"ef (x119)" means that "ef" is repeated 119 times

"E.b.l." means Error byte lenght

1rm    2rm    3rm    4rm    5rm
a0    a0    a0    a0    a0
00    00    00    00    00
a1    a1    a1    a1    a1
08    08    08    08    08
00    00    00    00    00
18    30    18    18    18
03    06    03    03    03
00    00    00    00    00
00    00    00    00    00
03    06    03    03    03
ff    fe    ff    ff    ff
20    40    20    20    20
00    00    00    00    00
13    26    13    13    13
00    00    00    00    00
00    00    00    00    00
00    00    00    00    00
00    00    00    00    00
00    00    00    00    00
20    40    20    40    20
00    00    00    00    00
13    26    30    26    13
00    00    00    00    00
00    00    00    00    00
00    00    00    00    00
00    00    00    00    00
20    00    01    00    20
00    40    00    40    00
13    00    00    00    13
00    26    30    26    00
00    00    00    00    00
00    00    00    00    00
00    00    00    00    00
00    00    00    00    00
40    00    02    00    20
00    40    00    40    00
26    00    01    00    13
00    26    60    26    00
00    00    00    00    00
00    00    00    00    00
00    00    00    00    00
00    00    00    00    00
40    00    02    00    40
00    40    00    40    00
26    00    01    00    26
00    26    60    4c    00
00    00    00    00    00
00    00    00    00    00
00    00    00    00    00
00    00    00    00    00
80    00    02    80    80
00    40    00    00    00
4c    00    01    4c    4c
00    26    60    00    00
00    00    00    00    00
00    00    00    00    00
00    00    00    00    00
00    00    00    00    00
00    00    02    80    80
00    40    00    00    00
98    00    01    4c    4c
00    26    60    00    00
00    00    00    00    00
00    00    00    00    00
00    00    00    00    00
00    00    00    00    00
00    00    02    80    80
00    40    00    00    00
98    00    01    4c    4c
00    26    60    00    00
00    00    00    00    00
00    00    00    00    00
00    00    00    00    00
00    00    00    80    00
00    00    02    00    80
98    40    00    4c    00
00    00    01    00    4c
00    26    60    00    00
00    00    00    00    00
00    00    00    20    00
00    00    00    00    00
40    00    00    60    00
00    00    00    0c    20
c0    10    00    00    00
18    00    01    00    60
00    30    00    0d    0c
00    06    60    74    00
1a    00    00    30    00
e8    00    00    0c    0d
60    06    69    14    74
18    3a    a0    00    30
60    18    80    38    0c
00    06    60    04    14
c0    0a    80    00    00
20    00    01    00    38
00    1c    80    80    04
02    04    40    00    00
00    00    00    4c    00
01    00    04    00    80
60    80    00    00    00
00    00    02    00    4c
00    4c    c0    00    00
00    00    00    00    00
00    00    00    40    00
05    00    00    0c    00
00    00    00    14    00
60    00    0a    00    40
a0    40    00    11    0c
00    0c    c0    00    14
88    14    40    00    00
00    00    00    20    11
00    11    10    b0    00
02    00    01    00    00
80    00    05    14    40
00    20    00    01    60
a0    b0    00    c4    00
0f    00    0f40    50    28
21    14    1e    09    03
80    01    Write to PCF8574    14    88
48    c4    40    30    a0
a0    50    24    0c    12
80    09    50    15    28
60    14    c0    00    60
a8    30    30    38    18
00    0c    54    04    2a
c0    15    00    00    00
20    00    e0    01    70
00    38    10    08    08
08    04    00    04    00
40    00    04    00    02
20    01    20    88    10
02    08    10    e0    10
47    04    01    00    01
00    00    26    00    23
00    88    80    01    80
00    e0    00    fd (x24)    00
0f    00    00    fb (x25)    00
ef (x119)    00    07    f9 (x41)    07
20    01    f7 (x46)    ef (x27)    f7 (x38)
00    fd (x48)    ef (x7)    E.b.l.    ef (x81)
21    fb (x70)    bf (x9)        20
13    20    7f (x37)        00
E.b.l.    21    ff (x20)        21
     13    E.b.l.        17
     E.b.l.    start        stop
         20
         00
         21
         17
         stop

My question: Why I not get every time the same?

First supposition: There is noise. I placed an oscilloscope and the 
noise level is below the i2c protocol standard.

Second supposition: The wrong takes logic analyzer waveform. No,the 
waveform of the oscilloscope and logic analyzer are equal.

Someone can explain me why?

Thanks,

Alfredo
