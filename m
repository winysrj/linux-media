Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp1.betherenow.co.uk ([87.194.0.68])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tghewett2@onetel.com>) id 1JT3wD-0000sG-Ma
	for linux-dvb@linuxtv.org; Sun, 24 Feb 2008 00:37:49 +0100
Message-Id: <23DD62DE-F5C7-4D4F-A837-9430974AD525@onetel.com>
From: Tim Hewett <tghewett2@onetel.com>
To: Manu Abraham <abraham.manu@gmail.com>
In-Reply-To: <47C09CB5.8060804@gmail.com>
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Sat, 23 Feb 2008 23:37:05 +0000
References: <65A7136B-8AAD-44EE-921E-5376D7BAC14E@onetel.com>
	<47C09CB5.8060804@gmail.com>
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

I tried the changes, the card is now recognised at boot time without  
needing any manual changes to the code.

However it now no longer tunes:


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



root@kubuntu7:~/linuxtv-dvb-apps-1.1.1/util/szap#


Many logs appear in dmesg:

[  252.991931] mantis_ack_wait (0): Slave RACK Fail !
[  252.993633] dvb_frontend_ioctl: DVBFE_GET_INFO
[  252.993637] stb0899_get_info: Querying DVB-S2 info
[  253.096348] dvb_frontend_ioctl: FESTATE_RETUNE: fepriv->state=2
[  253.094642] stb0899_search: set DVB-S2 params
[  253.097053] mantis start feed & dma
[  256.103782] mantis_ack_wait (0): Slave RACK Fail !
[  256.103965] stb6100_set_bandwidth: Bandwidth=39700000
[  259.105856] mantis_ack_wait (0): Slave RACK Fail !
[  259.106039] stb6100_get_bandwidth: Bandwidth=-1
[  262.117917] mantis_ack_wait (0): Slave RACK Fail !
[  262.118100] stb6100_set_frequency: Frequency=1068000
[  262.841409] mantis stop feed and dma
[  265.119990] mantis_ack_wait (0): Slave RACK Fail !
[  265.120173] stb6100_get_frequency: Frequency=493128704
[  265.614395] dvb_frontend_ioctl: DVBFE_GET_INFO
[  265.614400] stb0899_get_info: Querying DVB-S info
[  265.715893] newfec_to_oldfec: Unsupported FEC 9
[  265.715898] dvb_frontend_ioctl: FESTATE_RETUNE: fepriv->state=2
[  265.715929] mantis start feed & dma
[  265.716116] stb0899_search: set DVB-S params
[  268.725269] mantis_ack_wait (0): Slave RACK Fail !
[  268.725452] stb6100_set_bandwidth: Bandwidth=51610000
[  271.187024] mantis stop feed and dma
[  271.727343] mantis_ack_wait (0): Slave RACK Fail !
[  271.727526] stb6100_get_bandwidth: Bandwidth=-1
[  271.739040] stb6100_get_bandwidth: Bandwidth=40000000
[  274.747393] mantis_ack_wait (0): Slave RACK Fail !
[  274.747576] stb6100_set_frequency: Frequency=1068000
[  277.749467] mantis_ack_wait (0): Slave RACK Fail !
[  277.749649] stb6100_get_frequency: Frequency=487856768
[  280.755535] mantis_ack_wait (0): Slave RACK Fail !
[  280.755718] stb6100_get_bandwidth: Bandwidth=-32512
[  280.926082] dvb_frontend_ioctl: DVBFE_GET_INFO
[  280.926088] stb0899_get_info: Querying DVB-S info
[  281.027825] newfec_to_oldfec: Unsupported FEC 9
[  281.027831] dvb_frontend_ioctl: FESTATE_RETUNE: fepriv->state=2
[  281.026363] stb0899_search: set DVB-S params
[  281.028754] mantis start feed & dma
[  282.410988] mantis stop feed and dma
[  284.037242] mantis_ack_wait (0): Slave RACK Fail !
[  284.037425] stb6100_set_bandwidth: Bandwidth=51610000
[  287.039315] mantis_ack_wait (0): Slave RACK Fail !
[  287.039497] stb6100_get_bandwidth: Bandwidth=-1
[  287.051012] stb6100_get_bandwidth: Bandwidth=40000000
[  290.059364] mantis_ack_wait (0): Slave RACK Fail !
[  290.059547] stb6100_set_frequency: Frequency=1023000
[  293.061438] mantis_ack_wait (0): Slave RACK Fail !
[  293.061620] stb6100_get_frequency: Frequency=487856768
[  296.067506] mantis_ack_wait (0): Slave RACK Fail !
[  296.067688] stb6100_get_bandwidth: Bandwidth=-32512
[  296.229928] dvb_frontend_ioctl: DVBFE_GET_INFO
[  296.229932] stb0899_get_info: Querying DVB-S2 info
[  296.331851] dvb_frontend_ioctl: FESTATE_RETUNE: fepriv->state=2
[  296.331874] mantis start feed & dma
[  296.332053] stb0899_search: set DVB-S2 params
[  298.388761] mantis stop feed and dma
[  299.341223] mantis_ack_wait (0): Slave RACK Fail !
[  299.341407] stb6100_set_bandwidth: Bandwidth=39700000
[  302.343297] mantis_ack_wait (0): Slave RACK Fail !
[  302.343479] stb6100_get_bandwidth: Bandwidth=-1
[  305.355357] mantis_ack_wait (0): Slave RACK Fail !
[  305.355540] stb6100_set_frequency: Frequency=1023000
[  308.357430] mantis_ack_wait (0): Slave RACK Fail !
[  308.357613] stb6100_get_frequency: Frequency=493128704
[  308.853981] dvb_frontend_ioctl: DVBFE_GET_INFO
[  308.853987] stb0899_get_info: Querying DVB-S info
[  308.955298] newfec_to_oldfec: Unsupported FEC 9
[  308.955302] dvb_frontend_ioctl: FESTATE_RETUNE: fepriv->state=2
[  308.953772] stb0899_search: set DVB-S params
[  308.956175] mantis start feed & dma
[  311.688916] mantis stop feed and dma
[  311.962710] mantis_ack_wait (0): Slave RACK Fail !
[  311.962893] stb6100_set_bandwidth: Bandwidth=51610000
[  314.964783] mantis_ack_wait (0): Slave RACK Fail !
[  314.964966] stb6100_get_bandwidth: Bandwidth=-1
[  314.977227] stb6100_get_bandwidth: Bandwidth=40000000
[  317.984834] mantis_ack_wait (0): Slave RACK Fail !
[  317.985016] stb6100_set_frequency: Frequency=1023000
[  320.986907] mantis_ack_wait (0): Slave RACK Fail !
[  320.987088] stb6100_get_frequency: Frequency=487856768
[  323.992976] mantis_ack_wait (0): Slave RACK Fail !
[  323.993157] stb6100_get_bandwidth: Bandwidth=-32512

HTH,

Tim.


On 23 Feb 2008, at 22:22, Manu Abraham wrote:

> Tim Hewett wrote:
>> Gernot,
>> I have now tried the mantis tree. It also needed the  
>> MANTIS_VP_1041_DVB_S2 #define to be changed to 0x0001 for this  
>> card, but after doing that it was recognised:
>
> Applied the ID's to the mantis tree alongwith some other fixes/ 
> optimizations.
> Please do test the updated mantis tree.
>
>
> Regards,
> Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
