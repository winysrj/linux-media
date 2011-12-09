Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754977Ab1LIXnf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Dec 2011 18:43:35 -0500
Message-ID: <4EE29D1A.6010900@redhat.com>
Date: Fri, 09 Dec 2011 21:43:22 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] drxk: Switch the delivery system on FE_SET_PROPERTY
References: <1323454852-7426-1-git-send-email-mchehab@redhat.com> <4EE252E5.2050204@iki.fi> <4EE25A3C.9040404@redhat.com> <4EE25CB4.3000501@iki.fi> <4EE287A9.3000502@redhat.com> <CAGoCfiyE8JhX5fT_SYjb6_X5Mkjx1Vx34_pKYaTjXu+muWxxwg@mail.gmail.com> <4EE29BA6.1030909@redhat.com>
In-Reply-To: <4EE29BA6.1030909@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09-12-2011 21:37, Mauro Carvalho Chehab wrote:
> On 09-12-2011 20:33, Devin Heitmueller wrote:
>> On Fri, Dec 9, 2011 at 5:11 PM, Mauro Carvalho Chehab
>> <mchehab@redhat.com> wrote:
>>>> Could someone explain reason for that?
>>>
>>>
>>> I dunno, but I think this needs to be fixed, at least when the frontend
>>> is opened with O_NONBLOCK.
>>
>> Are you doing the drx-k firmware load on dvb_init()? That could
>> easily take 4 seconds.
>
> No. The firmware were opened previously.

Maybe the delay is due to this part of dvb_frontend.c:

static int dvb_mfe_wait_time = 5;
...
                         int mferetry = (dvb_mfe_wait_time << 1);

                         mutex_unlock (&adapter->mfe_lock);
                         while (mferetry-- && (mfedev->users != -1 ||
                                         mfepriv->thread != NULL)) {
                                 if(msleep_interruptible(500)) {
                                         if(signal_pending(current))
                                                 return -EINTR;
                                 }
                         }


If I set this modprobe parameter to 1, the delay reduces drastically:

[ 5975.865162] drxk: ConfigureI2CBridge
[ 5975.865164] xc5000: xc5000_init()
[ 5975.869257] xc5000: xc5000_is_firmware_loaded() returns True id = 0x1388
[ 5975.876009] xc5000: xc_initialize()
[ 5976.120891] xc5000: *** ADC envelope (0-1023) = 4
[ 5976.126260] xc5000: *** Frequency error = 0 Hz
[ 5976.131260] xc5000: *** Lock status (0-Wait, 1-Locked, 2-No-signal) = 1
[ 5976.139111] xc5000: *** HW: V03.02, FW: V01.06.0072
[ 5976.144733] xc5000: *** Horizontal sync frequency = 11292 Hz
[ 5976.150976] xc5000: *** Frame lines = 1442
[ 5976.155850] xc5000: *** Quality (0:<8dB, 7:>56dB) = 9
[ 5976.160937] drxk: drxk_gate_ctrldisable
[ 5976.160939] drxk: ConfigureI2CBridge
[ 5977.161897] drxk: drxk_c_get_tune_settings
[ 5977.162085] drxk: drxk_c_init
[ 5977.162089] drxk: drxk_gate_ctrlenable
[ 5977.162091] drxk: ConfigureI2CBridge
[ 5977.162094] xc5000: xc5000_init()
[ 5977.166095] xc5000: xc5000_is_firmware_loaded() returns True id = 0x1388
[ 5977.172836] xc5000: xc_initialize()
[ 5977.422213] xc5000: *** ADC envelope (0-1023) = 4
[ 5977.427706] xc5000: *** Frequency error = 0 Hz
[ 5977.432832] xc5000: *** Lock status (0-Wait, 1-Locked, 2-No-signal) = 1
[ 5977.440682] xc5000: *** HW: V03.02, FW: V01.06.0072
[ 5977.446177] xc5000: *** Horizontal sync frequency = 10460 Hz
[ 5977.452482] xc5000: *** Frame lines = 1442
[ 5977.457296] xc5000: *** Quality (0:<8dB, 7:>56dB) = 9
[ 5977.462385] drxk: drxk_gate_ctrldisable
[ 5977.462388] drxk: ConfigureI2CBridge
[ 5977.462390] drxk: drxk_set_parameters
[ 5977.462392] drxk: drxk_gate_ctrlenable
[ 5977.462394] drxk: ConfigureI2CBridge
[ 5977.463043] xc5000: xc5000_is_firmware_loaded() returns True id = 0x1388
[ 5977.469781] xc5000: xc5000_set_params() frequency=57000000 (Hz)
[ 5977.475740] xc5000: xc5000_set_params() QAM modulation
[ 5977.480912] xc5000: xc5000_set_params() Bandwidth 6MHz (5999550)
[ 5977.486948] xc5000: xc5000_set_params() frequency=55250000 (compensated)
[ 5977.493677] xc5000: xc_SetSignalSource(1) Source = CABLE
[ 5977.500024] xc5000: xc_SetTVStandard(0x8002,0x00c0)
[ 5977.504930] xc5000: xc_SetTVStandard() Standard = DTV6
[ 5977.518267] xc5000: xc_set_IF_frequency(freq_khz = 4000) freq_code = 0x1000
[ 5977.527135] xc5000: xc_tune_channel(55250000)
[ 5977.531530] xc5000: xc_set_RF_frequency(55250000)
[ 5977.728050] xc5000: *** ADC envelope (0-1023) = 768
[ 5977.733671] xc5000: *** Frequency error = 0 Hz
[ 5977.738649] xc5000: *** Lock status (0-Wait, 1-Locked, 2-No-signal) = 1
[ 5977.746523] xc5000: *** HW: V03.02, FW: V01.06.0072
[ 5977.752017] xc5000: *** Horizontal sync frequency = 14970 Hz
[ 5977.758288] xc5000: *** Frame lines = 65535
[ 5977.763137] xc5000: *** Quality (0:<8dB, 7:>56dB) = 5
[ 5977.768224] drxk: drxk_gate_ctrldisable
[ 5977.768226] drxk: ConfigureI2CBridge
[ 5977.768228] xc5000: xc5000_get_if_frequency()
[ 5977.772624] drxk: Start
[ 5977.772626] drxk: SetQAM
[ 5977.773530] drxk: QAMResetQAM
[ 5977.773880] drxk: scu_command
[ 5977.777653] drxk: QAMSetSymbolrate
[ 5977.778880] drxk: scu_command
[ 5977.782647] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[ 5977.789298] drxk: 02 00 00 00 10 00 05 00 03 02                    ..........
[ 5977.789490] drxk: scu_command
[ 5977.792644] drxk: scu_command
[ 5977.795641] drxk: SetFrequencyShifter
[ 5977.796119] drxk: SetQAMMeasurement
[ 5977.806489] drxk: SetQAM64
[ 5977.827502] drxk: MPEGTSDtoSetup
[ 5977.834621] drxk: scu_command
[ 5978.161550] drxk: drxk_read_status
[ 5978.161554] drxk: GetLockStatus
[ 5978.161556] drxk: GetQAMLockStatus
[ 5978.161558] drxk: scu_command
[ 5978.315220] drxk: drxk_read_status
[ 5978.315223] drxk: GetLockStatus
[ 5978.315225] drxk: GetQAMLockStatus
[ 5978.315227] drxk: scu_command
[ 5978.469137] drxk: drxk_read_status
[ 5978.469141] drxk: GetLockStatus
[ 5978.469143] drxk: GetQAMLockStatus
[ 5978.469144] drxk: scu_command
[ 5978.623043] drxk: drxk_read_status
[ 5978.623046] drxk: GetLockStatus
[ 5978.623048] drxk: GetQAMLockStatus
[ 5978.623050] drxk: scu_command
[ 5978.776974] drxk: drxk_read_status
[ 5978.776977] drxk: GetLockStatus
[ 5978.776979] drxk: GetQAMLockStatus
[ 5978.776981] drxk: scu_command
[ 5978.930891] drxk: drxk_read_status
[ 5978.930894] drxk: GetLockStatus
[ 5978.930896] drxk: GetQAMLockStatus
[ 5978.930898] drxk: scu_command
[ 5979.084814] drxk: drxk_read_status
[ 5979.084817] drxk: GetLockStatus
[ 5979.084819] drxk: GetQAMLockStatus
[ 5979.084821] drxk: scu_command
[ 5979.238727] drxk: drxk_read_status
[ 5979.238730] drxk: GetLockStatus
[ 5979.238732] drxk: GetQAMLockStatus
[ 5979.238734] drxk: scu_command
[ 5979.392643] drxk: drxk_read_status
[ 5979.392646] drxk: GetLockStatus
[ 5979.392648] drxk: GetQAMLockStatus
[ 5979.392650] drxk: scu_command
[ 5979.546595] drxk: drxk_read_status
[ 5979.546598] drxk: GetLockStatus
[ 5979.546601] drxk: GetQAMLockStatus
[ 5979.546602] drxk: scu_command
[ 5979.700506] drxk: drxk_c_get_tune_settings
[ 5979.700683] drxk: drxk_set_parameters
[ 5979.700687] drxk: drxk_gate_ctrlenable
[ 5979.700689] drxk: ConfigureI2CBridge
[ 5979.701382] xc5000: xc5000_is_firmware_loaded() returns True id = 0x1388
[ 5979.708099] xc5000: xc5000_set_params() frequency=57000000 (Hz)
[ 5979.714055] xc5000: xc5000_set_params() QAM modulation
[ 5979.719230] xc5000: xc5000_set_params() Bandwidth 6MHz (5929400)
[ 5979.725267] xc5000: xc5000_set_params() frequency=55250000 (compensated)
[ 5979.731996] xc5000: xc_SetSignalSource(1) Source = CABLE
[ 5979.738262] xc5000: xc_SetTVStandard(0x8002,0x00c0)
[ 5979.743170] xc5000: xc_SetTVStandard() Standard = DTV6
[ 5979.757100] xc5000: xc_set_IF_frequency(freq_khz = 4000) freq_code = 0x1000
[ 5979.765968] xc5000: xc_tune_channel(55250000)
[ 5979.770364] xc5000: xc_set_RF_frequency(55250000)
[ 5979.966886] xc5000: *** ADC envelope (0-1023) = 816
[ 5979.972506] xc5000: *** Frequency error = 0 Hz
[ 5979.977483] xc5000: *** Lock status (0-Wait, 1-Locked, 2-No-signal) = 1
[ 5979.985482] xc5000: *** HW: V03.02, FW: V01.06.0072
[ 5979.990975] xc5000: *** Horizontal sync frequency = 15023 Hz
[ 5979.997496] xc5000: *** Frame lines = 65535
[ 5980.002347] xc5000: *** Quality (0:<8dB, 7:>56dB) = 0
[ 5980.007428] drxk: drxk_gate_ctrldisable
[ 5980.007430] drxk: ConfigureI2CBridge
[ 5980.007432] xc5000: xc5000_get_if_frequency()
[ 5980.011820] drxk: Start
[ 5980.011821] drxk: SetQAM
[ 5980.012714] drxk: QAMResetQAM
[ 5980.013111] drxk: scu_command
[ 5980.016483] drxk: QAMSetSymbolrate
[ 5980.017713] drxk: scu_command
[ 5980.021482] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[ 5980.028126] drxk: 02 00 00 00 10 00 05 00 03 02                    ..........
[ 5980.028316] drxk: scu_command
[ 5980.031475] drxk: scu_command
[ 5980.034475] drxk: SetFrequencyShifter
[ 5980.034953] drxk: SetQAMMeasurement
[ 5980.045136] drxk: SetQAM64
[ 5980.066075] drxk: MPEGTSDtoSetup
[ 5980.073329] drxk: scu_command
[ 5980.700153] drxk: drxk_read_status
[ 5980.700157] drxk: GetLockStatus
[ 5980.700159] drxk: GetQAMLockStatus
[ 5980.700161] drxk: scu_command
[ 5980.853772] drxk: drxk_read_status
[ 5980.853775] drxk: GetLockStatus
[ 5980.853777] drxk: GetQAMLockStatus
[ 5980.853779] drxk: scu_command
[ 5981.007797] drxk: drxk_read_status
[ 5981.007801] drxk: GetLockStatus
[ 5981.007803] drxk: GetQAMLockStatus
[ 5981.007805] drxk: scu_command
[ 5981.161681] drxk: drxk_read_status
[ 5981.161684] drxk: GetLockStatus
[ 5981.161686] drxk: GetQAMLockStatus
[ 5981.161688] drxk: scu_command
[ 5981.315635] drxk: drxk_read_status
[ 5981.315638] drxk: GetLockStatus
[ 5981.315640] drxk: GetQAMLockStatus
[ 5981.315642] drxk: scu_command
[ 5981.469555] drxk: drxk_read_status
[ 5981.469558] drxk: GetLockStatus
[ 5981.469561] drxk: GetQAMLockStatus
[ 5981.469562] drxk: scu_command
[ 5981.623468] drxk: drxk_read_status
[ 5981.623472] drxk: GetLockStatus
[ 5981.623474] drxk: GetQAMLockStatus
[ 5981.623476] drxk: scu_command
[ 5981.777388] drxk: drxk_read_status
[ 5981.777391] drxk: GetLockStatus
[ 5981.777393] drxk: GetQAMLockStatus
[ 5981.777395] drxk: scu_command
[ 5981.931307] drxk: drxk_read_status
[ 5981.931311] drxk: GetLockStatus
[ 5981.931313] drxk: GetQAMLockStatus
[ 5981.931314] drxk: scu_command
[ 5982.085228] drxk: drxk_read_status
[ 5982.085232] drxk: GetLockStatus
[ 5982.085234] drxk: GetQAMLockStatus
[ 5982.085236] drxk: scu_command
[ 5982.239174] drxk: drxk_c_get_tune_settings
[ 5982.239356] drxk: drxk_set_parameters
[ 5982.239360] drxk: drxk_gate_ctrlenable
[ 5982.239362] drxk: ConfigureI2CBridge
[ 5982.240066] xc5000: xc5000_is_firmware_loaded() returns True id = 0x1388
[ 5982.246785] xc5000: xc5000_set_params() frequency=57000000 (Hz)
[ 5982.252740] xc5000: xc5000_set_params() QAM modulation
[ 5982.257912] xc5000: xc5000_set_params() Bandwidth 6MHz (5750000)
[ 5982.263949] xc5000: xc5000_set_params() frequency=55250000 (compensated)
[ 5982.270679] xc5000: xc_SetSignalSource(1) Source = CABLE
[ 5982.276941] xc5000: xc_SetTVStandard(0x8002,0x00c0)
[ 5982.281849] xc5000: xc_SetTVStandard() Standard = DTV6
[ 5982.295776] xc5000: xc_set_IF_frequency(freq_khz = 4000) freq_code = 0x1000
[ 5982.304771] xc5000: xc_tune_channel(55250000)
[ 5982.309169] xc5000: xc_set_RF_frequency(55250000)
[ 5982.506561] xc5000: *** ADC envelope (0-1023) = 724
[ 5982.512186] xc5000: *** Frequency error = 0 Hz
[ 5982.517408] xc5000: *** Lock status (0-Wait, 1-Locked, 2-No-signal) = 1
[ 5982.525178] xc5000: *** HW: V03.02, FW: V01.06.0072
[ 5982.530799] xc5000: *** Horizontal sync frequency = 14954 Hz
[ 5982.537149] xc5000: *** Frame lines = 65535
[ 5982.542022] xc5000: *** Quality (0:<8dB, 7:>56dB) = 5
[ 5982.547109] drxk: drxk_gate_ctrldisable
[ 5982.547111] drxk: ConfigureI2CBridge
[ 5982.547113] xc5000: xc5000_get_if_frequency()
[ 5982.551512] drxk: Start
[ 5982.551514] drxk: SetQAM
[ 5982.552390] drxk: QAMResetQAM
[ 5982.552769] drxk: scu_command
[ 5982.556160] drxk: QAMSetSymbolrate
[ 5982.557390] drxk: scu_command
[ 5982.561160] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[ 5982.567809] drxk: 02 00 00 00 10 00 05 00 03 02                    ..........
[ 5982.568001] drxk: scu_command
[ 5982.571154] drxk: scu_command
[ 5982.574150] drxk: SetFrequencyShifter
[ 5982.574630] drxk: SetQAMMeasurement
[ 5982.584376] drxk: SetQAM64
[ 5982.604258] drxk: MPEGTSDtoSetup
[ 5982.611361] drxk: scu_command
[ 5982.615007] drxk: drxk_gate_ctrlenable
[ 5982.615010] drxk: ConfigureI2CBridge
[ 5982.615012] xc5000: xc5000_sleep()
[ 5982.618436] xc5000: xc5000_TunerReset()
[ 5982.622313] drxk: drxk_gate_ctrldisable
[ 5982.622315] drxk: ConfigureI2CBridge
[ 5982.622317] drxk: drxk_c_sleep
[ 5982.622319] drxk: ShutDown
[ 5982.622321] drxk: MPEGTSStop



Regards,
Mauro.
