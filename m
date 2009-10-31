Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-ew0-f223.google.com ([209.85.219.223])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <albert.comerma@gmail.com>) id 1N4DBR-0005bW-Mt
	for linux-dvb@linuxtv.org; Sat, 31 Oct 2009 13:35:54 +0100
Received: by ewy23 with SMTP id 23so1220033ewy.26
	for <linux-dvb@linuxtv.org>; Sat, 31 Oct 2009 05:35:19 -0700 (PDT)
Message-ID: <4AEC2F03.6050205@gmail.com>
Date: Sat, 31 Oct 2009 13:35:15 +0100
From: Albert Comerma <albert.comerma@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] somebody messed something on xc2028 code?
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

Hi all, I just updated my ubuntu to karmic and found with surprise that 
with 2.6.31 kernel my device does not work... It seems to be related to 
the xc2028 code part since the kernel explosion happens when you try to 
tune the device, here it's my dmesg, any idea?

Albert

[ 1622.032196] usb 1-1: new high speed USB device using ehci_hcd and 
address 4
[ 1622.166041] usb 1-1: configuration #1 chosen from 1 choice
[ 1622.167341] dvb-usb: found a 'Pinnacle Expresscard 320cx' in cold 
state, will try to load a firmware
[ 1622.167353] usb 1-1: firmware: requesting dvb-usb-dib0700-1.20.fw
[ 1622.188465] dvb-usb: downloading firmware from file 
'dvb-usb-dib0700-1.20.fw'
[ 1622.396737] dib0700: firmware started successfully.
[ 1622.900198] dvb-usb: found a 'Pinnacle Expresscard 320cx' in warm state.
[ 1622.900308] dvb-usb: will pass the complete MPEG2 transport stream to 
the software demuxer.
[ 1622.900759] DVB: registering new adapter (Pinnacle Expresscard 320cx)
[ 1623.157839] DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
[ 1623.158165] xc2028 4-0061: creating new instance
[ 1623.158173] xc2028 4-0061: type set to XCeive xc2028/xc3028 tuner
[ 1623.158333] input: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:1a.7/usb1/1-1/input/input16
[ 1623.158418] dvb-usb: schedule remote query interval to 50 msecs.
[ 1623.158427] dvb-usb: Pinnacle Expresscard 320cx successfully 
initialized and connected.
[ 1670.979678] CE: hpet increasing min_delta_ns to 15000 nsec
[ 1753.316527] BUG: unable to handle kernel NULL pointer dereference at 
00000008
[ 1753.316543] IP: [<c03a8a13>] _request_firmware+0x1f3/0x250
[ 1753.316562] *pde = 00000000
[ 1753.316570] Oops: 0000 [#2] SMP
[ 1753.316578] last sysfs file: 
/sys/devices/LNXSYSTM:00/device:00/PNP0C0A:00/power_supply/BAT0/charge_full
[ 1753.316586] Modules linked in: tuner_xc2028 dvb_usb_dib0700 dib7000p 
dib7000m dvb_usb dvb_core dib3000mc dibx000_common dib0070 hidp 
binfmt_misc vboxnetflt vboxnetadp vboxdrv ppdev parport_pc 
snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss 
snd_mixer_oss snd_pcm arc4 ecb snd_seq_dummy snd_seq_oss iwlagn bridge 
stp bnep snd_seq_midi iwlcore snd_rawmidi joydev iptable_nat 
snd_seq_midi_event mac80211 nf_nat snd_seq nf_conntrack_ipv4 
nf_conntrack nf_defrag_ipv4 snd_timer snd_seq_device iptable_mangle snd 
sbp2 dell_wmi psmouse iptable_filter serio_raw ip_tables soundcore 
x_tables snd_page_alloc cfg80211 uvcvideo videodev v4l1_compat sdhci_pci 
sdhci led_class lp btusb dell_laptop dcdbas nvidia(P) parport usbhid 
dm_raid45 xor ohci1394 video output ieee1394 tg3 intel_agp agpgart
[ 1753.316753]
...

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
