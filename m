Return-path: <mchehab@pedra>
Received: from auth-1.ukservers.net ([217.10.138.154]:41260 "EHLO
	auth-1.ukservers.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759020Ab0JGBwf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 21:52:35 -0400
Message-ID: <075927E995BF46F0AAC3D433821C7D9F@telstraclear.tclad>
From: "Simon Baxter" <linuxtv@nzbaxters.com>
To: <linux-media@vger.kernel.org>, <linux-dvb@linuxtv.org>
References: <4EF44B7309644C7BBF72C458CF8C4F43@telstraclear.tclad>
Subject: Re: dm1105 scan but won't tune? [PROGRESS]
Date: Thu, 7 Oct 2010 14:52:20 +1300
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

OK, progress (idiot error?)

My problem was OptusB1 requires a 45 degree skew on the LNB on the dish 
itself.

So now I can do an szap as follows:
TV3:12456:h:0:22500:512:650:1920

./szap -l 11300 -c channels-conf/dvb-s/OptusD1E160 TV3
reading channels from file 'channels-conf/dvb-s/OptusD1E160'
zapping to 1 'TV3':
sat 0, frequency = 12456 MHz H, symbolrate 22500000, vpid = 0x0200, apid = 
0x028a sid = 0x0780
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal cd82 | snr be5c | ber 0000ff00 | unc fffffffe | 
FE_HAS_LOCK
status 1f | signal cd07 | snr be9e | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
status 1f | signal cd07 | snr be4a | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK


New problem though - I can now no longer scan with the LNB skewed!!
S 12456000 V 22500000 AUTO
S 12456000 H 22500000 AUTO

./scan dvb-s/OptusB1-NZ -l 11300
scanning dvb-s/OptusB1-NZ
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 12456000 V 22500000 9
initial transponder 12456000 H 22500000 9
>>> tune to: 12456:v:0:22500
DVB-S IF freq is 1156000
WARNING: >>> tuning failed!!!
>>> tune to: 12456:v:0:22500 (tuning failed)
DVB-S IF freq is 1156000
WARNING: >>> tuning failed!!!
>>> tune to: 12456:h:0:22500
DVB-S IF freq is 1156000
WARNING: >>> tuning failed!!!
>>> tune to: 12456:h:0:22500 (tuning failed)
DVB-S IF freq is 1156000
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.

Any ideas?
----- Original Message ----- 
From: "Simon Baxter" <linuxtv@nzbaxters.com>
To: <linux-media@vger.kernel.org>
Sent: Sunday, September 26, 2010 9:48 AM
Subject: dm1105 scan but won't tune? (anyone have one of these working?)


>>> Simon Baxter �����:
>>> Hi. I've got a new dm1105 dvb-s card which I can't get to work. I can
>>> scan and get transponders etc, but can't tune or get a front end lock.
>>
>>> I see there's been some work on this - does anyone have one of these
>>> dvb-s cards working?
>>
>>> I've just pulled the latest from
>>> http://mercurial.intuxication.org/hg/s2-liplianin
>>
>>> I can scan and get info:
>>> ./scan dvb-s/OptusB1-NZ -l 11300 -x 0
>>> scanning dvb-s/OptusB1-NZ
>>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>>> initial transponder 12456000 H 22500000 9
>>>>>> tune to: 12456:h:0:22500
>>> DVB-S IF freq is 1156000
>>> <snip>
>>> 0x0000 0x0781: pmt_pid 0x010b TV Works -- C4 (running)
>>> <snip>
>>> C4:12456:h:0:22500:513:651:1921
>>
>>> But I can't get a lock on szap:
>>> ./szap -c channels-conf/dvb-s/OptusD1E160 C4
>>> reading channels from file 'channels-conf/dvb-s/OptusD1E160'
>>> zapping to 2 'C4':
>>> sat 0, frequency = 12456 MHz H, symbolrate 22500000, vpid = 0x0201,
>>> apid = 0x028b sid = 0x0781
>>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>>> status 03 | signal 9ae2 | snr 7170 | ber 0000ff07 | unc fffffffe |
>>> status 03 | signal 9c2a | snr 719a | ber 0000ff05 | unc fffffffe |
>>> status 03 | signal 9b07 | snr 71d9 | ber 0000ff05 | unc fffffffe |
>>> status 03 | signal 9ace | snr 7200 | ber 0000ff05 | unc fffffffe |
>>
>>> Or in VDR -
>>> Sep 23 13:49:45 localhost vdr: [2105] frontend 0/0 timed out while
>>> tuning to channel 1, tp 112456
>>> Sep 23 13:50:06 localhost vdr: [2105] frontend 0/0 timed out while
>>> tuning to channel 16, tp 112483
>>> Sep 23 13:50:26 localhost vdr: [2105] frontend 0/0 timed out while
>>> tuning to channel 1, tp 112456
>>
>>
>>> Although dvbtune says:
>>> ./dvbtune -f 1245600 -s 22500 -p h -m -tone 0 -x
>>> Using DVB card "ST STV0299 DVB-S"
>>> tuning DVB-S to L-Band:3, Pol:H Srate=22500000, 22kHz=off
>>> polling....
>>> Getting frontend event
>>> FE_STATUS:
>>> polling....
>>> Getting frontend event
>>> FE_STATUS: FE_HAS_SIGNAL FE_HAS_CARRIER
>>> polling....
>>> Getting frontend event
>>> FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI
>>> FE_HAS_SYNC
>>> Event: Frequency: 10995803
>>> SymbolRate: 22500000
>>> FEC_inner: 3
>>
>>> Bit error rate: 65285
>>> Signal strength: 53063
>>> SNR: 48522
>>> FE_STATUS: FE_HAS_SIGNAL FE_HAS_LOCK FE_HAS_CARRIER FE_HAS_VITERBI
>>> FE_HAS_SYNC
>>> <?xml version="1.0" encoding="iso-8859-1"?>
>>> <satellite>
>>> <descriptor tag="0x01"
>>> data="4b59204469676974616c20536174656c6c697465205456f3ae000100a9f042413303eb0103ed0103f10103f401040201041101043801043d01044501044c02046002046102046202232983238d8a23f18426ad"
>>> text="KY.Digital.Satellite.TV.......BA3...................8.....E..L.....a..b............"
>>> />
>>> Nothing to read from fd_nit
>>> Scanning 12407000V 30000000
>>> Using DVB card "ST STV0299 DVB-S"
>>> tuning DVB-S to L-Band:774218352, Pol:V Srate=30000000, 22kHz=off
>>> polling....
>>> Getting frontend event
>>> FE_STATUS:
>>> polling....
>>> Getting frontend event
>>> FE_STATUS: FE_HAS_SIGNAL FE_HAS_CARRIER
>>> polling....
>>> polling....
>>
>>
>>> Any suggestions?
>>
>>> _______________________________________________
>>> linux-dvb users mailing list
>>> For V4L/DVB development, please use instead linux-media@xxxxxxxxxxxxxxx
>>> linux-dvb@xxxxxxxxxxx
>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>> Hi,
>>
>> Please, try set parameter card=<number>> at dm1105 module loading.
>>
>> Best reagrds,
>> Vladimir Monchenko.
>
> I've tried:
> modprobe dm1105 card=1
> modprobe dm1105 card=2
> modprobe dm1105 card=3
> modprobe dm1105 card=4
> modprobe dm1105 card=5
> modprobe dm1105 card=6
>
> but still can't tune the front end.  Any ideas?
>
> lspci -vvv has:
> 01:06.0 Ethernet controller: Device 195d:1105 (rev 10)
>        Subsystem: Device 195d:1105
>        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 64 (4000ns min, 8000ns max), Cache Line Size: 4 bytes
>        Interrupt: pin A routed to IRQ 16
>        Region 0: I/O ports at bc00 [size=256]
>        Kernel driver in use: dm1105
>        Kernel modules: dm1105
>
> lsmod:
> rc_dm1105_nec           1199  0
> dm1105                  9896  0
> dvb_core               86607  2 dm1105,stv0299
> ir_core                13013  8 
> rc_dm1105_nec,dm1105,ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,ir_rc5_decoder,ir_nec_decoder
> i2c_core               24507  7 
> dm1105,ds3000,cx24116,dvb_pll,stv0299,nvidia,i2c_nforce2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

