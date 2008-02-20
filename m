Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n20.bullet.mail.mud.yahoo.com ([68.142.200.47])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1JRtle-0007XG-4n
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 19:34:06 +0100
Date: Wed, 20 Feb 2008 13:52:59 -0400
From: manu <eallaud@yahoo.fr>
To: linux-dvb@linuxtv.org
In-Reply-To: <20080220173045.0cd4a51d@wanadoo.fr> (from
	david.bercot@wanadoo.fr on Wed Feb 20 12:30:45 2008)
Message-Id: <1203529979l.13771l.2l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re :  Any idea about my CI error ?
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

On 02/20/2008 12:30:45 PM, David BERCOT wrote:
> Hi,
> 
> For my S2-3200, I've done :
> # modprobe dvb-core cam_debug=255 [thank you Manu ;-)]
> # modprobe stb6100
> # modprobe stb0899
> # modprobe lnbp21
> # modprobe budget-c
> 
> and I have some more information about my CI :
> saa7146: register extension 'budget_ci dvb'.
> ACPI: PCI Interrupt 0000:05:01.0[A] -> GSI 22 (level, low) -> IRQ 22
> saa7146: found saa7146 @ mem ffffc20001046c00 (revision 1, irq 22)
> (0x13c2,0x1019). saa7146 (0): dma buffer size 192512
> DVB: registering new adapter (TT-Budget S2-3200 PCI)
> adapter has MAC addr = 00:d0:5c:0b:a5:8b
> input: Budget-CI dvb ir receiver saa7146 (0) as /class/input/input9
> dvb_ca_en50221_init
> budget_ci: CI interface initialised
> CAMCHANGE IRQ slot:0 change_type:1
> dvb_ca_en50221_thread_wakeup
> dvb_ca_en50221_thread
> stb0899_write_regs [0xf1b6]: 02
> stb0899_write_regs [0xf1c2]: 00
> stb0899_write_regs [0xf1c3]: 00
> _stb0899_read_reg: Reg=[0xf000], data=81
> stb0899_get_dev_id: ID reg=[0x81]
> stb0899_get_dev_id: Device ID=[8], Release=[1]
> _stb0899_read_s2reg Device=[0xf3fc], Base address=[0x00000400],
> Offset=[0xf334], Data=[0x444d4431]
> _stb0899_read_s2reg Device=[0xf3fc], Base address=[0x00000400],
> Offset=[0xf33c], Data=[0x00000001] stb0899_get_dev_id: Demodulator
> Core
> ID=[DMD1], Version=[1]
> _stb0899_read_s2reg Device=[0xfafc], Base address=[0x00000800],
> Offset=[0xfa2c], Data=[0x46454331]
> _stb0899_read_s2reg Device=[0xfafc], Base address=[0x00000800],
> Offset=[0xfa34], Data=[0x00000001] stb0899_get_dev_id: FEC Core
> ID=[FEC1], Version=[1]
> stb0899_attach: Attaching STB0899
> stb6100_attach: Attaching STB6100
> DVB: registering frontend 0 (STB0899 Multistandard)...
> dvb_ca adaptor 0: PC card did not respond :(
> 
> Does anyone have an idea about this error ?

Here is my log (with the PC card plugged in), as you can see they are 
really different! (Oh and the subscription card was not in, but it does 
not matter). I had a problem with my TT S-1500 which would not always 
recognize my pc card, seems the CI was defective (in general bad power 
supply can do that it seems).

[ 1014.008185] ACPI: PCI interrupt for device 0000:06:00.0 disabled
[ 1032.619673] saa7146: register extension 'budget_ci dvb'.
[ 1032.619870] ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 21 (level, 
low) -> IRQ 20
[ 1032.619897] saa7146: found saa7146 @ mem f8c54800 (revision 1, irq 
20) (0x13c2,0x1019).
[ 1032.619906] saa7146 (0): dma buffer size 192512
[ 1032.620403] DVB: registering new adapter (TT-Budget S2-3200 PCI)
[ 1032.621809] adapter has MAC addr = 00:d0:5c:67:ba:81
[ 1032.622261] input: Budget-CI dvb ir receiver saa7146 (0) as /class/
input/input5
[ 1032.622488] dvb_ca_en50221_init
[ 1032.622619] budget_ci: CI interface initialised
[ 1032.622625] dvb_ca_en50221_thread
[ 1032.826328] TUPLE type:0x1d length:4
[ 1032.826339]   0x00: 0x00 .
[ 1032.826346]   0x01: 0xdb .
[ 1032.826353]   0x02: 0x08 .
[ 1032.826360]   0x03: 0xff .
[ 1032.826372] TUPLE type:0x1c length:3
[ 1032.826380]   0x00: 0x00 .
[ 1032.826387]   0x01: 0x08 .
[ 1032.826393]   0x02: 0xff .
[ 1032.826406] TUPLE type:0x15 length:23
[ 1032.826413]   0x00: 0x05 .
[ 1032.826420]   0x01: 0x00 .
[ 1032.826427]   0x02: 0x41 A
[ 1032.826434]   0x03: 0x53 S
[ 1032.826440]   0x04: 0x54 T
[ 1032.826447]   0x05: 0x4f O
[ 1032.826454]   0x06: 0x4e N
[ 1032.826461]   0x07: 0x00 .
[ 1032.826468]   0x08: 0x44 D
[ 1032.826475]   0x09: 0x56 V
[ 1032.826482]   0x0a: 0x42 B
[ 1032.826489]   0x0b: 0x20  
[ 1032.826495]   0x0c: 0x43 C
[ 1032.826502]   0x0d: 0x41 A
[ 1032.826509]   0x0e: 0x20  
[ 1032.826516]   0x0f: 0x4d M
[ 1032.826523]   0x10: 0x6f o
[ 1032.826530]   0x11: 0x64 d
[ 1032.826537]   0x12: 0x75 u
[ 1032.826544]   0x13: 0x6c l
[ 1032.826551]   0x14: 0x65 e
[ 1032.826557]   0x15: 0x00 .
[ 1032.826564]   0x16: 0xff .
[ 1032.826577] TUPLE type:0x20 length:4
[ 1032.826584]   0x00: 0xff .
[ 1032.826591]   0x01: 0xff .
[ 1032.826598]   0x02: 0x01 .
[ 1032.826605]   0x03: 0x00 .
[ 1032.826617] TUPLE type:0x1a length:21
[ 1032.826624]   0x00: 0x01 .
[ 1032.826631]   0x01: 0x0f .
[ 1032.826638]   0x02: 0x00 .
[ 1032.826645]   0x03: 0x02 .
[ 1032.826651]   0x04: 0x01 .
[ 1032.826658]   0x05: 0xc0 .
[ 1032.826665]   0x06: 0x0e .
[ 1032.826672]   0x07: 0x41 A
[ 1032.826679]   0x08: 0x02 .
[ 1032.826686]   0x09: 0x44 D
[ 1032.826693]   0x0a: 0x56 V
[ 1032.826700]   0x0b: 0x42 B
[ 1032.826706]   0x0c: 0x5f _
[ 1032.826713]   0x0d: 0x43 C
[ 1032.826720]   0x0e: 0x49 I
[ 1032.826727]   0x0f: 0x5f _
[ 1032.826734]   0x10: 0x56 V
[ 1032.826741]   0x11: 0x31 1
[ 1032.826748]   0x12: 0x2e .
[ 1032.826755]   0x13: 0x30 0
[ 1032.826762]   0x14: 0x30 0
[ 1032.826774] TUPLE type:0x1b length:17
[ 1032.826782]   0x00: 0xc9 .
[ 1032.826789]   0x01: 0x41 A
[ 1032.826796]   0x02: 0x19 .
[ 1032.826803]   0x03: 0x37 7
[ 1032.826810]   0x04: 0x55 U
[ 1032.826817]   0x05: 0x4e N
[ 1032.826824]   0x06: 0x5e ^
[ 1032.826830]   0x07: 0x1d .
[ 1032.826837]   0x08: 0x56 V
[ 1032.826844]   0x09: 0xaa .
[ 1032.826851]   0x0a: 0x60 `
[ 1032.826858]   0x0b: 0x20  
[ 1032.826865]   0x0c: 0x03 .
[ 1032.826872]   0x0d: 0x03 .
[ 1032.826879]   0x0e: 0x50 P
[ 1032.826886]   0x0f: 0xff .
[ 1032.826893]   0x10: 0xff .
[ 1032.826905] TUPLE type:0x1b length:37
[ 1032.826912]   0x00: 0xcf .
[ 1032.826919]   0x01: 0x04 .
[ 1032.826926]   0x02: 0x09 .
[ 1032.826933]   0x03: 0x37 7
[ 1032.826940]   0x04: 0x55 U
[ 1032.826946]   0x05: 0x4d M
[ 1032.826953]   0x06: 0x5d ]
[ 1032.826960]   0x07: 0x1d .
[ 1032.826967]   0x08: 0x56 V
[ 1032.826974]   0x09: 0x22 "
[ 1032.826981]   0x0a: 0xc0 .
[ 1032.826987]   0x0b: 0x09 .
[ 1032.826994]   0x0c: 0x44 D
[ 1032.827001]   0x0d: 0x56 V
[ 1032.827008]   0x0e: 0x42 B
[ 1032.827015]   0x0f: 0x5f _
[ 1032.827022]   0x10: 0x48 H
[ 1032.827029]   0x11: 0x4f O
[ 1032.827035]   0x12: 0x53 S
[ 1032.827042]   0x13: 0x54 T
[ 1032.827049]   0x14: 0x00 .
[ 1032.827056]   0x15: 0xc1 .
[ 1032.827063]   0x16: 0x0e .
[ 1032.827070]   0x17: 0x44 D
[ 1032.827077]   0x18: 0x56 V
[ 1032.827084]   0x19: 0x42 B
[ 1032.827091]   0x1a: 0x5f _
[ 1032.827098]   0x1b: 0x43 C
[ 1032.827104]   0x1c: 0x49 I
[ 1032.827111]   0x1d: 0x5f _
[ 1032.827118]   0x1e: 0x4d M
[ 1032.827125]   0x1f: 0x4f O
[ 1032.827132]   0x20: 0x44 D
[ 1032.827139]   0x21: 0x55 U
[ 1032.827146]   0x22: 0x4c L
[ 1032.827153]   0x23: 0x45 E
[ 1032.827160]   0x24: 0x00 .
[ 1032.827173] TUPLE type:0x14 length:0
[ 1032.827180] END OF CHAIN TUPLE type:0xff
[ 1032.827183] Valid DVB CAM detected MANID:ffff DEVID:1 
CONFIGBASE:0x200 CONFIGOPTION:0xf
[ 1032.827186] dvb_ca_en50221_set_configoption
[ 1032.827199] Set configoption 0xf, read configoption 0xf
[ 1032.827206] DVB CAM validated successfully
[ 1032.926085] dvb_ca_en50221_link_init
[ 1032.926093] dvb_ca_en50221_wait_if_status
[ 1032.926101] dvb_ca_en50221_wait_if_status succeeded timeout:0
[ 1032.926104] dvb_ca_en50221_read_data
[ 1032.926137] Received CA packet for slot 0 connection id 0x0 
last_frag:1 size:0x2
[ 1032.926145] Chosen link buffer size of 16
[ 1032.926152] dvb_ca_en50221_wait_if_status
[ 1032.926159] dvb_ca_en50221_wait_if_status succeeded timeout:0
[ 1032.926162] dvb_ca_en50221_write_data
[ 1032.926203] Wrote CA packet for slot 0, connection id 0x0 
last_frag:1 size:0x2
[ 1032.926242] dvb_ca adapter 0: DVB CAM detected and initialised 
successfully
[ 1032.930104] stb0899_write_regs [0xf1b6]: 02
[ 1032.930316] stb0899_write_regs [0xf1c2]: 00
[ 1032.930513] stb0899_write_regs [0xf1c3]: 00
[ 1032.930912] _stb0899_read_reg: Reg=[0xf000], data=82
[ 1032.930917] stb0899_get_dev_id: ID reg=[0x82]
[ 1032.930920] stb0899_get_dev_id: Device ID=[8], Release=[2]
[ 1032.931992] _stb0899_read_s2reg Device=[0xf3fc], Base address=
[0x00000400], Offset=[0xf334], Data=[0x444d4431]
[ 1032.932941] _stb0899_read_s2reg Device=[0xf3fc], Base address=
[0x00000400], Offset=[0xf33c], Data=[0x00000001]
[ 1032.932947] stb0899_get_dev_id: Demodulator Core ID=[DMD1], Version=
[1]
[ 1032.933893] _stb0899_read_s2reg Device=[0xfafc], Base address=
[0x00000800], Offset=[0xfa2c], Data=[0x46454331]
[ 1032.934835] _stb0899_read_s2reg Device=[0xfafc], Base address=
[0x00000800], Offset=[0xfa34], Data=[0x00000001]
[ 1032.934840] stb0899_get_dev_id: FEC Core ID=[FEC1], Version=[1]
[ 1032.934844] stb0899_attach: Attaching STB0899 
[ 1032.934882] stb6100_attach: Attaching STB6100 
[ 1032.935011] DVB: registering frontend 0 (STB0899 Multistandard)...



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
