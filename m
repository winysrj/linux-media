Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:36522 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab2AKJVI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 04:21:08 -0500
Received: by werm1 with SMTP id m1so347880wer.19
        for <linux-media@vger.kernel.org>; Wed, 11 Jan 2012 01:21:05 -0800 (PST)
Message-ID: <4F0D547D.7040105@gmail.com>
Date: Wed, 11 Jan 2012 10:21:01 +0100
From: Fredrik Lingvall <fredrik.lingvall@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Mihai Dobrescu <msdobrescu@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Hauppauge HVR-930C problems
References: <CALJK-QhGrjC9K8CasrUJ-aisZh8U_4-O3uh_-dq6cNBWUx_4WA@mail.gmail.com> <4EE9AA21.1060101@gmail.com> <CALJK-QjxDpC8Y_gPXeAJaT2si_pRREiuTW=T8CWSTxGprRhfkg@mail.gmail.com> <4EEAFF47.5040003@gmail.com> <CALJK-Qhpk7NtSezrft_6+4FZ7Y35k=41xrc6ebxf2DzEH6KCWw@mail.gmail.com> <4EECB2C2.8050701@gmail.com> <4EECE392.5080000@gmail.com> <CALJK-QjChFbX7NH0qNhvaz=Hp8JfKENJMsLOsETiYO9ZyV_BOg@mail.gmail.com> <4EEDB060.7070708@gmail.com> <4EF747C7.10001@gmail.com> <4F0C4E59.6050503@gmail.com>
In-Reply-To: <4F0C4E59.6050503@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/10/12 15:42, Fredrik Lingvall wrote:
> On 12/25/11 16:56, Fredrik Lingvall wrote:
>> On 12/18/11 10:20, Fredrik Lingvall wrote:
>>> On 12/17/11 20:53, Mihai Dobrescu wrote:
>>>>
>>>>
>>>>
>>>> Mihai,
>>>>
>>>> I got some success. I did this,
>>>>
>>>> # cd /usr/src (for example)
>>>>
>>>> # git clone git://linuxtv.org/media_build.git
>>>>
>>>> # emerge dev-util/patchutils
>>>> # emerge Proc-ProcessTable
>>>>
>>>> # cd media_build
>>>> # ./build
>>>> # make install
>>>>
>>>> Which will install the latest driver on your running kernel (just 
>>>> in case
>>>> make sure /usr/src/linux points to your running kernel sources). Then
>>>> reboot.
>>>>
>>>> You should now see that (among other) modules have loaded:
>>>>
>>>> # lsmod
>>>>
>>>> <snip>
>>>>
>>>> em28xx                 93528  1 em28xx_dvb
>>>> v4l2_common             5254  1 em28xx
>>>> videobuf_vmalloc        4167  1 em28xx
>>>> videobuf_core          15151  2 em28xx,videobuf_vmalloc
>>>>
>>>> Then try w_scan and dvbscan etc. I got mythtv to scan too now. 
>>>> There were
>>>> some warnings and timeouts and I'm not sure if this is normal or not.
>>>>
>>>> You can also do a dmesg -c while scanning to monitor the changes en 
>>>> the
>>>> kernel log.
>>>>
>>>> Regards,
>>>>
>>>> /Fredrik
>>>>
>>>>
>>>> In my case I have:
>>>>
>>>> lsmod |grep em2
>>>> em28xx_dvb             12608  0
>>>> dvb_core               76187  1 em28xx_dvb
>>>> em28xx                 82436  1 em28xx_dvb
>>>> v4l2_common             5087  1 em28xx
>>>> videodev               70123  2 em28xx,v4l2_common
>>>> videobuf_vmalloc        3783  1 em28xx
>>>> videobuf_core          12991  2 em28xx,videobuf_vmalloc
>>>> rc_core                11695  11
>>>> rc_hauppauge,ir_lirc_codec,ir_mce_kbd_decoder,ir_sanyo_decoder,ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,ir_rc5_decoder,em28xx,ir_nec_decoder 
>>>>
>>>> tveeprom               12441  1 em28xx
>>>> i2c_core               14232  9
>>>> xc5000,drxk,em28xx_dvb,em28xx,v4l2_common,videodev,tveeprom,nvidia,i2c_i801 
>>>>
>>>>
>>>> yet, w_scan founds nothing.
>>>
>>> I was able to scan using the "media_build" install method described 
>>> above but when trying to watch a free channel the image and sound 
>>> was stuttering severly. I have tried both MythTV and mplayer with 
>>> similar results.
>>>
>>> I created the channel list for mplayer with:
>>>
>>> lintv ~ # dvbscan -x0 -fc /usr/share/dvb/dvb-c/no-Oslo-Get -o zap > 
>>> .mplayer/channels.conf
>>>
>>> And, for example,  I get this output from mplayer plus a very 
>>> (blocky) stuttering image and sound:
>>>
>>> lin-tv ~ # mplayer dvb://1@"TV8 Oslo" -ao jack
>>>
>>
>> I did some more tests with release snapshots 2011-12-13, 2011-12-21, 
>> and 2011-12-25, respectively. I did this by changing
>>
>> LATEST_TAR := 
>> http://linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2
>> LATEST_TAR_MD5 := 
>> http://linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2.md5
>>
>> in linux/Makefile to the corresponding release.
>>
>> Results:
>>
>> * linux-media-2011-12-13.tar.bz2
>>
>> The ./build script builds the drivers cleanly, scanning works, but  
>> watching video does not work correctly.
>>
>> * linux-media-2011-12-21.tar.bz2
>>
>> The ./build script fails at the as3645a.c file (on this machine but I 
>> can build it on two other machines using the same kernel and kernel 
>> 2.6.39-gentoo-r3, respectively). I can build it with make menuconfig 
>> etc (where I disabled stuff I don't need, eg. disabling [ ] Media 
>> Controller API (EXPERIMENTAL) ). The em28xx generate a kernel core 
>> dump though [1].
>>
>> * linux-media-2011-12-25.tar.bz2
>>
>> Same problem as 2011-12-21.
>>
>> Regards,
>>
>> /Fredrik
>>
>
> Here's some more test results.
>
> I have upgraded the kernel to 3.1.6-gentoo (where I enabled DVB when I 
> build the kernel). Both
>
> http://linuxtv.org/downloads/drivers/linux-media-2012-01-07.tar.bz2
>
> and
>
> http://linuxtv.org/downloads/drivers/linux-media-2012-01-08.tar.bz2
>
> now builds using the
>
> lin-tv ~ # cd /usr/src
> lin-tv src # git clone git://linuxtv.org/media_build.git
> lin-tv src # cd media_build
> lin-tv media_build # ./build
> lin-tv media_build # make install
>
> method. Scanning and (finally) watching video works but not flawlessly.
>
> I also suspect that I don't find all channels when I scan. I have 
> scanned using,
>
> * dvbscan -x 0 -fc /usr/share/dvb/dvb-c/no-Oslo-Get > 
> .mplayer/channels.conf
> * Kaffeine  (1.2.2)
> * MythTV (0.25_pre20120103)
>
> respectively. Both kaffeine and mythtv reports a very low signal level 
> (0%) and an SNR of only 1%. (kaffeine). I'm not sure if the driver 
> reports this correctly though.
>
> Whatching live TV works on some channels but not all. HD channels 
> seems more difficult than SD channels,  and I have not figured out why 
> some channels work and some don't. I get
>
> Signal 0% | S/N 2.6dB | BE 0 | (_L_S) Partial Lock
>
> and no video on many channels in mythtv.
>
> Regards,
>
> /Fredrik
>

Tried the

http://linuxtv.org/downloads/drivers/linux-media-2012-01-11.tar.bz2

release and the scan setting now looks different in MythTV  (it has more 
parameters) and dvbscan fails (mythtv scanning fails too):

lin-tv ~ # dvbscan -xo -fc /usr/share/dvb/dvb-c/no-Oslo-Get
scanning /usr/share/dvb/dvb-c/no-Oslo-Get
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 241000000 6900000 0 5
initial transponder 272000000 6900000 0 5
initial transponder 280000000 6900000 0 5
initial transponder 290000000 6900000 0 5
initial transponder 298000000 6900000 0 5
initial transponder 306000000 6900000 0 5
initial transponder 314000000 6900000 0 5
initial transponder 322000000 6900000 0 5
initial transponder 330000000 6900000 0 5
initial transponder 338000000 6900000 0 5
initial transponder 346000000 6900000 0 5
initial transponder 354000000 6900000 0 5
initial transponder 362000000 6900000 0 5
initial transponder 370000000 6900000 0 5
initial transponder 378000000 6900000 0 5
initial transponder 386000000 6900000 0 5
initial transponder 394000000 6900000 0 5
initial transponder 410000000 6900000 0 5
initial transponder 442000000 6952000 0 5
initial transponder 482000000 6900000 0 5
initial transponder 498000000 6900000 0 5
WARNING: frontend type (OFDM) is not compatible with requested tuning 
type (QAM)
WARNING: frontend type (OFDM) is not compatible with requested tuning 
type (QAM)
WARNING: frontend type (OFDM) is not compatible with requested tuning 
type (QAM)
WARNING: frontend type (OFDM) is not compatible with requested tuning 
type (QAM)
WARNING: frontend type (OFDM) is not compatible with requested tuning 
type (QAM)
WARNING: frontend type (OFDM) is not compatible with requested tuning 
type (QAM)
WARNING: frontend type (OFDM) is not compatible with requested tuning 
type (QAM)
WARNING: frontend type (OFDM) is not compatible with requested tuning 
type (QAM)
WARNING: frontend type (OFDM) is not compatible with requested tuning 
type (QAM)
WARNING: frontend type (OFDM) is not compatible with requested tuning 
type (QAM)
WARNING: frontend type (OFDM) is not compatible with requested tuning 
type (QAM)
WARNING: frontend type (OFDM) is not compatible with requested tuning 
type (QAM)
WARNING: frontend type (OFDM) is not compatible with requested tuning 
type (QAM)
WARNING: frontend type (OFDM) is not compatible with requested tuning 
type (QAM)
WARNING: frontend type (OFDM) is not compatible with requested tuning 
type (QAM)
WARNING: frontend type (OFDM) is not compatible with requested tuning 
type (QAM)
WARNING: frontend type (OFDM) is not compatible with requested tuning 
type (QAM)
WARNING: frontend type (OFDM) is not compatible with requested tuning 
type (QAM)
WARNING: frontend type (OFDM) is not compatible with requested tuning 
type (QAM)
WARNING: frontend type (OFDM) is not compatible with requested tuning 
type (QAM)
WARNING: frontend type (OFDM) is not compatible with requested tuning 
type (QAM)
ERROR: initial tuning failed
dumping lists (0 services)
Done.
lin-tv ~ #


/Fredrik

