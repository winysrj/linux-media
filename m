Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from posti8.jyu.fi ([130.234.5.35])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <liff@iki.fi>) id 1JOKei-00068l-BB
	for linux-dvb@linuxtv.org; Sun, 10 Feb 2008 23:28:12 +0100
Received: from localhost (localhost.localdomain [127.0.0.1])
	by posti8.jyu.fi (8.14.1/8.13.8) with ESMTP id m1AMSBg7011969
	for <linux-dvb@linuxtv.org>; Mon, 11 Feb 2008 00:28:11 +0200
Received: from posti8.jyu.fi ([127.0.0.1])
	by localhost (posti8.jyu.fi [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FhBBYsQw2I1r for <linux-dvb@linuxtv.org>;
	Mon, 11 Feb 2008 00:28:10 +0200 (EET)
Received: from [10.0.0.165] (yrtti.net [217.112.249.37]) (authenticated bits=0)
	by posti8.jyu.fi (8.14.1/8.13.8) with ESMTP id m1AMS9lW011964
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-dvb@linuxtv.org>; Mon, 11 Feb 2008 00:28:10 +0200
From: Olli Helenius <liff@iki.fi>
To: linux-dvb@linuxtv.org
Date: Mon, 11 Feb 2008 00:28:10 +0200
Message-Id: <1202682490.7086.52.camel@hede>
Mime-Version: 1.0
Subject: [linux-dvb] Twinhan VisionPlus 2021 DVB-C tuning problems and a
	solution
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

After some trial and error I managed to get tuning on a VP2021 DVB-C
card working. The card is detected correctly but running scan or czap
wouldn't tune to any channel.

The solution is just to ignore the checksum failure in dst_get_tuna. I
don't know exactly why it helps, though. Below you'll find all the
relevant information (I hope).

The patch is against changeset 7182:3a880d2669a6 from the 'tip' tag (or
branch?).


##### the "fix"
diff -r 3a880d2669a6 linux/drivers/media/dvb/bt8xx/dst.c
--- a/linux/drivers/media/dvb/bt8xx/dst.c       Sat Feb 09 09:59:00 2008 -0200
+++ b/linux/drivers/media/dvb/bt8xx/dst.c       Mon Feb 11 02:16:48 2008 +0200
@@ -1364,7 +1364,6 @@ static int dst_get_tuna(struct dst_state
        } else {
                if (state->rx_tuna[9] != dst_check_sum(&state->rx_tuna[2], 7)) {
                        dprintk(verbose, DST_INFO, 1, "checksum failure? ");
-                       return -EIO;
                }
        }
        if (state->rx_tuna[2] == 0 && state->rx_tuna[3] == 0)


##### module parameters:
        options bttv debug=10 i2c_hw=10 i2c_debug=10
        options dst verbose=10


##### dmesg from loading modules:
[ 2842.489922] Linux video capture interface: v2.00
[ 2842.498384] bttv: driver version 0.9.17 loaded
[ 2842.498391] bttv: using 8 buffers with 2080k (520 pages) each for capture
[ 2842.498934] bttv: Bt8xx card found (0).
[ 2842.498953] bttv0: Bt878 (rev 17) at 0000:02:03.0, irq: 17, latency: 32, mmio: 0xdeafe000
[ 2842.499333] bttv0: detected: Twinhan VisionPlus DVB [card=113], PCI subsystem ID is 1822:0001
[ 2842.499342] bttv0: using: Twinhan DST + clones [card=113,autodetected]
[ 2842.499361] bttv0: gpio: en=00000000, out=00000000 in=00f75bff [init]
[ 2842.499995] bttv0: tuner absent
[ 2842.500115] bttv0: add subdevice "dvb0"
[ 2842.523182] bt878: AUDIO driver version 0.0.0 loaded
[ 2842.523415] bt878: Bt878 AUDIO function found (0).
[ 2842.523440] ACPI: PCI Interrupt 0000:02:03.1[A] -> GSI 19 (level, low) -> IRQ 17
[ 2842.523447] bt878_probe: card id=[0x11822],[ Twinhan VisionPlus DVB ] has DVB functions.
[ 2842.523456] bt878(0): Bt878 (rev 17) at 02:03.1, irq: 17, latency: 32, memory: 0xdeaff000
[ 2842.538284] DVB: registering new adapter (bttv0)
[ 2842.640229] dst(0) dst_comm_init: Initializing DST.
[ 2842.640239] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001], outhigh=[0000]
[ 2842.642229] dst(0) rdc_reset_state: Resetting state machine
[ 2842.642232] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[ 2842.656869] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[ 2842.771975] writing [ 00 06 00 00 00 00 00 fa ]
[ 2842.771991] bt-i2c: <W aa 00 06 00 00 00 00 00 fa >
[ 2842.773209] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000], outhigh=[0000]
[ 2842.774208] bt-i2c: <R ab =ff >
[ 2842.774512] dst(0) read_dst: reply is 0xff
[ 2842.774517] dst(0) dst_wait_dst_ready: dst wait ready after 0
[ 2842.774519] bt-i2c: <R ab =00 =44 =43 =54 =2d =43 =49 =6c >
[ 2842.775870] dst(0) read_dst: reply is 0x0
[ 2842.775872]  0x44 0x43 0x54 0x2d 0x43 0x49 0x6c
[ 2842.775879] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000], outhigh=[0000]
[ 2842.776876] dst(0) dst_get_device_id: Recognise [DCT-CI]
[ 2842.776880] dst(0) dst_type_print: DST type: cable
[ 2842.776881] DST type flags : 0x1000 VLF 0x8 firmware version = 1 0x10 firmware version = 2
[ 2842.776887] dst(0) dst_comm_init: Initializing DST.
[ 2842.776890] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001], outhigh=[0000]
[ 2842.778877] dst(0) rdc_reset_state: Resetting state machine
[ 2842.778880] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[ 2842.791940] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[ 2842.895771] writing [ 00 0a 00 00 00 00 00 f6 ]
[ 2842.895780] bt-i2c: <W aa 00 0a 00 00 00 00 00 f6 >
[ 2842.896975] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000], outhigh=[0000]
[ 2842.901937] bt-i2c: <R ab =ff >
[ 2842.902238] dst(0) read_dst: reply is 0xff
[ 2846.102574] dst(0) dst_wait_dst_ready: dst wait NOT ready after 200
[ 2846.102584] dst(0) dst_get_mac: Unsupported Command
[ 2846.102587] dst(0) dst_probe: MAC: Unsupported command
[ 2846.102591] dst(0) dst_get_tuner_info: DST TYpe = MULTI FE
[ 2846.103319] dst(0) dst_comm_init: Initializing DST.
[ 2846.103325] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001], outhigh=[0000]
[ 2846.105636] dst(0) rdc_reset_state: Resetting state machine
[ 2846.105641] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[ 2846.122530] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[ 2846.226358] writing [ 00 13 00 00 00 00 00 ed ]
[ 2846.226557] bt-i2c: <W aa 00 13 00 00 00 00 00 ed >
[ 2846.227749] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000], outhigh=[0000]
[ 2846.232957] bt-i2c: <R ab =ff >
[ 2846.233193] dst(0) read_dst: reply is 0xff
[ 2849.429159] dst(0) dst_wait_dst_ready: dst wait NOT ready after 200
[ 2849.429168] dst(0) dst_get_tuner_info: Cmd=[0x13], Unsupported
[ 2849.429172] dst(0) dst_get_tuner_info: Forcing [DCT-CI] to TS188
[ 2849.429174] dst(0) dst_probe: Tuner: Unsupported command
[ 2849.463346] dst_ca_attach: registering DST-CA device
[ 2849.463397] DVB: registering frontend 0 (DST DVB-C)...


##### dmesg from trying to tune to a channel wo/patch:
[ 2877.926886] dst(0) dst_set_freq: set Frequency 426000000
[ 2877.926894] dst(0) dst_set_frontend: Set Frequency=[426000000]
[ 2877.926898] dst(0) dst_set_symbolrate: set symrate 6900000
[ 2877.926901] dst(0) dst_set_symbolrate: DCT-CI
[ 2877.926904] dst(0) dst_write_tuna: type_flags 0x121a 
[ 2877.926907] dst(0) dst_comm_init: Initializing DST.
[ 2877.926911] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001], outhigh=[0000]
[ 2877.928900] dst(0) rdc_reset_state: Resetting state machine
[ 2877.928903] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[ 2877.942833] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[ 2878.046660] writing [ 09 00 06 80 10 00 1a f4 80 d3 ]
[ 2878.046672] bt-i2c: <W aa 09 00 06 80 10 00 1a f4 80 d3 >
[ 2878.048186] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000], outhigh=[0000]
[ 2878.050174] bt-i2c: <R ab =ff >
[ 2878.050483] dst(0) read_dst: reply is 0xff
[ 2878.062637] dst(0) dst_wait_dst_ready: dst wait ready after 1
[ 2878.062641] bt-i2c: <R ab =09 =00 =06 =80 =10 =30 =00 =30 =11 =f0 >
[ 2878.064105] dst(0) read_dst: reply is 0x9
[ 2878.064107]  0x0 0x6 0x80 0x10 0x30 0x0 0x30 0x11 0xf0
[ 2878.064115] dst(0) dst_get_tuna: checksum failure? 


##### dmesg from tune to a channel w/patch:
[ 3130.198907] dst(0) dst_set_freq: set Frequency 426000000
[ 3130.198916] dst(0) dst_set_frontend: Set Frequency=[426000000]
[ 3130.198919] dst(0) dst_set_symbolrate: set symrate 6900000
[ 3130.198922] dst(0) dst_set_symbolrate: DCT-CI
[ 3130.198925] dst(0) dst_write_tuna: type_flags 0x121a 
[ 3130.198928] dst(0) dst_comm_init: Initializing DST.
[ 3130.198931] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001], outhigh=[0000]
[ 3130.200921] dst(0) rdc_reset_state: Resetting state machine
[ 3130.200924] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[ 3130.220956] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[ 3130.328775] writing [ 09 00 06 80 10 00 1a f4 80 d3 ]
[ 3130.328790] bt-i2c: <W aa 09 00 06 80 10 00 1a f4 80 d3 >
[ 3130.395445] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000], outhigh=[0000]
[ 3130.397436] bt-i2c: <R ab =ff >
[ 3130.397866] dst(0) read_dst: reply is 0xff
[ 3130.416662] dst(0) dst_wait_dst_ready: dst wait ready after 1
[ 3130.416671] bt-i2c: <R ab =09 =00 =06 =80 =10 =30 =00 =30 =11 =f0 >
[ 3130.476103] dst(0) read_dst: reply is 0x9
[ 3130.476108]  0x0 0x6 0x80 0x10 0x30 0x0 0x30 0x11 0xf0
[ 3130.476115] dst(0) dst_get_tuna: checksum failure? 
[ 3131.201482] dst(0) dst_comm_init: Initializing DST.
[ 3131.201493] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001], outhigh=[0000]
[ 3131.203483] dst(0) rdc_reset_state: Resetting state machine
[ 3131.203486] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[ 3131.219926] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[ 3131.327153] writing [ 00 05 00 00 00 00 00 fb ]
[ 3131.327168] bt-i2c: <W aa 00 05 00 00 00 00 00 fb >
[ 3131.363113] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000], outhigh=[0000]
[ 3131.368077] bt-i2c: <R ab =ff >
[ 3131.368487] dst(0) read_dst: reply is 0xff
[ 3131.371466] dst(0) dst_wait_dst_ready: dst wait ready after 0
[ 3131.371469] bt-i2c: <R ab =00 =05 =00 =30 =00 =30 =00 =9b >
[ 3131.411045] dst(0) read_dst: reply is 0x0
[ 3131.411050]  0x5 0x0 0x30 0x0 0x30 0x0 0x9b
[ 3132.413411] dst(0) dst_comm_init: Initializing DST.
[ 3132.413422] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001], outhigh=[0000]
[ 3132.415411] dst(0) rdc_reset_state: Resetting state machine
[ 3132.415414] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[ 3132.442817] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[ 3132.559062] writing [ 00 05 00 00 00 00 00 fb ]
[ 3132.559077] bt-i2c: <W aa 00 05 00 00 00 00 00 fb >
[ 3132.598076] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000], outhigh=[0000]
[ 3132.603040] bt-i2c: <R ab =ff >
[ 3132.603456] dst(0) read_dst: reply is 0xff
[ 3132.606435] dst(0) dst_wait_dst_ready: dst wait ready after 0
[ 3132.606438] bt-i2c: <R ab =00 =05 =00 =30 =00 =30 =00 =9b >
[ 3132.644863] dst(0) read_dst: reply is 0x0
[ 3132.644868]  0x5 0x0 0x30 0x0 0x30 0x0 0x9b


##### Relevant lines from lspci -n:
02:03.0 0400: 109e:036e (rev 11)
02:03.1 0480: 109e:0878 (rev 11)


##### Kernel: 2.6.24-7-generic from Ubuntu Hardy Heron on i686.



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
