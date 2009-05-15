Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:63174 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbZEOLPF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2009 07:15:05 -0400
Received: by bwz22 with SMTP id 22so1832311bwz.37
        for <linux-media@vger.kernel.org>; Fri, 15 May 2009 04:15:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <23be820f0905141553t1829e70buc491fa28493d7334@mail.gmail.com>
References: <23be820f0905141410k3cc3840eyd17b95730ec91f5c@mail.gmail.com>
	 <23be820f0905141553t1829e70buc491fa28493d7334@mail.gmail.com>
Date: Fri, 15 May 2009 13:15:05 +0200
Message-ID: <23be820f0905150415s3667ef70g99c1f9a4c83ad756@mail.gmail.com>
Subject: Re: twinhan cards
From: Gregor Fuis <gujs.lists@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have here more detailed output from dst module:

[    9.070205] dst(0) dst_comm_init: Initializing DST.
[    9.070273] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[    9.072332] dst(0) rdc_reset_state: Resetting state machine
[    9.072385] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[    9.090204] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[    9.221629] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[    9.222959] dst(0) read_dst: reply is 0xff
[    9.242137] dst(0) dst_wait_dst_ready: dst wait ready after 1
[    9.243786] dst(0) read_dst: reply is 0x0
[    9.243873] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[    9.244941] dst(0) dst_get_device_id: Recognise [DSTMCI]
[    9.244996] dst(0) dst_comm_init: Initializing DST.
[    9.245049] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[    9.247111] dst(0) rdc_reset_state: Resetting state machine
[    9.247165] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[    9.260174] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[    9.281994] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[    9.283344] dst(0) read_dst: reply is 0xff
[    9.300254] dst(0) dst_wait_dst_ready: dst wait ready after 1
[    9.302051] dst(0) read_dst: reply is 0x0
[    9.302136] debug_dst_buffer: [ 00 04 00 00 00 00 00 fc]
[    9.302147] dst(0) dst_get_device_id: Unsupported
[    9.302202] dst(0) dst_comm_init: Initializing DST.
[    9.302257] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[    9.304324] dst(0) rdc_reset_state: Resetting state machine
[    9.304378] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[    9.320185] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[    9.341707] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[    9.343064] dst(0) read_dst: reply is 0xff
[   13.350788] dst(0) dst_wait_dst_ready: dst wait NOT ready after 200
[   13.350869] dst(0) dst_check_mb86a15: Cmd=[0x10], failed
[   13.350924] dst(0) dst_get_device_id: Unsupported
[   13.350981] dst(0) dst_type_print: DST type: satellite
[   13.351045] dst(0) dst_comm_init: Initializing DST.
[   13.351101] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[   13.353169] dst(0) rdc_reset_state: Resetting state machine
[   13.353225] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[   13.372739] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[   13.400080] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[   13.401456] dst(0) read_dst: reply is 0xff
[   13.403521] dst(0) dst_wait_dst_ready: dst wait ready after 0
[   13.412580] dst(0) read_dst: reply is 0x0
[   13.412664] dst(0) dst_get_mac: MAC Address=[cd8d73ec]
[   13.412719] dst(0) dst_get_tuner_info: DST TYpe = MULTI FE
[   13.412775] dst(0) dst_comm_init: Initializing DST.
[   13.412830] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[   13.414896] dst(0) rdc_reset_state: Resetting state machine
[   13.414952] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[   13.430089] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[   13.453302] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[   13.454627] dst(0) read_dst: reply is 0xff
[   13.456681] dst(0) dst_wait_dst_ready: dst wait ready after 0
[   13.457939] dst(0) read_dst: reply is 0x0
[   13.458005] dst(0) dst_comm_init: Initializing DST.
[   13.458059] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[   13.460123] dst(0) rdc_reset_state: Resetting state machine
[   13.460180] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[   13.480089] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[   13.509163] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[   13.510474] dst(0) read_dst: reply is 0xff
[   17.520072] dst(0) dst_wait_dst_ready: dst wait NOT ready after 200
[   17.520155] dst(0) dst_fw_ver: Unsupported Command
[   17.520208] dst(0) dst_probe: FW: Unsupported command
[   17.556338] dst_ca_attach: registering DST-CA device
[   17.660165] dst(1) dst_comm_init: Initializing DST.
[   17.660239] dst(1) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[   17.662307] dst(1) rdc_reset_state: Resetting state machine
[   17.662368] dst(1) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[   17.680055] dst(1) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[   17.811404] dst(1) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[   17.812736] dst(1) read_dst: reply is 0xff
[   17.830046] dst(1) dst_wait_dst_ready: dst wait ready after 1
[   17.831425] dst(1) read_dst: reply is 0x0
[   17.831488] dst(1) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[   17.832551] dst(1) dst_get_device_id: Recognise [DSTMCI]
[   17.832605] dst(1) dst_comm_init: Initializing DST.
[   17.832658] dst(1) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[   17.834719] dst(1) rdc_reset_state: Resetting state machine
[   17.834772] dst(1) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[   17.850061] dst(1) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[   17.871382] dst(1) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[   17.872696] dst(1) read_dst: reply is 0xff
[   17.890045] dst(1) dst_wait_dst_ready: dst wait ready after 1
[   17.891455] dst(1) read_dst: reply is 0x0
[   17.891523] debug_dst_buffer: [ 00 04 00 00 00 00 00 fc]
[   17.891533] dst(1) dst_get_device_id: Unsupported
[   17.891586] dst(1) dst_comm_init: Initializing DST.
[   17.891640] dst(1) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[   17.893702] dst(1) rdc_reset_state: Resetting state machine
[   17.893756] dst(1) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[   17.910051] dst(1) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[   17.931372] dst(1) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[   17.932687] dst(1) read_dst: reply is 0xff
[   21.930061] dst(1) dst_wait_dst_ready: dst wait NOT ready after 200
[   21.930137] dst(1) dst_check_mb86a15: Cmd=[0x10], failed
[   21.930191] dst(1) dst_get_device_id: Unsupported
[   21.930248] dst(1) dst_type_print: DST type: satellite
[   21.930312] dst(1) dst_comm_init: Initializing DST.
[   21.930368] dst(1) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[   21.932432] dst(1) rdc_reset_state: Resetting state machine
[   21.932488] dst(1) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[   21.950052] dst(1) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[   21.971371] dst(1) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[   21.972687] dst(1) read_dst: reply is 0xff
[   21.974738] dst(1) dst_wait_dst_ready: dst wait ready after 0
[   21.976119] dst(1) read_dst: reply is 0x0
[   21.976182] dst(1) dst_get_mac: MAC Address=[cec8abec]
[   21.976237] dst(1) dst_get_tuner_info: DST TYpe = MULTI FE
[   21.976290] dst(1) dst_comm_init: Initializing DST.
[   21.976343] dst(1) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[   21.978404] dst(1) rdc_reset_state: Resetting state machine
[   21.978458] dst(1) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[   21.990049] dst(1) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[   22.011383] dst(1) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[   22.012696] dst(1) read_dst: reply is 0xff
[   22.014747] dst(1) dst_wait_dst_ready: dst wait ready after 0
[   22.016129] dst(1) read_dst: reply is 0x0
[   22.016190] dst(1) dst_comm_init: Initializing DST.
[   22.016243] dst(1) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[   22.018304] dst(1) rdc_reset_state: Resetting state machine
[   22.018358] dst(1) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[   22.030049] dst(1) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[   22.051362] dst(1) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[   22.052676] dst(1) read_dst: reply is 0xff
[   26.050034] dst(1) dst_wait_dst_ready: dst wait NOT ready after 200
[   26.050099] dst(1) dst_fw_ver: Unsupported Command
[   26.050153] dst(1) dst_probe: FW: Unsupported command
[   26.050475] dst_ca_attach: registering DST-CA device
[   26.160081] dst(2) dst_comm_init: Initializing DST.
[   26.160154] dst(2) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[   26.162222] dst(2) rdc_reset_state: Resetting state machine
[   26.162277] dst(2) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[   26.180053] dst(2) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[   26.311431] dst(2) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[   26.312751] dst(2) read_dst: reply is 0xff
[   26.330054] dst(2) dst_wait_dst_ready: dst wait ready after 1
[   26.331459] dst(2) read_dst: reply is 0x0
[   26.332112] dst(2) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[   26.333175] dst(2) dst_get_device_id: Recognise [DSTMCI]
[   26.333228] dst(2) dst_comm_init: Initializing DST.
[   26.333281] dst(2) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[   26.335342] dst(2) rdc_reset_state: Resetting state machine
[   26.335396] dst(2) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[   26.350050] dst(2) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[   26.371409] dst(2) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[   26.372728] dst(2) read_dst: reply is 0xff
[   26.390053] dst(2) dst_wait_dst_ready: dst wait ready after 1
[   26.391458] dst(2) read_dst: reply is 0x0
[   26.391519] debug_dst_buffer: [ 00 04 00 00 00 00 00 fc]
[   26.391529] dst(2) dst_get_device_id: Unsupported
[   26.391582] dst(2) dst_comm_init: Initializing DST.
[   26.391636] dst(2) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[   26.393698] dst(2) rdc_reset_state: Resetting state machine
[   26.393752] dst(2) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[   26.410052] dst(2) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[   26.431408] dst(2) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[   26.432725] dst(2) read_dst: reply is 0xff
[   30.430054] dst(2) dst_wait_dst_ready: dst wait NOT ready after 200
[   30.430113] dst(2) dst_check_mb86a15: Cmd=[0x10], failed
[   30.430168] dst(2) dst_get_device_id: Unsupported
[   30.430223] dst(2) dst_type_print: DST type: satellite
[   30.430284] dst(2) dst_comm_init: Initializing DST.
[   30.430337] dst(2) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[   30.432398] dst(2) rdc_reset_state: Resetting state machine
[   30.432452] dst(2) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[   30.450052] dst(2) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[   30.471390] dst(2) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[   30.472707] dst(2) read_dst: reply is 0xff
[   30.474758] dst(2) dst_wait_dst_ready: dst wait ready after 0
[   30.476167] dst(2) read_dst: reply is 0x0
[   30.476229] dst(2) dst_get_mac: MAC Address=[cec8bbec]
[   30.476284] dst(2) dst_get_tuner_info: DST TYpe = MULTI FE
[   30.476338] dst(2) dst_comm_init: Initializing DST.
[   30.476391] dst(2) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[   30.478452] dst(2) rdc_reset_state: Resetting state machine
[   30.478506] dst(2) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[   30.490049] dst(2) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[   30.511409] dst(2) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[   30.512725] dst(2) read_dst: reply is 0xff
[   30.514776] dst(2) dst_wait_dst_ready: dst wait ready after 0
[   30.516182] dst(2) read_dst: reply is 0x0
[   30.516243] dst(2) dst_comm_init: Initializing DST.
[   30.516297] dst(2) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[   30.518358] dst(2) rdc_reset_state: Resetting state machine
[   30.518412] dst(2) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[   30.530049] dst(2) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[   30.551386] dst(2) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[   30.552702] dst(2) read_dst: reply is 0xff
[   34.550033] dst(2) dst_wait_dst_ready: dst wait NOT ready after 200
[   34.550093] dst(2) dst_fw_ver: Unsupported Command
[   34.550147] dst(2) dst_probe: FW: Unsupported command
[   34.550469] dst_ca_attach: registering DST-CA device
[   34.660077] dst(3) dst_comm_init: Initializing DST.
[   34.660151] dst(3) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[   34.662219] dst(3) rdc_reset_state: Resetting state machine
[   34.662273] dst(3) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[   34.680053] dst(3) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[   34.900248] dst(3) write_dst: _write_dst error (err == -5, len ==
0x08, b0 == 0x00)
[   34.900314] dst(3) dst_error_recovery: Trying to return from previous errors.
[   34.900371] dst(3) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[   34.920053] dst(3) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[   34.940211] dst(3) write_dst: _write_dst error (err == -5, len ==
0x08, b0 == 0x00)
[   34.940276] dst(3) dst_error_recovery: Trying to return from previous errors.
[   34.940332] dst(3) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[   34.960059] dst(3) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[   34.980051] dst(3) write_dst: RDC 8820 RESET
[   34.980105] dst(3) dst_error_bailout: Trying to bailout from previous error.
[   34.980162] dst(3) rdc_8820_reset: Resetting DST
[   34.980215] dst(3) dst_gpio_outb: mask=[0004], enbb=[0004], outhigh=[0000]
[   34.982270] dst(3) dst_gpio_outb: mask=[0004], enbb=[0004], outhigh=[0004]
[   35.000104] dst(3) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[   35.020054] dst(3) dst_probe: unknown device.
[   35.020107] dst(3) dst_comm_init: Initializing DST.
[   35.020162] dst(3) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[   35.022223] dst(3) rdc_reset_state: Resetting state machine
[   35.022277] dst(3) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[   35.040074] dst(3) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[   35.151413] dst(3) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[   35.156734] dst(3) read_dst: reply is 0xff
[   35.159784] dst(3) dst_wait_dst_ready: dst wait ready after 0
[   35.161196] dst(3) read_dst: reply is 0x0
[   35.161259] dst(3) dst_get_mac: MAC Address=[cdd94bec]
[   35.161313] dst(3) dst_get_tuner_info: DST TYpe = MULTI FE
[   35.161366] dst(3) dst_comm_init: Initializing DST.
[   35.161420] dst(3) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[   35.163480] dst(3) rdc_reset_state: Resetting state machine
[   35.163534] dst(3) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[   35.180052] dst(3) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[   35.291416] dst(3) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[   35.296735] dst(3) read_dst: reply is 0xff
[   35.299784] dst(3) dst_wait_dst_ready: dst wait ready after 0
[   35.301194] dst(3) read_dst: reply is 0x0
[   35.301255] dst(3) dst_comm_init: Initializing DST.
[   35.301309] dst(3) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[   35.303370] dst(3) rdc_reset_state: Resetting state machine
[   35.303424] dst(3) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[   35.320052] dst(3) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[   35.431408] dst(3) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[   35.436726] dst(3) read_dst: reply is 0xff
[   39.430054] dst(3) dst_wait_dst_ready: dst wait NOT ready after 200
[   39.430111] dst(3) dst_fw_ver: Unsupported Command
[   39.430166] dst(3) dst_probe: FW: Unsupported command
[   39.430220] dst(3) dst_attach: unknown DST type. please report to
the LinuxTV.org DVB mailinglist.


Regards,
Gregor
