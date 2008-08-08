Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n6.bullet.mail.tp2.yahoo.com ([203.188.202.87])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1KRWW9-0007YI-8S
	for linux-dvb@linuxtv.org; Fri, 08 Aug 2008 20:16:52 +0200
Date: Fri, 08 Aug 2008 14:13:59 -0400
From: manu <eallaud@yahoo.fr>
To: Linux DVB Mailing List <linux-dvb@linuxtv.org>
Message-Id: <1218219239l.14019l.0l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] [BUG]: stb6100 getting carrier but stb0899 unable to
 get data (on a transponder that is emitting normally)
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

	Hi all,
the saga goes on: my TT-3200 gets the carrier on a transponder 
(freq=11495MHz, srate=30MS, FEC=5/6, polar is vertical) which is known 
to work (checked with my STB).
So what is not working is the demodulation, so stb0899 I guess. Here is 
a snippet of dmesg during an unsuccessful tuning to this transponder:

[56993.647796] stb0899_get_params: Get DVB-S params
[56994.145488] dvb_frontend_thread: Frontend ALGO = DVBFE_ALGO_CUSTOM, 
state=16
[56994.145494] stb0899_search: set DVB-S params
[56994.145498] stb0899_search: delivery system=1
[56994.145501] stb0899_search: Frequency=1745000, Srate=30000000
[56994.145504] stb0899_search: Parameters IN RANGE
[56994.145725] _stb0899_read_reg: Reg=[0xf1c2], data=78
[56994.145944] _stb0899_read_reg: Reg=[0xf1c3], data=07
[56994.145947] stb0899_set_delivery: Delivery System -- DVB-S
[56994.146163] _stb0899_read_reg: Reg=[0xf533], data=08
[56994.146168] stb0899_write_regs [0xf533]: 08
[56994.146343] stb0899_write_regs [0xf548]: b1
[56994.146516] stb0899_write_regs [0xf549]: 40
[56994.146689] stb0899_write_regs [0xf54a]: 42
[56994.146862] stb0899_write_regs [0xf54b]: 12
[56994.147243] _stb0899_read_reg: Reg=[0xff11], data=c0
[56994.147246] stb0899_write_regs [0xff11]: c0
[56994.147422] stb0899_write_regs [0xf1c2]: 78 07
[56994.147630] stb0899_set_mclk: state->config=f8c0fc00
[56994.147633] stb0899_set_mclk: mdiv=21
[56994.147636] stb0899_write_regs [0xf1b3]: 15
[56994.148023] _stb0899_read_reg: Reg=[0xf1b3], data=15
[56994.148026] stb0899_get_mclk: div=21, mclk=99000000
[56994.148029] stb0899_set_mclk: MasterCLOCK=99000000
[56994.148031] stb0899_search: DVB-S delivery system
[56994.148244] _stb0899_read_reg: Reg=[0xf12a], data=48
[56994.148247] stb0899_i2c_gate_ctrl: Enabling I2C Repeater ...
[56994.148249] stb0899_write_regs [0xf12a]: c8
[56994.148425] stb6100_set_bandwidth: set bandwidth to 65650000 Hz
[56994.148429] stb6100_write_reg_range:     Write @ 0x60: [9:1]
[56994.148432] stb6100_write_reg_range:         FCCK: 0x4d
[56994.148565] stb6100_write_reg_range:     Write @ 0x60: [6:1]
[56994.148569] stb6100_write_reg_range:         F: 0xdc
[56994.153465] stb6100_write_reg_range:     Write @ 0x60: [9:1]
[56994.153470] stb6100_write_reg_range:         FCCK: 0x0d
[56994.153604] stb6100_set_bandwidth: Bandwidth=65650000
[56994.154123] stb6100_read_regs:     Read from 0x60
[56994.154128] stb6100_read_regs:         LD: 0x81
[56994.154130] stb6100_read_regs:         VCO: 0x68
[56994.154133] stb6100_read_regs:         NI: 0x40
[56994.154135] stb6100_read_regs:         NF: 0x42
[56994.154138] stb6100_read_regs:         K: 0x3d
[56994.154140] stb6100_read_regs:         G: 0x38
[56994.154143] stb6100_read_regs:         F: 0xdc
[56994.154145] stb6100_read_regs:         DLB: 0xdc
[56994.154148] stb6100_read_regs:         TEST1: 0x8f
[56994.154150] stb6100_read_regs:         FCCK: 0x0d
[56994.154153] stb6100_read_regs:         LPEN: 0xfb
[56994.154156] stb6100_read_regs:         TEST3: 0xde
[56994.154158] stb6100_get_bandwidth: bandwidth = 66000000 Hz
[56994.154161] stb6100_get_bandwidth: Bandwidth=66000000
[56994.154373] _stb0899_read_reg: Reg=[0xf12a], data=c8
[56994.154376] stb0899_i2c_gate_ctrl: Disabling I2C Repeater ...
[56994.154380] stb0899_write_regs [0xf12a]: 48
[56994.154554] stb0899_write_regs [0xf157]: 11
[56994.154729] stb0899_search: running DVB-S search algo ..
[56994.154733] stb0899_set_srate: -->
[56994.154735] stb0899_write_regs [0xf446]: 4d 93 60
[56994.154999] stb0899_write_regs [0xf41c]: c8
[56994.155398] _stb0899_read_reg: Reg=[0xf41d], data=a9
[56994.155401] stb0899_write_regs [0xf41d]: a9
[56994.155576] stb0899_dvbs_algo: Set the timing loop to acquisition
[56994.155580] stb0899_write_regs [0xf417]: 46
[56994.155755] stb0899_write_regs [0xf41b]: ee
[56994.155929] stb0899_dvbs_algo: Derot Percent=30 Srate=30000000 
mclk=1510
[56994.155932] stb0899_dvbs_algo: RESET stream merger
[56994.156144] _stb0899_read_reg: Reg=[0xff11], data=c0
[56994.156148] stb0899_write_regs [0xff11]: c0
[56994.156540] _stb0899_read_reg: Reg=[0xf583], data=3c
[56994.156543] stb0899_write_regs [0xf583]: 3c
[56994.156727] stb0899_write_regs [0xf41e]: 01
[56994.156900] stb0899_write_regs [0xf53d]: 19
[56994.157285] _stb0899_read_reg: Reg=[0xf12a], data=48
[56994.157288] stb0899_i2c_gate_ctrl: Enabling I2C Repeater ...
[56994.157291] stb0899_write_regs [0xf12a]: c8
[56994.157953] stb6100_read_regs:     Read from 0x60
[56994.157956] stb6100_read_regs:         LD: 0x81
[56994.157959] stb6100_read_regs:         VCO: 0x68
[56994.157962] stb6100_read_regs:         NI: 0x40
[56994.157964] stb6100_read_regs:         NF: 0x42
[56994.157967] stb6100_read_regs:         K: 0x3d
[56994.157970] stb6100_read_regs:         G: 0x38
[56994.157973] stb6100_read_regs:         F: 0xdc
[56994.157976] stb6100_read_regs:         DLB: 0xdc
[56994.157979] stb6100_read_regs:         TEST1: 0x8f
[56994.157982] stb6100_read_regs:         FCCK: 0x0d
[56994.157985] stb6100_read_regs:         LPEN: 0xfb
[56994.157988] stb6100_read_regs:         TEST3: 0xde
[56994.157991] stb6100_get_bandwidth: bandwidth = 66000000 Hz
[56994.157994] stb6100_get_bandwidth: Bandwidth=66000000
[56994.158206] _stb0899_read_reg: Reg=[0xf12a], data=c8
[56994.158210] stb0899_i2c_gate_ctrl: Disabling I2C Repeater ...
[56994.158213] stb0899_write_regs [0xf12a]: 48
[56994.158391] stb0899_write_regs [0xf43e]: 00 00
[56994.158598] stb0899_write_regs [0xf439]: 00
[56994.158987] _stb0899_read_reg: Reg=[0xf41b], data=ee
[56994.158991] stb0899_write_regs [0xf41b]: ee
[56994.159370] _stb0899_read_reg: Reg=[0xf12a], data=48
[56994.159374] stb0899_i2c_gate_ctrl: Enabling I2C Repeater ...
[56994.159377] stb0899_write_regs [0xf12a]: c8
[56994.159551] stb0899_dvbs_algo: Tuner set frequency
[56994.160044] stb6100_read_regs:     Read from 0x60
[56994.160047] stb6100_read_regs:         LD: 0x81
[56994.160050] stb6100_read_regs:         VCO: 0x68
[56994.160053] stb6100_read_regs:         NI: 0x40
[56994.160056] stb6100_read_regs:         NF: 0x42
[56994.160059] stb6100_read_regs:         K: 0x3d
[56994.160062] stb6100_read_regs:         G: 0x38
[56994.160065] stb6100_read_regs:         F: 0xdc
[56994.160068] stb6100_read_regs:         DLB: 0xdc
[56994.160071] stb6100_read_regs:         TEST1: 0x8f
[56994.160074] stb6100_read_regs:         FCCK: 0x0d
[56994.160077] stb6100_read_regs:         LPEN: 0xfb
[56994.160080] stb6100_read_regs:         TEST3: 0xde
[56994.160083] stb6100_set_frequency: Get Frontend parameters
[56994.160086] stb0899_get_params: Get DVB-S params
[56994.160089] stb6100_set_frequency: Delivery system = DVB-S, Symbol 
Rate=[30000000]
[56994.160095] stb6100_set_frequency: frequency = 1745000, srate = 
30000000, g = 8, odiv = 0, psd2 = 1, fxtal = 27000, osm = 8, fvco = 
3490000, N(I) = 64, N(F) = 322
[56994.160101] stb6100_write_reg_range:     Write @ 0x60: [1:11]
[56994.160104] stb6100_write_reg_range:         VCO: 0xe8
[56994.160107] stb6100_write_reg_range:         NI: 0x40
[56994.160111] stb6100_write_reg_range:         NF: 0x42
[56994.160114] stb6100_write_reg_range:         K: 0x3d
[56994.160117] stb6100_write_reg_range:         G: 0x38
[56994.160120] stb6100_write_reg_range:         F: 0xdc
[56994.160123] stb6100_write_reg_range:         DLB: 0xdc
[56994.160126] stb6100_write_reg_range:         TEST1: 0x8f
[56994.160129] stb6100_write_reg_range:         FCCK: 0x4d
[56994.160132] stb6100_write_reg_range:         LPEN: 0xeb
[56994.160135] stb6100_write_reg_range:         TEST3: 0xde
[56994.160631] stb6100_write_reg_range:     Write @ 0x60: [10:1]
[56994.160634] stb6100_write_reg_range:         LPEN: 0xfb
[56994.160766] stb6100_write_reg_range:     Write @ 0x60: [1:1]
[56994.160769] stb6100_write_reg_range:         VCO: 0x88
[56994.169432] stb6100_write_reg_range:     Write @ 0x60: [1:1]
[56994.169436] stb6100_write_reg_range:         VCO: 0x68
[56994.169569] stb6100_write_reg_range:     Write @ 0x60: [9:1]
[56994.169573] stb6100_write_reg_range:         FCCK: 0x0d
[56994.205367] stb6100_set_frequency: Frequency=1745000
[56994.205868] stb6100_read_regs:     Read from 0x60
[56994.205872] stb6100_read_regs:         LD: 0x81
[56994.205876] stb6100_read_regs:         VCO: 0x68
[56994.205878] stb6100_read_regs:         NI: 0x40
[56994.205881] stb6100_read_regs:         NF: 0x42
[56994.205884] stb6100_read_regs:         K: 0x3d
[56994.205887] stb6100_read_regs:         G: 0x38
[56994.205890] stb6100_read_regs:         F: 0xdc
[56994.205893] stb6100_read_regs:         DLB: 0xdc
[56994.205896] stb6100_read_regs:         TEST1: 0x8f
[56994.205899] stb6100_read_regs:         FCCK: 0x0d
[56994.205902] stb6100_read_regs:         LPEN: 0xfb
[56994.205905] stb6100_read_regs:         TEST3: 0xde
[56994.205910] stb6100_get_frequency: frequency = 1744980 kHz, odiv = 
0, psd2 = 1, fxtal = 27000 kHz, fvco = 3489960 kHz, N(I) = 64, N(F) = 
322
[56994.205915] stb6100_get_frequency: Frequency=1744980
[56994.213350] stb0899_dvbs_algo: current derot freq=0
[56994.213847] stb6100_read_regs:     Read from 0x60
[56994.213851] stb6100_read_regs:         LD: 0x81
[56994.213854] stb6100_read_regs:         VCO: 0x68
[56994.213857] stb6100_read_regs:         NI: 0x40
[56994.213859] stb6100_read_regs:         NF: 0x42
[56994.213862] stb6100_read_regs:         K: 0x3d
[56994.213865] stb6100_read_regs:         G: 0x38
[56994.213868] stb6100_read_regs:         F: 0xdc
[56994.213871] stb6100_read_regs:         DLB: 0xdc
[56994.213874] stb6100_read_regs:         TEST1: 0x8f
[56994.213877] stb6100_read_regs:         FCCK: 0x0d
[56994.213880] stb6100_read_regs:         LPEN: 0xfb
[56994.213883] stb6100_read_regs:         TEST3: 0xde
[56994.213886] stb6100_get_bandwidth: bandwidth = 66000000 Hz
[56994.213890] stb6100_get_bandwidth: Bandwidth=66000000
[56994.214107] _stb0899_read_reg: Reg=[0xf12a], data=c8
[56994.214111] stb0899_i2c_gate_ctrl: Disabling I2C Repeater ...
[56994.214114] stb0899_write_regs [0xf12a]: 48
[56994.222326] stb0899_write_regs [0xf439]: f2
[56994.222719] _stb0899_read_reg: Reg=[0xf438], data=5e
[56994.222935] _stb0899_read_reg: Reg=[0xf439], data=00
[56994.222940] stb0899_check_tmg: ------->TIMING OK !
[56994.223186] stb0899_read_regs [0xf43e]: fe 00
[56994.223192] stb0899_search_tmg: ------->TIMING OK ! Derot Freq = 
-512
[56994.223196] stb0899_dvbs_algo: TIMING OK ! Derot freq=-512, 
mclk=1510
[56994.223415] _stb0899_read_reg: Reg=[0xf41b], data=ee
[56994.223419] stb0899_write_regs [0xf41b]: ee
[56994.223596] stb0899_search_carrier: Derot Freq=-512, mclk=1510
[56994.229526] _stb0899_read_reg: Reg=[0xf41b], data=ee
[56994.229531] stb0899_write_regs [0xf41b]: ee
[56994.229914] _stb0899_read_reg: Reg=[0xf43a], data=c0
[56994.229919] stb0899_check_carrier: --------------------> 
STB0899_DSTATUS=[0xc0]
[56994.229922] stb0899_check_carrier: -------------> CARRIEROK !
[56994.230168] stb0899_read_regs [0xf43e]: fe 00
[56994.230173] stb0899_search_carrier: ----> CARRIER OK !, Derot 
Freq=-512
[56994.230178] stb0899_dvbs_algo: CARRIER OK ! Derot freq=-512, 
mclk=1510
[56994.230392] _stb0899_read_reg: Reg=[0xff11], data=c0
[56994.230395] stb0899_write_regs [0xff11]: c8
[56994.238504] _stb0899_read_reg: Reg=[0xff11], data=c8
[56994.238509] stb0899_write_regs [0xff11]: c0
[56994.238682] stb0899_write_regs [0xf50c]: 00
[56994.239062] _stb0899_read_reg: Reg=[0xf50d], data=40
[56994.239068] stb0899_search_data: Derot freq=-5478, mclk=1510
[56994.239293] _stb0899_read_reg: Reg=[0xf41b], data=ee
[56994.239297] stb0899_write_regs [0xf41b]: ee
[56994.239469] stb0899_write_regs [0xf43e]: ea 9a
[56994.246487] _stb0899_read_reg: Reg=[0xf41b], data=ee
[56994.246491] stb0899_write_regs [0xf41b]: ee
[56994.246877] _stb0899_read_reg: Reg=[0xf43a], data=c8
[56994.246881] stb0899_check_carrier: --------------------> 
STB0899_DSTATUS=[0xc8]
[56994.246884] stb0899_check_carrier: -------------> CARRIEROK !
[56994.247095] _stb0899_read_reg: Reg=[0xff11], data=c0
[56994.247099] stb0899_write_regs [0xff11]: c8
[56994.253478] _stb0899_read_reg: Reg=[0xff11], data=c8
[56994.253482] stb0899_write_regs [0xff11]: c0
[56994.253654] stb0899_write_regs [0xf50c]: 00
[56994.254034] _stb0899_read_reg: Reg=[0xf50d], data=00
[56994.254249] _stb0899_read_reg: Reg=[0xf50d], data=00
[56994.254460] _stb0899_read_reg: Reg=[0xf50d], data=00

Goes on like that for a while. 

Note that the card works great on 4 other transponders 
(11093,11555,11635,11675 MHz) the only difference being the FEC (the 4 
others are 3/4).
So my question is: how can we fix that? Or at least how do we gather 
data so someone in the know-how could fix that?
Thx
Bye
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
