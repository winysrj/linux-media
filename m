Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bobrnet.cust.inethome.cz ([88.146.180.6]
	helo=mailserver.bobrnet.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <pavel.hofman@insite.cz>) id 1L9LDD-0002sy-Jc
	for linux-dvb@linuxtv.org; Sun, 07 Dec 2008 16:06:24 +0100
Message-ID: <493BE666.8030007@insite.cz>
Date: Sun, 07 Dec 2008 16:06:14 +0100
From: Pavel Hofman <pavel.hofman@insite.cz>
MIME-Version: 1.0
To: Alex Betis <alex.betis@gmail.com>
References: <49346726.7010303@insite.cz>
	<4934D218.4090202@verbraak.org>		<4935B72F.1000505@insite.cz>		<c74595dc0812022332s2ef51d1cn907cbe5e4486f496@mail.gmail.com>	<c74595dc0812022347j37e83279mad4f00354ae0e611@mail.gmail.com>
	<49371511.1060703@insite.cz>
In-Reply-To: <49371511.1060703@insite.cz>
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

Pavel Hofman napsal(a):
> Alex Betis napsal(a):
>> On Wed, Dec 3, 2008 at 9:32 AM, Alex Betis <alex.betis@gmail.com 
>> <mailto:alex.betis@gmail.com>> wrote:
>>
>>
>>     On Wed, Dec 3, 2008 at 12:31 AM, Pavel Hofman
>>     <pavel.hofman@insite.cz <mailto:pavel.hofman@insite.cz>> wrote:
>>
>>         pavel@htpc:~/project/satelit2/szap-s2$
>>         <mailto:pavel@htpc:~/project/satelit2/szap-s2$> ./szap-s2 -x
>>         EinsFestival
>>         reading channels from file '/home/pavel/.szap/channels.conf'
>>         zapping to 5 'EinsFestival':
>>         delivery DVB-S, modulation QPSK
>>         sat 0, frequency 12110 MHz H, symbolrate 27500000, coderate auto,
>>
>>     I don't think there is 12110 channel on Astra 19.2, at least not
>>     accirding to lyngsat.
>>
>> My bad, there is such channel... I somehow got to Astra 1G only page 
>> instead of all Atras in that position.
>> Try other frequencies anyway.
>>  
>> Maybe you have diseqc problems?
>>
> 


Hi,

Partial success :)

I added a few free-to-air channels I was able to tune in WinXP to 
channels.conf:

Entertainment:12012:v:0:27500:2582:2581:8037
SkyNews:12207:v:0:27500:514:645:4707
WineTV:11555:h:1:27500:2372:2374:50435
AvaTest:11555:h:1:27500:2329:2330:50446
Vegas:11515:h:1:27500:3568:3567:8035
Faith:11515:h:1:27500:2375:2376:50455


The first two on LNB0, the rest on LNB1.

For LNB0, I can tune via szap2:

pavel@htpc:~/project/satelit2/szap-s2$ ./szap-s2 -r SkyNews
reading channels from file '/home/pavel/.szap/channels.conf'
zapping to 2 'SkyNews':
delivery DVB-S, modulation QPSK
sat 0, frequency 12207 MHz V, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x0202, apid 0x0285, sid 0x1263
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 0136 | snr 002d | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
status 1f | signal 0136 | snr 0031 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK

and view the channels with

mplayer - < /dev/dvb/adapter0/dvr0

For LNB1, it seems I can get signal via szap2:

pavel@htpc:~/project/satelit2/szap-s2$ ./szap-s2 -r Faith
reading channels from file '/home/pavel/.szap/channels.conf'
zapping to 6 'Faith':
delivery DVB-S, modulation QPSK
sat 1, frequency 11515 MHz H, symbolrate 27500000, coderate auto, 
rolloff 0.35
vpid 0x0947, apid 0x0948, sid 0xc517
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal 0178 | snr 0051 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
status 1f | signal 0178 | snr 0051 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
status 1f | signal 0178 | snr 0050 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK


However, /dev/dvb/adapter0/dvr0 outputs no data for any of the stations 
on the second LNB1.


Perhaps it is correct and the channels I checked broadcast no stream at 
this time. Since scan2 keeps failing, please is there a place to 
download recent channels.conf for Astra 19.2E so that I can test on many 
more channels?

Thanks a lot,

Pavel.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
