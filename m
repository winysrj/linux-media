Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bobrnet.cust.inethome.cz ([88.146.180.6]
	helo=mailserver.bobrnet.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <pavel.hofman@insite.cz>) id 1L7dm4-00049I-V4
	for linux-dvb@linuxtv.org; Tue, 02 Dec 2008 23:31:22 +0100
Message-ID: <4935B72F.1000505@insite.cz>
Date: Tue, 02 Dec 2008 23:31:11 +0100
From: Pavel Hofman <pavel.hofman@insite.cz>
MIME-Version: 1.0
To: Michel Verbraak <michel@verbraak.org>
References: <49346726.7010303@insite.cz> <4934D218.4090202@verbraak.org>
In-Reply-To: <4934D218.4090202@verbraak.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Technisat HD2 cannot szap/scan
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

Michel Verbraak napsal(a):
> Pavel Hofman schreef:
>> Hello,
>>
>>
>> I have studied many pages, tried to make the card work. I can tune and 
>> view programs in windows.
>>
>> My setup:
>>
>> Ubuntu 8.04, P4 32bit, Technisat HD2 connected to dual LNB, A heading to 
>> Astra 19.2E, B heading to Astra 23.5E
>>
>> uname -a:
>> Linux htpc 2.6.24-19-generic #1 SMP
>>
>>
>> lspci -v:
>> 05:01.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI 
>> Bridge Controller [Ver 1.0] (rev 01)
>>          Subsystem: Unknown device 1ae4:0003
>>          Flags: bus master, medium devsel, latency 32, IRQ 22
>>          Memory at 92000000 (32-bit, prefetchable) [size=4K]
>>
>>
>> I fetched latest mantis from  http://jusst.de/hg/mantis, changed
>> #define TECHNISAT_SKYSTAR_HD2  0x0003
>>
>>
>>   
> <snip>
>> I fetched latest dvb-apps from  http://linuxtv.org/hg/dvb-apps, compiled.
>>
>>   
> <snip>
>> Please what are the next steps I should perform to make the card work? 
>> Such as the success report 
>> http://www.mail-archive.com/linux-dvb@linuxtv.org/msg29608.html
>>
>>
>> I can post verbose=5 messages for stb0899/stb6100 if needed. Thank you 
>> very much for your help and suggestions.
>>
>> Regards,
>>
>> Pavel.
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>   
> 
> Pavel,
> 
> Try http://mercurial.intuxication.org/hg/s2-liplianin . This one works 
> for me on Fedora 9 with the latest scan tool (scan-s2) from 
> http://mercurial.intuxication.org/hg/scan-s2 and tune tool (szap-s2) 
> from http://mercurial.intuxication.org/hg/szap-s2.
> 
> If you unpack the driver and the tools unpack them into the same 
> directory and make a symbolic link named "s2" pointing to the 
> s2-liplianing-* directory. Do this before compiling of the tools.
> 
> Regards,
> 
> Michel.

Michel,

Thanks a lot for your help. The compilation succeeded, modules got loaded:

[   43.347517] mantis_alloc_buffers (0): DMA=0x1f4e0000 cpu=0xdf4e0000 
size=65536
[   43.347570] mantis_alloc_buffers (0): RISC=0x1fbe5000 cpu=0xdfbe5000 
size=1000
[   43.347616] DVB: registering new adapter (Mantis dvb adapter)
[   43.897518] stb0899_attach: Attaching STB0899
[   43.897526] mantis_frontend_init (0): found STB0899 DVB-S/DVB-S2 
frontend @0x68
[   43.897576] stb6100_attach: Attaching STB6100
[   43.897932] DVB: registering adapter 0 frontend 0 (STB0899 
Multistandard)...
[   43.898020] mantis_ca_init (0): Registering EN50221 device
[   43.993056] mantis_ca_init (0): Registered EN50221 device


However:

pavel@htpc:~/project/satelit2/szap-s2$ ./szap-s2 -x EinsFestival
reading channels from file '/home/pavel/.szap/channels.conf'
zapping to 5 'EinsFestival':
delivery DVB-S, modulation QPSK
sat 0, frequency 12110 MHz H, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x00c9, apid 0x00ca, sid 0x0001
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc fffffffe |


pavel@htpc:~/project/satelit2/scan-s2$ ./scan-s2 -s 0  dvb-s/Astra-19.2E
API major 5, minor 0
scanning dvb-s/Astra-19.2E
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder DVB-S  12551500 V 22000000 5/6 AUTO AUTO
initial transponder DVB-S2 12551500 V 22000000 5/6 AUTO AUTO
----------------------------------> Using DVB-S
 >>> tune to: 12551:vS0C56:S0.0W:22000:
DVB-S IF freq is 1951500
WARNING: >>> tuning failed!!!
 >>> tune to: 12551:vS0C56:S0.0W:22000: (tuning failed)
DVB-S IF freq is 1951500
WARNING: >>> tuning failed!!!
----------------------------------> Using DVB-S2
 >>> tune to: 12551:vS1C56:S0.0W:22000:
DVB-S IF freq is 1951500
WARNING: >>> tuning failed!!!
 >>> tune to: 12551:vS1C56:S0.0W:22000: (tuning failed)
DVB-S IF freq is 1951500
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.


While dmesg:
[  660.524758] mantis stop feed and dma
[  680.128573] stb6100_set_bandwidth: Bandwidth=51610000
[  680.136922] stb6100_get_bandwidth: Bandwidth=52000000
[  680.163669] stb6100_get_bandwidth: Bandwidth=52000000
[  680.251698] stb6100_set_frequency: Frequency=1951500
[  680.260045] stb6100_get_frequency: Frequency=1951488
[  680.273930] stb6100_get_bandwidth: Bandwidth=52000000
[  681.003293] stb6100_set_bandwidth: Bandwidth=51610000
[  681.011639] stb6100_get_bandwidth: Bandwidth=52000000
[  681.038384] stb6100_get_bandwidth: Bandwidth=52000000
[  681.130415] stb6100_set_frequency: Frequency=1951500
[  681.138761] stb6100_get_frequency: Frequency=1951488
[  681.152646] stb6100_get_bandwidth: Bandwidth=52000000
[  681.883001] stb6100_set_bandwidth: Bandwidth=51610000
[  681.891348] stb6100_get_bandwidth: Bandwidth=52000000
[  681.918095] stb6100_get_bandwidth: Bandwidth=52000000
[  682.006124] stb6100_set_frequency: Frequency=1951500
[  682.014471] stb6100_get_frequency: Frequency=1951488

I am afraid there is no major difference to my previous experiments.

Please do you think some debug messages would help?

Thanks a lot,

Pavel.




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
