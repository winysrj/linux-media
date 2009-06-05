Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:38256 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbZFEHvi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2009 03:51:38 -0400
Received: by fxm9 with SMTP id 9so357941fxm.37
        for <linux-media@vger.kernel.org>; Fri, 05 Jun 2009 00:51:40 -0700 (PDT)
Message-ID: <4A28CEAD.9000000@gmail.com>
Date: Fri, 05 Jun 2009 09:52:13 +0200
From: Jan Nikitenko <jan.nikitenko@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: AVerTV Volar Black HD: i2c oops in warm state on mips
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am trying to get AverMedia AVerTV Volar Black HD (A850) usb dvb-t tuner
running on mips32 little endian platform (to stream dvb-t from home router on LAN).
I've cross compiled v4l-dvb mercurial sources (revision 11448:d4274bbb8605) and
when plugging the tuner stick, I get following kernel oops log on serial console:

dvb-usb: found a 'AverMedia AVerTV Volar Black HD (A850)' in cold state, will
try to load a firmware
usb 1-1: firmware: requesting dvb-usb-af9015.fw
dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
dvb-usb: found a 'AverMedia AVerTV Volar Black HD (A850)' in warm state.
dvb-usb: will use the device's hardware PID filter (table count: 32).
DVB: registering new adapter (AverMedia AVerTV Volar Black HD (A850))

CPU 0 Unable to handle kernel paging request at virtual address 00000000, epc ==
803a4488, ra == c049a1c8
Oops[#1]:
Cpu 0
$ 0   : 00000000 10003c00 00000000 803a4468
$ 4   : 8f17c600 8f067b30 00000002 00000038
$ 8   : 00000001 8faf3e98 11da000d 09010002
$12   : 00000000 00000000 00000000 0000000a
$16   : 8f17c600 8f067b68 8faf3c00 8f067c04
$20   : 8f067b9c 00000100 8f067bf0 80104100
$24   : 00000000 2aba9fb0
$28   : 8f066000 8f067af0 802cbc48 c049a1c8
Hi    : 00000000
Lo    : 00000000
epc   : 803a4488 i2c_transfer+0x20/0x104
     Not tainted
ra    : c049a1c8 af9013_read_reg+0x78/0xc4 [af9013]
Status: 10003c03    KERNEL EXL IE
Cause : 00808008
BadVA : 00000000
PrId  : 03030200 (Au1550)
Modules linked in: af9013 dvb_usb_af9015(+) dvb_usb dvb_core firmware_class
i2c_au1550 au1550_spi
Process modprobe (pid: 2757, threadinfo=8f066000, task=8fade098, tls=2aad6470)
Stack : c049f5e0 80163090 805ba880 00000100 8f067bf0 0000d733 8f067b68 8faf3c00
         8f067c04 c049a1c8 80163bc0 8056a630 8f067b40 80163224 80569fc8 8f0033d7
         00000038 80140003 8f067b2c 00010038 c0420001 8f067b28 c049f5e0 00000004
         00000004 c049a524 c049d5a8 c049d5a8 00000000 803a6700 00000000 8f17c600
         c042a7a4 8f17c600 c042a7a4 c049c924 00000000 00000000 00000002 613a6c00
         ...
Call Trace:
[<803a4488>] i2c_transfer+0x20/0x104
[<c049a1c8>] af9013_read_reg+0x78/0xc4 [af9013]
[<c049a524>] af9013_read_reg_bits+0x2c/0x70 [af9013]
[<c049c924>] af9013_attach+0x98/0x65c [af9013]
[<c04257bc>] af9015_af9013_frontend_attach+0x214/0x67c [dvb_usb_af9015]
[<c03e2428>] dvb_usb_adapter_frontend_init+0x20/0x12c [dvb_usb]
[<c03e1ad8>] dvb_usb_device_init+0x374/0x6b0 [dvb_usb]
[<c0426120>] af9015_usb_probe+0x4fc/0xfcc [dvb_usb_af9015]
[<80381024>] usb_probe_interface+0xbc/0x218
[<803227fc>] driver_probe_device+0x12c/0x30c
[<80322a80>] __driver_attach+0xa4/0xac
[<80321ed0>] bus_for_each_dev+0x60/0xd0
[<8032162c>] bus_add_driver+0x1e8/0x2a8
[<80322cdc>] driver_register+0x7c/0x17c
[<80380d30>] usb_register_driver+0xa0/0x12c
[<c042e030>] af9015_usb_module_init+0x30/0x6c [dvb_usb_af9015]
[<8010d2a4>] __kprobes_text_end+0x3c/0x1f4
[<80167150>] sys_init_module+0xb8/0x1cc
[<80102370>] stack_done+0x20/0x3c


Code: afb10018  7000003f  00808021 <8c430000> 7000003f  1060002d  00c09021
8f830014  3c02efff


The used dvb-t sources work ok on intel x86 platform (used kernel 2.6.24), but
on mips, there seems to be some problem with i2c after switch of the tuner into
the warm state via firmware load (tested with 2.6.25.17 and 2.6.29-rc7 mips
kernels, with the same result) - it seems to me, that adap pointer (or the
structure) is not valid (adap->algo is NULL):

(gdb) c
Continuing.

Breakpoint 1, i2c_transfer (adap=0x8f17c600, msgs=0x8f067b30, num=2)
     at /usr/src/linux/drivers/i2c/i2c-core.c:1036
1036            if (adap->algo->master_xfer) {
(gdb) p *msgs
$4 = {addr = 56, flags = 0, len = 3, buf = 0x8f0c9b2c "×3"}
(gdb) p *adap
$2 = {owner = 0x0, id = 0, class = 0, algo = 0x0, algo_data = 0x0,
client_register = 0, client_unregister = 0, level = 0 '\0',
   bus_lock = {count = {counter = 0}, wait_lock = {raw_lock = {<No data
fields>}}, wait_list = {next = 0xc042a00c, prev = 0x8fb55000}},
   clist_lock = {count = {counter = 1}, wait_lock = {raw_lock = {<No data
fields>}}, wait_list = {next = 0x1, prev = 0x1}},
   timeout = -1894267336, retries = -1894267336, dev = {klist_children = {k_lock
= {raw_lock = {<No data fields>}}, k_list = {next = 0x1,
         prev = 0x8f17c644}, get = 0x8f17c644, put = 0}, knode_parent = {n_klist
= 0x0, n_node = {next = 0x0, prev = 0x4}, n_ref = {
         refcount = {counter = -1069368724}}}, knode_driver = {n_klist = 0x0,
n_node = {next = 0x0, prev = 0x0}, n_ref = {refcount = {
           counter = 0}}}, knode_bus = {n_klist = 0x1, n_node = {next =
0x8f17c674, prev = 0x8f17c674}, n_ref = {refcount = {
           counter = 1}}}, parent = 0x8f17c680, kobj = {name = 0x8f17c680
"\200Æ\027\217\200Æ\027\217", entry = {next = 0x0, prev = 0x0},
       parent = 0x8fb3f494, kset = 0x8fb3f494, ktype = 0x8031f5b0, sd =
0x8031e8e8, kref = {refcount = {counter = -1883942816}},
       state_initialized = 0, state_in_sysfs = 0, state_add_uevent_sent = 1,
state_remove_uevent_sent = 0},
     bus_id = "\034Ð\004\217\001", '\0' <repeats 14 times>, uevent_suppress = 0,
init_name = 0x0, type = 0x0, sem = {lock = {
         raw_lock = {<No data fields>}}, count = 0, wait_list = {next = 0x0,
prev = 0x8fb55060}}, bus = 0x8f049780, driver = 0x8fb3f4c8,
     driver_data = 0x8f04d050, platform_data = 0x8f9b0988, power = {power_state
= {event = -1887399424}, can_wakeup = 0,
       should_wakeup = 0, status = 2401748540, entry = {next = 0x4, prev =
0x7}}, dma_mask = 0x2d633269, coherent_dma_mask = 0,
     dma_parms = 0x0, dma_pools = {next = 0x0, prev = 0x0}, dma_mem = 0x0,
archdata = {<No data fields>}, devt = 1, devres_lock = {
       raw_lock = {<No data fields>}}, devres_head = {next = 0x8f17c71c, prev =
0x8f17c71c}, knode_class = {n_klist = 0x0, n_node = {
         next = 0x0, prev = 0x8f17c000}, n_ref = {refcount = {counter = 0}}},
class = 0x0, groups = 0x0, release = 0x1},
   nr = -1884031696, clients = {next = 0x8f04d0b8, prev = 0x0},
   name = '\0' <repeats 16 times>,
"\\Ç\027\217\\Ç\027\217\000\000\000\000\000\000\000\000lÇ\027\217lÇ\027\217°\t\233\217(Ù\004\217",
   dev_released = {done = 2399300920, wait = {lock = {raw_lock = {<No data
fields>}}, task_list = {next = 0x1, prev = 0x8058370c}}}}


Tried two mips32 little endian platforms: Broadcom BCM3302 /asus wl500gp router/
and alchemy au1550 with the same result.

Any ideas why this happens?

Thanks and best regards,
Jan

