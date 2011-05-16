Return-path: <mchehab@pedra>
Received: from ims-d14.mx.aol.com ([205.188.249.151]:36280 "EHLO
	ims-d14.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572Ab1EPXzp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 May 2011 19:55:45 -0400
Received: from oms-db04.r1000.mx.aol.com (oms-db04.r1000.mx.aol.com [205.188.58.4])
	by ims-d14.mx.aol.com (8.14.1/8.14.1) with ESMTP id p4GNgNBw007047
	for <linux-media@vger.kernel.org>; Mon, 16 May 2011 19:42:23 -0400
Received: from mtaout-db05.r1000.mx.aol.com (mtaout-db05.r1000.mx.aol.com [172.29.51.197])
	by oms-db04.r1000.mx.aol.com (AOL Outbound OMS Interface) with ESMTP id A0A151C000085
	for <linux-media@vger.kernel.org>; Mon, 16 May 2011 19:42:23 -0400 (EDT)
Received: from [192.168.1.34] (unknown [201.255.105.7])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mtaout-db05.r1000.mx.aol.com (MUA/Third Party Client Interface) with ESMTPSA id 6D9BAE00027E
	for <linux-media@vger.kernel.org>; Mon, 16 May 2011 19:42:21 -0400 (EDT)
Message-ID: <4DD1B65F.8020902@netscape.net>
Date: Mon, 16 May 2011 20:42:23 -0300
From: =?UTF-8?B?QWxmcmVkbyBKZXPDunMgRGVsYWl0aQ==?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
CC: linux-media@vger.kernel.org
Subject: Re: Help to make a driver. ISDB-Tb
References: <4DBC422F.10102@netscape.net> <4DBCB4EF.5070104@redhat.com> <4DBE0F74.80602@netscape.net> <4DBEAC3D.7040608@redhat.com> <4DC179F6.1020905@netscape.net>
In-Reply-To: <4DC179F6.1020905@netscape.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi
>
> Digital television: not tune any channels with w-scan or gnome-dvb-setup.
> But with the latter, it captures 2 weak signals, but I can not know 
> which is.
> Under windows also capture 2 channel and I'm in a place where the 
> signal is low.
> I'll try to have more signal strength.
>
> If I run dmesg after scan channels I get the following:
>
> [ 3474.858537] mb86a20s: mb86a20s_set_frontend:
> [ 3474.858541] mb86a20s: mb86a20s_set_frontend: Calling tuner set 
> parameters
> [ 3474.981157] mb86a20s: mb86a20s_read_status:
> [ 3474.981649] mb86a20s: mb86a20s_read_status: val = 2, status = 0x01

I improved the antenna signal and I've got this:

alfredo@linux:~> mplayer -dumpstream dvb://'C5N HD' -dumpfile 
mplayer-dumpfile.ts
MPlayer dev-SVN-r33321-4.5-openSUSE Linux 11.4 (x86_64)-Packman (C) 
2000-2011 MPlayer Team
Can't open joystick device /dev/input/js0: No such file or directory
Can't init input joystick
mplayer: could not open config files /home/alfredo/.lircrc and 
/etc/lirc/lircrc
mplayer: No such file or directory
Failed to read LIRC config file ~/.lircrc.
Loading extension-related profile 'vo.vdpau'

Playing dvb://C5N HD.
dvb_tune Freq: 551142857
dvb_streaming_read, attempt N. 6 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 5 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 4 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 3 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 2 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 1 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, return 0 bytes
dvb_streaming_read, attempt N. 6 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 5 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 4 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 3 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 2 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, attempt N. 1 failed with errno 0 when reading 2048 bytes
dvb_streaming_read, return 0 bytes
Core dumped ;)

Exiting... (End of file)

dmesg

[11359.790188] cx23885[0]/0: restarting queue
[11359.790197] cx23885[0]/0: queue is empty - first active
[11359.790202] cx23885[0]/0: cx23885_start_dma() w: 752, h: 32, f: 2
[11359.790209] cx23885[0]/0: cx23885_sram_channel_setup() Configuring 
channel [TS1 B]
[11359.790423] cx23885[0]/0: cx23885_start_dma() enabling TS int's and DMA
[11359.790436] cx23885[0]/0: [ffff880058342e00/0] cx23885_buf_queue - 
first active
[11359.790441] cx23885[0]/0: queue is not empty - append to active
[11359.790445] cx23885[0]/0: [ffff88002d4fba00/1] cx23885_buf_queue - 
append to active
[11359.790449] cx23885[0]/0: queue is not empty - append to active
[11359.790453] cx23885[0]/0: [ffff88003758ae00/2] cx23885_buf_queue - 
append to active
[11359.790457] cx23885[0]/0: queue is not empty - append to active
[11359.790460] cx23885[0]/0: [ffff88005815f800/3] cx23885_buf_queue - 
append to active
[11359.790464] cx23885[0]/0: queue is not empty - append to active
[11359.790468] cx23885[0]/0: [ffff88003758ac00/4] cx23885_buf_queue - 
append to active
[11359.790472] cx23885[0]/0: queue is not empty - append to active
[11359.790476] cx23885[0]/0: [ffff88005ae15600/5] cx23885_buf_queue - 
append to active
[11359.790480] cx23885[0]/0: queue is not empty - append to active
[11359.790484] cx23885[0]/0: [ffff88005ae15000/6] cx23885_buf_queue - 
append to active
[11359.790488] cx23885[0]/0: queue is not empty - append to active
[11359.790492] cx23885[0]/0: [ffff88005ae15400/7] cx23885_buf_queue - 
append to active
[11359.790496] cx23885[0]/0: queue is not empty - append to active
[11359.790499] cx23885[0]/0: [ffff88005a0ce000/8] cx23885_buf_queue - 
append to active
[11359.790503] cx23885[0]/0: queue is not empty - append to active
[11359.790507] cx23885[0]/0: [ffff88005a0cea00/9] cx23885_buf_queue - 
append to active
[11359.790511] cx23885[0]/0: queue is not empty - append to active
[11359.790515] cx23885[0]/0: [ffff88005a0cee00/10] cx23885_buf_queue - 
append to active
[11359.790519] cx23885[0]/0: queue is not empty - append to active
[11359.790523] cx23885[0]/0: [ffff8800374ffe00/11] cx23885_buf_queue - 
append to active
[11359.790527] cx23885[0]/0: queue is not empty - append to active
[11359.790531] cx23885[0]/0: [ffff8800582a0c00/12] cx23885_buf_queue - 
append to active
[11359.790535] cx23885[0]/0: queue is not empty - append to active
[11359.790539] cx23885[0]/0: [ffff8800582a0600/13] cx23885_buf_queue - 
append to active
[11359.790543] cx23885[0]/0: queue is not empty - append to active
[11359.790547] cx23885[0]/0: [ffff8800582a0000/14] cx23885_buf_queue - 
append to active
[11359.790551] cx23885[0]/0: queue is not empty - append to active
[11359.790554] cx23885[0]/0: [ffff8800582a0a00/15] cx23885_buf_queue - 
append to active
[11359.790558] cx23885[0]/0: queue is not empty - append to active
[11359.790562] cx23885[0]/0: [ffff8800582a0200/16] cx23885_buf_queue - 
append to active
[11359.790566] cx23885[0]/0: queue is not empty - append to active
[11359.790570] cx23885[0]/0: [ffff8800582a0800/17] cx23885_buf_queue - 
append to active
[11359.790578] cx23885[0]/0: queue is not empty - append to active
[11359.790582] cx23885[0]/0: [ffff88005ae14400/18] cx23885_buf_queue - 
append to active
[11359.790586] cx23885[0]/0: queue is not empty - append to active
[11359.790590] cx23885[0]/0: [ffff88005ae14e00/19] cx23885_buf_queue - 
append to active
[11359.790594] cx23885[0]/0: queue is not empty - append to active
[11359.790598] cx23885[0]/0: [ffff88005ae14600/20] cx23885_buf_queue - 
append to active
[11359.790602] cx23885[0]/0: queue is not empty - append to active
[11359.790605] cx23885[0]/0: [ffff88005ae14c00/21] cx23885_buf_queue - 
append to active
[11359.790609] cx23885[0]/0: queue is not empty - append to active
[11359.790613] cx23885[0]/0: [ffff88005ae14a00/22] cx23885_buf_queue - 
append to active
[11359.790617] cx23885[0]/0: queue is not empty - append to active
[11359.790621] cx23885[0]/0: [ffff88005ae14000/23] cx23885_buf_queue - 
append to active
[11359.790625] cx23885[0]/0: queue is not empty - append to active
[11359.790629] cx23885[0]/0: [ffff880037511a00/24] cx23885_buf_queue - 
append to active
[11359.790633] cx23885[0]/0: queue is not empty - append to active
[11359.790637] cx23885[0]/0: [ffff880037511c00/25] cx23885_buf_queue - 
append to active
[11359.790641] cx23885[0]/0: queue is not empty - append to active
[11359.790645] cx23885[0]/0: [ffff880037511e00/26] cx23885_buf_queue - 
append to active
[11359.790649] cx23885[0]/0: queue is not empty - append to active
[11359.790652] cx23885[0]/0: [ffff880037683c00/27] cx23885_buf_queue - 
append to active
[11359.790656] cx23885[0]/0: queue is not empty - append to active
[11359.790660] cx23885[0]/0: [ffff880037683800/28] cx23885_buf_queue - 
append to active
[11359.790664] cx23885[0]/0: queue is not empty - append to active
[11359.790668] cx23885[0]/0: [ffff880037683000/29] cx23885_buf_queue - 
append to active
[11359.790672] cx23885[0]/0: queue is not empty - append to active
[11359.790676] cx23885[0]/0: [ffff880037683e00/30] cx23885_buf_queue - 
append to active
[11359.790680] cx23885[0]/0: queue is not empty - append to active
[11359.790684] cx23885[0]/0: [ffff880037748400/31] cx23885_buf_queue - 
append to active
[11360.064047] mb86a20s: mb86a20s_read_status:
[11360.064533] mb86a20s: mb86a20s_read_status: val = 4, status = 0x03
[11360.064541] mb86a20s: mb86a20s_set_frontend:
[11360.064544] mb86a20s: mb86a20s_set_frontend: Calling tuner set parameters
[11360.490076] mb86a20s: mb86a20s_read_status:
[11360.490562] mb86a20s: mb86a20s_read_status: val = 5, status = 0x07
[11360.490571] mb86a20s: mb86a20s_set_frontend:
[11360.490574] mb86a20s: mb86a20s_set_frontend: Calling tuner set parameters
[11360.792038] cx23885[0]/0: cx23885_timeout()
[11360.792045] cx23885[0]/0: cx23885_stop_dma()
[11360.792058] cx23885[0]/0: [ffff880058342e00/0] timeout - dma=0x03bbf000
[11360.792063] cx23885[0]/0: [ffff88002d4fba00/1] timeout - dma=0x02ec9000
[11360.792068] cx23885[0]/0: [ffff88003758ae00/2] timeout - dma=0x02ec7000
[11360.792072] cx23885[0]/0: [ffff88005815f800/3] timeout - dma=0x18792000
[11360.792076] cx23885[0]/0: [ffff88003758ac00/4] timeout - dma=0x038b2000
[11360.792081] cx23885[0]/0: [ffff88005ae15600/5] timeout - dma=0x02eb1000
[11360.792085] cx23885[0]/0: [ffff88005ae15000/6] timeout - dma=0x03a4b000
[11360.792089] cx23885[0]/0: [ffff88005ae15400/7] timeout - dma=0x18510000
[11360.792094] cx23885[0]/0: [ffff88005a0ce000/8] timeout - dma=0x02ee5000
[11360.792098] cx23885[0]/0: [ffff88005a0cea00/9] timeout - dma=0x02ee1000
[11360.792103] cx23885[0]/0: [ffff88005a0cee00/10] timeout - dma=0x09dc5000
[11360.792107] cx23885[0]/0: [ffff8800374ffe00/11] timeout - dma=0x594a5000
[11360.792112] cx23885[0]/0: [ffff8800582a0c00/12] timeout - dma=0x1a04b000
[11360.792116] cx23885[0]/0: [ffff8800582a0600/13] timeout - dma=0x19dcc000
[11360.792121] cx23885[0]/0: [ffff8800582a0000/14] timeout - dma=0x19d17000
[11360.792125] cx23885[0]/0: [ffff8800582a0a00/15] timeout - dma=0x02ef3000
[11360.792129] cx23885[0]/0: [ffff8800582a0200/16] timeout - dma=0x02ee9000
[11360.792134] cx23885[0]/0: [ffff8800582a0800/17] timeout - dma=0x03b7f000
[11360.792138] cx23885[0]/0: [ffff88005ae14400/18] timeout - dma=0x02c8f000
[11360.792143] cx23885[0]/0: [ffff88005ae14e00/19] timeout - dma=0x02c93000
[11360.792147] cx23885[0]/0: [ffff88005ae14600/20] timeout - dma=0x02c9b000
[11360.792151] cx23885[0]/0: [ffff88005ae14c00/21] timeout - dma=0x02ca3000
[11360.792156] cx23885[0]/0: [ffff88005ae14a00/22] timeout - dma=0x02cab000
[11360.792160] cx23885[0]/0: [ffff88005ae14000/23] timeout - dma=0x02cb3000
[11360.792164] cx23885[0]/0: [ffff880037511a00/24] timeout - dma=0x02cbb000
[11360.792169] cx23885[0]/0: [ffff880037511c00/25] timeout - dma=0x02cc3000
[11360.792173] cx23885[0]/0: [ffff880037511e00/26] timeout - dma=0x02ccb000
[11360.792177] cx23885[0]/0: [ffff880037683c00/27] timeout - dma=0x02cd3000
[11360.792182] cx23885[0]/0: [ffff880037683800/28] timeout - dma=0x02cdb000
[11360.792186] cx23885[0]/0: [ffff880037683000/29] timeout - dma=0x02ce3000
[11360.792191] cx23885[0]/0: [ffff880037683e00/30] timeout - dma=0x02ceb000
[11360.792195] cx23885[0]/0: [ffff880037748400/31] timeout - dma=0x02cf4000
[11360.792198] cx23885[0]/0: restarting queue

As there is little sign, I asked another person to try and got this:

$femon -H
FE: Fujitsu mb86A20s (DVBT)
Problem retrieving frontend information: Operation not supported
status SCVYL | signal 6% | snr 71% | ber -1217255176 | unc -1217744071 | 
FE_HAS_LOCK
Problem retrieving frontend information: Operation not supported
status SCVYL | signal 12% | snr 71% | ber -1217255176 | unc -1217744071 
| FE_HAS_LOCK
Problem retrieving frontend information: Operation not supported
status SCVYL | signal 12% | snr 71% | ber -1217255176 | unc -1217744071 
| FE_HAS_LOCK

and this:

[ 397.962795] mb86a20s: mb86a20s_read_status: val = 9, status = 0x1f
[ 397.962798] mb86a20s: mb86a20s_read_signal_strength:
[ 397.983108] mb86a20s: mb86a20s_read_signal_strength: signal strength = 
4096
[ 398.019975] mb86a20s: mb86a20s_read_status:
[ 398.020461] mb86a20s: mb86a20s_read_status: val = 9, status = 0x1f

I think these values ​​would have to watch TV, but no.

Suggestions are welcome

Thanks in advance

Alfredo



-- 
Dona tu voz
http://www.voxforge.org/es

