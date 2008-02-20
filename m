Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.169])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <achasper@gmail.com>) id 1JRvNe-00070x-7I
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 21:17:26 +0100
Received: by ug-out-1314.google.com with SMTP id o29so1304352ugd.20
	for <linux-dvb@linuxtv.org>; Wed, 20 Feb 2008 12:17:20 -0800 (PST)
From: "A. C. Hasper" <achasper@gmail.com>
To: linux-dvb@linuxtv.org
Date: Wed, 20 Feb 2008 21:17:58 +0100
Message-Id: <1203538678.8313.12.camel@srv-roden.vogelwikke.nl>
Mime-Version: 1.0
Subject: [linux-dvb] Driver source for Freecom DVB-T (with usb id 14aa:0160)
	v0.0.2	works
Reply-To: achasper@gmail.com
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

I have just received the driver source (v0.0.2) for the Freecom DVB-T
USB device with usb id 14aa:0160 from Realtek. The bug in v0.0.1 seems
to be fixed. I can now tune to channels and watch TV (tested with
Kaffeine).

dmesg output:

usb 3-1: USB disconnect, address 3
usb 5-5: new high speed USB device using ehci_hcd and address 9
usb 5-5: new device found, idVendor=14aa, idProduct=0160
usb 5-5: new device strings: Mfr=1, Product=2, SerialNumber=3
usb 5-5: Product: DTV Receiver
usb 5-5: Manufacturer: DTV Receiver
usb 5-5: SerialNumber: 0000000000039537
usb 5-5: configuration #1 chosen from 1 choice
dvb-usb: found a 'Freecom USB 2.0 DVB-T Device' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
DVB: registering new adapter (Freecom USB 2.0 DVB-T Device)
+rtd2831u_fe_attach
-rtd2831u_fe_attach
DVB: registering frontend 0 (Realtek RTD2830 DVB-T)...
input: IR-receiver inside an USB DVB receiver as /class/input/input7
dvb-usb: schedule remote query interval to 300 msecs.
dvb-usb: Freecom USB 2.0 DVB-T Device successfully initialized and
connected.

and some output while scanning for channels:

+ ########################## rtd2830_init: 441: init once v.0.0.2
#####################################################TD2831_RMAP_INDEX_USB_STAT=0x3
HIGH SPEED
#####################################################RTD2831_RMAP_INDEX_SYS_GPO=0x10
#####################################################RTD2831_RMAP_INDEX_SYS_GPO=0x1
#####################################################RTD2831_RMAP_INDEX_SYS_GPO=0x5
This device has the MT2060 onboard.....
CDevice::MT2060TunerInit -- begin
MT2060_Open -- Start
MT2060_Open:MT_NO_ERROR -->MT2060_ReInit
MT2060_ReInit -- start
MT2060_ReInit:Initialize the tuner state.
MT2060_ReInit:Write the default values to each of the tuner registers
******************** read time = 1 ******************
MT2060_Open -- end
MT2060_SetParam
MT2060_SetGainRange
CDevice::MT2060TunerInit -- end
###################rtd2830_general_init:
rtd2830_general_init : demod know tuner type MT2060
rtd2830_general_init
- rtd2830_init
rtd2830_get_tune_settings: Do Nothing
+ rtd2830_set_parameters
CDevice::SetMT2060Tuner -- begin
MT2060_ChangeFreq -- start
f_in = 786000000, f_IF1 = 1220000000, f_out = 36125000, f_IFBW =
8750000Round_fLO
MT_ResetExclZones
MT_AvoidSpurs status = 0ofLO1=1871000000, ofLO2=1176250000,
pInfo->reg[LO_STATUS]=8 
status1 = 0
status2 = 0
status3 = 0
status = 0, reg[LO1_1] = 0xffstatus4 = 0
Write LO1C_1 register
MT2060_ChangeFreq -- end
CDevice::SetMT2060Tuner -- end
+rtd2830_soft_reset
-rtd2830_soft_reset
rtd2830_scan_channel_procedure : *****SIGNAL_LOCK***** 
- rtd2830_set_parameters
  rtd2830_read_status ******FSM = 11******
  rtd2830_read_status ******FSM = 11******
  rtd2830_read_status ******FSM = 11******
  rtd2830_read_status ******FSM = 11******
...

As you can see it does find the correct tuner chip now.

Driver source can be downloaded from
http://www.megaupload.com/?d=DPE2C8I5

Instructions on how to build the driver can be found in the Doc/
directory.

Have fun.
Andy


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
