Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.175])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <tim@dockerz.net>) id 1MaqrJ-0003Fv-9r
	for linux-dvb@linuxtv.org; Tue, 11 Aug 2009 14:53:46 +0200
Received: by wf-out-1314.google.com with SMTP id 28so1317106wff.17
	for <linux-dvb@linuxtv.org>; Tue, 11 Aug 2009 05:53:41 -0700 (PDT)
Message-ID: <4A8169D0.3030008@dockerz.net>
Date: Tue, 11 Aug 2009 13:53:36 +0100
From: Tim Docker <tim@dockerz.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] problem: Hauppauge Nova TD500
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

I'm trying to diagnose a problem with a mythtv setup based upon a 
hauppauge nova td 500. I've had the setup for some months - it seemed to 
work reasonably reliably initially, but over the last few weeks I've had 
consistent problems with the tuner card entering a state where it is 
unable to receive a signal. I was seeing multiple errors via dmesg of 
the form:

[27317.617958] DiB0070 I2C write failed

Web trawling suggested that this could be resolved with an updated 
driver - I did this yesterday, with the latest version from mercurial, 
obtained and built as per the instructions here:

http://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers 


I installed this over the top of the 2.6.27-14-generic kernel from the 
mythbuntu distribution, and manually installed the 1.20 firmware.

In 24 uptime hours I haven't seen any I2C errors, but unfortunately, it 
has still entered some state where I can't received a signal. 
Mysteriously, there doesn't appear to be any relevant errors or messages 
in dmesg. From the log snippet below, you can see that no signal is 
being returned by tzap, but if I unload and reload the modules, 
everything comes back to life.

I'd really appreciate any tips or pointers on what might be going wrong 
here.

Thanks,

Tim

------- snippet showing dmesg dvb related output at boot -----------------

[   11.935560] dib0700: loaded with support for 9 different device-types
[   11.935760] dvb-usb: found a 'Hauppauge Nova-TD-500 (84xxx)' in cold 
state, will try to load a firmware
[   11.935763] firmware: requesting dvb-usb-dib0700-1.20.fw
[   11.986891] phy0: Selected rate control algorithm 'pid'
[   12.153734] dvb-usb: downloading firmware from file 
'dvb-usb-dib0700-1.20.fw'
[   12.204961] Broadcom 43xx driver loaded [ Features: PLR, Firmware-ID: 
FW13 ]
[   12.361320] dib0700: firmware started successfully.
[   12.864020] dvb-usb: found a 'Hauppauge Nova-TD-500 (84xxx)' in warm 
state.
[   12.864066] dvb-usb: will pass the complete MPEG2 transport stream to 
the software demuxer.
[   12.864233] DVB: registering new adapter (Hauppauge Nova-TD-500 (84xxx))
[   13.087819] DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
[   13.263971] DiB0070: successfully identified
[   13.263975] dvb-usb: will pass the complete MPEG2 transport stream to 
the software demuxer.
[   13.264166] DVB: registering new adapter (Hauppauge Nova-TD-500 (84xxx))
[   13.402995] DVB: registering adapter 1 frontend 0 (DiBcom 7000PC)...
[   13.584024] DiB0070: successfully identified
[   13.584099] input: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:0a.0/0000:01:07.2/usb3/3-1/input/input5
[   13.596142] dvb-usb: schedule remote query interval to 50 msecs.
[   13.596148] dvb-usb: Hauppauge Nova-TD-500 (84xxx) successfully 
initialized and connected.
[   13.596297] usbcore: registered new interface driver dvb_usb_dib0700


------ history showing no-signal and recovery by reloading -----------

timd@dkz-mythtv:~$ sudo tzap -r -c ~/.tzap/channels.conf "ABC1"
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
tuning to 226500000 Hz
video pid 0x0200, audio pid 0x028a
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 | 
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 | 
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 | 
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 | 
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 | 
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 | 
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 | 
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 | 
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 | 
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 | 
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 | 
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 | 
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 | 
status 00 | signal ffff | snr 0000 | ber 00000000 | unc 00000000 | ^C
timd@dkz-mythtv:~$ sudo rmmod dib7000p dib7000m dib3000mc dib0070 
dvb_usb_dib0700
ERROR: Module dib7000p is in use by dvb_usb_dib0700
ERROR: Module dib7000m is in use by dvb_usb_dib0700
ERROR: Module dib3000mc is in use by dvb_usb_dib0700
ERROR: Module dib0070 is in use by dvb_usb_dib0700
timd@dkz-mythtv:~$ sudo rmmod dib7000p dib7000m dib3000mc dib0070 
dvb_usb_dib0700
ERROR: Module dvb_usb_dib0700 does not exist in /proc/modules
imd@dkz-mythtv:~$ sudo modprobe dvb-usb-dib0700
timd@dkz-mythtv:~$ sudo tzap -r -c ~/.tzap/channels.conf "ABC1"
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
tuning to 226500000 Hz
video pid 0x0200, audio pid 0x028a
status 1f | signal a89f | snr 0000 | ber 001fffff | unc 00000215 | 
FE_HAS_LOCK
status 1f | signal a8c3 | snr 0000 | ber 00000710 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal a8ac | snr 0000 | ber 00000480 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal a8e8 | snr 0000 | ber 000004b0 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal a8d8 | snr 0000 | ber 00000420 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal a8bc | snr 0000 | ber 000003c0 | unc 00000000 | 
FE_HAS_LOCK
status 1f | signal a8d0 | snr 0000 | ber 000005b0 | unc 00000000 | 
FE_HAS_LOCK


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
