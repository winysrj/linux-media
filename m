Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n35.bullet.mail.ukl.yahoo.com ([87.248.110.168])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1JU9js-0005Zm-3h
	for linux-dvb@linuxtv.org; Wed, 27 Feb 2008 01:01:36 +0100
Date: Tue, 26 Feb 2008 19:59:22 -0400
From: manu <eallaud@yahoo.fr>
To: linux-dvb@linuxtv.org
References: <20080118155007.050e2f8c@wanadoo.fr>
In-Reply-To: <20080118155007.050e2f8c@wanadoo.fr> (from
	david.bercot@wanadoo.fr on Fri Jan 18 10:50:07 2008)
Message-Id: <1204070362l.7293l.2l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re :  My own TT S2-3200 problems ;-)
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

On 01/18/2008 10:50:07 AM, David BERCOT wrote:
> Hi,
> 
> Like many others, I'm trying to use my TT S2-3200 under Debian. 
> Before
> trying softwares (VDR, etc...), I'd like to install it properly.
> 
> Here is my steps (from many tutorials) :
> FIRMWARE
> # mkdir /data/debian/DVB
> # cd /data/debian/DVB
> # wget http://www.linuxtv.org/downloads/firmware/dvb-ttpci-01.fw-2622
> # cd /lib/firmware/
> # cp -a /data/debian/DVB/dvb-ttpci-01.fw-2622 .
> # ln -s dvb-ttpci-01.fw-2622 dvb-ttpci-01.fw
> 
> DRIVER
> # cd /data/debian/DVB
> # apt-get install mercurial
> # hg clone http://jusst.de/hg/multiproto
> # cd multiproto
> # make
> # make install
> # modprobe stb6100
> # modprobe stb0899
> # modprobe lnbp21
> # modprobe budget-ci
> 
> DMESG
> # dmesg
> saa7146: register extension 'budget_ci dvb'.
> ACPI: PCI Interrupt 0000:05:01.0[A] -> GSI 22 (level, low) -> IRQ 22
> saa7146: found saa7146 @ mem ffffc20001598c00 (revision 1, irq 22)
> (0x13c2,0x1019).
> saa7146 (0): dma buffer size 192512
> DVB: registering new adapter (TT-Budget S2-3200 PCI)
> adapter has MAC addr = 00:d0:5c:0b:a5:8b
> input: Budget-CI dvb ir receiver saa7146 (0) as /class/input/input9
> budget_ci: CI interface initialised
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
> ID=[DMD1], Version=[1] _stb0899_read_s2reg Device=[0xfafc], Base
> address=[0x00000800], Offset=[0xfa2c], Data=[0x46454331]
> _stb0899_read_s2reg Device=[0xfafc], Base address=[0x00000800],
> Offset=[0xfa34], Data=[0x00000001] stb0899_get_dev_id: FEC Core
> ID=[FEC1], Version=[1] stb0899_attach: Attaching STB0899
> stb6100_attach: Attaching STB6100 DVB: registering frontend 0 
> (STB0899
> Multistandard)... dvb_ca adaptor 0: PC card did not respond :(
> 
> Do you have any clue about this error ?
> 
> Thank you very much.
>

Hi David,
did you manage to test with the cam to get something working?
I would be thrilled to know if someone has ever managed to get the TT 
3200 to work with a CAM (I mean the full monty: lock+good picture ;-)
Bye
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
