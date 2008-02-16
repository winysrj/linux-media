Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from hpsmtp-eml20.kpnxchange.com ([213.75.38.85])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <scha0273@planet.nl>) id 1JQJA7-0005Ej-80
	for linux-dvb@linuxtv.org; Sat, 16 Feb 2008 10:16:47 +0100
Message-ID: <47B6A9DB.501@planet.nl>
Date: Sat, 16 Feb 2008 10:16:11 +0100
From: henk schaap <haschaap@planet.nl>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] multiproto and tt3200: don't get a lock
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

Hi all,

I am already a few weeks experimenting to get my tt3200 with the 
multiproto driver to work. Still no lock on a channel. May be someone 
can give me good suggestion?

Henk Schaap

Here is some data:

Distribution: Suse 10.3
TT-budget S2-3200
Multiproto driver from Manu
Instruction to install the driver: from 
http://www.vdr-wiki.de/wiki/index.php/OpenSUSE_VDR_DVB-S2_-_Teil2:_DVB_Treiber
szap patch from Manu

DMESG looks nice to me, only the failing probe of rtc_cmos is suspicious!
--------------------------------------------------------------------------
saa7146: register extension 'budget_ci dvb'.
ACPI: PCI Interrupt 0000:05:04.0[A] -> GSI 17 (level, low) -> IRQ 17
saa7146: found saa7146 @ mem ffffc20001018400 (revision 1, irq 17) 
(0x13c2,0x1019).
saa7146 (0): dma buffer size 192512
DVB: registering new adapter (TT-Budget S2-3200 PCI)
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc_cmos: probe of 00:03 failed with error -16
Floppy drive(s): fd0 is 1.44M
adapter has MAC addr = 00:d0:5c:0b:5b:f3
input: Budget-CI dvb ir receiver saa7146 (0) as /class/input/input3
budget_ci: CI interface initialised
FDC 0 is a post-1991 82077
sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 3:0:0:0: Attached scsi CD-ROM sr0
stb0899_attach: Attaching STB0899
stb6100_attach: Attaching STB6100
DVB: registering frontend 0 (STB0899 Multistandard)...

And zapping to a channel with szap gives the following result:
-------------------------------------------------------------
henk@mediapark:~/bin/szap> ./szap -n 1775
reading channels from file '/home/henk/.szap/channels.conf'
zapping to 1775 'WDR 3;ARD':
sat 0, frequency = 12109 MHz H, symbolrate 27500000, vpid = 0x1fff, apid 
= 0x05dd sid = 0x0000
Querying info .. Delivery system=DVB-S
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
----------------------------------> Using 'STB0899 DVB-S' DVB-Sstatus 00 
| signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
