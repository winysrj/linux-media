Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41047 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756931AbZKWLdp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 06:33:45 -0500
Date: Mon, 23 Nov 2009 12:33:38 +0100
From: grafgrimm77@gmx.de
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: dibusb-common.c FE_HAS_LOCK problem
Message-ID: <20091123123338.7273255b@x2.grafnetz>
In-Reply-To: <alpine.LRH.2.00.0911231206450.14263@pub1.ifh.de>
References: <20091107105614.7a51f2f5@x2.grafnetz>
	<alpine.LRH.2.00.0911191630250.12734@pub2.ifh.de>
	<20091121182514.61b39d23@x2.grafnetz>
	<alpine.LRH.2.00.0911230947540.14263@pub1.ifh.de>
	<20091123120310.5b10c9cc@x2.grafnetz>
	<alpine.LRH.2.00.0911231206450.14263@pub1.ifh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mon, 23 Nov 2009 12:11:40 +0100 (CET)
schrieb Patrick Boettcher <pboettcher@kernellabs.com>:

> On Mon, 23 Nov 2009, Mario Bachmann wrote:
> >> sequence in dibusb_i2c_xfer
> >>
> >> instead of break, please add something like
> >>
> >> printk(KERN_ERR "----- hello stupid I2C access ----\n");
> >>
> >> recompile and load the new module, then check whether the line is
> >> appearing in /var/log/messages or /var/log/syslog when you tune the board.
> >>
> >> If this is the case, try to identify which device is issuing the access by
> >> printing the i2c-address of struct i2c_msg.
> >>
> >> HTH,
> >> --
> >>
> >> Patrick
> >> http://www.kernellabs.com/
> >
> > Hello Patrick,
> >
> > I tried it with Kernel 2.6.31.6 (same as before).
> >
> > I made the printk-change, recompiled and reloaded the modules and pluged in my Twinhan Magic Box...
> > It definately jumps in the last else-branch and shows "hello stupid I2C access", but no KERN_ERR ?!
> 
> KERN_ERR is a prefix for printk to define the message priority to high. 
> (to have it in syslog or messages)
> 
> > dibusb: This device has the Thomson Cable onboard. Which is default.
> > ----- hello stupid I2C access ----
> 
> Hmm... where is this coming from:
> 
> can you write it like that:
> 
> else {
>  	printk(...);
>  	dump_stack();
> }
> 
> > Hey, without the break-command, tuning seems to work:
> > $ tzap pro7 -r
> > using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> > reading channels from file '/home/grafrotz/.tzap/channels.conf'
> > tuning to 738000000 Hz
> > video pid 0x0131, audio pid 0x0132
> > status 00 | signal 0000 | snr 0000 | ber 001fffff | unc 0000ffff |
> > status 1f | signal 0b20 | snr 008d | ber 001fffff | unc 0000ffff | FE_HAS_LOCK
> > status 1f | signal f4dd | snr 0077 | ber 00000770 | unc 00000000 | FE_HAS_LOCK
> > status 1f | signal ffff | snr 008c | ber 00000770 | unc 00000000 | FE_HAS_LOCK
> 
> We are close to identify the drivers in charge for the stupid I2c access.
> 
> --
> 
> Patrick Boettcher - Kernel Labs
> http://www.kernellabs.com/

I use this code now:
		} else
			printk(KERN_ERR "----- hello stupid I2C access ----\n");
			dump_stack();
	}

dmesg
dvb-usb: TwinhanDTV USB-Ter USB1.1 / Magic Box I / HAMA USB1.1 DVB-T device successfully deinitialized and disconnected.
usbcore: deregistering interface driver dvb_usb_dibusb_mb
usb 4-2: new full speed USB device using ohci_hcd and address 6
usb 4-2: configuration #1 chosen from 1 choice
dvb-usb: found a 'TwinhanDTV USB-Ter USB1.1 / Magic Box I / HAMA USB1.1 DVB-T device' in cold state, will try to load a firmware
usb 4-2: firmware: requesting dvb-usb-dibusb-5.0.0.11.fw
dvb-usb: downloading firmware from file 'dvb-usb-dibusb-5.0.0.11.fw'
usbcore: registered new interface driver dvb_usb_dibusb_mb
usb 4-2: USB disconnect, address 6
dvb-usb: generic DVB-USB module successfully deinitialized and disconnected.
usb 4-2: new full speed USB device using ohci_hcd and address 7
usb 4-2: configuration #1 chosen from 1 choice
dvb-usb: found a 'TwinhanDTV USB-Ter USB1.1 / Magic Box I / HAMA USB1.1 DVB-T device' in warm state.
dvb-usb: will use the device's hardware PID filter (table count: 16).
DVB: registering new adapter (TwinhanDTV USB-Ter USB1.1 / Magic Box I / HAMA USB1.1 DVB-T device)
Pid: 255, comm: khubd Tainted: P       A   2.6.31.6 #1
Call Trace:
 [<ffffffffa0042292>] ? dibusb_i2c_xfer+0xe2/0x130 [dvb_usb_dibusb_common]
 [<ffffffff81341dc1>] ? i2c_transfer+0x91/0xe0
 [<ffffffffa0059c23>] ? dib3000_read_reg+0x63/0x80 [dib3000mb]
 [<ffffffffa005ad52>] ? dib3000mb_attach+0x52/0xd4 [dib3000mb]
 [<ffffffffa0073268>] ? dibusb_dib3000mb_frontend_attach+0x28/0x50 [dvb_usb_dibusb_mb]
 [<ffffffffa0034ef3>] ? dvb_usb_adapter_frontend_init+0x13/0x100 [dvb_usb]
 [<ffffffffa0034837>] ? dvb_usb_device_init+0x357/0x630 [dvb_usb]
 [<ffffffff81314021>] ? usb_match_one_id+0x31/0xb0
 [<ffffffffa0073050>] ? dibusb_probe+0x20/0xa0 [dvb_usb_dibusb_mb]
 [<ffffffff81314962>] ? usb_probe_interface+0xa2/0x170
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff812b0ca0>] ? driver_probe_device+0x80/0x180
 [<ffffffff812b0e69>] ? __device_attach+0x29/0x60
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff812b013c>] ? bus_for_each_drv+0x5c/0x90
 [<ffffffff812b0f55>] ? device_attach+0x85/0x90
 [<ffffffff812aff45>] ? bus_probe_device+0x25/0x40
 [<ffffffff812ae879>] ? device_add+0x4d9/0x5a0
 [<ffffffff81313af0>] ? usb_set_configuration+0x4a0/0x670
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff8131c1cf>] ? generic_probe+0x2f/0xb0
 [<ffffffff812b0ca0>] ? driver_probe_device+0x80/0x180
 [<ffffffff812b0e69>] ? __device_attach+0x29/0x60
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff812b013c>] ? bus_for_each_drv+0x5c/0x90
 [<ffffffff812b0f55>] ? device_attach+0x85/0x90
 [<ffffffff812aff45>] ? bus_probe_device+0x25/0x40
 [<ffffffff812ae879>] ? device_add+0x4d9/0x5a0
 [<ffffffff8130ceda>] ? usb_new_device+0x5a/0xd0
 [<ffffffff8130e220>] ? hub_thread+0x7e0/0x1040
 [<ffffffff810564c6>] ? dequeue_task_fair+0x46/0x190
 [<ffffffff81074e70>] ? autoremove_wake_function+0x0/0x30
 [<ffffffff8130da40>] ? hub_thread+0x0/0x1040
 [<ffffffff81074ade>] ? kthread+0x9e/0xb0
 [<ffffffff8102c73a>] ? child_rip+0xa/0x20
 [<ffffffff81074a40>] ? kthread+0x0/0xb0
 [<ffffffff8102c730>] ? child_rip+0x0/0x20
Pid: 255, comm: khubd Tainted: P       A   2.6.31.6 #1
Call Trace:
 [<ffffffffa0042292>] ? dibusb_i2c_xfer+0xe2/0x130 [dvb_usb_dibusb_common]
 [<ffffffff81341dc1>] ? i2c_transfer+0x91/0xe0
 [<ffffffffa0059c23>] ? dib3000_read_reg+0x63/0x80 [dib3000mb]
 [<ffffffffa005ad66>] ? dib3000mb_attach+0x66/0xd4 [dib3000mb]
 [<ffffffffa0073268>] ? dibusb_dib3000mb_frontend_attach+0x28/0x50 [dvb_usb_dibusb_mb]
 [<ffffffffa0034ef3>] ? dvb_usb_adapter_frontend_init+0x13/0x100 [dvb_usb]
 [<ffffffffa0034837>] ? dvb_usb_device_init+0x357/0x630 [dvb_usb]
 [<ffffffff81314021>] ? usb_match_one_id+0x31/0xb0
 [<ffffffffa0073050>] ? dibusb_probe+0x20/0xa0 [dvb_usb_dibusb_mb]
 [<ffffffff81314962>] ? usb_probe_interface+0xa2/0x170
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff812b0ca0>] ? driver_probe_device+0x80/0x180
 [<ffffffff812b0e69>] ? __device_attach+0x29/0x60
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff812b013c>] ? bus_for_each_drv+0x5c/0x90
 [<ffffffff812b0f55>] ? device_attach+0x85/0x90
 [<ffffffff812aff45>] ? bus_probe_device+0x25/0x40
 [<ffffffff812ae879>] ? device_add+0x4d9/0x5a0
 [<ffffffff81313af0>] ? usb_set_configuration+0x4a0/0x670
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff8131c1cf>] ? generic_probe+0x2f/0xb0
 [<ffffffff812b0ca0>] ? driver_probe_device+0x80/0x180
 [<ffffffff812b0e69>] ? __device_attach+0x29/0x60
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff812b013c>] ? bus_for_each_drv+0x5c/0x90
 [<ffffffff812b0f55>] ? device_attach+0x85/0x90
 [<ffffffff812aff45>] ? bus_probe_device+0x25/0x40
 [<ffffffff812ae879>] ? device_add+0x4d9/0x5a0
 [<ffffffff8130ceda>] ? usb_new_device+0x5a/0xd0
 [<ffffffff8130e220>] ? hub_thread+0x7e0/0x1040
 [<ffffffff810564c6>] ? dequeue_task_fair+0x46/0x190
 [<ffffffff81074e70>] ? autoremove_wake_function+0x0/0x30
 [<ffffffff8130da40>] ? hub_thread+0x0/0x1040
 [<ffffffff81074ade>] ? kthread+0x9e/0xb0
 [<ffffffff8102c73a>] ? child_rip+0xa/0x20
 [<ffffffff81074a40>] ? kthread+0x0/0xb0
 [<ffffffff8102c730>] ? child_rip+0x0/0x20
DVB: registering adapter 0 frontend 0 (DiBcom 3000M-B DVB-T)...
Pid: 255, comm: khubd Tainted: P       A   2.6.31.6 #1
Call Trace:
 [<ffffffffa0042292>] ? dibusb_i2c_xfer+0xe2/0x130 [dvb_usb_dibusb_common]
 [<ffffffff81341dc1>] ? i2c_transfer+0x91/0xe0
 [<ffffffffa0059081>] ? dib3000_write_reg+0x51/0x70 [dib3000mb]
 [<ffffffffa0059a4f>] ? dib3000mb_tuner_pass_ctrl+0x1f/0x70 [dib3000mb]
 [<ffffffffa007318e>] ? dibusb_tuner_probe_and_attach+0x7e/0x130 [dvb_usb_dibusb_mb]
 [<ffffffffa0034f60>] ? dvb_usb_adapter_frontend_init+0x80/0x100 [dvb_usb]
 [<ffffffffa0034837>] ? dvb_usb_device_init+0x357/0x630 [dvb_usb]
 [<ffffffff81314021>] ? usb_match_one_id+0x31/0xb0
 [<ffffffffa0073050>] ? dibusb_probe+0x20/0xa0 [dvb_usb_dibusb_mb]
 [<ffffffff81314962>] ? usb_probe_interface+0xa2/0x170
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff812b0ca0>] ? driver_probe_device+0x80/0x180
 [<ffffffff812b0e69>] ? __device_attach+0x29/0x60
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff812b013c>] ? bus_for_each_drv+0x5c/0x90
 [<ffffffff812b0f55>] ? device_attach+0x85/0x90
 [<ffffffff812aff45>] ? bus_probe_device+0x25/0x40
 [<ffffffff812ae879>] ? device_add+0x4d9/0x5a0
 [<ffffffff81313af0>] ? usb_set_configuration+0x4a0/0x670
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff8131c1cf>] ? generic_probe+0x2f/0xb0
 [<ffffffff812b0ca0>] ? driver_probe_device+0x80/0x180
 [<ffffffff812b0e69>] ? __device_attach+0x29/0x60
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff812b013c>] ? bus_for_each_drv+0x5c/0x90
 [<ffffffff812b0f55>] ? device_attach+0x85/0x90
 [<ffffffff812aff45>] ? bus_probe_device+0x25/0x40
 [<ffffffff812ae879>] ? device_add+0x4d9/0x5a0
 [<ffffffff8130ceda>] ? usb_new_device+0x5a/0xd0
 [<ffffffff8130e220>] ? hub_thread+0x7e0/0x1040
 [<ffffffff810564c6>] ? dequeue_task_fair+0x46/0x190
 [<ffffffff81074e70>] ? autoremove_wake_function+0x0/0x30
 [<ffffffff8130da40>] ? hub_thread+0x0/0x1040
 [<ffffffff81074ade>] ? kthread+0x9e/0xb0
 [<ffffffff8102c73a>] ? child_rip+0xa/0x20
 [<ffffffff81074a40>] ? kthread+0x0/0xb0
 [<ffffffff8102c730>] ? child_rip+0x0/0x20
Pid: 255, comm: khubd Tainted: P       A   2.6.31.6 #1
Call Trace:
 [<ffffffffa0042292>] ? dibusb_i2c_xfer+0xe2/0x130 [dvb_usb_dibusb_common]
 [<ffffffff81341dc1>] ? i2c_transfer+0x91/0xe0
 [<ffffffffa0059081>] ? dib3000_write_reg+0x51/0x70 [dib3000mb]
 [<ffffffffa00731a5>] ? dibusb_tuner_probe_and_attach+0x95/0x130 [dvb_usb_dibusb_mb]
 [<ffffffffa0034f60>] ? dvb_usb_adapter_frontend_init+0x80/0x100 [dvb_usb]
 [<ffffffffa0034837>] ? dvb_usb_device_init+0x357/0x630 [dvb_usb]
 [<ffffffff81314021>] ? usb_match_one_id+0x31/0xb0
 [<ffffffffa0073050>] ? dibusb_probe+0x20/0xa0 [dvb_usb_dibusb_mb]
 [<ffffffff81314962>] ? usb_probe_interface+0xa2/0x170
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff812b0ca0>] ? driver_probe_device+0x80/0x180
 [<ffffffff812b0e69>] ? __device_attach+0x29/0x60
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff812b013c>] ? bus_for_each_drv+0x5c/0x90
 [<ffffffff812b0f55>] ? device_attach+0x85/0x90
 [<ffffffff812aff45>] ? bus_probe_device+0x25/0x40
 [<ffffffff812ae879>] ? device_add+0x4d9/0x5a0
 [<ffffffff81313af0>] ? usb_set_configuration+0x4a0/0x670
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff8131c1cf>] ? generic_probe+0x2f/0xb0
 [<ffffffff812b0ca0>] ? driver_probe_device+0x80/0x180
 [<ffffffff812b0e69>] ? __device_attach+0x29/0x60
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff812b013c>] ? bus_for_each_drv+0x5c/0x90
 [<ffffffff812b0f55>] ? device_attach+0x85/0x90
 [<ffffffff812aff45>] ? bus_probe_device+0x25/0x40
 [<ffffffff812ae879>] ? device_add+0x4d9/0x5a0
 [<ffffffff8130ceda>] ? usb_new_device+0x5a/0xd0
 [<ffffffff8130e220>] ? hub_thread+0x7e0/0x1040
 [<ffffffff810564c6>] ? dequeue_task_fair+0x46/0x190
 [<ffffffff81074e70>] ? autoremove_wake_function+0x0/0x30
 [<ffffffff8130da40>] ? hub_thread+0x0/0x1040
 [<ffffffff81074ade>] ? kthread+0x9e/0xb0
 [<ffffffff8102c73a>] ? child_rip+0xa/0x20
 [<ffffffff81074a40>] ? kthread+0x0/0xb0
 [<ffffffff8102c730>] ? child_rip+0x0/0x20
Pid: 255, comm: khubd Tainted: P       A   2.6.31.6 #1
Call Trace:
 [<ffffffffa0042292>] ? dibusb_i2c_xfer+0xe2/0x130 [dvb_usb_dibusb_common]
 [<ffffffff81341dc1>] ? i2c_transfer+0x91/0xe0
 [<ffffffffa0059081>] ? dib3000_write_reg+0x51/0x70 [dib3000mb]
 [<ffffffffa0059a6d>] ? dib3000mb_tuner_pass_ctrl+0x3d/0x70 [dib3000mb]
 [<ffffffffa00731c5>] ? dibusb_tuner_probe_and_attach+0xb5/0x130 [dvb_usb_dibusb_mb]
 [<ffffffffa0034f60>] ? dvb_usb_adapter_frontend_init+0x80/0x100 [dvb_usb]
 [<ffffffffa0034837>] ? dvb_usb_device_init+0x357/0x630 [dvb_usb]
 [<ffffffff81314021>] ? usb_match_one_id+0x31/0xb0
 [<ffffffffa0073050>] ? dibusb_probe+0x20/0xa0 [dvb_usb_dibusb_mb]
 [<ffffffff81314962>] ? usb_probe_interface+0xa2/0x170
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff812b0ca0>] ? driver_probe_device+0x80/0x180
 [<ffffffff812b0e69>] ? __device_attach+0x29/0x60
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff812b013c>] ? bus_for_each_drv+0x5c/0x90
 [<ffffffff812b0f55>] ? device_attach+0x85/0x90
 [<ffffffff812aff45>] ? bus_probe_device+0x25/0x40
 [<ffffffff812ae879>] ? device_add+0x4d9/0x5a0
 [<ffffffff81313af0>] ? usb_set_configuration+0x4a0/0x670
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff8131c1cf>] ? generic_probe+0x2f/0xb0
 [<ffffffff812b0ca0>] ? driver_probe_device+0x80/0x180
 [<ffffffff812b0e69>] ? __device_attach+0x29/0x60
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff812b013c>] ? bus_for_each_drv+0x5c/0x90
 [<ffffffff812b0f55>] ? device_attach+0x85/0x90
 [<ffffffff812aff45>] ? bus_probe_device+0x25/0x40
 [<ffffffff812ae879>] ? device_add+0x4d9/0x5a0
 [<ffffffff8130ceda>] ? usb_new_device+0x5a/0xd0
 [<ffffffff8130e220>] ? hub_thread+0x7e0/0x1040
 [<ffffffff810564c6>] ? dequeue_task_fair+0x46/0x190
 [<ffffffff81074e70>] ? autoremove_wake_function+0x0/0x30
 [<ffffffff8130da40>] ? hub_thread+0x0/0x1040
 [<ffffffff81074ade>] ? kthread+0x9e/0xb0
 [<ffffffff8102c73a>] ? child_rip+0xa/0x20
 [<ffffffff81074a40>] ? kthread+0x0/0xb0
 [<ffffffff8102c730>] ? child_rip+0x0/0x20
dibusb: This device has the Thomson Cable onboard. Which is default.
Pid: 255, comm: khubd Tainted: P       A   2.6.31.6 #1
Call Trace:
 [<ffffffffa0042292>] ? dibusb_i2c_xfer+0xe2/0x130 [dvb_usb_dibusb_common]
 [<ffffffff81341dc1>] ? i2c_transfer+0x91/0xe0
 [<ffffffffa0059081>] ? dib3000_write_reg+0x51/0x70 [dib3000mb]
 [<ffffffffa0059a4f>] ? dib3000mb_tuner_pass_ctrl+0x1f/0x70 [dib3000mb]
 [<ffffffffa00855b9>] ? dvb_pll_attach+0x99/0x238 [dvb_pll]
 [<ffffffffa00730ff>] ? dibusb_thomson_tuner_attach+0x2f/0x40 [dvb_usb_dibusb_mb]
 [<ffffffffa0073226>] ? dibusb_tuner_probe_and_attach+0x116/0x130 [dvb_usb_dibusb_mb]
 [<ffffffffa0034f60>] ? dvb_usb_adapter_frontend_init+0x80/0x100 [dvb_usb]
 [<ffffffffa0034837>] ? dvb_usb_device_init+0x357/0x630 [dvb_usb]
 [<ffffffff81314021>] ? usb_match_one_id+0x31/0xb0
 [<ffffffffa0073050>] ? dibusb_probe+0x20/0xa0 [dvb_usb_dibusb_mb]
 [<ffffffff81314962>] ? usb_probe_interface+0xa2/0x170
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff812b0ca0>] ? driver_probe_device+0x80/0x180
 [<ffffffff812b0e69>] ? __device_attach+0x29/0x60
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff812b013c>] ? bus_for_each_drv+0x5c/0x90
 [<ffffffff812b0f55>] ? device_attach+0x85/0x90
 [<ffffffff812aff45>] ? bus_probe_device+0x25/0x40
 [<ffffffff812ae879>] ? device_add+0x4d9/0x5a0
 [<ffffffff81313af0>] ? usb_set_configuration+0x4a0/0x670
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff8131c1cf>] ? generic_probe+0x2f/0xb0
 [<ffffffff812b0ca0>] ? driver_probe_device+0x80/0x180
 [<ffffffff812b0e69>] ? __device_attach+0x29/0x60
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff812b013c>] ? bus_for_each_drv+0x5c/0x90
 [<ffffffff812b0f55>] ? device_attach+0x85/0x90
 [<ffffffff812aff45>] ? bus_probe_device+0x25/0x40
 [<ffffffff812ae879>] ? device_add+0x4d9/0x5a0
 [<ffffffff8130ceda>] ? usb_new_device+0x5a/0xd0
 [<ffffffff8130e220>] ? hub_thread+0x7e0/0x1040
 [<ffffffff810564c6>] ? dequeue_task_fair+0x46/0x190
 [<ffffffff81074e70>] ? autoremove_wake_function+0x0/0x30
 [<ffffffff8130da40>] ? hub_thread+0x0/0x1040
 [<ffffffff81074ade>] ? kthread+0x9e/0xb0
 [<ffffffff8102c73a>] ? child_rip+0xa/0x20
 [<ffffffff81074a40>] ? kthread+0x0/0xb0
 [<ffffffff8102c730>] ? child_rip+0x0/0x20
----- hello stupid I2C access ----
Pid: 255, comm: khubd Tainted: P       A   2.6.31.6 #1
Call Trace:
 [<ffffffffa0042292>] ? dibusb_i2c_xfer+0xe2/0x130 [dvb_usb_dibusb_common]
 [<ffffffff81341dc1>] ? i2c_transfer+0x91/0xe0
 [<ffffffffa0059081>] ? dib3000_write_reg+0x51/0x70 [dib3000mb]
 [<ffffffffa00855c9>] ? dvb_pll_attach+0xa9/0x238 [dvb_pll]
 [<ffffffffa00730ff>] ? dibusb_thomson_tuner_attach+0x2f/0x40 [dvb_usb_dibusb_mb]
 [<ffffffffa0073226>] ? dibusb_tuner_probe_and_attach+0x116/0x130 [dvb_usb_dibusb_mb]
 [<ffffffffa0034f60>] ? dvb_usb_adapter_frontend_init+0x80/0x100 [dvb_usb]
 [<ffffffffa0034837>] ? dvb_usb_device_init+0x357/0x630 [dvb_usb]
 [<ffffffff81314021>] ? usb_match_one_id+0x31/0xb0
 [<ffffffffa0073050>] ? dibusb_probe+0x20/0xa0 [dvb_usb_dibusb_mb]
 [<ffffffff81314962>] ? usb_probe_interface+0xa2/0x170
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff812b0ca0>] ? driver_probe_device+0x80/0x180
 [<ffffffff812b0e69>] ? __device_attach+0x29/0x60
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff812b013c>] ? bus_for_each_drv+0x5c/0x90
 [<ffffffff812b0f55>] ? device_attach+0x85/0x90
 [<ffffffff812aff45>] ? bus_probe_device+0x25/0x40
 [<ffffffff812ae879>] ? device_add+0x4d9/0x5a0
 [<ffffffff81313af0>] ? usb_set_configuration+0x4a0/0x670
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff8131c1cf>] ? generic_probe+0x2f/0xb0
 [<ffffffff812b0ca0>] ? driver_probe_device+0x80/0x180
 [<ffffffff812b0e69>] ? __device_attach+0x29/0x60
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff812b013c>] ? bus_for_each_drv+0x5c/0x90
 [<ffffffff812b0f55>] ? device_attach+0x85/0x90
 [<ffffffff812aff45>] ? bus_probe_device+0x25/0x40
 [<ffffffff812ae879>] ? device_add+0x4d9/0x5a0
 [<ffffffff8130ceda>] ? usb_new_device+0x5a/0xd0
 [<ffffffff8130e220>] ? hub_thread+0x7e0/0x1040
 [<ffffffff810564c6>] ? dequeue_task_fair+0x46/0x190
 [<ffffffff81074e70>] ? autoremove_wake_function+0x0/0x30
 [<ffffffff8130da40>] ? hub_thread+0x0/0x1040
 [<ffffffff81074ade>] ? kthread+0x9e/0xb0
 [<ffffffff8102c73a>] ? child_rip+0xa/0x20
 [<ffffffff81074a40>] ? kthread+0x0/0xb0
 [<ffffffff8102c730>] ? child_rip+0x0/0x20
Pid: 255, comm: khubd Tainted: P       A   2.6.31.6 #1
Call Trace:
 [<ffffffffa0042292>] ? dibusb_i2c_xfer+0xe2/0x130 [dvb_usb_dibusb_common]
 [<ffffffff81341dc1>] ? i2c_transfer+0x91/0xe0
 [<ffffffffa0059081>] ? dib3000_write_reg+0x51/0x70 [dib3000mb]
 [<ffffffffa0059a6d>] ? dib3000mb_tuner_pass_ctrl+0x3d/0x70 [dib3000mb]
 [<ffffffffa0085613>] ? dvb_pll_attach+0xf3/0x238 [dvb_pll]
 [<ffffffffa00730ff>] ? dibusb_thomson_tuner_attach+0x2f/0x40 [dvb_usb_dibusb_mb]
 [<ffffffffa0073226>] ? dibusb_tuner_probe_and_attach+0x116/0x130 [dvb_usb_dibusb_mb]
 [<ffffffffa0034f60>] ? dvb_usb_adapter_frontend_init+0x80/0x100 [dvb_usb]
 [<ffffffffa0034837>] ? dvb_usb_device_init+0x357/0x630 [dvb_usb]
 [<ffffffff81314021>] ? usb_match_one_id+0x31/0xb0
 [<ffffffffa0073050>] ? dibusb_probe+0x20/0xa0 [dvb_usb_dibusb_mb]
 [<ffffffff81314962>] ? usb_probe_interface+0xa2/0x170
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff812b0ca0>] ? driver_probe_device+0x80/0x180
 [<ffffffff812b0e69>] ? __device_attach+0x29/0x60
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff812b013c>] ? bus_for_each_drv+0x5c/0x90
 [<ffffffff812b0f55>] ? device_attach+0x85/0x90
 [<ffffffff812aff45>] ? bus_probe_device+0x25/0x40
 [<ffffffff812ae879>] ? device_add+0x4d9/0x5a0
 [<ffffffff81313af0>] ? usb_set_configuration+0x4a0/0x670
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff8131c1cf>] ? generic_probe+0x2f/0xb0
 [<ffffffff812b0ca0>] ? driver_probe_device+0x80/0x180
 [<ffffffff812b0e69>] ? __device_attach+0x29/0x60
 [<ffffffff812b0e40>] ? __device_attach+0x0/0x60
 [<ffffffff812b013c>] ? bus_for_each_drv+0x5c/0x90
 [<ffffffff812b0f55>] ? device_attach+0x85/0x90
 [<ffffffff812aff45>] ? bus_probe_device+0x25/0x40
 [<ffffffff812ae879>] ? device_add+0x4d9/0x5a0
 [<ffffffff8130ceda>] ? usb_new_device+0x5a/0xd0
 [<ffffffff8130e220>] ? hub_thread+0x7e0/0x1040
 [<ffffffff810564c6>] ? dequeue_task_fair+0x46/0x190
 [<ffffffff81074e70>] ? autoremove_wake_function+0x0/0x30
 [<ffffffff8130da40>] ? hub_thread+0x0/0x1040
 [<ffffffff81074ade>] ? kthread+0x9e/0xb0
 [<ffffffff8102c73a>] ? child_rip+0xa/0x20
 [<ffffffff81074a40>] ? kthread+0x0/0xb0
 [<ffffffff8102c730>] ? child_rip+0x0/0x20
input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:04.0/usb4/4-2/input/input6
dvb-usb: schedule remote query interval to 150 msecs.
dvb-usb: TwinhanDTV USB-Ter USB1.1 / Magic Box I / HAMA USB1.1 DVB-T device successfully initialized and connected.
