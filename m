Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpout06.highway.telekom.at ([195.3.96.89]:40347 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752307Ab1KZU5p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Nov 2011 15:57:45 -0500
Message-ID: <4ED152C4.404@aon.at>
Date: Sat, 26 Nov 2011 21:57:40 +0100
From: Johann Klammer <klammerr@aon.at>
MIME-Version: 1.0
To: linux-usb@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: PROBLEM: EHCI disconnects DVB & HDD
References: <Pine.LNX.4.44L0.1111251022100.1951-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1111251022100.1951-100000@iolanthe.rowland.org>
Content-Type: multipart/mixed;
 boundary="------------070401020008090708090909"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070401020008090708090909
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Alan Stern wrote:
> This is probably a low-level hardware error.  Interference between the
> two ports of some kind.

This is quite possible. Have been able to produce a more verbose logfile 
snippet.


--------------070401020008090708090909
Content-Type: text/plain;
 name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.log"

[25045.734288] af9013_update_ber_unc: err bits:1286 total bits:16320000 abort count:0
[25045.734355] >>> 21 65 38 d3 85 03 03 01 10 
[25045.750125] <<< 65 00 
[25045.750197] >>> 21 66 38 d3 86 03 03 01 27 
[25045.766121] <<< 66 00 
[25045.766195] >>> 20 67 38 d3 91 00 03 01 
[25045.782147] <<< 67 00 11 
[25045.782218] >>> 21 68 38 d3 91 03 03 01 11 
[25045.798202] <<< 68 00 
[25047.489434] >>> 20 69 38 d5 07 00 03 01 
[25047.502162] <<< 69 00 72 
[25047.502235] af9013_update_signal_strength
[25047.502271] >>> 20 6a 38 d0 7c 00 03 01 
[25047.518083] <<< 6a 00 a8 
[25047.518154] >>> 20 6b 38 d0 7d 00 03 01 
[25047.534080] <<< 6b 00 47 
[25047.534151] >>> 20 6c 38 d2 e1 00 03 01 
[25047.550076] <<< 6c 00 08 
[25047.550146] >>> 20 6d 38 d2 e3 00 03 01 
[25047.566079] <<< 6d 00 0e 
[25047.566146] >>> 20 6e 38 d2 e4 00 03 01 
[25047.582140] <<< 6e 00 93 
[25047.582207] >>> 20 6f 38 d2 e5 00 03 01 
[25047.598075] <<< 6f 00 0b 
[25047.598146] >>> 20 70 38 d3 c1 00 03 01 
[25047.614080] <<< 70 00 58 
[25047.614153] >>> 21 71 38 d2 e2 03 03 01 01 
[25047.630138] <<< 71 00 
[25047.645438] >>> 20 72 38 d2 e6 00 03 01 
[25047.654097] <<< 72 00 f0 
[25047.654169] >>> 20 73 38 d2 e1 00 03 01 
[25047.670158] <<< 73 00 08 
[25047.670230] >>> 21 74 38 d2 e1 03 03 01 08 
[25047.686083] <<< 74 00 
[25047.686153] >>> 20 75 38 d3 91 00 03 01 
[25047.702087] <<< 75 00 11 
[25047.702163] >>> 20 76 38 d3 8a 00 03 01 
[25047.718158] <<< 76 00 00 
[25047.718232] >>> 20 77 38 d3 8b 00 03 01 
[25047.734083] <<< 77 00 00 
[25047.734162] >>> 20 78 38 d3 87 00 03 01 
[25047.750080] <<< 78 00 53 
[25047.750150] >>> 20 79 38 d3 88 00 03 01 
[25047.766142] <<< 79 00 03 
[25047.766214] >>> 20 7a 38 d3 89 00 03 01 
[25047.782061] <<< 7a 00 00 
[25047.782148] >>> 20 7b 38 d3 85 00 03 01 
[25047.798063] <<< 7b 00 10 
[25047.798143] >>> 20 7c 38 d3 86 00 03 01 
[25047.814130] <<< 7c 00 27 
[25047.814216] af9013_update_ber_unc: err bits:851 total bits:16320000 abort count:0
[25047.814279] >>> 21 7d 38 d3 85 03 03 01 10 
[25047.830052] <<< 7d 00 
[25047.830125] >>> 21 7e 38 d3 86 03 03 01 27 
[25047.846069] <<< 7e 00 
[25047.846130] >>> 20 7f 38 d3 91 00 03 01 
[25047.862066] <<< 7f 00 11 
[25047.862136] >>> 21 80 38 d3 91 03 03 01 11 
[25047.878084] <<< 80 00 
[25049.527925] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 000a
[25049.527990] ehci_hcd 0000:00:10.3: GetStatus port:1 status 00100a 0  ACK POWER sig=se0 PEC CSC
[25049.528039] hub 1-0:1.0: port 1, status 0100, change 0003, 12 Mb/s
[25049.528062] usb 1-1: USB disconnect, device number 2
[25049.528111] usb 1-1: unregistering device
[25049.528130] usb 1-1: unregistering interface 1-1:1.0
[25049.528374] usb-storage: storage_disconnect() called
[25049.541186] usb-storage: -- usb_stor_release_resources
[25049.541204] usb-storage: -- sending exit command to thread
[25049.541232] usb-storage: *** thread awakened.
[25049.541246] usb-storage: -- exiting
[25049.541299] usb-storage: -- dissociate_dev
[25049.541424] usb 1-1: usb_disable_device nuking all URBs
[25049.543935] ehci_hcd 0000:00:10.3: GetStatus port:1 status 001803 0  ACK POWER sig=j CSC CONNECT
[25049.569580] >>> 20 81 38 d5 07 00 03 01 
[25049.669642] hub 1-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x501
[25049.725674] ehci_hcd 0000:00:10.3: port 1 high speed
[25049.725718] ehci_hcd 0000:00:10.3: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
[25049.781694] usb 1-1: new high speed USB device number 4 using ehci_hcd
[25051.581718] usb 1-3: kdvb-ad-1-fe-0 timed out on ep2out len=0/8
[25051.581748] af9015: bulk message failed:-110 (8/0)
[25051.581802] af9013: I2C read failed reg:d507
[25052.565761] >>> 20 82 38 d5 07 00 03 01 
[25054.577928] usb 1-3: kdvb-ad-1-fe-0 timed out on ep2out len=0/8
[25054.577956] af9015: bulk message failed:-110 (8/0)
[25054.578012] af9013: I2C read failed reg:d507
[25054.794039] usb 1-1: khubd timed out on ep0in len=0/64
[25055.425927] >>> 20 83 38 d5 07 00 03 01 
[25057.438083] usb 1-3: kdvb-ad-1-fe-0 timed out on ep2out len=0/8
[25057.438110] af9015: bulk message failed:-110 (8/0)
[25057.438163] af9013: I2C read failed reg:d507
[25058.238115] >>> 20 84 38 d5 07 00 03 01 
[25059.806230] usb 1-1: khubd timed out on ep0in len=0/64
[25060.250263] usb 1-3: kdvb-ad-1-fe-0 timed out on ep2out len=0/8
[25060.250289] af9015: bulk message failed:-110 (8/0)
[25060.250342] af9013: I2C read failed reg:d507
[25061.058269] >>> 20 85 38 d5 07 00 03 01 
[25063.070487] usb 1-3: kdvb-ad-1-fe-0 timed out on ep2out len=0/8
[25063.070512] af9015: bulk message failed:-110 (8/0)
[25063.070565] af9013: I2C read failed reg:d507
[25063.922457] >>> 20 86 38 d5 07 00 03 01 
[25064.818955] usb 1-1: khubd timed out on ep0in len=0/64
[25064.874603] ehci_hcd 0000:00:10.3: port 1 high speed
[25064.874648] ehci_hcd 0000:00:10.3: GetStatus port:1 status 00100f 0  ACK POWER sig=se0 PEC PE CSC CONNECT
[25064.874761] hub 1-0:1.0: unable to enumerate USB device on port 1
[25064.874849] ehci_hcd 0000:00:10.3: GetStatus port:3 status 00180b 0  ACK POWER sig=j PEC CSC CONNECT
[25064.874893] hub 1-0:1.0: port 3, status 0501, change 0003, 480 Mb/s
[25064.874916] usb 1-3: USB disconnect, device number 3
[25064.874956] usb 1-3: unregistering device
[25064.874976] usb 1-3: unregistering interface 1-3:1.0
[25064.875349] ehci_hcd 0000:00:10.3: shutdown urb c735c6a0 ep2out-bulk
[25064.886554] af9015: bulk message failed:-108 (8/0)
[25064.886613] af9013: I2C read failed reg:d507
[25064.886690] ehci_hcd 0000:00:10.3: shutdown urb ceacb1a0 ep4in-bulk
[25064.886716] ehci_hcd 0000:00:10.3: shutdown urb ceacb220 ep4in-bulk
[25064.886741] ehci_hcd 0000:00:10.3: shutdown urb c3de5e40 ep4in-bulk
[25064.886766] ehci_hcd 0000:00:10.3: shutdown urb c3de5f40 ep4in-bulk
[25064.886791] ehci_hcd 0000:00:10.3: shutdown urb ceacb0a0 ep4in-bulk
[25064.886816] ehci_hcd 0000:00:10.3: shutdown urb ceacb120 ep4in-bulk
[25064.898556] af9015_usb_device_exit:
[25064.898601] af9015_i2c_exit:
[25064.898836] state before exiting everything: 3
[25064.899377] af9013_i2c_gate_ctrl: enable:1
[25064.899422] >>> 20 87 38 d4 17 00 03 01 
[25064.899497] af9015: bulk message failed:-19 (8/0)
[25064.899536] af9013: I2C read failed reg:d417
[25064.899572] af9013_i2c_gate_ctrl: enable:1
[25064.899605] >>> 20 88 38 d4 17 00 03 01 
[25064.899673] af9015: bulk message failed:-19 (8/0)
[25064.899711] af9013: I2C read failed reg:d417
[25064.899746] >>> 22 89 c0 00 17 39 01 01 f1 
[25064.899820] af9015: bulk message failed:-19 (9/0)
[25064.899861] tda18218: i2c wr failed ret:-19 reg:17 len:1
[25064.899901] af9013_i2c_gate_ctrl: enable:0
[25064.899934] >>> 20 8a 38 d4 17 00 03 01 
[25064.900003] af9015: bulk message failed:-19 (8/0)
[25064.900041] af9013: I2C read failed reg:d417
[25064.900075] af9013_i2c_gate_ctrl: enable:0
[25064.900108] >>> 20 8b 38 d4 17 00 03 01 
[25064.900177] af9015: bulk message failed:-19 (8/0)
[25064.900215] af9013: I2C read failed reg:d417
[25064.900250] af9013_sleep
[25064.900276] af9013_lock_led: onoff:0
[25064.900307] >>> 20 8c 38 d7 30 00 03 01 
[25064.900375] af9015: bulk message failed:-19 (8/0)
[25064.900413] af9013: I2C read failed reg:d730
[25064.900447] power control: 0
[25200.715024] INFO: task khubd:318 blocked for more than 120 seconds.
[25200.715083] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[25200.715139] khubd           D e087baf7     0   318      2 0x00000000
[25200.715200]  ce3f63e0 00000046 00d23940 e087baf7 000016cb ce3f63e0 ce3f63e0 c1263ea0
[25200.715292]  c101d1c5 47aac777 ca1effd0 7fffffff c125e525 00000001 ce3f63e0 c101e334
[25200.715384]  00100100 00200200 ccffb110 ca1effd0 ce961004 ce9388a4 00000246 ce31bc00
[25200.715476] Call Trace:
[25200.715538]  [<c101d1c5>] ? check_preempt_curr+0x52/0x62
[25200.715598]  [<c125e525>] ? wait_for_common+0x60/0xaa
[25200.715653]  [<c101e334>] ? try_to_wake_up+0x58/0x58
[25200.715838]  [<cf995b71>] ? dvb_unregister_frontend+0x95/0xcb [dvb_core]
[25200.715901]  [<c10360ba>] ? wake_up_bit+0x16/0x16
[25200.715991]  [<cfa80119>] ? dvb_usb_adapter_frontend_exit+0x12/0x21 [dvb_usb]
[25200.716083]  [<cfa7f2c3>] ? dvb_usb_exit+0x43/0xc0 [dvb_usb]
[25200.716191]  [<cfa7f373>] ? dvb_usb_device_exit+0x33/0x43 [dvb_usb]
[25200.716371]  [<cf9f70f5>] ? usb_unbind_interface+0x40/0xf2 [usbcore]
[25200.716458]  [<c119ddde>] ? __device_release_driver+0x5e/0x95
[25200.716512]  [<c119de2a>] ? device_release_driver+0x15/0x1e
[25200.716564]  [<c119da7e>] ? bus_remove_device+0x92/0xa7
[25200.716614]  [<c119bdd2>] ? device_del+0xea/0x12d
[25200.716748]  [<cf9f5a62>] ? usb_disable_device+0x78/0x178 [usbcore]
[25200.716944]  [<cf9f01fe>] ? usb_disconnect+0x9c/0xeb [usbcore]
[25200.717162]  [<cf9f1aa5>] ? hub_thread+0x60d/0xe11 [usbcore]
[25200.717222]  [<c10360ba>] ? wake_up_bit+0x16/0x16
[25200.717272]  [<c101d46d>] ? complete+0x23/0x2b
[25200.717407]  [<cf9f1498>] ? usb_remote_wakeup+0x40/0x40 [usbcore]
[25200.717462]  [<c1035e57>] ? kthread+0x62/0x67
[25200.717509]  [<c1035df5>] ? kthread_worker_fn+0xd9/0xd9
[25200.717570]  [<c125fe86>] ? kernel_thread_helper+0x6/0xd
[25320.714530] INFO: task khubd:318 blocked for more than 120 seconds.
[25320.714587] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[25320.714644] khubd           D e087baf7     0   318      2 0x00000000
[25320.714705]  ce3f63e0 00000046 00d23940 e087baf7 000016cb ce3f63e0 ce3f63e0 c1263ea0
[25320.714798]  c101d1c5 47aac777 ca1effd0 7fffffff c125e525 00000001 ce3f63e0 c101e334
[25320.714890]  00100100 00200200 ccffb110 ca1effd0 ce961004 ce9388a4 00000246 ce31bc00
[25320.714982] Call Trace:
[25320.715043]  [<c101d1c5>] ? check_preempt_curr+0x52/0x62
[25320.715103]  [<c125e525>] ? wait_for_common+0x60/0xaa
[25320.715157]  [<c101e334>] ? try_to_wake_up+0x58/0x58
[25320.715336]  [<cf995b71>] ? dvb_unregister_frontend+0x95/0xcb [dvb_core]
[25320.715399]  [<c10360ba>] ? wake_up_bit+0x16/0x16
[25320.715488]  [<cfa80119>] ? dvb_usb_adapter_frontend_exit+0x12/0x21 [dvb_usb]
[25320.715578]  [<cfa7f2c3>] ? dvb_usb_exit+0x43/0xc0 [dvb_usb]
[25320.715686]  [<cfa7f373>] ? dvb_usb_device_exit+0x33/0x43 [dvb_usb]
[25320.715864]  [<cf9f70f5>] ? usb_unbind_interface+0x40/0xf2 [usbcore]
[25320.715950]  [<c119ddde>] ? __device_release_driver+0x5e/0x95
[25320.716004]  [<c119de2a>] ? device_release_driver+0x15/0x1e
[25320.716056]  [<c119da7e>] ? bus_remove_device+0x92/0xa7
[25320.716105]  [<c119bdd2>] ? device_del+0xea/0x12d
[25320.716238]  [<cf9f5a62>] ? usb_disable_device+0x78/0x178 [usbcore]
[25320.716431]  [<cf9f01fe>] ? usb_disconnect+0x9c/0xeb [usbcore]
[25320.716646]  [<cf9f1aa5>] ? hub_thread+0x60d/0xe11 [usbcore]
[25320.716706]  [<c10360ba>] ? wake_up_bit+0x16/0x16
[25320.716756]  [<c101d46d>] ? complete+0x23/0x2b
[25320.716890]  [<cf9f1498>] ? usb_remote_wakeup+0x40/0x40 [usbcore]
[25320.716945]  [<c1035e57>] ? kthread+0x62/0x67
[25320.716992]  [<c1035df5>] ? kthread_worker_fn+0xd9/0xd9
[25320.717051]  [<c125fe86>] ? kernel_thread_helper+0x6/0xd
[25440.714130] INFO: task khubd:318 blocked for more than 120 seconds.
[25440.714266] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[25440.714375] khubd           D e087baf7     0   318      2 0x00000000
[25440.714452]  ce3f63e0 00000046 00d23940 e087baf7 000016cb ce3f63e0 ce3f63e0 c1263ea0
[25440.714599]  c101d1c5 47aac777 ca1effd0 7fffffff c125e525 00000001 ce3f63e0 c101e334
[25440.714743]  00100100 00200200 ccffb110 ca1effd0 ce961004 ce9388a4 00000246 ce31bc00
[25440.714851] Call Trace:
[25440.714930]  [<c101d1c5>] ? check_preempt_curr+0x52/0x62
[25440.715030]  [<c125e525>] ? wait_for_common+0x60/0xaa
[25440.715125]  [<c101e334>] ? try_to_wake_up+0x58/0x58
[25440.715328]  [<cf995b71>] ? dvb_unregister_frontend+0x95/0xcb [dvb_core]
[25440.715437]  [<c10360ba>] ? wake_up_bit+0x16/0x16
[25440.715534]  [<cfa80119>] ? dvb_usb_adapter_frontend_exit+0x12/0x21 [dvb_usb]
[25440.715625]  [<cfa7f2c3>] ? dvb_usb_exit+0x43/0xc0 [dvb_usb]
[25440.715735]  [<cfa7f373>] ? dvb_usb_device_exit+0x33/0x43 [dvb_usb]
[25440.715918]  [<cf9f70f5>] ? usb_unbind_interface+0x40/0xf2 [usbcore]
[25440.716007]  [<c119ddde>] ? __device_release_driver+0x5e/0x95
[25440.718967]  [<c119de2a>] ? device_release_driver+0x15/0x1e
[25440.719020]  [<c119da7e>] ? bus_remove_device+0x92/0xa7
[25440.719069]  [<c119bdd2>] ? device_del+0xea/0x12d
[25440.719206]  [<cf9f5a62>] ? usb_disable_device+0x78/0x178 [usbcore]
[25440.719398]  [<cf9f01fe>] ? usb_disconnect+0x9c/0xeb [usbcore]
[25440.719613]  [<cf9f1aa5>] ? hub_thread+0x60d/0xe11 [usbcore]
[25440.719673]  [<c10360ba>] ? wake_up_bit+0x16/0x16
[25440.719724]  [<c101d46d>] ? complete+0x23/0x2b
[25440.719858]  [<cf9f1498>] ? usb_remote_wakeup+0x40/0x40 [usbcore]
[25440.719912]  [<c1035e57>] ? kthread+0x62/0x67
[25440.719959]  [<c1035df5>] ? kthread_worker_fn+0xd9/0xd9
[25440.720020]  [<c125fe86>] ? kernel_thread_helper+0x6/0xd

--------------070401020008090708090909--
