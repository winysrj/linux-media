Return-path: <mchehab@pedra>
Received: from imr-da04.mx.aol.com ([205.188.105.146]:33283 "EHLO
	imr-da04.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab1FIWWL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jun 2011 18:22:11 -0400
Received: from mtaout-ma06.r1000.mx.aol.com (mtaout-ma06.r1000.mx.aol.com [172.29.41.6])
	by imr-da04.mx.aol.com (8.14.1/8.14.1) with ESMTP id p59MM5RV031824
	for <linux-media@vger.kernel.org>; Thu, 9 Jun 2011 18:22:05 -0400
Received: from [192.168.1.150] (unknown [190.195.143.236])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mtaout-ma06.r1000.mx.aol.com (MUA/Third Party Client Interface) with ESMTPSA id E88F7E000112
	for <linux-media@vger.kernel.org>; Thu,  9 Jun 2011 18:22:03 -0400 (EDT)
Message-ID: <4DF1478F.4080007@netscape.net>
Date: Thu, 09 Jun 2011 19:22:07 -0300
From: =?windows-1252?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: XC5000 and MB86A20S
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi


I'm trying to run the X8507 MyGica plate, as I said in another post.
I notice that when I try to tune a channel, the frequency of the XC5000 
is different from the central carrier as I would expect to happen. Is 
this normal?
Can someone tell me where is the documentation of the XC5000 and MB86A20S.
Below are the results I get.


Thanks in advance



Alfredo


alfredo@linux:~> mplayer -dumpstream dvb://'Encuentro' -dumpfile 
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


Playing dvb://Encuentro.

dvb_tune Freq: 521142857

dvb_streaming_read, attempt N. 6 failed with errno 0 when reading 544 bytes

dvb_streaming_read, attempt N. 6 failed with errno 0 when reading 900 bytes

dvb_streaming_read, attempt N. 5 failed with errno 0 when reading 148 bytes

dvb_streaming_read, attempt N. 6 failed with errno 0 when reading 1256 bytes

dvb_streaming_read, attempt N. 5 failed with errno 0 when reading 1256 bytes



dmesg:


[ 2235.637152] mb86a20s: mb86a20s_initfe:

[ 2235.722354] mb86a20s: mb86a20s_initfe: Initialization succeeded.

[ 2235.722704] xc5000: xc5000_init()

[ 2235.723435] xc5000: xc5000_is_firmware_loaded() returns True id = 0x1388

[ 2235.723437] xc5000: xc_initialize()

[ 2235.963737] xc5000: *** ADC envelope (0-1023) = 152

[ 2235.964451] xc5000: *** Frequency error = 62 Hz

[ 2235.965163] xc5000: *** Lock status (0-Wait, 1-Locked, 2-No-signal) = 2

[ 2235.966642] xc5000: *** HW: V03.02, FW: V01.06.0072

[ 2235.967376] xc5000: *** Horizontal sync frequency = 16526 Hz

[ 2235.968088] xc5000: *** Frame lines = 570

[ 2235.968851] xc5000: *** Quality (0:<8dB, 7:>56dB) = 0

[ 2236.069395] mb86a20s: mb86a20s_set_frontend:

[ 2236.069749] mb86a20s: mb86a20s_set_frontend: Calling tuner set parameters

[ 2236.070487] xc5000: xc5000_is_firmware_loaded() returns True id = 0x1388

[ 2236.070493] xc5000: xc5000_set_params() frequency=521142857 (Hz)

[ 2236.070497] xc5000: xc5000_set_params() OFDM

[ 2236.070501] xc5000: xc5000_set_params() frequency=519392857 (compensated)

[ 2236.070505] xc5000: xc_SetSignalSource(0) Source = ANTENNA

[ 2236.071793] xc5000: xc_SetTVStandard(0x8002,0x00c0)

[ 2236.071796] xc5000: xc_SetTVStandard() Standard = DTV6

[ 2236.081039] xc5000: xc_set_IF_frequency(freq_khz = 3300) freq_code = 
0xd33

[ 2236.089762] xc5000: xc_tune_channel(519392857)

[ 2236.089764] xc5000: xc_set_RF_frequency(519392857)

[ 2236.342767] xc5000: *** ADC envelope (0-1023) = 932

[ 2236.343502] xc5000: *** Frequency error = 0 Hz

[ 2236.344204] xc5000: *** Lock status (0-Wait, 1-Locked, 2-No-signal) = 1

[ 2236.345670] xc5000: *** HW: V03.02, FW: V01.06.0072

[ 2236.346399] xc5000: *** Horizontal sync frequency = 15404 Hz

[ 2236.347129] xc5000: *** Frame lines = 65535

[ 2236.347925] xc5000: *** Quality (0:<8dB, 7:>56dB) = 1

[ 2236.350019] mb86a20s: mb86a20s_read_status:

[ 2236.351208] mb86a20s: mb86a20s_read_status: val = 2, status = 0x01

[ 2236.361292] mb86a20s: mb86a20s_read_status:

[ 2236.362471] mb86a20s: mb86a20s_read_status: val = 2, status = 0x01

[ 2236.372549] mb86a20s: mb86a20s_read_status:

[ 2236.373716] mb86a20s: mb86a20s_read_status: val = 2, status = 0x01

[ 2236.383789] mb86a20s: mb86a20s_read_status:

[ 2236.384970] mb86a20s: mb86a20s_read_status: val = 2, status = 0x01

[ 2236.395049] mb86a20s: mb86a20s_read_status:

[ 2236.396235] mb86a20s: mb86a20s_read_status: val = 2, status = 0x01

[ 2236.400035] mb86a20s: mb86a20s_read_status:

[ 2236.401226] mb86a20s: mb86a20s_read_status: val = 2, status = 0x01

[ 2236.401233] mb86a20s: mb86a20s_set_frontend:

[ 2236.401581] mb86a20s: mb86a20s_set_frontend: Calling tuner set parameters

[ 2236.402298] xc5000: xc5000_is_firmware_loaded() returns True id = 0x1388

[ 2236.402303] xc5000: xc5000_set_params() frequency=521267857 (Hz)

[ 2236.402306] xc5000: xc5000_set_params() OFDM

[ 2236.402310] xc5000: xc5000_set_params() frequency=519517857 (compensated)

[ 2236.402314] xc5000: xc_SetSignalSource(0) Source = ANTENNA

[ 2236.403608] xc5000: xc_SetTVStandard(0x8002,0x00c0)

[ 2236.403611] xc5000: xc_SetTVStandard() Standard = DTV6

[ 2236.412019] xc5000: xc_set_IF_frequency(freq_khz = 3300) freq_code = 
0xd33

[ 2236.420733] xc5000: xc_tune_channel(519517857)

[ 2236.420735] xc5000: xc_set_RF_frequency(519517857)

[ 2236.625772] xc5000: *** ADC envelope (0-1023) = 896

[ 2236.626507] xc5000: *** Frequency error = 0 Hz

[ 2236.627241] xc5000: *** Lock status (0-Wait, 1-Locked, 2-No-signal) = 1

[ 2236.628709] xc5000: *** HW: V03.02, FW: V01.06.0072

[ 2236.629443] xc5000: *** Horizontal sync frequency = 15641 Hz

[ 2236.630178] xc5000: *** Frame lines = 65535

[ 2236.630941] xc5000: *** Quality (0:<8dB, 7:>56dB) = 5

[ 2236.633036] mb86a20s: mb86a20s_read_status:

[ 2236.634252] mb86a20s: mb86a20s_read_status: val = 2, status = 0x01

[ 2236.644330] mb86a20s: mb86a20s_read_status:

[ 2236.645509] mb86a20s: mb86a20s_read_status: val = 2, status = 0x01

[ 2236.655587] mb86a20s: mb86a20s_read_status:

[ 2236.656747] mb86a20s: mb86a20s_read_status: val = 2, status = 0x01

[ 2236.666879] mb86a20s: mb86a20s_read_status:

[ 2236.668062] mb86a20s: mb86a20s_read_status: val = 2, status = 0x01

[ 2236.678140] mb86a20s: mb86a20s_read_status:

[ 2236.679334] mb86a20s: mb86a20s_read_status: val = 2, status = 0x01

[ 2236.683021] mb86a20s: mb86a20s_read_status:

[ 2236.684202] mb86a20s: mb86a20s_read_status: val = 2, status = 0x01

[ 2236.684207] mb86a20s: mb86a20s_set_frontend:

[ 2236.684554] mb86a20s: mb86a20s_set_frontend: Calling tuner set parameters

[ 2236.685260] xc5000: xc5000_is_firmware_loaded() returns True id = 0x1388

[ 2236.685262] xc5000: xc5000_set_params() frequency=521017857 (Hz)

[ 2236.685263] xc5000: xc5000_set_params() OFDM

[ 2236.685265] xc5000: xc5000_set_params() frequency=519267857 (compensated)

[ 2236.685267] xc5000: xc_SetSignalSource(0) Source = ANTENNA

[ 2236.686546] xc5000: xc_SetTVStandard(0x8002,0x00c0)

[ 2236.686548] xc5000: xc_SetTVStandard() Standard = DTV6

[ 2236.695018] xc5000: xc_set_IF_frequency(freq_khz = 3300) freq_code = 
0xd33

[ 2236.703742] xc5000: xc_tune_channel(519267857)

[ 2236.703744] xc5000: xc_set_RF_frequency(519267857)

[ 2236.908773] xc5000: *** ADC envelope (0-1023) = 856

[ 2236.909507] xc5000: *** Frequency error = 0 Hz

[ 2236.910207] xc5000: *** Lock status (0-Wait, 1-Locked, 2-No-signal) = 1

[ 2236.911676] xc5000: *** HW: V03.02, FW: V01.06.0072

[ 2236.912410] xc5000: *** Horizontal sync frequency = 15771 Hz

[ 2236.913155] xc5000: *** Frame lines = 65535

[ 2236.913918] xc5000: *** Quality (0:<8dB, 7:>56dB) = 5

[ 2236.916030] mb86a20s: mb86a20s_read_status:

[ 2236.917228] mb86a20s: mb86a20s_read_status: val = 2, status = 0x01

[ 2236.927307] mb86a20s: mb86a20s_read_status:

[ 2236.928480] mb86a20s: mb86a20s_read_status: val = 2, status = 0x01

…

[ 2239.576593] mb86a20s: mb86a20s_set_frontend: Calling tuner set parameters

[ 2239.577334] xc5000: xc5000_is_firmware_loaded() returns True id = 0x1388

[ 2239.577339] xc5000: xc5000_set_params() frequency=521017857 (Hz)

[ 2239.577342] xc5000: xc5000_set_params() OFDM

[ 2239.577346] xc5000: xc5000_set_params() frequency=519267857 (compensated)

[ 2239.577350] xc5000: xc_SetSignalSource(0) Source = ANTENNA

[ 2239.578642] xc5000: xc_SetTVStandard(0x8002,0x00c0)

[ 2239.578646] xc5000: xc_SetTVStandard() Standard = DTV6

[ 2239.587031] xc5000: xc_set_IF_frequency(freq_khz = 3300) freq_code = 
0xd33

[ 2239.595735] xc5000: xc_tune_channel(519267857)

[ 2239.595737] xc5000: xc_set_RF_frequency(519267857)

[ 2239.800841] xc5000: *** ADC envelope (0-1023) = 916

[ 2239.801577] xc5000: *** Frequency error = 0 Hz

[ 2239.802277] xc5000: *** Lock status (0-Wait, 1-Locked, 2-No-signal) = 1

[ 2239.803748] xc5000: *** HW: V03.02, FW: V01.06.0072

[ 2239.804454] xc5000: *** Horizontal sync frequency = 15870 Hz

[ 2239.805156] xc5000: *** Frame lines = 1023

[ 2239.805915] xc5000: *** Quality (0:<8dB, 7:>56dB) = 5

[ 2239.808007] mb86a20s: mb86a20s_read_status:

[ 2239.809282] mb86a20s: mb86a20s_read_status: val = 2, status = 0x01

…

[ 2253.026267] mb86a20s: mb86a20s_read_status: val = 9, status = 0x1f

[ 2253.940496] xc5000: xc5000_sleep()

[ 2253.940504] xc5000: xc5000_TunerReset()

-- 
Dona tu voz
http://www.voxforge.org/es

