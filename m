Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from balanced.mail.policyd.dreamhost.com ([208.97.132.119]
	helo=spunkymail-a19.g.dreamhost.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@dawes.za.net>) id 1JvYbP-00034Q-SH
	for linux-dvb@linuxtv.org; Mon, 12 May 2008 16:02:12 +0200
Message-ID: <48284D8B.4050909@dawes.za.net>
Date: Mon, 12 May 2008 16:00:43 +0200
From: Rogan Dawes <lists@dawes.za.net>
MIME-Version: 1.0
To: Patrick Boettcher <patrick.boettcher@desy.de>
References: <48281E7A.8010006@dawes.za.net>	<Pine.LNX.4.64.0805121254410.11078@pub3.ifh.de>	<48282843.6010906@dawes.za.net>	<Pine.LNX.4.64.0805121418530.11078@pub3.ifh.de>
	<48283D17.3060303@dawes.za.net>
In-Reply-To: <48283D17.3060303@dawes.za.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-T South Africa
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

Rogan Dawes wrote:
> Patrick Boettcher wrote:
>> Hi,
>>
>> I'm now 100% sure that this is a DVB-H transport stream.
>>
>> the appearing/disappearing TS-PIDs in the dvbtraffic are indicating that 
>> timeslicing is active.
>>
>> The dvbsnoop clearly says that there are only MPE-sections which is 
>> another indicator for that.
>>
>> I will commit my two little, proof-of-concept-like, tools soon and tell 
>> you where to find and how to try it.
>>
>> Patrick.
>>
> 
> Great! Thanks for your help.
> 
> I look forward to trying your code out, and seeing if I can actually get 
> anything from these streams.
> 
> Rogan
> 

So I ran w_scan again, with more conservative options, and actualy 
picked up the channels that are being broadcast via DVB-T on 770MHz. In 
case anyone cares:

S-a-b-c 
1(SABC):770000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:85:83:61
S-a-b-c 
2(SABC):770000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:260:34:62
S-a-b-c 
3(SABC):770000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:65:89:63
eTV(ETV):770000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:272:273:105

Unfortunately, VLC jumps all over the place (window resizing, mostly), 
and shows a pretty garbled signal. It is visually recognizable as a TV 
broadcast, though. Eventually, though, VLC just dumps core with a 
segmentation fault.

I guess this is related to a weak/corrupted signal, although the ber 
showing up while running tzap seemed reasonable:

rogan@athena:~/w_scan-20080105$ tzap "eTV(ETV)"
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
tuning to 770000000 Hz
video pid 0x0110, audio pid 0x0111
status 00 | signal 9393 | snr 4646 | ber 0001fffe | unc 00000000 |
status 1f | signal 9494 | snr f5f5 | ber 0000f4c8 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9393 | snr f9f9 | ber 0000fc64 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9393 | snr f8f8 | ber 000100ce | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9393 | snr f9f9 | ber 0001083e | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9393 | snr f9f9 | ber 00011630 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f5f5 | ber 000131be | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f5f5 | ber 000115ca | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9191 | snr f8f8 | ber 00013590 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f9f9 | ber 0001188a | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9393 | snr f8f8 | ber 0001074e | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9393 | snr f9f9 | ber 0001030e | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9393 | snr f5f5 | ber 00010b5a | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9393 | snr f6f6 | ber 0000fe42 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9393 | snr f6f6 | ber 00010196 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f8f8 | ber 0001236c | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f8f8 | ber 00011d80 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f8f8 | ber 0001213c | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f8f8 | ber 00011a4e | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f5f5 | ber 0001244c | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f5f5 | ber 00011a2e | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f8f8 | ber 00012650 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f8f8 | ber 00013684 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9191 | snr f8f8 | ber 00012bb0 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f8f8 | ber 00012082 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9191 | snr f5f5 | ber 00011ea6 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f5f5 | ber 0001251a | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f5f5 | ber 00011292 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f5f5 | ber 0001132e | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f8f8 | ber 00011f66 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9191 | snr f7f7 | ber 00012310 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9393 | snr f8f8 | ber 00010cb2 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f8f8 | ber 00010ec2 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f9f9 | ber 00011a10 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f4f4 | ber 00013166 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f5f5 | ber 00011f96 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f8f8 | ber 00012c24 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f8f8 | ber 000119e6 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f8f8 | ber 00011a2a | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9393 | snr f8f8 | ber 00011ea4 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f5f5 | ber 00011bc8 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f5f5 | ber 00010af0 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9191 | snr f9f9 | ber 00012ae6 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f8f8 | ber 00011f40 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f8f8 | ber 00011de8 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9393 | snr f0f0 | ber 00013958 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9393 | snr acac | ber 0001fffe | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9393 | snr e5e5 | ber 0001fffe | unc ffffffff | 
FE_HAS_LOCK
status 00 | signal 9191 | snr 6c6c | ber 0001fffe | unc 00000000 |
status 1f | signal 9292 | snr e6e6 | ber 0001fffe | unc ffffffff | 
FE_HAS_LOCK
status 01 | signal 9292 | snr 2525 | ber 0001fffe | unc ffffffff |
status 1f | signal 9191 | snr e1e1 | ber 0001fffe | unc ffffffff | 
FE_HAS_LOCK
status 00 | signal 9191 | snr 3a3a | ber 0001fffe | unc 00000000 |
status 1f | signal 9191 | snr f7f7 | ber 00012c98 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9191 | snr f8f8 | ber 00012cd0 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9191 | snr f8f8 | ber 00011012 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9191 | snr f4f4 | ber 00011c16 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9191 | snr f7f7 | ber 00012550 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9191 | snr f8f8 | ber 00011d94 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9191 | snr f7f7 | ber 00011bfe | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f8f8 | ber 00011ac8 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9191 | snr f7f7 | ber 00012ba2 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9191 | snr f4f4 | ber 00011cbc | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f8f8 | ber 0001140a | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9191 | snr f6f6 | ber 00012264 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f6f6 | ber 0001229a | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9191 | snr f7f7 | ber 00011c34 | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f7f7 | ber 0000fbdc | unc ffffffff | 
FE_HAS_LOCK
status 1f | signal 9292 | snr f3f3 | ber 00016966 | unc ffffffff | 
FE_HAS_LOCK

I guess I'll need to get a better DVB antenna.

Rogan

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
