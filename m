Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp1.betherenow.co.uk ([87.194.0.68])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tghewett2@onetel.com>) id 1JT4oX-0006Rj-1Z
	for linux-dvb@linuxtv.org; Sun, 24 Feb 2008 01:33:57 +0100
Message-Id: <3F173028-6967-4658-847D-041C4A70B78C@onetel.com>
From: Tim Hewett <tghewett2@onetel.com>
To: Manu Abraham <abraham.manu@gmail.com>
In-Reply-To: <47C0AF98.5000703@gmail.com>
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Sun, 24 Feb 2008 00:33:22 +0000
References: <65A7136B-8AAD-44EE-921E-5376D7BAC14E@onetel.com>
	<47C09CB5.8060804@gmail.com>
	<FE251317-5C82-44A7-B2F3-7F0254A787E6@onetel.com>
	<47C0AF98.5000703@gmail.com>
Cc: Tim Hewett <tghewett2@onetel.com>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Help with Skystar HD2 (Twinhan VP-1041/Azurewave
	AD	SP400 rebadge)
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

Manu,

Thanks, it now tunes to horizontal transponders though not vertical  
ones. I think others have been having similar symptoms with the mantis/ 
multiproto trees.

It won't tune to any DVB-S2 transponder, but that has not changed  
since previously.

Output from successful tuning:

root@kubuntu7:~/linuxtv-dvb-apps-1.1.1/util/szap# ./szap -r -p -l  
UNIVERSAL -t 0 -a 4 BBCNews24
reading channels from file '/root/.szap/channels.conf'
zapping to 6 'BBCNEWS24':
sat 1, frequency = 10773 MHz H, symbolrate 22000000, vpid = 0x0917,  
apid = 0x0919 sid = 0x0002
Querying info .. Delivery system=DVB-S
using '/dev/dvb/adapter4/frontend0' and '/dev/dvb/adapter4/demux0'
----------------------------------> Using 'STB0899 DVB-S' DVB-S
do_tune: API version=3, delivery system = 0
do_tune: Frequency = 1023000, Srate = 22000000
do_tune: Frequency = 1023000, Srate = 22000000


couldn't find pmt-pid for sid 0002
status 1e | signal 0128 | snr 0072 | ber 00000000 | unc fffffffe |  
FE_HAS_LOCK
status 1e | signal 0128 | snr 0071 | ber 00000000 | unc fffffffe |  
FE_HAS_LOCK
status 1e | signal 0128 | snr 0073 | ber 00000000 | unc fffffffe |  
FE_HAS_LOCK

root@kubuntu7:~/linuxtv-dvb-apps-1.1.1/util/szap#


Output from unsuccessful tuning:

root@kubuntu7:~/linuxtv-dvb-apps-1.1.1/util/szap# ./szap -r -p -l  
UNIVERSAL -t 0 -a 4 BBC1West
reading channels from file '/root/.szap/channels.conf'
zapping to 1 'BBC1West':
sat 1, frequency = 10818 MHz V, symbolrate 22000000, vpid = 0x0901,  
apid = 0x0903 sid = 0x0002
Querying info .. Delivery system=DVB-S
using '/dev/dvb/adapter4/frontend0' and '/dev/dvb/adapter4/demux0'
----------------------------------> Using 'STB0899 DVB-S' DVB-S
do_tune: API version=3, delivery system = 0
do_tune: Frequency = 1068000, Srate = 22000000
do_tune: Frequency = 1068000, Srate = 22000000



root@kubuntu7:~/linuxtv-dvb-apps-1.1.1/util/szap#


Messages in dmesg for successful tuning:

[  402.455361] dvb_frontend_ioctl: DVBFE_GET_INFO
[  402.455366] stb0899_get_info: Querying DVB-S info
[  402.556373] newfec_to_oldfec: Unsupported FEC 9
[  402.556377] dvb_frontend_ioctl: FESTATE_RETUNE: fepriv->state=2
[  402.556998] mantis start feed & dma
[  402.557255] stb0899_search: set DVB-S params
[  402.567810] stb6100_set_bandwidth: Bandwidth=51610000
[  402.569927] stb6100_get_bandwidth: Bandwidth=52000000
[  402.581331] stb6100_get_bandwidth: Bandwidth=52000000
[  402.613394] stb6100_set_frequency: Frequency=1023000
[  402.615510] stb6100_get_frequency: Frequency=1022994
[  402.621496] stb6100_get_bandwidth: Bandwidth=52000000
[  404.541047] _stb0899_read_reg: Read error, Reg=[0xf525], Status=-121
[  404.541749] mantis stop feed and dma


Messages in dmesg for unsuccessful tuning:

[  428.255926] dvb_frontend_ioctl: DVBFE_GET_INFO
[  428.255935] stb0899_get_info: Querying DVB-S info
[  428.358369] newfec_to_oldfec: Unsupported FEC 9
[  428.358375] dvb_frontend_ioctl: FESTATE_RETUNE: fepriv->state=2
[  428.358384] stb0899_search: set DVB-S params
[  428.366099] mantis start feed & dma
[  428.370052] stb6100_set_bandwidth: Bandwidth=51610000
[  428.372169] stb6100_get_bandwidth: Bandwidth=52000000
[  428.383571] stb6100_get_bandwidth: Bandwidth=52000000
[  428.415643] stb6100_set_frequency: Frequency=1068000
[  428.417759] stb6100_get_frequency: Frequency=1068002
[  428.423743] stb6100_get_bandwidth: Bandwidth=52000000
[  428.855068] stb0899_search: set DVB-S params
[  428.867399] stb6100_set_bandwidth: Bandwidth=51610000
[  428.869513] stb6100_get_bandwidth: Bandwidth=52000000
[  428.880942] stb6100_get_bandwidth: Bandwidth=52000000
[  428.912989] stb6100_set_frequency: Frequency=1068000
[  428.915105] stb6100_get_frequency: Frequency=1068002
[  428.921089] stb6100_get_bandwidth: Bandwidth=52000000
[  429.360404] stb0899_search: set DVB-S params
[  429.372735] stb6100_set_bandwidth: Bandwidth=51610000
[  429.374877] stb6100_get_bandwidth: Bandwidth=52000000
[  429.386280] stb6100_get_bandwidth: Bandwidth=52000000
[  429.420690] stb6100_set_frequency: Frequency=1068000
[  429.423096] stb6100_get_frequency: Frequency=1068002
[  429.428790] stb6100_get_bandwidth: Bandwidth=52000000
[  429.858115] stb0899_search: set DVB-S params
[  429.870449] stb6100_set_bandwidth: Bandwidth=51610000
[  429.872856] stb6100_get_bandwidth: Bandwidth=52000000
[  429.884544] stb6100_get_bandwidth: Bandwidth=52000000
[  429.918035] stb6100_set_frequency: Frequency=1068000
[  429.920436] stb6100_get_frequency: Frequency=1068002
[  429.926137] stb6100_get_bandwidth: Bandwidth=52000000
[  430.325501] stb0899_search: set DVB-S params
[  430.337835] stb6100_set_bandwidth: Bandwidth=51610000
[  430.340273] stb6100_get_bandwidth: Bandwidth=52000000
[  430.351963] stb6100_get_bandwidth: Bandwidth=52000000
[  430.385421] stb6100_set_frequency: Frequency=1068000
[  430.387816] stb6100_get_frequency: Frequency=1068002
[  430.393523] stb6100_get_bandwidth: Bandwidth=52000000
[  430.834833] stb0899_search: set DVB-S params
[  430.847166] stb6100_set_bandwidth: Bandwidth=51610000
[  430.849576] stb6100_get_bandwidth: Bandwidth=52000000
[  430.861267] stb6100_get_bandwidth: Bandwidth=52000000
[  430.894753] stb6100_set_frequency: Frequency=1068000
[  430.897148] stb6100_get_frequency: Frequency=1068002
[  430.902855] stb6100_get_bandwidth: Bandwidth=52000000
[  431.133659] mantis stop feed and dma

HTH,

Tim.


On 23 Feb 2008, at 23:43, Manu Abraham wrote:

> Tim Hewett wrote:
>> Manu,
>> I tried the changes, the card is now recognised at boot time  
>> without needing any manual changes to the code.
>> However it now no longer tunes:
>
> Sigh! missed out something while i carried forward something. I have
> applied the fix to the tree just now. Please try again.
>
> Regards,
> Manu
>
>


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
