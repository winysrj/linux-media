Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244Ab1LIXhX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Dec 2011 18:37:23 -0500
Message-ID: <4EE29BA6.1030909@redhat.com>
Date: Fri, 09 Dec 2011 21:37:10 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] drxk: Switch the delivery system on FE_SET_PROPERTY
References: <1323454852-7426-1-git-send-email-mchehab@redhat.com> <4EE252E5.2050204@iki.fi> <4EE25A3C.9040404@redhat.com> <4EE25CB4.3000501@iki.fi> <4EE287A9.3000502@redhat.com> <CAGoCfiyE8JhX5fT_SYjb6_X5Mkjx1Vx34_pKYaTjXu+muWxxwg@mail.gmail.com>
In-Reply-To: <CAGoCfiyE8JhX5fT_SYjb6_X5Mkjx1Vx34_pKYaTjXu+muWxxwg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09-12-2011 20:33, Devin Heitmueller wrote:
> On Fri, Dec 9, 2011 at 5:11 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com>  wrote:
>>> Could someone explain reason for that?
>>
>>
>> I dunno, but I think this needs to be fixed, at least when the frontend
>> is opened with O_NONBLOCK.
>
> Are you doing the drx-k firmware load on dvb_init()?  That could
> easily take 4 seconds.

No. The firmware were opened previously.

This is what happens at the driver:

	(frontend0 open - DVB-C)
[ 5177.932326] drxk: drxk_c_init
[ 5177.932330] drxk: SetOperationMode
[ 5177.932691] drxk: drxk_gate_ctrlenable
[ 5177.932695] drxk: ConfigureI2CBridge
[ 5177.932697] xc5000: xc5000_init()
[ 5177.936565] xc5000: xc5000_is_firmware_loaded() returns True id = 0x1388
[ 5177.943306] xc5000: xc_initialize()
[ 5178.187199] xc5000: *** ADC envelope (0-1023) = 4
[ 5178.192569] xc5000: *** Frequency error = 0 Hz
[ 5178.197566] xc5000: *** Lock status (0-Wait, 1-Locked, 2-No-signal) = 1
[ 5178.205291] xc5000: *** HW: V03.02, FW: V01.06.0072
[ 5178.210662] xc5000: *** Horizontal sync frequency = 15473 Hz
[ 5178.216909] xc5000: *** Frame lines = 789
[ 5178.221659] xc5000: *** Quality (0:<8dB, 7:>56dB) = 9
[ 5178.226753] drxk: drxk_gate_ctrldisable
[ 5178.226755] drxk: ConfigureI2CBridge
	(frontend1 open - DVB-T)
[ 5181.224873] drxk: drxk_gate_ctrlenable
[ 5181.224877] drxk: ConfigureI2CBridge
[ 5181.224880] xc5000: xc5000_sleep()
[ 5181.228327] xc5000: xc5000_TunerReset()
[ 5181.232204] drxk: drxk_gate_ctrldisable
[ 5181.232205] drxk: ConfigureI2CBridge
[ 5181.232207] drxk: drxk_c_sleep
[ 5181.232209] drxk: ShutDown
[ 5181.232211] drxk: MPEGTSStop
[ 5181.731673] drxk: drxk_t_init
[ 5181.731677] drxk: SetOperationMode
[ 5181.732101] drxk: MPEGTSStop
[ 5181.734075] drxk: PowerDownQAM
[ 5181.735075] drxk: scu_command
[ 5181.737970] drxk: SetIqmAf
[ 5181.738948] drxk: SetOperationMode: DVB-T
[ 5181.738950] drxk: SetDVBTStandard
[ 5181.738952] drxk: PowerUpDVBT
[ 5181.738954] drxk: CtrlPowerMode
[ 5181.738956] drxk: PowerUpDevice
[ 5181.740321] drxk: DVBTEnableOFDMTokenRing
[ 5181.741947] drxk: SwitchAntennaToDVBT
[ 5181.741949] drxk: scu_command
[ 5181.744718] drxk: scu_command
[ 5181.750317] drxk: SetIqmAf
[ 5181.755439] drxk: BLChainCmd
[ 5181.760710] drxk: ADCSynchronization
[ 5181.760713] drxk: ADCSyncMeasurement
[ 5181.763596] drxk: SetPreSaw
[ 5181.764309] drxk: SetAgcRf
[ 5181.766433] drxk: SetAgcIf
[ 5181.773183] drxk: MPEGTSDtoSetup
[ 5181.777948] drxk: DVBTActivatePresets
[ 5181.777951] drxk: DVBTCtrlSetIncEnable
[ 5181.778301] drxk: DVBTCtrlSetFrEnable
[ 5181.778703] drxk: DVBTCtrlSetEchoThreshold
[ 5181.779697] drxk: DVBTCtrlSetEchoThreshold
[ 5181.781053] drxk: drxk_gate_ctrlenable
[ 5181.781056] drxk: ConfigureI2CBridge
[ 5181.781058] xc5000: xc5000_init()
[ 5181.785050] xc5000: xc5000_is_firmware_loaded() returns True id = 0x1388
[ 5181.791790] xc5000: xc_initialize()
[ 5182.041187] xc5000: *** ADC envelope (0-1023) = 4
[ 5182.046559] xc5000: *** Frequency error = 0 Hz
[ 5182.051557] xc5000: *** Lock status (0-Wait, 1-Locked, 2-No-signal) = 1
[ 5182.059448] xc5000: *** HW: V03.02, FW: V01.06.0072
[ 5182.065154] xc5000: *** Horizontal sync frequency = 14817 Hz
[ 5182.071424] xc5000: *** Frame lines = 1283
[ 5182.076273] xc5000: *** Quality (0:<8dB, 7:>56dB) = 9
[ 5182.081366] drxk: drxk_gate_ctrldisable
[ 5182.081368] drxk: ConfigureI2CBridge
[ 5185.079823] drxk: drxk_gate_ctrlenable
[ 5185.079827] drxk: ConfigureI2CBridge
[ 5185.079830] xc5000: xc5000_sleep()
[ 5185.083276] xc5000: xc5000_TunerReset()
[ 5185.087104] drxk: drxk_gate_ctrldisable
[ 5185.087107] drxk: ConfigureI2CBridge
[ 5185.087111] drxk: drxk_t_sleep
[ 5185.087323] drxk: drxk_c_init
[ 5185.087326] drxk: SetOperationMode
[ 5185.087778] drxk: MPEGTSStop
[ 5185.089993] drxk: PowerDownDVBT
[ 5185.090780] drxk: scu_command
[ 5185.094100] drxk: scu_command
[ 5185.098219] drxk: SetIqmAf
[ 5185.099221] drxk: CtrlPowerMode
[ 5185.099223] drxk: MPEGTSStop
[ 5185.101218] drxk: PowerDownDVBT
[ 5185.101854] drxk: scu_command
[ 5185.105090] drxk: scu_command
[ 5185.109215] drxk: SetIqmAf
[ 5185.110215] drxk: DVBTEnableOFDMTokenRing
[ 5185.112566] drxk: SetOperationMode: DVB-C Annex C
[ 5185.112568] drxk: SetQAMStandard
[ 5185.112570] drxk: SwitchAntennaToQAM
[ 5185.112572] drxk: PowerUpQAM
[ 5185.112574] drxk: CtrlPowerMode
[ 5185.112575] drxk: QAMResetQAM
[ 5185.112962] drxk: scu_command
[ 5185.116838] drxk: BLChainCmd
[ 5185.127954] drxk: SetIqmAf
[ 5185.129306] drxk: ADCSynchronization
[ 5185.129308] drxk: ADCSyncMeasurement
[ 5185.132949] drxk: InitAGC
[ 5185.149315] drxk: SetPreSaw
[ 5185.149721] drxk: SetAgcRf
[ 5185.151720] drxk: SetAgcIf
[ 5185.155817] drxk: drxk_gate_ctrlenable
[ 5185.155820] drxk: ConfigureI2CBridge
[ 5185.155822] xc5000: xc5000_init()
[ 5185.159694] xc5000: xc5000_is_firmware_loaded() returns True id = 0x1388
[ 5185.166432] xc5000: xc_initialize()
[ 5185.416305] xc5000: *** ADC envelope (0-1023) = 4
[ 5185.421593] xc5000: *** Frequency error = 0 Hz
[ 5185.426676] xc5000: *** Lock status (0-Wait, 1-Locked, 2-No-signal) = 1
[ 5185.434622] xc5000: *** HW: V03.02, FW: V01.06.0072
[ 5185.440270] xc5000: *** Horizontal sync frequency = 14374 Hz
[ 5185.446579] xc5000: *** Frame lines = 1283
[ 5185.451389] xc5000: *** Quality (0:<8dB, 7:>56dB) = 9
[ 5185.456475] drxk: drxk_gate_ctrldisable
[ 5185.456477] drxk: ConfigureI2CBridge
[ 5185.456614] drxk: drxk_c_get_tune_settings
[ 5185.456773] drxk: drxk_set_parameters
[ 5185.456776] drxk: drxk_gate_ctrlenable
[ 5185.456778] drxk: ConfigureI2CBridge
[ 5185.457576] xc5000: xc5000_is_firmware_loaded() returns True id = 0x1388
[ 5185.464311] xc5000: xc5000_set_params() frequency=57000000 (Hz)
[ 5185.470268] xc5000: xc5000_set_params() QAM modulation
[ 5185.475439] xc5000: xc5000_set_params() Bandwidth 6MHz (5999550)
[ 5185.481473] xc5000: xc5000_set_params() frequency=55250000 (compensated)
[ 5185.488202] xc5000: xc_SetSignalSource(1) Source = CABLE
[ 5185.494524] xc5000: xc_SetTVStandard(0x8002,0x00c0)
[ 5185.499435] xc5000: xc_SetTVStandard() Standard = DTV6
[ 5185.513360] xc5000: xc_set_IF_frequency(freq_khz = 4000) freq_code = 0x1000
[ 5185.528244] xc5000: xc_tune_channel(55250000)
[ 5185.532643] xc5000: xc_set_RF_frequency(55250000)
[ 5185.729144] xc5000: *** ADC envelope (0-1023) = 744
[ 5185.734762] xc5000: *** Frequency error = 0 Hz
[ 5185.739739] xc5000: *** Lock status (0-Wait, 1-Locked, 2-No-signal) = 1
[ 5185.747612] xc5000: *** HW: V03.02, FW: V01.06.0072
[ 5185.753107] xc5000: *** Horizontal sync frequency = 15038 Hz
[ 5185.759410] xc5000: *** Frame lines = 65535
[ 5185.764408] xc5000: *** Quality (0:<8dB, 7:>56dB) = 5
[ 5185.769503] drxk: drxk_gate_ctrldisable
[ 5185.769505] drxk: ConfigureI2CBridge
[ 5185.769507] xc5000: xc5000_get_if_frequency()
[ 5185.773902] drxk: Start
[ 5185.773904] drxk: SetQAM
[ 5185.774845] drxk: QAMResetQAM
[ 5185.775218] drxk: scu_command
[ 5185.778738] drxk: QAMSetSymbolrate
[ 5185.779969] drxk: scu_command
[ 5185.783737] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
[ 5185.790388] drxk: 02 00 00 00 10 00 05 00 03 02                    ..........
[ 5185.790581] drxk: scu_command
[ 5185.793857] drxk: scu_command
[ 5185.797729] drxk: SetFrequencyShifter
[ 5185.798209] drxk: SetQAMMeasurement
[ 5185.808601] drxk: SetQAM64
[ 5185.829359] drxk: MPEGTSDtoSetup
[ 5185.836588] drxk: scu_command
	(I've aborted w_scan to avoid generating a too big dump)
[ 5188.837828] drxk: drxk_gate_ctrlenable
[ 5188.837833] drxk: ConfigureI2CBridge
[ 5188.837835] xc5000: xc5000_sleep()
[ 5188.841280] xc5000: xc5000_TunerReset()
[ 5188.845155] drxk: drxk_gate_ctrldisable
[ 5188.845157] drxk: ConfigureI2CBridge
[ 5188.845159] drxk: drxk_c_sleep
[ 5188.845160] drxk: ShutDown
[ 5188.845162] drxk: MPEGTSStop
