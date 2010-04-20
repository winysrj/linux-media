Return-path: <linux-media-owner@vger.kernel.org>
Received: from smarthost02.mail.zen.net.uk ([212.23.3.141]:39086 "EHLO
	smarthost02.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751853Ab0DTWDU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Apr 2010 18:03:20 -0400
Message-ID: <4BCE2472.9000408@whitelands.org.uk>
Date: Tue, 20 Apr 2010 23:02:26 +0100
From: Paul Shepherd <paul@whitelands.org.uk>
MIME-Version: 1.0
To: william <kc@cobradevil.org>
CC: linux-media@vger.kernel.org
Subject: Re: Fwd: Tevii S660 USB card and dw2102 module generating RC messages
References: <4BC8219A.6060604@whitelands.org.uk> <s2k3907abe61004160234vd88652e6h2738162ba90d0279@mail.gmail.com> <4BC8A1AA.6020609@whitelands.org.uk> <4BCAB275.5000902@cobradevil.org>
In-Reply-To: <4BCAB275.5000902@cobradevil.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 18/04/2010 08:19, william wrote:
> Hello Paul,
>
> I know what is happening but i have no solution.
>
> The message: dw2102: query RC enter
>
> is a message from the ir receiver in the device.
> I noticed by accident that when you push some buttons on the remote
> (which came with the tevii box) while tailing the log file you will see
> the buttons on the remote.
>
> i'm not sure because my device did not work at all so i send it back to
> my supplier but i think the lib-s2planin drivers could fix it but i had
> no chance to test it myself.
> If you are going to try the s2planin drivers please let me know how it
> works!
>
> With kind regards
>
> William
>
>

I also discovered that RC is remote control.  Tried the v4l-dvb in 
various combos which looked promising for a period but usually ended up 
with either the s660 or my nova dvb-t usb flooding the system and 
rendering the usb keyboard unsable.  Tried increasing the query time on 
the RC which seemed to help but still had problems.

Then tried s2-liplianin code at your suggestion which looked promising 
but it was strangely requesting a 2nd upload dvb-fe-ds3000.fw which 
although present in /lib/firmware didn't occur. Later it crashed:

> Apr 18 23:23:12 antec300 kernel: [  324.866653] usb 1-1: new high speed USB device using ehci_hcd and address 4
> Apr 18 23:23:12 antec300 kernel: [  325.458058] usb 1-1: new high speed USB device using ehci_hcd and address 5
> Apr 18 23:23:12 antec300 kernel: [  325.590133] usb 1-1: configuration #1 chosen from 1 choice
> Apr 18 23:23:12 antec300 kernel: [  325.590330] dvb-usb: found a 'TeVii S660 USB' in cold state, will try to load a firmware
> Apr 18 23:23:12 antec300 kernel: [  325.590339] usb 1-1: firmware: requesting dvb-usb-s660.fw
> Apr 18 23:23:12 antec300 kernel: [  325.595031] dvb-usb: downloading firmware from file 'dvb-usb-s660.fw'
> Apr 18 23:23:12 antec300 kernel: [  325.595037] dw2102: start downloading DW210X firmware
> Apr 18 23:23:12 antec300 kernel: [  325.713426] dvb-usb: found a 'TeVii S660 USB' in warm state.
> Apr 18 23:23:12 antec300 kernel: [  325.713479] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
> Apr 18 23:23:12 antec300 kernel: [  325.717592] DVB: registering new adapter (TeVii S660 USB)
> Apr 18 23:23:18 antec300 kernel: [  331.716487] dvb-usb: MAC address: 00:00:a0:00:00:00
> Apr 18 23:23:18 antec300 kernel: [  331.780801] input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/input/input7
> Apr 18 23:23:18 antec300 kernel: [  331.780862] dvb-usb: schedule remote query interval to 150 msecs.
> Apr 18 23:23:18 antec300 kernel: [  331.780866] dvb-usb: TeVii S660 USB successfully initialized and connected.
> Apr 18 23:23:18 antec300 kernel: [  331.780905] usb 1-1: USB disconnect, address 5
> Apr 18 23:23:18 antec300 kernel: [  331.813419] dvb-usb: TeVii S660 USB successfully deinitialized and disconnected.
> Apr 18 23:23:19 antec300 kernel: [  332.051995] usb 1-1: new high speed USB device using ehci_hcd and address 6
> Apr 18 23:23:19 antec300 kernel: [  332.184522] usb 1-1: config 1 interface 0 altsetting 0 bulk endpoint 0x81 has invalid maxpacket 2
> Apr 18 23:23:19 antec300 kernel: [  332.185114] usb 1-1: configuration #1 chosen from 1 choice
> Apr 18 23:23:19 antec300 kernel: [  332.185298] dvb-usb: found a 'TeVii S660 USB' in cold state, will try to load a firmware
> Apr 18 23:23:19 antec300 kernel: [  332.185304] usb 1-1: firmware: requesting dvb-usb-s660.fw
> Apr 18 23:23:19 antec300 kernel: [  332.190277] dvb-usb: downloading firmware from file 'dvb-usb-s660.fw'
> Apr 18 23:23:19 antec300 kernel: [  332.190282] dw2102: start downloading DW210X firmware
> Apr 18 23:23:19 antec300 kernel: [  332.307623] dvb-usb: found a 'TeVii S660 USB' in warm state.
> Apr 18 23:23:19 antec300 kernel: [  332.307676] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
> Apr 18 23:23:19 antec300 kernel: [  332.307818] DVB: registering new adapter (TeVii S660 USB)
> Apr 18 23:23:23 antec300 kernel: [  336.413508] dvb-usb: MAC address: 00:18:bd:5c:60:b0
> Apr 18 23:23:23 antec300 kernel: [  336.462191] DS3000 chip version: 0.192 attached.
> Apr 18 23:23:23 antec300 kernel: [  336.462195] dw2102: Attached ds3000+ds2020!
> Apr 18 23:23:23 antec300 kernel: [  336.462197]
> Apr 18 23:23:23 antec300 kernel: [  336.462202] DVB: registering adapter 1 frontend 0 (Montage Technology DS3000/TS2020)...
> Apr 18 23:23:23 antec300 kernel: [  336.463198] input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1a.7/usb1/1-1/input/input8
> Apr 18 23:23:23 antec300 kernel: [  336.463244] dvb-usb: schedule remote query interval to 150 msecs.
> Apr 18 23:23:23 antec300 kernel: [  336.463250] dvb-usb: TeVii S660 USB successfully initialized and connected.
> Apr 18 23:24:00 antec300 kernel: [  373.534616] ds3000_firmware_ondemand: Waiting for firmware upload (dvb-fe-ds3000.fw)...
> Apr 18 23:24:00 antec300 kernel: [  373.534625] usb 1-1: firmware: requesting dvb-fe-ds3000.fw
> Apr 18 23:24:00 antec300 kernel: [  373.568629] ds3000_firmware_ondemand: Waiting for firmware upload(2)...
> Apr 19 07:42:02 antec300 rsyslogd: [origin software="rsyslogd" swVersion="4.2.0" x-pid="979" x-info="http://www.rsyslog.com"] rsyslogd was HUPed, type 'lightweight'.
> Apr 19 07:42:02 antec300 rsyslogd: [origin software="rsyslogd" swVersion="4.2.0" x-pid="979" x-info="http://www.rsyslog.com"] rsyslogd was HUPed, type 'lightweight'.
> Apr 19 13:58:51 antec300 kernel: [52785.475150] ds3000_firmware_ondemand: Waiting for firmware upload (dvb-fe-ds3000.fw)...
> Apr 19 13:58:51 antec300 kernel: [52785.475159] usb 1-1: firmware: requesting dvb-fe-ds3000.fw
> Apr 19 13:58:51 antec300 kernel: [52785.479716] ds3000_firmware_ondemand: Waiting for firmware upload(2)...
> Apr 19 17:46:30 antec300 kernel: [66424.255594] ds3000_firmware_ondemand: Waiting for firmware upload (dvb-fe-ds3000.fw)...
> Apr 19 17:46:30 antec300 kernel: [66424.255602] usb 1-1: firmware: requesting dvb-fe-ds3000.fw
> Apr 19 17:46:30 antec300 kernel: [66424.260652] ds3000_firmware_ondemand: Waiting for firmware upload(2)...
> Apr 19 19:06:34 antec300 kernel: [71220.731748] usb 1-1: USB disconnect, address 6
> Apr 19 19:09:44 antec300 kernel: [71410.033797] dvb-usb: TeVii S660 USB successfully deinitialized and disconnected.
> Apr 19 19:10:23 antec300 kernel: [71448.827499] usb 1-2: USB disconnect, address 2
> Apr 19 19:13:47 antec300 kernel: [71652.872116] khubd         D c08185c0     0    40      2 0x00000000
> Apr 19 19:13:47 antec300 kernel: [71652.872126]  f71a9da8 00000046 f2d58000 c08185c0 f7194168 c08185c0 85a47f55 000040fb
> Apr 19 19:13:47 antec300 kernel: [71652.872140]  c08185c0 c08185c0 f7194168 c08185c0 00000000 000040fb c08185c0 f2d46300
> Apr 19 19:13:47 antec300 kernel: [71652.872153]  f7193ed0 f43f5000 f71a9db8 f6b727f4 f71a9dd4 f830d4fd f71a9dbc c03a4552
> Apr 19 19:13:47 antec300 kernel: [71652.872166] Call Trace:
> Apr 19 19:13:47 antec300 kernel: [71652.872195]  [<f830d4fd>] dvb_unregister_frontend+0x9d/0xe0 [dvb_core]
> Apr 19 19:13:47 antec300 kernel: [71652.872207]  [<c03a4552>] ? device_unregister+0x12/0x20
> Apr 19 19:13:47 antec300 kernel: [71652.872216]  [<c015c180>] ? autoremove_wake_function+0x0/0x40
> Apr 19 19:13:47 antec300 kernel: [71652.872229]  [<f80eb095>] dvb_usb_adapter_frontend_exit+0x15/0x30 [dvb_usb]
> Apr 19 19:13:47 antec300 kernel: [71652.872240]  [<f80ea485>] dvb_usb_exit+0x45/0xf0 [dvb_usb]
> Apr 19 19:13:47 antec300 kernel: [71652.872249]  [<c0572da4>] ? mutex_lock+0x14/0x40
> Apr 19 19:13:47 antec300 kernel: [71652.872260]  [<f80ea55d>] dvb_usb_device_exit+0x2d/0x50 [dvb_usb]
> Apr 19 19:13:47 antec300 kernel: [71652.872272]  [<c0418ab9>] usb_unbind_interface+0xe9/0x120
> Apr 19 19:13:47 antec300 kernel: [71652.872280]  [<c03a691e>] __device_release_driver+0x3e/0x90
> Apr 19 19:13:47 antec300 kernel: [71652.872287]  [<c03a6a30>] device_release_driver+0x20/0x40
> Apr 19 19:13:47 antec300 kernel: [71652.872295]  [<c03a5d73>] bus_remove_device+0x73/0x90
> Apr 19 19:13:47 antec300 kernel: [71652.872302]  [<c03a44df>] device_del+0xef/0x150
> Apr 19 19:13:47 antec300 kernel: [71652.872310]  [<c041596d>] usb_disable_device+0x7d/0xf0
> Apr 19 19:13:47 antec300 kernel: [71652.872328]  [<c04105be>] usb_disconnect+0x9e/0x110
> Apr 19 19:13:47 antec300 kernel: [71652.872336]  [<c0410973>] hub_port_connect_change+0x83/0x830
> Apr 19 19:13:47 antec300 kernel: [71652.872344]  [<c0416640>] ? usb_control_msg+0xd0/0x120
> Apr 19 19:13:47 antec300 kernel: [71652.872352]  [<c040e7bb>] ? clear_port_feature+0x4b/0x60
> Apr 19 19:13:47 antec300 kernel: [71652.872359]  [<c04121d5>] hub_events+0x1f5/0x500
> Apr 19 19:13:47 antec300 kernel: [71652.872366]  [<c057209c>] ? schedule+0x40c/0x730
> Apr 19 19:13:47 antec300 kernel: [71652.872373]  [<c015c2da>] ? finish_wait+0x4a/0x70
> Apr 19 19:13:47 antec300 kernel: [71652.872380]  [<c04124e0>] ? hub_thread+0x0/0x150
> Apr 19 19:13:47 antec300 kernel: [71652.872387]  [<c0412515>] hub_thread+0x35/0x150
> Apr 19 19:13:47 antec300 kernel: [71652.872394]  [<c015c180>] ? autoremove_wake_function+0x0/0x40
> Apr 19 19:13:47 antec300 kernel: [71652.872402]  [<c015be8c>] kthread+0x7c/0x90
> Apr 19 19:13:47 antec300 kernel: [71652.872408]  [<c015be10>] ? kthread+0x0/0x90
> Apr 19 19:13:47 antec300 kernel: [71652.872417]  [<c0104047>] kernel_thread_helper+0x7/0x10
> Apr 19 19:15:47 antec300 kernel: [71772.692034] khubd         D c08185c0     0    40      2 0x00000000

Not even really sure whether it's the h/w, the firmware, the linux code 
or a combination; may even be an interaction with my existing nova usb 
device. Also don't know whether others have a working Ubuntu+S660 
combination.

I've wasted too many evenings on this and decided that the S660 on my pc 
is unlikely to be workable in the near term so have bought a Nova-HD-S2 
PCI card.  I'll probably have another go later perhaps on another pc.

paul

