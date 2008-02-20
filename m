Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n19.bullet.mail.mud.yahoo.com ([68.142.200.46])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1JRgae-0007CO-8F
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 05:29:52 +0100
Date: Tue, 19 Feb 2008 22:37:49 -0400
From: manu <eallaud@yahoo.fr>
To: Linux DVB Mailing List <linux-dvb@linuxtv.org>
Message-Id: <1203475069l.9490l.0l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] [BUG]: insering cam stop irq10 on TT S2-3200
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
my TT S2-3200 is able to scan and szap with a solid lock (confirmed by 
a dvbsnoop where I can see the correct PAT and such), but as soon as I 
plug the pc card (aston which was working great with my now defunct TT 
S-1500) the stream stops. You can see in the log that when the card has 
just been validated the irq10 handler stops being called. Any idea to 
help me out? I can instrument the code, well whatever can speed up 
debugging the problem.

The log (snippet of dmesg)

[16317.609473] budget_ci: budget_ci_irq(): dev: f09d9b40, budget_ci: 
f4d5d000
[16317.609478] budget_core: ttpci_budget_irq10_handler(): dev: 
f09d9b40, budget: f4d5d000
[16317.618250] _stb0899_read_reg: Reg=[0xf525], data=00
[16317.618494] _stb0899_read_reg: Reg=[0xf524], data=00
[16317.622093] budget_ci: budget_ci_irq(): dev: f09d9b40, budget_ci: 
f4d5d000
[16317.622099] budget_core: ttpci_budget_irq10_handler(): dev: 
f09d9b40, budget: f4d5d000
[16317.633913] budget_ci: budget_ci_irq(): dev: f09d9b40, budget_ci: 
f4d5d000
[16317.633918] budget_core: ttpci_budget_irq10_handler(): dev: 
f09d9b40, budget: f4d5d000
[16317.633932] dmxdev: section callback 00 b0 5d 02 5b d1
[16317.646123] budget_ci: ciintf_slot_ts_enable(): slot_ts_enable 
budget_ci=f4d5d000
[16317.646140] budget_core: stop_ts_capture(): budget: f4d5d000
[16317.646146] budget_core: start_ts_capture(): budget: f4d5d000
[16317.656092] dvb_ca adapter 0: DVB CAM detected and initialised 
successfully
[16318.616561] stb0899_read_status: Delivery system DVB-S/DSS
[16318.616912] _stb0899_read_reg: Reg=[0xf50d], data=18
[16318.616949] stb0899_read_status: --------> FE_HAS_CARRIER | 
FE_HAS_LOCK
[16318.617382] _stb0899_read_reg: Reg=[0xf58c], data=15
[16318.617418] stb0899_read_status: --------> FE_HAS_VITERBI | 
FE_HAS_SYNC
[16318.617861] _stb0899_read_reg: Reg=[0xf50d], data=18
[16318.618132] _stb0899_read_reg: Reg=[0xf42e], data=34
[16318.618169] stb0899_read_signal_strength: AGCIQVALUE = 0x34, C = 500 
* 0.1 dBm
[16318.618686] _stb0899_read_reg: Reg=[0xf50d], data=18
[16318.619014] stb0899_read_regs [0xf440]: 15 7f
[16318.619021] stb0899_read_snr: NIR = 0x157f = 5503, C/N = 94 * 0.1 
dBm
[16318.619023] 
[16318.720031] _stb0899_read_reg: Reg=[0xf525], data=00
[16318.720301] _stb0899_read_reg: Reg=[0xf524], data=00
[16318.823828] _stb0899_read_reg: Reg=[0xf525], data=00
[16318.824099] _stb0899_read_reg: Reg=[0xf524], data=00

Thx,
Bye
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
