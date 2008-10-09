Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1Knzft-0004fn-0i
	for linux-dvb@linuxtv.org; Thu, 09 Oct 2008 19:51:47 +0200
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Knzfm-0003jL-Rd
	for linux-dvb@linuxtv.org; Thu, 09 Oct 2008 17:51:38 +0000
Received: from pd953215b.dip0.t-ipconnect.de ([217.83.33.91])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Thu, 09 Oct 2008 17:51:38 +0000
Received: from malte.forkel by pd953215b.dip0.t-ipconnect.de with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Thu, 09 Oct 2008 17:51:38 +0000
To: linux-dvb@linuxtv.org
From: Malte Forkel <malte.forkel@berlin.de>
Date: Thu, 09 Oct 2008 19:51:26 +0200
Message-ID: <gclgb0$m3j$1@ger.gmane.org>
References: <gbofuu$gds$1@ger.gmane.org>
	<alpine.DEB.2.00.0809282207220.6275@ybpnyubfg.ybpnyqbznva>
Mime-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0809282207220.6275@ybpnyubfg.ybpnyqbznva>
Subject: Re: [linux-dvb] Still problems with ttusb_dec / DEC3000-s
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

BOUWSMA Barry schrieb:
> On Sun, 28 Sep 2008, Malte Forkel wrote:
> 
>> I'm trying to get my Hauppauge DEC3000-s working. And I don't seem to be the only one. For an earlier, more accurate account see e.g. http://www.linuxtv.org/pipermail/linux-dvb/2006-April/009259.html. 
> 
> Please, wrap your lines at around 70 characters or less, or
> fix your mailer to do that -- in my quoting of you here, I see

I hope I managed to fix at least that problem :-)

>> I'm trying to get my Hauppauge DEC3000-s working. And I don't seem to be the $
> without re-formatting, and that makes it hard for me to address
> what you write if I've forgotten what it was...
> 
> 
>> errors. But I still can't scan:
>> # scan -x0 -t1 /usr/share/dvb/dvb-s/Astra-19.2E | tee channels.conf
>> scanning /usr/share/dvb/dvb-s/Astra-19.2E
>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>> initial transponder 12551500 V 22000000 5
>>>>> tune to: 12551:v:0:22000
> 
>> Is anybody successfully using a DEC3000-s or can give some advice?
> 
> Yes, I use the DEC3000-s with ``success'', for some values
> of ``success''...
> 
> You are probably running into the problem I had, that it does
> not appear to generate the 22kHz bandswitch tone normally
> needed to tune in what are essentially all interesting
> high-band transponders.
> 
> I used to feed it with the loop-through output of a receiver
> tuned to a horizontal+hi-band transponder to enable me to
> receive what were then all german channels of interest to me.
> 
> I'm now connected via a Multischalter; this somehow permits
> me to tune all bands of four sat positions successfully,
> without help from other hardware.
> 
> If you are experiencing this problem, then you can only
> tune in the transponders below 11700MHz of any satellite
> without help -- and the starting frequency for the NIT
> data you quoted is not in this range.
> 
> You can hand-craft an initial data file with, say, the ARD
> transponder at 10744MHz at 19E2, and see if that gets you
> a few channels (largely spanish).
> 
> If you get this, then your device is ``working'', and I
> would have to ask, for what purpose do you intend to use
> it (which channels do you want to watch/record)?
> 
> In particular, the USB1 bandwidth limitation prevents me
> from using it for other than radio, except for a handful
> of channels (largely commercial/private) with limited
> bandwidth that don't get corrupted by packet-loss -- the
> only german public-service broadcasts not affected are
> Bayern-alpha (you can not hear the AC3 5.1 channel such
> as on the jazz broadcast which just finished, but that is
> a different problem) and Suedwest-Saarland, both of which
> for me require either my multiswitch, or the loop-through
> hack.
> 
> 
> thanks,
> barry bouwsma

I'm sorry for the late replay. I thought, testing the DEC3000-s by
setting up a Windows box shouldn't take that long. Silly me.

First though, I tried to follow your suggestions. I tuned to a channel
with a frequency below the 11700MHz barrier:

# szap -a 0 -c channels_byname.conf arte
reading channels from file 'channels_byname.conf'
zapping to 90 'arte':
sat 0, frequency = 10743 MHz H, symbolrate 22000000, vpid = 0x0191, apid
= 0x0192 sid = 0x7034
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
FE_DISEQC_SEND_BURST failed: Operation not supported
DMX_SET_PES_FILTER failed (PID = 0x0191): 110 Connection timed out
DMX_SET_PES_FILTER failed (PID = 0x0192): 110 Connection timed out
status 1f | signal fffe | snr fffe | ber fffffffe | unc fffffffe |
FE_HAS_LOCK
status 1f | signal fffe | snr fffe | ber fffffffe | unc fffffffe |
FE_HAS_LOCK
status 1f | signal fffe | snr fffe | ber fffffffe | unc fffffffe |
FE_HAS_LOCK
^C

Then, I wrote a new start file

# Astra 19.2E SDT info service transponder
# freq pol sr fec
S 10743800 H 22000000 5/6

and tried scanning with that

# scan -a1 -x0 -t1 Astra-19.2E_low | tee channels.conf
scanning Astra-19.2E_low
using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'
initial transponder 10743800 H 22000000 5
>>> tune to: 10743:h:0:22000
DVB-S IF freq is 993800
0x0000 0x7031: pmt_pid 0x0000 ARD -- EinsExtra (running)
0x0000 0x7032: pmt_pid 0x0000 ARD -- EinsFestival (running)
0x0000 0x7033: pmt_pid 0x0000 ARD -- EinsPlus (running)
0x0000 0x7034: pmt_pid 0x0000 ARD -- arte (running)
0x0000 0x7035: pmt_pid 0x0000 ARD -- Phoenix (running)
Network Name 'ASTRA'
>>> tune to: 12070:h:0:27500
DVB-S IF freq is 1470500
start_filter:1350: ERROR: ioctl DMX_SET_FILTER failed: 110 Connection
timed out
start_filter:1350: ERROR: ioctl DMX_SET_FILTER failed: 110 Connection
timed out
WARNING: filter timeout pid 0x0010
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
>>> tune to: 11797:h:0:27500
DVB-S IF freq is 1197500
start_filter:1350: ERROR: ioctl DMX_SET_FILTER failed: 110 Connection
timed out
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
>>> tune to: 11719:h:0:27500
DVB-S IF freq is 1119500
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
>>> tune to: 12031:h:0:27500
DVB-S IF freq is 1431500
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
>>> tune to: 12460:h:0:27500
DVB-S IF freq is 1860500
start_filter:1350: ERROR: ioctl DMX_SET_FILTER failed: 110 Connection
timed out
start_filter:1350: ERROR: ioctl DMX_SET_FILTER failed: 110 Connection
timed out
start_filter:1350: ERROR: ioctl DMX_SET_FILTER failed: 110 Connection
timed out
^CERROR: interrupted by SIGINT, dumping partial result...
dumping lists (5 services)
Done.

The resulting channels.conf looks like this

EinsExtra:10743:h:0:22000:101:102:28721
EinsFestival:10743:h:0:22000:201:202:28722
EinsPlus:10743:h:0:22000:301:302:28723
arte:10743:h:0:22000:401:402:28724
Phoenix:10743:h:0:22000:501:502:28725

And when I try to tune to one of those channels, I get

# szap -a 1 -c channels.conf arte
reading channels from file 'channels.conf'
zapping to 4 'arte':
sat 0, frequency = 10743 MHz H, symbolrate 22000000, vpid = 0x0191, apid
= 0x0192 sid = 0x7034
using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'
FE_DISEQC_SEND_BURST failed: Operation not supported
status 1f | signal fffe | snr fffe | ber fffffffe | unc fffffffe |
FE_HAS_LOCK
status 1f | signal fffe | snr fffe | ber fffffffe | unc fffffffe |
FE_HAS_LOCK
status 1f | signal fffe | snr fffe | ber fffffffe | unc fffffffe |
FE_HAS_LOCK

With my Windows setup, everything seemed to work fine, though. I
installed Hauppauge dec218c, the latest software I could find, on a
Windows 2000 box. I got a nice picture, despite the USB bottleneck, and
I could tune to any channel, regardless of the 11700MHz frequency barrier.

Doesn't that suggest that the DEC3000-s is ok and that the problems are
caused by a Linux driver bug?

Thanks,
Malte



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
