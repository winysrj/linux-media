Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from averel.grnet-hq.admin.grnet.gr ([195.251.29.3])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zmousm@admin.grnet.gr>) id 1KAowB-0006SG-Re
	for linux-dvb@linuxtv.org; Mon, 23 Jun 2008 18:30:43 +0200
Message-Id: <DDA4E5EE-7DCC-4EA1-A5A8-622C1A61B945@admin.grnet.gr>
From: Zenon Mousmoulas <zmousm@admin.grnet.gr>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0 (Apple Message framework v924)
Date: Mon, 23 Jun 2008 19:30:32 +0300
Subject: [linux-dvb] Problem "watching" (not tuning to?) Astra HD
	Promo/Anixe HD
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

Hi,

I have a Hauppauge HVR-4000. My system is running the latest Debian  
testing kernel (2.6.24-7) plus drivers from  http://linuxtv.org/hg/v4l-dvb/rev/127f67dea087 
  patched with http://dev.kewl.org/hauppauge/experimental/mfe-s2-7285.diff 
, as per the wiki notes (mostly): http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-4000#Drivers

I have no problem tuning with http://dev.kewl.org/hauppauge/experimental/szap-meow.tgz 
  to any DVB-S or DVB-S2 QPSK/8PSK transponder I have tried. However  
there seems to be a problem with the reception of the Astra HD Promo  
service at 11914500H on Astra1H. I don't know what the problem is  
exactly, since tuning seems to work:

tvbox2:~# szap-meow -r -p -c diseqc2_Astra-19.2E -m 1 -e 9 -o 2 -w 2  
ASTRAHDPROMO
reading channels from file 'diseqc2_Astra-19.2E'
zapping to 1 'ASTRAHDPROMO':
sat 1, frequency = 11914 MHz H, symbolrate 27500000, vpid = 0x04ff,  
apid = 0x0503 sid = 0x0083
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 1f | signal fd40 | snr 6199 | ber 00000000 | unc 00000000 |  
FE_HAS_LOCK
status 1f | signal fe80 | snr 64cd | ber 00000000 | unc 00000000 |  
FE_HAS_LOCK
status 1f | signal fe40 | snr 6333 | ber 00000000 | unc 00000000 |  
FE_HAS_LOCK
status 1f | signal fd80 | snr 6333 | ber 00000000 | unc 00000000 |  
FE_HAS_LOCK
status 1f | signal fe40 | snr 6199 | ber 00000000 | unc 00000000 |  
FE_HAS_LOCK
status 1f | signal fe80 | snr 6000 | ber 00000000 | unc 00000000 |  
FE_HAS_LOCK

There is an occasional ber > 0 and the snr is not exceptional, but  
there are other services with much worse snr/ber that have no problem  
whatsoever.

I don't have vdr, mythtv etc. applications installed on the system. I  
test by redirecting the output of vdr0 to a file, to play back the TS  
later, or by piping to VLC, to stream on the lan. VLC clearly shows  
there is a problem because there is always a flood of messages from  
libdvbpsi on stderr like Bad CRC_32, TS discontinuity, invalid  
section, PSI section too long etc. I'm not that confident about VLC  
debugging, but I know for sure this doesn't happen when the service  
works right.

I've tried tuning to freq 11915 as well as using different values for  
roll-off (-o) and pilot (-w). It doesn't make any difference (-w 1  
doesn't work if I remember right).

The same thing happens with the Anixe HD service, also on the same  
transponder.

I have no problem tuning to other transponders on Astra1H that carry a  
mix of scrambled+FTA or FTA-only services, like 11875500H or  
12051000V, but they are DVB-S. I also have no problem tuning to DVB-S2  
transponders on other LNBs (I have a 4x1 diseqc v1.0 switch with this  
LNB in position AB), but I could not test any other such transponders  
with QPSK modulation.

I'm wondering what could be the cause of this problem:

At first I thought the problem could be that the transponder carries  
scrambled services as well, but that does not seem to be the case.
Then I thought the problem could be the H.264 video payload of the  
video ES of these services, confusing VLC, hence the many error  
messages, but I've been able to stream/play at least one other  
"similar" service (Luxe TV) with no particular problems.

Finally I reconsidered the "saga" of the HVR-4000 driver, and started  
thinking that perhaps I should have gone with one of the other  
implementations in the first place. I had this card setup a few months  
ago with 2.6.24 and multiproto, but I had to redo the installation and  
this time I wanted to try to stick with the official linuxtv.org tree.  
Could this be the reason? If so, however, I suppose tuning wouldn't  
work at all, right?

Am I missing something here? Any ideas/suggestions you may have are  
more than welcome...

Thanks,
Z.

PS: Somewhat off-topic question, but here goes anyway, since I have  
not found a definitive answer: Is there any device with DVB-S2 *and*  
CI and driver support for both? I have noticed that TT-budget S2-3200  
+ CI could possibly be the one, but I believe the CI part still  
doesn't work.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
