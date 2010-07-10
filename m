Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51470 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180Ab0GJWXI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Jul 2010 18:23:08 -0400
Received: by vws5 with SMTP id 5so3162051vws.19
        for <linux-media@vger.kernel.org>; Sat, 10 Jul 2010 15:23:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTil3JUgSE43P12RWUkErU1Uj5uQrTJQTzkq9eZQB@mail.gmail.com>
References: <AANLkTil3JUgSE43P12RWUkErU1Uj5uQrTJQTzkq9eZQB@mail.gmail.com>
Date: Sun, 11 Jul 2010 00:23:06 +0200
Message-ID: <AANLkTil1wXrhQJwdxYoAQubAzgoK3qp5J6czsg0Z_qJU@mail.gmail.com>
Subject: Re: 2.6.35-rc4 doesn't play well with TerraTec cinergyT2
From: Jan Willies <jan@willies.info>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2010/7/5 Jan Willies <jan@willies.info>:
> I'm running 2.6.35-rc4 and get this with a TerraTec cinergyT2:
>
> Jul  5 10:03:03 htpc kernel: dvb-usb: found a 'TerraTec/qanu USB2.0
> Highspeed DVB-T Receiver' in warm state.
> Jul  5 10:03:05 htpc kernel: dvb-usb: bulk message failed: -110 (2/0)
> Jul  5 10:03:05 htpc kernel: dvb-usb: will pass the complete MPEG2
> transport stream to the software demuxer.
> Jul  5 10:03:05 htpc kernel: dvb-usb: will pass the complete MPEG2
> transport stream to the software demuxer.
> Jul  5 10:03:05 htpc kernel: DVB: registering new adapter
> (TerraTec/qanu USB2.0 Highspeed DVB-T Receiver)
> Jul  5 10:03:07 htpc kernel: dvb-usb: bulk message failed: -110 (1/0)
> Jul  5 10:03:07 htpc kernel: DVB: registering adapter 0 frontend 0
> (TerraTec/qanu USB2.0 Highspeed DVB-T Receiver)...
> Jul  5 10:03:07 htpc kernel: input: IR-receiver inside an USB DVB
> receiver as /devices/pci0000:00/0000:00:04.1/usb1/1-2/input/input4
> Jul  5 10:03:07 htpc kernel: dvb-usb: schedule remote query interval
> to 50 msecs.
> Jul  5 10:03:09 htpc kernel: dvb-usb: bulk message failed: -110 (2/0)
> Jul  5 10:03:09 htpc kernel: dvb-usb: TerraTec/qanu USB2.0 Highspeed
> DVB-T Receiver successfully initialized and connected.
> Jul  5 10:03:09 htpc kernel: dvb-usb: TerraTec/qanu USB2.0 Highspeed
> DVB-T Receiver successfully initialized and connected.
> Jul  5 10:03:09 htpc kernel: usbcore: registered new interface driver cinergyT2
> Jul  5 10:03:11 htpc kernel: dvb-usb: bulk message failed: -110 (1/0)
> Jul  5 10:03:13 htpc kernel: dvb-usb: bulk message failed: -110 (1/0)
> Jul  5 10:03:15 htpc kernel: dvb-usb: bulk message failed: -110 (1/0)
> Jul  5 10:03:17 htpc kernel: dvb-usb: bulk message failed: -110 (1/0)
> Jul  5 10:03:19 htpc kernel: dvb-usb: bulk message failed: -110 (1/0)
> Jul  5 10:03:22 htpc kernel: dvb-usb: bulk message failed: -110 (1/0)
> Jul  5 10:03:22 htpc kernel: usbcore: deregistering interface driver cinergyT2
> Jul  5 10:03:22 htpc kernel: dvb-usb: TerraTec/qanu USB2.0 Highspeed
> DVB-T Receiver successfully deinitialized and disconnected.
>
> 2.6.35-rc3 was ok. Is this a known regression or am I doing something wrong?

Now I'm getting these messages with my distros kernel too
(2.6.33.6-147.fc13.i686), along with a call trace:

dvb-usb: recv bulk message failed: -75
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (9/0)
cinergyT2: cinergyt2_fe_set_frontend() Failed! err=-110

dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (2/0)
dvb-usb: error while enabling fifo.
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (2/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
usbcore: deregistering interface driver cinergyT2
dvb-usb: TerraTec/qanu USB2.0 Highspeed DVB-T Receiver successfully
deinitialized and disconnected.
dvb-usb: found a 'TerraTec/qanu USB2.0 Highspeed DVB-T Receiver' in warm state.
dvb-usb: bulk message failed: -110 (2/0)
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (TerraTec/qanu USB2.0 Highspeed DVB-T Receiver)
dvb-usb: bulk message failed: -110 (1/0)
DVB: registering adapter 0 frontend 0 (TerraTec/qanu USB2.0 Highspeed
DVB-T Receiver)...
input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:06.1/usb2/2-1/input/input4
dvb-usb: schedule remote query interval to 50 msecs.
dvb-usb: bulk message failed: -110 (2/0)
dvb-usb: TerraTec/qanu USB2.0 Highspeed DVB-T Receiver successfully
initialized and connected.
usbcore: registered new interface driver cinergyT2
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
usbcore: deregistering interface driver cinergyT2
dvb-usb: bulk message failed: -108 (1/0)
dvb-usb: TerraTec/qanu USB2.0 Highspeed DVB-T Receiver successfully
deinitialized and disconnected.
dvb-usb: found a 'TerraTec/qanu USB2.0 Highspeed DVB-T Receiver' in warm state.
dvb-usb: bulk message failed: -110 (2/0)
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (TerraTec/qanu USB2.0 Highspeed DVB-T Receiver)
dvb-usb: bulk message failed: -110 (1/0)
DVB: registering adapter 0 frontend 0 (TerraTec/qanu USB2.0 Highspeed
DVB-T Receiver)...
input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:06.1/usb2/2-1/input/input5
dvb-usb: schedule remote query interval to 50 msecs.
dvb-usb: bulk message failed: -110 (2/0)
dvb-usb: TerraTec/qanu USB2.0 Highspeed DVB-T Receiver successfully
initialized and connected.
usbcore: registered new interface driver cinergyT2
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
usbcore: deregistering interface driver cinergyT2
dvb-usb: TerraTec/qanu USB2.0 Highspeed DVB-T Receiver successfully
deinitialized and disconnected.
dvb-usb: found a 'TerraTec/qanu USB2.0 Highspeed DVB-T Receiver' in warm state.
dvb-usb: bulk message failed: -110 (2/0)
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (TerraTec/qanu USB2.0 Highspeed DVB-T Receiver)
dvb-usb: bulk message failed: -110 (1/0)
DVB: registering adapter 0 frontend 0 (TerraTec/qanu USB2.0 Highspeed
DVB-T Receiver)...
input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:06.1/usb2/2-1/input/input6
dvb-usb: schedule remote query interval to 50 msecs.
dvb-usb: bulk message failed: -110 (2/0)
dvb-usb: TerraTec/qanu USB2.0 Highspeed DVB-T Receiver successfully
initialized and connected.
usbcore: registered new interface driver cinergyT2
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
dvb-usb: bulk message failed: -110 (1/0)
usbcore: deregistering interface driver cinergyT2
dvb-usb: bulk message failed: -108 (1/0)
dvb-usb: TerraTec/qanu USB2.0 Highspeed DVB-T Receiver successfully
deinitialized and disconnected.
usb 2-1: USB disconnect, address 2
usb 2-1: new high speed USB device using ehci_hcd and address 3
usb 2-1: config 1 interface 0 altsetting 0 bulk endpoint 0x1 has
invalid maxpacket 64
usb 2-1: config 1 interface 0 altsetting 0 bulk endpoint 0x81 has
invalid maxpacket 64
usb 2-1: New USB device found, idVendor=0ccd, idProduct=0038
usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-1: Product: Cinergy T²
usb 2-1: Manufacturer: TerraTec GmbH
dvb-usb: found a 'TerraTec/qanu USB2.0 Highspeed DVB-T Receiver' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (TerraTec/qanu USB2.0 Highspeed DVB-T Receiver)
DVB: registering adapter 0 frontend 0 (TerraTec/qanu USB2.0 Highspeed
DVB-T Receiver)...
input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:06.1/usb2/2-1/input/input7
dvb-usb: schedule remote query interval to 50 msecs.
dvb-usb: TerraTec/qanu USB2.0 Highspeed DVB-T Receiver successfully
initialized and connected.
usbcore: registered new interface driver cinergyT2
usb 2-1: USB disconnect, address 3
dvb-usb: bulk message failed: -22 (1/-186434564)
dvb-usb: bulk message failed: -22 (2/0)
dvb-usb: could not submit URB no. 0 - get them all back
dvb-usb: bulk message failed: -22 (2/-1068899786)
dvb-usb: error while enabling fifo.
dvb-usb: bulk message failed: -22 (1/-1030716876)
dvb-usb: bulk message failed: -22 (2/0)
dvb-usb: bulk message failed: -22 (1/-186434564)
dvb-usb: bulk message failed: -22 (1/-1028638272)
dvb-usb: bulk message failed: -22 (9/646)
cinergyT2: cinergyt2_fe_set_frontend() Failed! err=-22

dvb-usb: bulk message failed: -22 (1/800)
dvb-usb: bulk message failed: -22 (1/800)
dvb-usb: bulk message failed: -22 (2/0)
dvb-usb: bulk message failed: -22 (2/-1028619776)
dvb-usb: bulk message failed: -22 (1/-186434564)
dvb-usb: bulk message failed: -22 (9/646)
cinergyT2: cinergyt2_fe_set_frontend() Failed! err=-22

dvb-usb: bulk message failed: -22 (9/646)
cinergyT2: cinergyt2_fe_set_frontend() Failed! err=-22

dvb-usb: bulk message failed: -22 (1/800)
dvb-usb: bulk message failed: -22 (1/800)
dvb-usb: bulk message failed: -22 (1/800)
dvb-usb: bulk message failed: -22 (1/800)
dvb-usb: bulk message failed: -22 (1/800)
dvb-usb: bulk message failed: -22 (1/800)
dvb-usb: bulk message failed: -22 (1/800)
dvb-usb: bulk message failed: -22 (1/800)
dvb-usb: bulk message failed: -22 (1/800)
dvb-usb: bulk message failed: -22 (1/800)
dvb-usb: bulk message failed: -22 (1/800)
dvb-usb: bulk message failed: -22 (9/646)
cinergyT2: cinergyt2_fe_set_frontend() Failed! err=-22

dvb-usb: bulk message failed: -22 (1/800)
dvb-usb: bulk message failed: -22 (1/800)
dvb-usb: bulk message failed: -22 (9/646)
cinergyT2: cinergyt2_fe_set_frontend() Failed! err=-22

dvb-usb: bulk message failed: -22 (1/800)
dvb-usb: bulk message failed: -22 (1/800)
dvb-usb: bulk message failed: -22 (2/0)
INFO: task khubd:43 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
khubd         D 0000152b     0    43      2 0x00000000
 f6dd7dec 00000046 63a8c683 0000152b f6dcbf00 c0a266e4 c0a2b200 c0a2b200
 c0a2b200 f6dcc25c 00200200 015e9661 c2a036e4 00000002 00000000 0000152b
 f6dcbfc0 f6dd7dec 00000000 00000000 00000000 c0fb5400 00000001 f6dd7df4
Call Trace:
 [<f7d7cc57>] dvb_unregister_frontend+0x94/0xcb [dvb_core]
 [<c044be05>] ? autoremove_wake_function+0x0/0x2f
 [<f7ffbb75>] dvb_usb_adapter_frontend_exit+0x15/0x25 [dvb_usb]
 [<f7ffb308>] dvb_usb_exit+0x2c/0x91 [dvb_usb]
 [<f7ffb3a3>] dvb_usb_device_exit+0x36/0x4a [dvb_usb]
 [<c067c50b>] usb_unbind_interface+0x4b/0xc0
 [<c062eb60>] __device_release_driver+0x57/0x99
 [<c062ec37>] device_release_driver+0x18/0x23
 [<c062e0b2>] bus_remove_device+0x90/0xb9
 [<c062c8c2>] device_del+0xf3/0x14b
 [<c0679aa8>] usb_disable_device+0xa6/0x172
 [<c0674067>] usb_disconnect+0xcb/0x183
 [<c0675c97>] hub_thread+0x570/0x10d8
 [<c042b36b>] ? dequeue_task_fair+0x57/0x5c
 [<c044be05>] ? autoremove_wake_function+0x0/0x2f
 [<c044bac3>] kthread+0x5f/0x64
 [<c0675727>] ? hub_thread+0x0/0x10d8
 [<c0675727>] ? hub_thread+0x0/0x10d8
 [<c044bac3>] ? kthread+0x5f/0x64
 [<c044ba64>] ? kthread+0x0/0x64
 [<c040383e>] kernel_thread_helper+0x6/0x10
INFO: task khubd:43 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
khubd         D 0000152b     0    43      2 0x00000000
 f6dd7dec 00000046 63a8c683 0000152b f6dcbf00 c0a266e4 c0a2b200 c0a2b200
 c0a2b200 f6dcc25c 00200200 015e9661 c2a036e4 00000002 00000000 0000152b
 f6dcbfc0 f6dd7dec 00000000 00000000 00000000 c0fb5400 00000001 f6dd7df4
Call Trace:
 [<f7d7cc57>] dvb_unregister_frontend+0x94/0xcb [dvb_core]
 [<c044be05>] ? autoremove_wake_function+0x0/0x2f
 [<f7ffbb75>] dvb_usb_adapter_frontend_exit+0x15/0x25 [dvb_usb]
 [<f7ffb308>] dvb_usb_exit+0x2c/0x91 [dvb_usb]
 [<f7ffb3a3>] dvb_usb_device_exit+0x36/0x4a [dvb_usb]
 [<c067c50b>] usb_unbind_interface+0x4b/0xc0
 [<c062eb60>] __device_release_driver+0x57/0x99
 [<c062ec37>] device_release_driver+0x18/0x23
 [<c062e0b2>] bus_remove_device+0x90/0xb9
 [<c062c8c2>] device_del+0xf3/0x14b
 [<c0679aa8>] usb_disable_device+0xa6/0x172
 [<c0674067>] usb_disconnect+0xcb/0x183
 [<c0675c97>] hub_thread+0x570/0x10d8
 [<c042b36b>] ? dequeue_task_fair+0x57/0x5c
 [<c044be05>] ? autoremove_wake_function+0x0/0x2f
 [<c044bac3>] kthread+0x5f/0x64
 [<c0675727>] ? hub_thread+0x0/0x10d8
 [<c0675727>] ? hub_thread+0x0/0x10d8
 [<c044bac3>] ? kthread+0x5f/0x64
 [<c044ba64>] ? kthread+0x0/0x64
 [<c040383e>] kernel_thread_helper+0x6/0x10
INFO: task khubd:43 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
khubd         D 0000152b     0    43      2 0x00000000
 f6dd7dec 00000046 63a8c683 0000152b f6dcbf00 c0a266e4 c0a2b200 c0a2b200
 c0a2b200 f6dcc25c 00200200 015e9661 c2a036e4 00000002 00000000 0000152b
 f6dcbfc0 f6dd7dec 00000000 00000000 00000000 c0fb5400 00000001 f6dd7df4
Call Trace:
 [<f7d7cc57>] dvb_unregister_frontend+0x94/0xcb [dvb_core]
 [<c044be05>] ? autoremove_wake_function+0x0/0x2f
 [<f7ffbb75>] dvb_usb_adapter_frontend_exit+0x15/0x25 [dvb_usb]
 [<f7ffb308>] dvb_usb_exit+0x2c/0x91 [dvb_usb]
 [<f7ffb3a3>] dvb_usb_device_exit+0x36/0x4a [dvb_usb]
 [<c067c50b>] usb_unbind_interface+0x4b/0xc0
 [<c062eb60>] __device_release_driver+0x57/0x99
 [<c062ec37>] device_release_driver+0x18/0x23
 [<c062e0b2>] bus_remove_device+0x90/0xb9
 [<c062c8c2>] device_del+0xf3/0x14b
 [<c0679aa8>] usb_disable_device+0xa6/0x172
 [<c0674067>] usb_disconnect+0xcb/0x183
 [<c0675c97>] hub_thread+0x570/0x10d8
 [<c042b36b>] ? dequeue_task_fair+0x57/0x5c
 [<c044be05>] ? autoremove_wake_function+0x0/0x2f
 [<c044bac3>] kthread+0x5f/0x64
 [<c0675727>] ? hub_thread+0x0/0x10d8
 [<c0675727>] ? hub_thread+0x0/0x10d8
 [<c044bac3>] ? kthread+0x5f/0x64
 [<c044ba64>] ? kthread+0x0/0x64
 [<c040383e>] kernel_thread_helper+0x6/0x10
INFO: task khubd:43 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
khubd         D 0000152b     0    43      2 0x00000000
 f6dd7dec 00000046 63a8c683 0000152b f6dcbf00 c0a266e4 c0a2b200 c0a2b200
 c0a2b200 f6dcc25c 00200200 015e9661 c2a036e4 00000002 00000000 0000152b
 f6dcbfc0 f6dd7dec 00000000 00000000 00000000 c0fb5400 00000001 f6dd7df4
Call Trace:
 [<f7d7cc57>] dvb_unregister_frontend+0x94/0xcb [dvb_core]
 [<c044be05>] ? autoremove_wake_function+0x0/0x2f
 [<f7ffbb75>] dvb_usb_adapter_frontend_exit+0x15/0x25 [dvb_usb]
 [<f7ffb308>] dvb_usb_exit+0x2c/0x91 [dvb_usb]
 [<f7ffb3a3>] dvb_usb_device_exit+0x36/0x4a [dvb_usb]
 [<c067c50b>] usb_unbind_interface+0x4b/0xc0
 [<c062eb60>] __device_release_driver+0x57/0x99
 [<c062ec37>] device_release_driver+0x18/0x23
 [<c062e0b2>] bus_remove_device+0x90/0xb9
 [<c062c8c2>] device_del+0xf3/0x14b
 [<c0679aa8>] usb_disable_device+0xa6/0x172
 [<c0674067>] usb_disconnect+0xcb/0x183
 [<c0675c97>] hub_thread+0x570/0x10d8
 [<c042b36b>] ? dequeue_task_fair+0x57/0x5c
 [<c044be05>] ? autoremove_wake_function+0x0/0x2f
 [<c044bac3>] kthread+0x5f/0x64
 [<c0675727>] ? hub_thread+0x0/0x10d8
 [<c0675727>] ? hub_thread+0x0/0x10d8
 [<c044bac3>] ? kthread+0x5f/0x64
 [<c044ba64>] ? kthread+0x0/0x64
 [<c040383e>] kernel_thread_helper+0x6/0x10
INFO: task khubd:43 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
khubd         D 0000152b     0    43      2 0x00000000
 f6dd7dec 00000046 63a8c683 0000152b f6dcbf00 c0a266e4 c0a2b200 c0a2b200
 c0a2b200 f6dcc25c 00200200 015e9661 c2a036e4 00000002 00000000 0000152b
 f6dcbfc0 f6dd7dec 00000000 00000000 00000000 c0fb5400 00000001 f6dd7df4
Call Trace:
 [<f7d7cc57>] dvb_unregister_frontend+0x94/0xcb [dvb_core]
 [<c044be05>] ? autoremove_wake_function+0x0/0x2f
 [<f7ffbb75>] dvb_usb_adapter_frontend_exit+0x15/0x25 [dvb_usb]
 [<f7ffb308>] dvb_usb_exit+0x2c/0x91 [dvb_usb]
 [<f7ffb3a3>] dvb_usb_device_exit+0x36/0x4a [dvb_usb]
 [<c067c50b>] usb_unbind_interface+0x4b/0xc0
 [<c062eb60>] __device_release_driver+0x57/0x99
 [<c062ec37>] device_release_driver+0x18/0x23
 [<c062e0b2>] bus_remove_device+0x90/0xb9
 [<c062c8c2>] device_del+0xf3/0x14b
 [<c0679aa8>] usb_disable_device+0xa6/0x172
 [<c0674067>] usb_disconnect+0xcb/0x183
 [<c0675c97>] hub_thread+0x570/0x10d8
 [<c042b36b>] ? dequeue_task_fair+0x57/0x5c
 [<c044be05>] ? autoremove_wake_function+0x0/0x2f
 [<c044bac3>] kthread+0x5f/0x64
 [<c0675727>] ? hub_thread+0x0/0x10d8
 [<c0675727>] ? hub_thread+0x0/0x10d8
 [<c044bac3>] ? kthread+0x5f/0x64
 [<c044ba64>] ? kthread+0x0/0x64
 [<c040383e>] kernel_thread_helper+0x6/0x10
