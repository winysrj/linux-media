Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n7a.bullet.ukl.yahoo.com ([217.146.183.155])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <el_es_cr@yahoo.co.uk>) id 1JUL6H-00013Y-QD
	for linux-dvb@linuxtv.org; Wed, 27 Feb 2008 13:09:29 +0100
Message-ID: <47C552BF.80008@yahoo.co.uk>
Date: Wed, 27 Feb 2008 12:08:31 +0000
From: Lukasz Sokol <el_es_cr@yahoo.co.uk>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Mux multiple live MPEG streams into TS
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

Hello Group,

I'm a newbie here, so please excuse my lameness.

I need to create a TS to be upconverted to DVB-VHF. The thing is, the 
stream will be live TV signal.

I haven't yet tried too much (beside of configuring a TV tuner card) 
because I see I need to learn more, read, digest. Any 
pointers/tips/hints are welcome.

The system itself is to have multiple analog TV tuners (maybe even with 
an MPEG encoders - that would simplify things a lot, right ?) which 
output need to be then muxed and upconverted. The upconverting part is 
not an issue here, because this is solved (with DekTec DTA-115 and 
accompanying software).

The issue is the muxing of MPEG streams into a TS (MPTS?).

I have downloaded the JustDVBIt! from CINECA, and trying to understand 
what it does - it is a carousel server (so they call it) which can 
directly call the upconverter player application, no problem.

Is here anybody who tried this before and can share the experience ? I 
know this list is mainly on DVB receiving (or is it ?) and what I need 
is just the opposite.

I want to try the single MPEG stream first (the problem is I have the 
Hauppauge WinTV card with no MPEG encoder... but this will be single for 
a test purpose, anyway). The card I have here, I can view TV on it so 
the tuner and (what else?) works good.

I was suggested to use VLC to receive the stream (and probably to encode 
it into MPEG too) - somebody could please suggest some failsafe options 
here ?

Right now I am reading the VLC docs (and the JustDVBIt! too) hope I come 
with some good outcome.

One thing I could ask is : what is the most recommended setting for a 
DVB upconverter to use, so it upconverts the TS the way the STBs will be 
able to receive it flawlessly ? I can set everything from the frequency, 
bitrate, till the modulation, constellation and other I forgot right now 
;) Or can I just assume the STBs will be able to receive anything ? How 
does this look like on DVB receiving side ? (I suppose the transmitting 
standard has to be Irish/Britsh DVB-T compliant - which is... ?)

Hope this makes sense for anybody ;)
Like I said, any hints/pointers/links/manpages etc are welcome.

Thanks for your attention :)
-- 
Regards,
Lukasz Sokol


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
