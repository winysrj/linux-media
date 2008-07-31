Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <psofa.psofa@gmail.com>) id 1KOgYf-0004tX-HB
	for linux-dvb@linuxtv.org; Fri, 01 Aug 2008 00:23:42 +0200
Received: by yw-out-2324.google.com with SMTP id 3so361459ywj.41
	for <linux-dvb@linuxtv.org>; Thu, 31 Jul 2008 15:23:37 -0700 (PDT)
Message-ID: <8e485a510807311523o225e174ap47be04914d886402@mail.gmail.com>
Date: Fri, 1 Aug 2008 01:23:37 +0300
From: psofa <psofa.psofa@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Skystar HD locking problems
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

Is anyone using the multiproto drivers located here
http://jusst.de/hg/multiproto/ with a skystar hd (not just tt3200)
successfully?The skystar hd is supposed to be a clone of TT-3200.In
the TT-3200 threads most people state that their tuning problems are
mostly gone.However i don't see any improvement in mine (in fact if i
had to guess id say they are worse).I still need to add 4-5Mhz to get
a lock with simpledvbtune which I'm not willing to do to my vdr
channels list.
Here is an example on astra 19E:
Mythbox dvb # ./simpledvbtune -n 0 -f 11954
using '/dev/dvb/adapter0/frontend0' as frontend
frontend fd=3: type=0
ioclt: FE_SET_VOLTAGE : 1
High band
tone: 1
dvbfe setparams :  delsys=1 1354MHz / Rate : 27500kBPS
Status: 1e: Carrier Viterbi Sync Lock
SNR: 0 62 (0x3e) (6.2dB)
BER: 0 0 0 0 (0x0)
Signal: 222 173 (0xdead) -8531 (5700.5dBm)
Frontend: f=1351.805

Status: 00:
SNR: 222 173 (0xdead) (5700.5dB)
BER: 0 0 0 0 (0x0)
Signal: 222 173 (0xdead) -8531 (5700.5dBm)
Frontend: f=1351.805

Status: 00:
SNR: 222 173 (0xdead) (5700.5dB)
BER: 0 0 0 0 (0x0)
Signal: 222 173 (0xdead) -8531 (5700.5dBm)
Frontend: f=1351.805

Status: 00:
SNR: 222 173 (0xdead) (5700.5dB)
BER: 0 0 0 0 (0x0)
Signal: 222 173 (0xdead) -8531 (5700.5dBm)
Frontend: f=1351.805

Another with +4mhz:
Mythbox dvb # ./simpledvbtune -n 0 -f 11958
using '/dev/dvb/adapter0/frontend0' as frontend
frontend fd=3: type=0
ioclt: FE_SET_VOLTAGE : 1
High band
tone: 1
dvbfe setparams :  delsys=1 1358MHz / Rate : 27500kBPS
Status: 1e: Carrier Viterbi Sync Lock
SNR: 0 33 (0x21) (3.3dB)
BER: 0 0 0 0 (0x0)
Signal: 0 193 (0xc1) 193 (19.3dBm)
Frontend: f=1351.897

Status: 1e: Carrier Viterbi Sync Lock
SNR: 0 33 (0x21) (3.3dB)
BER: 0 0 0 0 (0x0)
Signal: 0 195 (0xc3) 195 (19.5dBm)
Frontend: f=1351.897

The strange part is that in the correct mhz version the frontend
immediately locks but then looses this lock.This happens with other
frequencies i tried as well.
So considering that the tt-3200 users are having little tuning
problems since the last changes , is the skystar hd hardware any
different from the tt3200?

Also, does anyone know the status of the driver's dev?Since all i see
lately in the commits is some one liners plus the dev doesn't
participate in the corresponding threads, the chances of fixing this
don't seem very high.I'm thinking of trying my luck with another card
(hvr4000)...

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
