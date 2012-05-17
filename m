Return-path: <linux-media-owner@vger.kernel.org>
Received: from zixgateway01.skylight.com ([67.52.159.36]:33957 "EHLO
	zixgateway01.skylight.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744Ab2EQFQr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 01:16:47 -0400
Received: from zixgateway01.skylight.com (ZixVPM [127.0.0.1])
	by Outbound.skylight.com (Proprietary) with ESMTP id 9A55824500C7
	for <linux-media@vger.kernel.org>; Wed, 16 May 2012 22:16:46 -0700 (PDT)
Received: from smtp.skylight.com (corp11.corp.skylight.com [192.168.16.30])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	by zixgateway01.skylight.com (Proprietary) with ESMTP id 4AF0124500C4
	for <linux-media@vger.kernel.org>; Wed, 16 May 2012 22:16:43 -0700 (PDT)
From: Rajkumar Farkiya <rfarkiya@skylight.com>
To: "'linux-media@vger.kernel.org'" <linux-media@vger.kernel.org>
Date: Wed, 16 May 2012 22:16:42 -0700
Subject: RE: HVR950Q Signal loss on 3.3.0-4.fc16.x86_64
Message-ID: <8599A863A5D5FE489BFCE0DFC109E5DF0BB718EB5C@corp11>
References: <37CF56EC1547A8479F2524D809F2DD2F07DEFD5C6E@corp11>
In-Reply-To: <37CF56EC1547A8479F2524D809F2DD2F07DEFD5C6E@corp11>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guys... Looking forward for any help on this issue.

Thanks,
Raj

-----Original Message-----
From: Rajkumar Farkiya
Sent: Thursday, May 10, 2012 5:19 PM
To: linux-media@vger.kernel.org
Subject: HVR950Q Signal loss on 3.3.0-4.fc16.x86_64

Hi Guys,

Having issue with HVR950q on fedora 16 Kernel 3.3.0-4.fc16.x86_64.

TV Tuner driver works for couple of hours but then suddenly it drops the signal and never locks in to analog or digital signals until I reset the USB bus or unload the au0828 driver.

I've no_poweroff=1 set and debugging enabled. Also its running on 10 PCs and all of them are doing the same on D525 platform.

Looking forward for help from you guys.

Here are the debug info from the kernel messages.

Thanks,
Raj

This is for tuning Analog Channels

May 10 15:06:20 IPC4G kernel: [13650.958746] au8522_i2c_gate_ctrl(1)
May 10 15:06:20 IPC4G kernel: [13650.961451] xc5000: xc5000_sleep()
May 10 15:06:20 IPC4G kernel: [13650.961457] au8522_i2c_gate_ctrl(0)
May 10 15:06:20 IPC4G kernel: [13650.964117] au8522_sleep()
May 10 15:06:21 IPC4G kernel: [13651.944679] xc5000: xc5000_is_firmware_loaded() returns True id = 0x1388
May 10 15:06:21 IPC4G kernel: [13651.944685] xc5000: xc5000_set_tv_freq() frequency=884 (in units of 62.5khz)
May 10 15:06:21 IPC4G kernel: [13651.944691] xc5000: xc_SetSignalSource(1) Source = CABLE
May 10 15:06:21 IPC4G kernel: [13651.952805] xc5000: xc_SetTVStandard(0x8020,0x0400)
May 10 15:06:21 IPC4G kernel: [13651.952809] xc5000: xc_SetTVStandard() Standard = M/N-NTSC/PAL-BTSC
May 10 15:06:21 IPC4G kernel: [13651.976553] xc5000: xc_tune_channel(55250000)
May 10 15:06:21 IPC4G kernel: [13651.976557] xc5000: xc_set_RF_frequency(55250000)
May 10 15:06:22 IPC4G kernel: [13652.622803] xc5000: *** ADC envelope (0-1023) = 956
May 10 15:06:22 IPC4G kernel: [13652.627560] xc5000: *** Frequency error = 781 Hz
May 10 15:06:22 IPC4G kernel: [13652.632330] xc5000: *** Lock status (0-Wait, 1-Locked, 2-No-signal) = 2
May 10 15:06:22 IPC4G kernel: [13652.641803] xc5000: *** HW: V03.02, FW: V01.06.0072
May 10 15:06:22 IPC4G kernel: [13652.646561] xc5000: *** Horizontal sync frequency = 15374 Hz
May 10 15:06:22 IPC4G kernel: [13652.651553] xc5000: *** Frame lines = 65535
May 10 15:06:22 IPC4G kernel: [13652.656677] xc5000: *** Quality (0:<8dB, 7:>56dB) = 32895

This is the debug logs from tuning Digital Channel

May 10 15:07:16 IPC4G kernel: [13706.850087] xc5000: xc5000_sleep()
May 10 15:07:16 IPC4G kernel: [13706.853855] au8522_init()
May 10 15:07:16 IPC4G kernel: [13706.856297] au8522_i2c_gate_ctrl(1)
May 10 15:07:16 IPC4G kernel: [13706.858669] au8522_i2c_gate_ctrl(1)
May 10 15:07:16 IPC4G kernel: [13706.861107] xc5000: xc5000_init()
May 10 15:07:16 IPC4G kernel: [13706.866102] xc5000: xc5000_is_firmware_loaded() returns True id = 0x1388
May 10 15:07:16 IPC4G kernel: [13706.866115] xc5000: xc_initialize()
May 10 15:07:16 IPC4G kernel: [13707.276083] xc5000: *** ADC envelope (0-1023) = 32
May 10 15:07:16 IPC4G kernel: [13707.280914] xc5000: *** Frequency error = 1062 Hz
May 10 15:07:16 IPC4G kernel: [13707.285663] xc5000: *** Lock status (0-Wait, 1-Locked, 2-No-signal) = 2
May 10 15:07:16 IPC4G kernel: [13707.295185] xc5000: *** HW: V03.02, FW: V01.06.0072
May 10 15:07:16 IPC4G kernel: [13707.300073] xc5000: *** Horizontal sync frequency = 15267 Hz
May 10 15:07:16 IPC4G kernel: [13707.304788] xc5000: *** Frame lines = 593
May 10 15:07:16 IPC4G kernel: [13707.309558] xc5000: *** Quality (0:<8dB, 7:>56dB) = 32895
May 10 15:07:16 IPC4G kernel: [13707.309565] au8522_i2c_gate_ctrl(0)
May 10 15:07:16 IPC4G SLAccess[1153]: vo_vdpau: vdpau API version : 1
May 10 15:07:16 IPC4G SLAccess[1153]: vo_vdpau: vdpau implementation description : NVIDIA VDPAU Driver Shared Library  295.49  Tue May  1 00:13:48 PDT 2012
May 10 15:07:16 IPC4G SLAccess[1153]: vo_vdpau: maximum video surface size for chroma type 4:2:2 is 4096x4096
May 10 15:07:16 IPC4G SLAccess[1153]: vo_vdpau: maximum video surface size for chroma type 4:2:0 is 4096x4096
May 10 15:07:16 IPC4G SLAccess[1153]: vo_vdpau: maximum output surface size is 8192x8192
May 10 15:07:16 IPC4G SLAccess[1153]: vo_vdpau: hold a maximum of 10 video output surfaces for reuse
May 10 15:07:16 IPC4G SLAccess[1153]: vo_vdpau: using 4 output surfaces of size 1920x1080 for display queue
May 10 15:07:16 IPC4G SLAccess[1153]: vdpau_set_property: property=0, value=1
May 10 15:07:16 IPC4G SLAccess[1153]: vo_vdpau: deinterlace: bob
May 10 15:07:16 IPC4G SLAccess[1153]: vdpau_set_property: property=1, value=1
May 10 15:07:16 IPC4G kernel: [13707.425215] au8522_set_frontend(frequency=207000000)
May 10 15:07:16 IPC4G kernel: [13707.425224] au8522_enable_modulation(0x00000005)
May 10 15:07:16 IPC4G kernel: [13707.425229] au8522_enable_modulation() QAM 256
May 10 15:07:17 IPC4G kernel: [13707.597100] au8522_set_if() 6.00 MHz
May 10 15:07:17 IPC4G kernel: [13707.705045] au8522_i2c_gate_ctrl(1)
May 10 15:07:17 IPC4G kernel: [13707.712421] xc5000: xc5000_is_firmware_loaded() returns True id = 0x1388
May 10 15:07:17 IPC4G kernel: [13707.712427] xc5000: xc5000_set_params() frequency=207000000 (Hz)
May 10 15:07:17 IPC4G kernel: [13707.712432] xc5000: xc5000_set_params() QAM modulation
May 10 15:07:17 IPC4G kernel: [13707.712437] xc5000: xc5000_set_params() frequency=207000000 (compensated to 205250000)
May 10 15:07:17 IPC4G kernel: [13707.712443] xc5000: xc_SetSignalSource(1) Source = CABLE
May 10 15:07:17 IPC4G kernel: [13707.720547] xc5000: xc_SetTVStandard(0x8002,0x00c0)
May 10 15:07:17 IPC4G kernel: [13707.720552] xc5000: xc_SetTVStandard() Standard = DTV6
May 10 15:07:17 IPC4G kernel: [13707.736545] xc5000: xc_set_IF_frequency(freq_khz = 6000) freq_code = 0x1800
May 10 15:07:17 IPC4G kernel: [13707.752790] xc5000: xc_tune_channel(205250000)
May 10 15:07:17 IPC4G kernel: [13707.752794] xc5000: xc_set_RF_frequency(205250000)
May 10 15:07:17 IPC4G kernel: [13708.034789] xc5000: *** ADC envelope (0-1023) = 676
May 10 15:07:17 IPC4G kernel: [13708.039664] xc5000: *** Frequency error = 0 Hz
May 10 15:07:17 IPC4G kernel: [13708.044419] xc5000: *** Lock status (0-Wait, 1-Locked, 2-No-signal) = 1
May 10 15:07:17 IPC4G kernel: [13708.053914] xc5000: *** HW: V03.02, FW: V01.06.0072
May 10 15:07:17 IPC4G kernel: [13708.058664] xc5000: *** Horizontal sync frequency = 16091 Hz
May 10 15:07:17 IPC4G kernel: [13708.063427] xc5000: *** Frame lines = 566
May 10 15:07:17 IPC4G kernel: [13708.068185] xc5000: *** Quality (0:<8dB, 7:>56dB) = 32895
May 10 15:07:17 IPC4G kernel: [13708.068192] au8522_i2c_gate_ctrl(0)
May 10 15:07:17 IPC4G kernel: [13708.070570] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.074415] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.074419] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.075513] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.079318] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.079324] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.080409] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.084178] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.084183] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.085274] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.089183] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.089190] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.090280] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.094071] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.094077] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.095171] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.099179] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.099184] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.100275] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.104064] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.104070] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.105162] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.109074] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.109079] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.110170] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.114179] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.114185] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.115278] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.119180] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.119185] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.120275] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.124186] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.124192] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.125284] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.129186] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.129192] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.130277] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.134073] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.134079] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.135171] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.139075] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.139081] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.140172] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.144082] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.144088] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.145179] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.149074] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.149079] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.150169] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.154076] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.154081] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.155172] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.159074] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.159079] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.160168] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.164074] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.164079] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.165170] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.169076] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.169081] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.170168] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.174079] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.174084] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.175205] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.179098] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.179108] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.180197] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.184100] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.184109] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.185197] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.189097] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.189106] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.190197] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.194075] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.194081] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.195169] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.199075] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.199080] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.200167] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.204076] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.204082] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.205173] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.209075] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.209081] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.210168] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.214076] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.214081] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.215174] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.219076] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.219082] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.220171] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.224076] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.224081] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.225171] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.229074] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.229079] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.230167] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.234075] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.234081] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.235170] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.239075] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.239080] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.240168] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.244075] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.244080] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.245171] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.249075] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.249081] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.250167] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.254074] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.254080] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.255169] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.259074] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.259079] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.260165] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.264075] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.264080] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.265170] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.269075] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.269081] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.270168] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.274072] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.274078] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.275166] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.279075] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.279080] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.280170] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.284075] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.284080] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.285173] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.289074] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.289079] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.290171] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.294080] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.294085] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.295174] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.299074] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.299080] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.300169] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.304176] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.304180] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.305388] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.309183] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.309189] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.310280] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.314185] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.314191] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.315286] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.319072] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.319077] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.320169] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.324186] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.324193] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.325287] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.329074] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.329080] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.330172] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.334073] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.334079] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.335168] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.339076] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.339081] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.340171] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.344099] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.344109] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.345200] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.349098] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.349108] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.350197] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.354097] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.354107] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.355197] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.359075] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.359080] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.360169] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.364074] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.364080] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.365172] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.369074] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.369079] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.370168] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.374076] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.374081] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.375172] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.379074] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.379080] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.380175] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.384073] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.384079] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.385171] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.389187] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.389194] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.390290] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.394074] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.394079] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.395171] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.399077] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.399082] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.400172] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.404073] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.404078] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.405169] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.409083] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.409088] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.410176] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.414076] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.414081] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.415172] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.419076] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.419081] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.420169] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.424076] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.424081] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.425171] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.429102] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.429107] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.430191] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.434076] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.434082] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.435168] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.439172] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.439176] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.440270] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.444316] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.444322] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.445416] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.449316] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.449323] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.450418] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.454545] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.454549] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.455638] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.459665] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.459669] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.460755] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.464915] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.464919] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.466024] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.469790] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.469795] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.470881] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.474671] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.474675] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.475762] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.479540] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.479545] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.480630] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.484415] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.484420] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.485502] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.489416] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.489421] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.490505] au8522_read_status() Checking QAM
May 10 15:07:17 IPC4G kernel: [13708.494415] au8522_read_status() DEMODLOCKING
May 10 15:07:17 IPC4G kernel: [13708.494419] au8522_read_status() status 0x00000000
May 10 15:07:17 IPC4G kernel: [13708.495504] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.499420] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.499424] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.500508] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.504541] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.504545] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.505628] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.509423] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.509428] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.510513] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.514415] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.514420] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.515508] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.519296] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.519300] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.520382] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.524178] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.524183] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.525266] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.529094] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.529103] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.530192] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.534186] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.534192] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.535285] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.539186] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.539192] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.540284] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.544178] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.544183] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.545268] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.549314] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.549319] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.550420] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.554179] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.554185] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.555274] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.559076] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.559082] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.560173] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.564076] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.564081] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.565171] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.569178] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.569184] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.570273] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.574077] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.574082] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.575171] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.579098] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.579107] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.580197] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.584104] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.584113] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.585203] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.589097] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.589106] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.590195] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.594098] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.594108] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.595194] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.599102] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.599111] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.600201] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.604102] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.604111] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.605201] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.609097] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.609107] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.610196] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.614076] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.614081] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.615170] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.619188] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.619194] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.620283] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.624075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.624080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.625169] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.629073] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.629079] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.630169] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.634076] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.634081] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.635171] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.639075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.639080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.640170] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.644074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.644079] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.645167] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.649187] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.649193] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.650284] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.654084] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.654089] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.655177] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.659187] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.659193] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.660283] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.664075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.664080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.665170] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.669074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.669079] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.670167] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.674075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.674080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.675166] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.679075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.679081] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.680171] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.684074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.684079] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.685166] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.689075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.689080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.690169] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.694073] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.694079] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.695164] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.699075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.699081] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.700170] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.704094] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.704100] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.705189] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.709077] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.709082] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.710170] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.714186] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.714192] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.715283] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.719185] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.719192] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.720286] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.724189] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.724195] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.725292] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.729186] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.729193] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.730285] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.734179] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.734185] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.735276] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.739074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.739079] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.740171] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.744187] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.744193] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.745287] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.749075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.749080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.750172] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.754187] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.754194] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.755288] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.759072] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.759078] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.760169] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.764188] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.764194] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.765286] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.769074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.769079] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.770170] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.774186] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.774192] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.775285] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.779074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.779080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.780170] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.784076] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.784081] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.785172] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.789187] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.789193] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.790289] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.794078] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.794084] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.795177] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.799075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.799080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.800172] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.804076] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.804082] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.805171] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.809098] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.809108] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.810198] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.814098] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.814108] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.815194] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.819076] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.819081] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.820173] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.824074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.824079] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.825169] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.829074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.829080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.830170] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.834074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.834080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.835169] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.839074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.839079] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.840168] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.844073] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.844079] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.845170] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.849077] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.849082] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.850168] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.854076] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.854081] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.855168] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.859075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.859080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.860170] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.864074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.864080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.865166] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.869072] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.869077] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.870163] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.874074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.874079] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.875166] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.879075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.879080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.880165] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.884074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.884079] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.885161] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.889102] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.889112] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.890199] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.894074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.894080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.895167] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.899074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.899080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.900164] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.904075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.904080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.905168] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.909074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.909079] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.910166] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.914078] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.914084] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.915167] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.919075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.919080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.920167] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.924169] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.924173] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.925262] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.929190] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.929196] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.930281] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.934185] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.934192] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.935277] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.939066] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.939072] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.940161] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.944074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.944079] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.945170] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.949076] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.949081] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.950173] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.954172] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.954177] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.955266] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.959186] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.959192] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.960285] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.964073] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.964078] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.965173] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.969189] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.969195] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.970288] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.974074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.974079] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.975171] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.979185] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.979192] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.980286] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.984076] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.984082] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.985171] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.989076] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.989082] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.990170] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.994086] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.994092] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13708.995180] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13708.999073] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13708.999079] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.000167] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.004075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.004080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.005172] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.009076] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.009081] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.010173] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.014186] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.014192] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.015289] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.019075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.019080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.020173] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.024187] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.024194] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.025287] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.029072] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.029078] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.030170] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.034188] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.034194] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.035290] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.039073] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.039079] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.040171] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.044187] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.044193] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.045287] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.049184] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.049190] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.050285] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.054073] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.054079] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.055170] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.059076] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.059081] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.060170] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.064075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.064080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.065168] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.068541] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.068545] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.069633] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.073420] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.073424] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.073442] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.077177] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.077182] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.077189] au8522_set_frontend(frequency=207000000)
May 10 15:07:18 IPC4G kernel: [13709.077211] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.081073] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.081078] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.082172] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.086074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.086079] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.087173] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.091074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.091079] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.092170] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.096075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.096080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.097171] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.101079] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.101084] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.102175] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.106080] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.106085] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.107177] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.111075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.111080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.112170] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.116074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.116080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.117169] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.121075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.121081] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.122169] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.126073] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.126078] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.127169] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.131076] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.131081] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.132174] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.136076] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.136081] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.137169] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.141078] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.141083] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.142176] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.146076] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.146082] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.147171] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.151075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.151081] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.152173] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.156075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.156080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.157172] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.161079] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.161084] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.162206] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.166099] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.166109] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.167201] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.171077] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.171082] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.172174] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.176075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.176080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.177176] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.181178] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.181184] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.182279] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.186187] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.186193] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.187289] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.191075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.191080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.192170] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.196075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.196080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.197172] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.201073] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.201079] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.202167] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.206075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.206081] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.207172] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.211166] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.211170] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.212267] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.216186] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.216193] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.217290] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.221186] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.221192] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.222287] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.226073] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.226079] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.227168] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.231073] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.231079] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.232171] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.236073] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.236079] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.237168] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.241082] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.241088] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.242175] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.246074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.246080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.247169] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.251185] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.251191] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.252280] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.256185] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.256191] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.257281] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.261074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.261080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.262167] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.266076] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.266081] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.267171] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.271074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.271079] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.272169] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.276074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.276079] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.277168] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.281076] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.281081] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.282171] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.286187] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.286193] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.287282] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.291186] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.291192] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.292281] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.296074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.296080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.297166] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.301075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.301081] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.302170] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.306075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.306081] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.307170] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.311075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.311080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.312169] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.316172] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.316176] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.317276] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.321320] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.321326] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.322418] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.326178] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.326184] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.327278] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.331074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.331079] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.332166] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.336073] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.336078] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.337168] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.341074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.341080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.342168] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.346075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.346081] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.347166] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.351077] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.351082] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.352171] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.356074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.356080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.357167] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.361079] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.361084] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.362171] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.366075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.366080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.367168] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.371075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.371080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.372168] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.376075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.376081] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.377172] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.381075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.381080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.382170] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.386165] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.386169] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.387266] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.391314] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.391320] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.392412] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.396184] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.396191] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.397286] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.401185] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.401191] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.402287] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.406189] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.406195] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.407290] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.411194] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.411199] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.412296] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.416178] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.416184] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.417277] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.421073] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.421078] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.422170] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.426074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.426079] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.427165] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.431076] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.431081] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.432168] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.436101] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.436111] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.437202] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.441075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.441081] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.442170] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.446075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.446081] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.447171] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.451077] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.451082] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.452170] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.456075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.456080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.457171] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.461074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.461079] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.462167] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.466076] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.466081] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.467167] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.471081] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.471086] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.472174] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.476074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.476079] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.477168] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.481075] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.481080] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.482169] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.486185] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.486191] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.487282] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.491073] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.491078] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.492166] au8522_read_status() Checking QAM
May 10 15:07:18 IPC4G kernel: [13709.496074] au8522_read_status() DEMODLOCKING
May 10 15:07:18 IPC4G kernel: [13709.496079] au8522_read_status() status 0x00000000
May 10 15:07:18 IPC4G kernel: [13709.497169] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.501075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.501080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.502170] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.506077] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.506082] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.507169] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.511074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.511079] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.512168] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.516075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.516081] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.517171] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.521074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.521080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.522170] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.526080] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.526085] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.527173] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.531074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.531080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.532169] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.536076] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.536081] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.537167] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.541074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.541079] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.542169] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.546074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.546079] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.547166] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.551074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.551079] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.552175] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.556187] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.556193] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.557289] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.561072] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.561076] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.562166] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.566073] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.566079] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.567170] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.571188] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.571194] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.572283] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.576076] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.576082] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.577172] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.581082] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.581087] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.582178] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.586171] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.586176] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.587269] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.591187] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.591193] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.592287] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.596074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.596080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.597170] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.601074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.601080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.602171] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.606076] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.606081] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.607172] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.611074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.611079] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.612170] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.616077] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.616082] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.617170] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.621074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.621079] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.622167] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.626075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.626080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.627170] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.631075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.631081] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.632169] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.636100] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.636110] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.637199] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.641099] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.641109] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.642199] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.646093] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.646103] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.647189] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.651100] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.651110] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.652200] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.656099] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.656109] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.657197] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.661075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.661081] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.662171] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.666073] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.666079] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.667166] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.671081] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.671086] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.672173] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.676074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.676080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.677165] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.681077] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.681083] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.682170] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.686075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.686081] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.687168] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.691074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.691080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.692166] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.696075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.696081] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.697169] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.701074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.701080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.702167] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.706075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.706081] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.707166] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.711078] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.711084] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.712169] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.716077] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.716082] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.717171] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.721186] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.721191] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.722289] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.726077] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.726083] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.727180] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.731187] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.731193] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.732288] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.736186] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.736193] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.737286] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.741080] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.741086] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.742176] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.746075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.746081] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.747170] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.751074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.751079] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.752168] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.756083] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.756089] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.757179] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.761074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.761079] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.762169] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.766075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.766080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.767174] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.771076] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.771081] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.772171] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.776074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.776080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.777170] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.781075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.781080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.782169] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.786074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.786080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.787166] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.791074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.791080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.792167] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.796074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.796079] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.797167] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.801072] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.801078] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.802166] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.806075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.806080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.807166] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.811100] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.811110] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.812200] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.816098] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.816108] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.817196] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.821079] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.821085] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.822176] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.826076] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.826081] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.827171] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.831077] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.831082] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.832174] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.836076] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.836081] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.837172] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.841074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.841080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.842173] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.846076] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.846082] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.847173] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.851100] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.851110] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.852204] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.856077] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.856082] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.857173] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.861079] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.861085] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.862176] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.866075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.866080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.867171] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.871076] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.871081] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.872174] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.876073] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.876079] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.877171] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.881077] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.881082] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.882175] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.886185] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.886190] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.887280] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.891103] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.891107] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.892194] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.896100] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.896109] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.897197] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.901110] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.901120] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.902210] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.906100] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.906109] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.907199] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.911187] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.911193] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.912284] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.916183] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.916189] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.917280] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.921416] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.921420] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.922512] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.926415] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.926419] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.927512] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.931433] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.931437] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.932528] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.936316] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.936321] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.937408] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.941177] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.941182] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.942275] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.946073] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.946079] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.947169] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.951074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.951079] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.952171] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.956076] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.956082] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.957171] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.961075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.961080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.962174] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.966081] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.966086] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.967177] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.971075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.971081] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.972170] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.976076] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.976081] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.977170] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.981074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.981079] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.982168] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.986074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.986080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.987173] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.991075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.991080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.992168] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13709.996074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13709.996080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13709.997173] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.001073] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.001078] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.002166] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.006079] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.006084] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.007175] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.011074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.011080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.012169] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.016076] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.016081] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.017174] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.021074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.021080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.022173] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.026079] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.026084] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.027177] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.031074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.031080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.032171] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.036077] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.036082] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.037175] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.041076] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.041082] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.042172] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.046075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.046081] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.047172] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.051075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.051080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.052171] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.056075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.056081] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.057172] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.061075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.061081] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.062170] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.066074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.066079] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.067171] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.071076] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.071081] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.072170] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.076084] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.076089] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.077032] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.080788] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.080792] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.080799] au8522_set_frontend(frequency=207000000)
May 10 15:07:19 IPC4G kernel: [13710.080820] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.084914] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.084919] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.086027] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.089789] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.089793] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.090883] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.094664] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.094668] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.095756] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.099539] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.099543] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.100635] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.104421] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.104426] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.105513] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.109423] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.109427] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.110523] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.114307] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.114313] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.115407] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.119317] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.119323] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.120413] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.124179] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.124185] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.125274] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.129075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.129081] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.130171] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.134101] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.134111] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.135201] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.139099] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.139109] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.140197] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.144101] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.144110] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.145199] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.149100] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.149110] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.150200] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.154099] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.154108] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.155198] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.159101] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.159112] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.160202] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.164084] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.164093] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.165181] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.169077] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.169082] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.170171] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.174074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.174079] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.175165] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.179074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.179080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.180169] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.184074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.184080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.185167] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.189073] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.189078] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.190167] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.194075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.194080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.195168] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.199074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.199079] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.200168] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.204083] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.204089] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.205178] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.209077] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.209083] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.210170] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.214073] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.214079] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.215168] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.219075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.219080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.220167] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.224077] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.224082] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.225169] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.229077] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.229082] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.230171] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.234074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.234079] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.235169] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.239075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.239080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.240170] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.244075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.244080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.245169] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.249076] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.249081] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.250169] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.254075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.254080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.255169] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.259073] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.259079] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.260168] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.264076] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.264082] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.265170] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.269073] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.269079] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.270167] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.274075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.274080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.275167] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.279074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.279079] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.280168] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.284076] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.284081] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.285172] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.289078] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.289083] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.290172] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.294075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.294081] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.295169] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.299081] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.299087] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.300176] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.304080] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.304085] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.305173] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.309074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.309079] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.310168] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.314074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.314079] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.315168] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.319074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.319080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.320171] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.324187] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.324193] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.325284] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.329075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.329080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.330169] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.334076] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.334082] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.335169] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.339074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.339079] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.340168] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.344077] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.344083] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.345171] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.349075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.349081] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.350171] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.354075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.354080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.355170] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.359079] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.359084] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.360177] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.364078] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.364083] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.365175] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.369075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.369081] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.370170] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.374078] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.374083] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.375177] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.379187] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.379193] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.380288] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.384186] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.384193] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.385289] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.389074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.389079] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.390175] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.394186] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.394193] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.395290] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.399186] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.399192] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.400288] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.404179] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.404184] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.405277] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.409178] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.409183] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.410276] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.414186] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.414193] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.415287] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.419180] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.419186] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.420281] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.424186] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.424193] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.425287] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.429178] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.429184] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.430276] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.434074] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.434080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.435171] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.439077] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.439082] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.440173] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.444075] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.444080] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.445168] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.449076] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.449081] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.450173] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.454079] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.454084] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.455173] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.459077] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.459083] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.460172] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.463915] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.463919] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.465030] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.468791] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.468795] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.469886] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.473664] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.473669] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.474759] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.478664] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.478669] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.479760] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.483663] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.483668] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.484758] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.488539] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.488543] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.489636] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.493421] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.493425] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.494516] au8522_read_status() Checking QAM
May 10 15:07:19 IPC4G kernel: [13710.498320] au8522_read_status() DEMODLOCKING
May 10 15:07:19 IPC4G kernel: [13710.498326] au8522_read_status() status 0x00000000
May 10 15:07:19 IPC4G kernel: [13710.499420] au8522_read_status() Checking QAM
May 10 15:07:20 IPC4G kernel: [13710.503177] au8522_read_status() DEMODLOCKING
May 10 15:07:20 IPC4G kernel: [13710.503183] au8522_read_status() status 0x00000000
May 10 15:07:20 IPC4G kernel: [13710.504275] au8522_read_status() Checking QAM
May 10 15:07:20 IPC4G kernel: [13710.508074] au8522_read_status() DEMODLOCKING
May 10 15:07:20 IPC4G kernel: [13710.508079] au8522_read_status() status 0x00000000
May 10 15:07:20 IPC4G kernel: [13710.509172] au8522_read_status() Checking QAM
May 10 15:07:20 IPC4G kernel: [13710.513076] au8522_read_status() DEMODLOCKING
May 10 15:07:20 IPC4G kernel: [13710.513081] au8522_read_status() status 0x00000000
May 10 15:07:20 IPC4G kernel: [13710.514171] au8522_read_status() Checking QAM
May 10 15:07:20 IPC4G kernel: [13710.518075] au8522_read_status() DEMODLOCKING
May 10 15:07:20 IPC4G kernel: [13710.518080] au8522_read_status() status 0x00000000
May 10 15:07:20 IPC4G kernel: [13710.519169] au8522_read_status() Checking QAM
May 10 15:07:20 IPC4G kernel: [13710.523077] au8522_read_status() DEMODLOCKING
May 10 15:07:20 IPC4G kernel: [13710.523082] au8522_read_status() status 0x00000000
May 10 15:07:20 IPC4G kernel: [13710.524169] au8522_read_status() Checking QAM
May 10 15:07:20 IPC4G kernel: [13710.528075] au8522_read_status() DEMODLOCKING
May 10 15:07:20 IPC4G kernel: [13710.528081] au8522_read_status() status 0x00000000
May 10 15:07:20 IPC4G kernel: [13710.529172] au8522_read_status() Checking QAM
May 10 15:07:20 IPC4G kernel: [13710.533077] au8522_read_status() DEMODLOCKING
May 10 15:07:20 IPC4G kernel: [13710.533082] au8522_read_status() status 0x00000000
May 10 15:07:20 IPC4G kernel: [13710.534171] au8522_read_status() Checking QAM
May 10 15:07:20 IPC4G kernel: [13710.538074] au8522_read_status() DEMODLOCKING
May 10 15:07:20 IPC4G kernel: [13710.538080] au8522_read_status() status 0x00000000
May 10 15:07:20 IPC4G kernel: [13710.539169] au8522_read_status() Checking QAM
May 10 15:07:20 IPC4G kernel: [13710.543076] au8522_read_status() DEMODLOCKING
May 10 15:07:20 IPC4G kernel: [13710.543082] au8522_read_status() status 0x00000000
May 10 15:07:20 IPC4G kernel: [13710.544171] au8522_read_status() Checking QAM
May 10 15:07:20 IPC4G kernel: [13710.548075] au8522_read_status() DEMODLOCKING
May 10 15:07:20 IPC4G kernel: [13710.548081] au8522_read_status() status 0x00000000
May 10 15:07:20 IPC4G kernel: [13710.549169] au8522_read_status() Checking QAM
May 10 15:07:20 IPC4G kernel: [13710.553079] au8522_read_status() DEMODLOCKING
May 10 15:07:20 IPC4G kernel: [13710.553085] au8522_read_status() status 0x00000000
May 10 15:07:20 IPC4G kernel: [13710.554207] au8522_read_status() Checking QAM
May 10 15:07:20 IPC4G kernel: [13710.558102] au8522_read_status() DEMODLOCKING
May 10 15:07:20 IPC4G kernel: [13710.558112] au8522_read_status() status 0x00000000
May 10 15:07:20 IPC4G kernel: [13710.559202] au8522_read_status() Checking QAM
May 10 15:07:20 IPC4G kernel: [13710.563102] au8522_read_status() DEMODLOCKING
May 10 15:07:20 IPC4G kernel: [13710.563111] au8522_read_status() status 0x00000000
May 10 15:07:20 IPC4G kernel: [13710.564202] au8522_read_status() Checking QAM
May 10 15:07:20 IPC4G kernel: [13710.568099] au8522_read_status() DEMODLOCKING
May 10 15:07:20 IPC4G kernel: [13710.568109] au8522_read_status() status 0x00000000
May 10 15:07:20 IPC4G kernel: [13710.569196] au8522_read_status() Checking QAM
May 10 15:07:20 IPC4G kernel: [13710.573102] au8522_read_status() DEMODLOCKING
May 10 15:07:20 IPC4G kernel: [13710.573112] au8522_read_status() status 0x00000000
May 10 15:07:20 IPC4G kernel: [13711.080047] au8522_read_status() Checking QAM
May 10 15:07:20 IPC4G kernel: [13711.083788] au8522_read_status() DEMODLOCKING
May 10 15:07:20 IPC4G kernel: [13711.083793] au8522_read_status() status 0x00000000
May 10 15:07:20 IPC4G kernel: [13711.083799] au8522_set_frontend(frequency=207000000)
May 10 15:07:21 IPC4G kernel: [13712.083046] au8522_read_status() Checking QAM
May 10 15:07:21 IPC4G kernel: [13712.087074] au8522_read_status() DEMODLOCKING
May 10 15:07:21 IPC4G kernel: [13712.087079] au8522_read_status() status 0x00000000
May 10 15:07:21 IPC4G kernel: [13712.087088] au8522_set_frontend(frequency=207000000)
May 10 15:07:22 IPC4G kernel: [13713.087039] au8522_read_status() Checking QAM
May 10 15:07:22 IPC4G kernel: [13713.090790] au8522_read_status() DEMODLOCKING
May 10 15:07:22 IPC4G kernel: [13713.090794] au8522_read_status() status 0x00000000
May 10 15:07:22 IPC4G kernel: [13713.090801] au8522_set_frontend(frequency=207000000)
May 10 15:07:23 IPC4G kernel: [13714.090034] au8522_read_status() Checking QAM
May 10 15:07:23 IPC4G kernel: [13714.094077] au8522_read_status() DEMODLOCKING
May 10 15:07:23 IPC4G kernel: [13714.094082] au8522_read_status() status 0x00000000
May 10 15:07:23 IPC4G kernel: [13714.094090] au8522_set_frontend(frequency=207000000)
May 10 15:07:24 IPC4G kernel: [13715.094046] au8522_read_status() Checking QAM
May 10 15:07:24 IPC4G kernel: [13715.098073] au8522_read_status() DEMODLOCKING
May 10 15:07:24 IPC4G kernel: [13715.098078] au8522_read_status() status 0x00000000
May 10 15:07:24 IPC4G kernel: [13715.098087] au8522_set_frontend(frequency=207000000)
May 10 15:07:25 IPC4G kernel: [13716.098044] au8522_read_status() Checking QAM
May 10 15:07:25 IPC4G kernel: [13716.101796] au8522_read_status() DEMODLOCKING
May 10 15:07:25 IPC4G kernel: [13716.101802] au8522_read_status() status 0x00000000
May 10 15:07:25 IPC4G kernel: [13716.101810] au8522_set_frontend(frequency=207000000)
May 10 15:07:26 IPC4G kernel: [13717.101041] au8522_read_status() Checking QAM
May 10 15:07:26 IPC4G kernel: [13717.105074] au8522_read_status() DEMODLOCKING
May 10 15:07:26 IPC4G kernel: [13717.105079] au8522_read_status() status 0x00000000
May 10 15:07:26 IPC4G kernel: [13717.105088] au8522_set_frontend(frequency=207000000)
May 10 15:07:27 IPC4G kernel: [13718.105045] au8522_read_status() Checking QAM
May 10 15:07:27 IPC4G kernel: [13718.108786] au8522_read_status() DEMODLOCKING
May 10 15:07:27 IPC4G kernel: [13718.108790] au8522_read_status() status 0x00000000
May 10 15:07:27 IPC4G kernel: [13718.108797] au8522_set_frontend(frequency=207000000)
May 10 15:07:28 IPC4G kernel: [13719.108047] au8522_read_status() Checking QAM
May 10 15:07:28 IPC4G kernel: [13719.112074] au8522_read_status() DEMODLOCKING
May 10 15:07:28 IPC4G kernel: [13719.112079] au8522_read_status() status 0x00000000
May 10 15:07:28 IPC4G kernel: [13719.112087] au8522_set_frontend(frequency=207000000)
May 10 15:07:29 IPC4G kernel: [13720.112044] au8522_read_status() Checking QAM
May 10 15:07:29 IPC4G kernel: [13720.115786] au8522_read_status() DEMODLOCKING
May 10 15:07:29 IPC4G kernel: [13720.115791] au8522_read_status() status 0x00000000
May 10 15:07:29 IPC4G kernel: [13720.115798] au8522_set_frontend(frequency=207000000)
May 10 15:07:30 IPC4G kernel: [13721.115040] au8522_read_status() Checking QAM
May 10 15:07:30 IPC4G kernel: [13721.118787] au8522_read_status() DEMODLOCKING
May 10 15:07:30 IPC4G kernel: [13721.118791] au8522_read_status() status 0x00000000
May 10 15:07:30 IPC4G kernel: [13721.118798] au8522_set_frontend(frequency=207000000)
May 10 15:07:31 IPC4G kernel: [13722.118046] au8522_read_status() Checking QAM
May 10 15:07:31 IPC4G kernel: [13722.121786] au8522_read_status() DEMODLOCKING
May 10 15:07:31 IPC4G kernel: [13722.121790] au8522_read_status() status 0x00000000
May 10 15:07:31 IPC4G kernel: [13722.121797] au8522_set_frontend(frequency=207000000)
May 10 15:07:32 IPC4G kernel: [13723.121047] au8522_read_status() Checking QAM
May 10 15:07:32 IPC4G kernel: [13723.124911] au8522_read_status() DEMODLOCKING
May 10 15:07:32 IPC4G kernel: [13723.124916] au8522_read_status() status 0x00000000
May 10 15:07:32 IPC4G kernel: [13723.124923] au8522_set_frontend(frequency=207000000)
May 10 15:07:33 IPC4G kernel: [13724.124044] au8522_read_status() Checking QAM
May 10 15:07:33 IPC4G kernel: [13724.128063] au8522_read_status() DEMODLOCKING
May 10 15:07:33 IPC4G kernel: [13724.128069] au8522_read_status() status 0x00000000
May 10 15:07:33 IPC4G kernel: [13724.128077] au8522_set_frontend(frequency=207000000)
May 10 15:07:34 IPC4G kernel: [13725.128045] au8522_read_status() Checking QAM
May 10 15:07:34 IPC4G kernel: [13725.131795] au8522_read_status() DEMODLOCKING
May 10 15:07:34 IPC4G kernel: [13725.131799] au8522_read_status() status 0x00000000
May 10 15:07:34 IPC4G kernel: [13725.131806] au8522_set_frontend(frequency=207000000)
May 10 15:07:35 IPC4G kernel: [13726.131044] au8522_read_status() Checking QAM
May 10 15:07:35 IPC4G kernel: [13726.134784] au8522_read_status() DEMODLOCKING
May 10 15:07:35 IPC4G kernel: [13726.134789] au8522_read_status() status 0x00000000
May 10 15:07:35 IPC4G kernel: [13726.134796] au8522_set_frontend(frequency=207000000)
May 10 15:07:36 IPC4G kernel: [13727.134052] au8522_read_status() Checking QAM
May 10 15:07:36 IPC4G kernel: [13727.137784] au8522_read_status() DEMODLOCKING
May 10 15:07:36 IPC4G kernel: [13727.137789] au8522_read_status() status 0x00000000
May 10 15:07:36 IPC4G kernel: [13727.137795] au8522_set_frontend(frequency=207000000)
May 10 15:07:37 IPC4G kernel: [13728.137053] au8522_read_status() Checking QAM
May 10 15:07:37 IPC4G kernel: [13728.140785] au8522_read_status() DEMODLOCKING
May 10 15:07:37 IPC4G kernel: [13728.140789] au8522_read_status() status 0x00000000
May 10 15:07:37 IPC4G kernel: [13728.140796] au8522_set_frontend(frequency=207000000)
May 10 15:07:38 IPC4G kernel: [13729.140033] au8522_read_status() Checking QAM
May 10 15:07:38 IPC4G kernel: [13729.144066] au8522_read_status() DEMODLOCKING
May 10 15:07:38 IPC4G kernel: [13729.144071] au8522_read_status() status 0x00000000
May 10 15:07:38 IPC4G kernel: [13729.144079] au8522_set_frontend(frequency=207000000)
May 10 15:07:39 IPC4G kernel: [13730.144047] au8522_read_status() Checking QAM
May 10 15:07:39 IPC4G kernel: [13730.148068] au8522_read_status() DEMODLOCKING
May 10 15:07:39 IPC4G kernel: [13730.148073] au8522_read_status() status 0x00000000
May 10 15:07:39 IPC4G kernel: [13730.148081] au8522_set_frontend(frequency=207000000)
May 10 15:07:40 IPC4G kernel: [13731.148035] au8522_read_status() Checking QAM
May 10 15:07:40 IPC4G kernel: [13731.151782] au8522_read_status() DEMODLOCKING
May 10 15:07:40 IPC4G kernel: [13731.151787] au8522_read_status() status 0x00000000
May 10 15:07:40 IPC4G kernel: [13731.151793] au8522_set_frontend(frequency=207000000)
May 10 15:07:41 IPC4G kernel: [13732.151039] au8522_read_status() Checking QAM
May 10 15:07:41 IPC4G kernel: [13732.154784] au8522_read_status() DEMODLOCKING
May 10 15:07:41 IPC4G kernel: [13732.154788] au8522_read_status() status 0x00000000
May 10 15:07:41 IPC4G kernel: [13732.154795] au8522_set_frontend(frequency=207000000)
May 10 15:07:42 IPC4G kernel: [13733.154043] au8522_read_status() Checking QAM
May 10 15:07:42 IPC4G kernel: [13733.157783] au8522_read_status() DEMODLOCKING
May 10 15:07:42 IPC4G kernel: [13733.157788] au8522_read_status() status 0x00000000
May 10 15:07:42 IPC4G kernel: [13733.157794] au8522_set_frontend(frequency=207000000)
May 10 15:07:43 IPC4G kernel: [13734.157046] au8522_read_status() Checking QAM
May 10 15:07:43 IPC4G kernel: [13734.160922] au8522_read_status() DEMODLOCKING
May 10 15:07:43 IPC4G kernel: [13734.160928] au8522_read_status() status 0x00000000
May 10 15:07:43 IPC4G kernel: [13734.160936] au8522_set_frontend(frequency=207000000)
May 10 15:07:44 IPC4G kernel: [13735.160046] au8522_read_status() Checking QAM
May 10 15:07:44 IPC4G kernel: [13735.163784] au8522_read_status() DEMODLOCKING
May 10 15:07:44 IPC4G kernel: [13735.163788] au8522_read_status() status 0x00000000
May 10 15:07:44 IPC4G kernel: [13735.163795] au8522_set_frontend(frequency=207000000)
May 10 15:07:45 IPC4G kernel: [13736.163043] au8522_read_status() Checking QAM
May 10 15:07:45 IPC4G kernel: [13736.167065] au8522_read_status() DEMODLOCKING
May 10 15:07:45 IPC4G kernel: [13736.167071] au8522_read_status() status 0x00000000
May 10 15:07:45 IPC4G kernel: [13736.167079] au8522_set_frontend(frequency=207000000)
May 10 15:07:46 IPC4G kernel: [13737.167045] au8522_read_status() Checking QAM
May 10 15:07:46 IPC4G kernel: [13737.171065] au8522_read_status() DEMODLOCKING
May 10 15:07:46 IPC4G kernel: [13737.171070] au8522_read_status() status 0x00000000
May 10 15:07:46 IPC4G kernel: [13737.171079] au8522_set_frontend(frequency=207000000)



