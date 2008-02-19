Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <pansyg@gmx.at>) id 1JRH8A-0004Ke-OH
	for linux-dvb@linuxtv.org; Tue, 19 Feb 2008 02:18:46 +0100
From: Gernot Pansy <pansyg@gmx.at>
To: linux-dvb@linuxtv.org
Date: Tue, 19 Feb 2008 02:18:11 +0100
References: <65A7136B-8AAD-44EE-921E-5376D7BAC14E@onetel.com>
In-Reply-To: <65A7136B-8AAD-44EE-921E-5376D7BAC14E@onetel.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802190218.11492.pansyg@gmx.at>
Subject: Re: [linux-dvb] Help with Skystar HD2 (Twinhan VP-1041/Azurewave AD
	SP400 rebadge)
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


hy,

have you tried some other channel on a diffrent multiplex?

i have also troubles on 2 multiplexes, but i believe that's trough my bad 
signal strength (it's the same on windows).

otherwise there have to be some initialization registers configured 
differently. manu is the only guy, how knows about that and can help you.

gernot

On Tuesday 19 February 2008 00:51:49 Tim Hewett wrote:
> Gernot,
>
> I have now tried the mantis tree. It also needed the
> MANTIS_VP_1041_DVB_S2 #define to be changed to 0x0001 for this card,
> but after doing that it was recognised:
>
> [   56.586237] ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
> [   56.586330] ACPI: PCI Interrupt 0000:01:06.0[A] -> Link [APC1] ->
> GSI 16 (level, low) -> IRQ 16
> [   56.586556] irq: 16, latency: 32
> [   56.586557]  memory: 0xe5100000, mmio: 0xffffc200000f8000
> [   56.586708] found a VP-1041 PCI DSS/DVB-S/DVB-S2 device on (01:06.0),
> [   56.586791]     Mantis Rev 1 [1ae4:0001], irq: 16, latency: 32
> [   56.586847]     memory: 0xe5100000, mmio: 0xffffc200000f8000
> [   56.589867]     MAC Address=[00:08:c9:e0:26:92]
> [   56.589972] mantis_alloc_buffers (0): DMA=0x1aa10000
> cpu=0xffff81001aa10000 size=65536
> [   56.590081] mantis_alloc_buffers (0): RISC=0x1b7f0000
> cpu=0xffff81001b7f0000 size=1000
> [   56.590187] DVB: registering new adapter (Mantis dvb adapter)
> [   57.106676] stb0899_write_regs [0xf1b6]: 02
> [   57.107730] stb0899_write_regs [0xf1c2]: 00
> [   57.108781] stb0899_write_regs [0xf1c3]: 00
> [   57.110884] _stb0899_read_reg: Reg=[0xf000], data=82
> [   57.110964] stb0899_get_dev_id: ID reg=[0x82]
> [   57.111040] stb0899_get_dev_id: Device ID=[8], Release=[2]
> [   57.117425] _stb0899_read_s2reg Device=[0xf3fc], Base
> address=[0x00000400], Offset=[0xf334], Data=[0x444d4431]
> [   57.123732] _stb0899_read_s2reg Device=[0xf3fc], Base
> address=[0x00000400], Offset=[0xf33c], Data=[0x00000001]
> [   57.123735] stb0899_get_dev_id: Demodulator Core ID=[DMD1],
> Version=[1]
> [   57.130121] _stb0899_read_s2reg Device=[0xfafc], Base
> address=[0x00000800], Offset=[0xfa2c], Data=[0x46454331]
> [   57.136428] _stb0899_read_s2reg Device=[0xfafc], Base
> address=[0x00000800], Offset=[0xfa34], Data=[0x00000001]
> [   57.136430] stb0899_get_dev_id: FEC Core ID=[FEC1], Version=[1]
> [   57.136509] stb0899_attach: Attaching STB0899
> [   57.136586] mantis_frontend_init (0): found STB0899 DVB-S/DVB-S2
> frontend @0x68
> [   57.136690] stb6100_attach: Attaching STB6100
> [   57.137118] DVB: registering frontend 1 (STB0899 Multistandard)...
>
> However it still doesn't tune. e.g.:
>
> root@kubuntu7:~/linuxtv-dvb-apps-1.1.1/util/szap# ./szap -r -p -l
> UNIVERSAL -t 0 -a 1 BBC1West
> reading channels from file '/root/.szap/channels.conf'
> zapping to 1 'BBC1West':
> sat 0, frequency = 10818 MHz V, symbolrate 22000000, vpid = 0x0901,
> apid = 0x0904 sid = 0x0002
> Querying info .. Delivery system=DVB-S
> using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'
> ----------------------------------> Using 'STB0899 DVB-S' DVB-S
> do_tune: API version=3, delivery system = 0
> do_tune: Frequency = 1068000, Srate = 22000000
> do_tune: Frequency = 1068000, Srate = 22000000
>
>
> Whereas this is the result when using an ordinary Skystar 2 card
> (which works fine):
>
> root@kubuntu7:~/linuxtv-dvb-apps-1.1.1/util/szap# ./szap -r -p -l
> UNIVERSAL -t 0 -a 0 BBC1West
> reading channels from file '/root/.szap/channels.conf'
> zapping to 1 'BBC1West':
> sat 0, frequency = 10818 MHz V, symbolrate 22000000, vpid = 0x0901,
> apid = 0x0904 sid = 0x0002
> Querying info .. Delivery system=DVB-S
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> ----------------------------------> Using 'ST STV0299 DVB-S' DVB-S
> do_tune: API version=3, delivery system = 0
> do_tune: Frequency = 1068000, Srate = 22000000
> do_tune: Frequency = 1068000, Srate = 22000000
>
>
> couldn't find pmt-pid for sid 0002
> status 1f | signal cac8 | snr cb6d | ber 000061d0 | unc 00000000 |
> FE_HAS_LOCK
> status 1f | signal c9f0 | snr d15e | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status 1f | signal ca1d | snr d176 | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
>
>
> Using szap on the Skystar HD2 caused lots of logs to dmesg:
>
> [   97.691029] stb0899_search: set DVB-S params
> [   97.691112] stb0899_search: delivery system=1
> [   97.691188] stb0899_search: Frequency=1068000, Srate=22000000
> [   97.691269] stb0899_search: Parameters IN RANGE
> [   97.692611] _stb0899_read_reg: Reg=[0xf1c2], data=20
> [   97.694085] _stb0899_read_reg: Reg=[0xf1c3], data=00
> [   97.694166] stb0899_set_delsys: Delivery System -- DVB-S
> [   97.695848] _stb0899_read_reg: Reg=[0xf533], data=01
> [   97.695929] stb0899_write_regs [0xf533]: 09
> [   97.697420] stb0899_write_regs [0xf548]: b1
> [   97.698913] stb0899_write_regs [0xf549]: 40
> [   97.700410] stb0899_write_regs [0xf54a]: 42
> [   97.701778] stb0899_write_regs [0xf54b]: 12
> [   97.704225] _stb0899_read_reg: Reg=[0xff11], data=00
> [   97.704308] stb0899_write_regs [0xff11]: 80
> [   97.705797] stb0899_write_regs [0xf1c2]: 78 07
> [   97.707631] stb0899_set_mclk: state->config=ffffffff882654a0
> [   97.707713] stb0899_set_mclk: mdiv=21
> [   97.707788] stb0899_write_regs [0xf1b3]: 15
> [   97.710338] _stb0899_read_reg: Reg=[0xf1b3], data=15
> [   97.710427] stb0899_get_mclk: div=21, mclk=99000000
> [   97.710505] stb0899_set_mclk: MasterCLOCK=99000000
> [   97.710582] stb0899_search: DVB-S delivery system
> [   97.712051] _stb0899_read_reg: Reg=[0xf12a], data=5c
> [   97.712131] stb0899_i2c_gate_ctrl: Enabling I2C Repeater ...
> [   97.712211] stb0899_write_regs [0xf12a]: dc
> [   97.715358] _stb0899_read_reg: Reg=[0xf12a], data=5c
> [   97.717042] _stb0899_read_reg: Reg=[0xf12a], data=5c
> [   97.717121] stb0899_i2c_gate_ctrl: Enabling I2C Repeater ...
> [   97.717202] stb0899_write_regs [0xf12a]: dc
> [   97.720769] _stb0899_read_reg: Reg=[0xf12a], data=5c
> [   97.726992] _stb0899_read_reg: Reg=[0xf12a], data=5c
> [   97.727071] stb0899_i2c_gate_ctrl: Enabling I2C Repeater ...
> [   97.727150] stb0899_write_regs [0xf12a]: dc
> [   97.730951] _stb0899_read_reg: Reg=[0xf12a], data=5c
> [   97.731030] stb6100_set_bandwidth: Bandwidth=51610000
> [   97.732640] _stb0899_read_reg: Reg=[0xf12a], data=5c
> [   97.732719] stb0899_i2c_gate_ctrl: Enabling I2C Repeater ...
> [   97.732800] stb0899_write_regs [0xf12a]: dc
> [   97.740229] _stb0899_read_reg: Reg=[0xf12a], data=5c
> [   97.740309] stb6100_get_bandwidth: Bandwidth=52000000
> [   97.740311] stb0899_write_regs [0xf157]: 11
> [   97.741801] stb0899_search: running DVB-S search algo ..
> [   97.741898] stb0899_set_srate: -->
> [   97.741973] stb0899_write_regs [0xf446]: 38 e3 90
> [   97.744156] stb0899_write_regs [0xf41c]: 89
> [   97.746593] _stb0899_read_reg: Reg=[0xf41d], data=94
> [   97.746672] stb0899_write_regs [0xf41d]: a7
> [   97.748164] stb0899_dvbs_algo: Set the timing loop to acquisition
> [   97.748262] stb0899_write_regs [0xf417]: 46
> [   97.749648] stb0899_write_regs [0xf41b]: ee
> [   97.750809] stb0899_dvbs_algo: Derot Percent=30 Srate=22000000
> mclk=1647
> [   97.750893] stb0899_dvbs_algo: RESET stream merger
> [   97.752023] _stb0899_read_reg: Reg=[0xff11], data=80
> [   97.752103] stb0899_write_regs [0xff11]: c0
> [   97.754207] _stb0899_read_reg: Reg=[0xf583], data=5c
> [   97.754286] stb0899_write_regs [0xf583]: 3c
> [   97.755338] stb0899_write_regs [0xf41e]: 01
> [   97.756392] stb0899_write_regs [0xf53d]: 19
> [   97.758498] _stb0899_read_reg: Reg=[0xf12a], data=5c
> [   97.758577] stb0899_i2c_gate_ctrl: Enabling I2C Repeater ...
> [   97.758656] stb0899_write_regs [0xf12a]: dc
> [   97.764979] _stb0899_read_reg: Reg=[0xf12a], data=5c
> [   97.765058] stb6100_get_bandwidth: Bandwidth=52000000
> [   97.765060] stb0899_write_regs [0xf43e]: 00 00
> [   97.766462] stb0899_write_regs [0xf439]: 00
> [   97.768568] _stb0899_read_reg: Reg=[0xf41b], data=ee
> [   97.768646] stb0899_write_regs [0xf41b]: ee
> [   97.769700] stb0899_dvbs_algo: Tuner set frequency
> [   97.770830] _stb0899_read_reg: Reg=[0xf12a], data=5c
> [   97.770909] stb0899_i2c_gate_ctrl: Enabling I2C Repeater ...
> [   97.770989] stb0899_write_regs [0xf12a]: dc
> [   97.777313] _stb0899_read_reg: Reg=[0xf12a], data=5c
> [   97.777392] stb0899_get_params: Get DVB-S params
> [   97.778522] _stb0899_read_reg: Reg=[0xf12a], data=5c
> [   97.778601] stb0899_i2c_gate_ctrl: Enabling I2C Repeater ...
> [   97.778680] stb0899_write_regs [0xf12a]: dc
> [   97.784985] _stb0899_read_reg: Reg=[0xf12a], data=5c
> [   97.786116] _stb0899_read_reg: Reg=[0xf12a], data=5c
> [   97.786195] stb0899_i2c_gate_ctrl: Enabling I2C Repeater ...
> [   97.786274] stb0899_write_regs [0xf12a]: dc
> [   97.789079] _stb0899_read_reg: Reg=[0xf12a], data=5c
> [   97.790210] _stb0899_read_reg: Reg=[0xf12a], data=5c
> [   97.790300] stb0899_i2c_gate_ctrl: Enabling I2C Repeater ...
> [   97.790380] stb0899_write_regs [0xf12a]: dc
> [   97.793185] _stb0899_read_reg: Reg=[0xf12a], data=5c
> [   97.802463] _stb0899_read_reg: Reg=[0xf12a], data=5c
> [   97.802544] stb0899_i2c_gate_ctrl: Enabling I2C Repeater ...
> [   97.802623] stb0899_write_regs [0xf12a]: dc
> [   97.805428] _stb0899_read_reg: Reg=[0xf12a], data=5c
> [   97.806559] _stb0899_read_reg: Reg=[0xf12a], data=5c
> [   97.806637] stb0899_i2c_gate_ctrl: Enabling I2C Repeater ...
> [   97.806716] stb0899_write_regs [0xf12a]: dc
> [   97.809521] _stb0899_read_reg: Reg=[0xf12a], data=5c
> [   97.845351] stb6100_set_frequency: Frequency=1068000
> [   97.846406] _stb0899_read_reg: Reg=[0xf12a], data=5c
> [   97.846484] stb0899_i2c_gate_ctrl: Enabling I2C Repeater ...
> [   97.846563] stb0899_write_regs [0xf12a]: dc
> [   97.852886] _stb0899_read_reg: Reg=[0xf12a], data=5c
> [   97.852965] stb6100_get_frequency: Frequency=1068002
> [   97.857361] stb0899_dvbs_algo: current derot freq=0
> [   97.858492] _stb0899_read_reg: Reg=[0xf12a], data=5c
> [   97.858574] stb0899_i2c_gate_ctrl: Enabling I2C Repeater ...
> [   97.858653] stb0899_write_regs [0xf12a]: dc
> [   97.864975] _stb0899_read_reg: Reg=[0xf12a], data=5c
> [   97.865054] stb6100_get_bandwidth: Bandwidth=52000000
> [   97.869318] stb0899_write_regs [0xf439]: f2
> [   97.871424] _stb0899_read_reg: Reg=[0xf438], data=80
> [   97.872554] _stb0899_read_reg: Reg=[0xf439], data=02
> [   97.872633] stb0899_check_tmg: ------->TIMING OK !
> [   97.874113] stb0899_read_regs [0xf43e]: fd 6d
> [   97.874117] stb0899_search_tmg: ------->TIMING OK ! Derot Freq = -659
> [   97.874199] stb0899_dvbs_algo: TIMING OK ! Derot freq=-659, mclk=1647
> [   97.875335] _stb0899_read_reg: Reg=[0xf41b], data=ee
> [   97.875413] stb0899_write_regs [0xf41b]: ee
> [   97.876467] stb0899_search_carrier: Derot Freq=-659, mclk=1647
> [   97.882354] _stb0899_read_reg: Reg=[0xf41b], data=ee
>
> Those logs don't look too bad superficially, but it's still not working.
>
> Tim.
>
> > hy,
> >
> > the wiki is not up2date.
> >
> > Twinhan VP-1041 support is now in the mantis tree (inkl. multiproto)
> >
> > hg clone http://jusst.de/hg/mantis
> >
> > but for me, the old initialization parameters works much better.
> > with the new
> > ones i get only a destructed picture (unwatchable).
> >
> > gernot



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
