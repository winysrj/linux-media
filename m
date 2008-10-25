Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <david.may10@ntlworld.com>) id 1KtkA3-000889-Tu
	for linux-dvb@linuxtv.org; Sat, 25 Oct 2008 16:30:41 +0200
Received: from aamtaout02-winn.ispmail.ntl.com ([81.103.221.35])
	by mtaout02-winn.ispmail.ntl.com
	(InterMail vM.7.05.02.00 201-2174-114-20060621) with ESMTP id
	<20081025143000.YJUE21103.mtaout02-winn.ispmail.ntl.com@aamtaout02-winn.ispmail.ntl.com>
	for <linux-dvb@linuxtv.org>; Sat, 25 Oct 2008 15:30:00 +0100
Received: from video1 ([62.254.12.213]) by aamtaout02-winn.ispmail.ntl.com
	(InterMail vG.2.02.00.01 201-2161-120-102-20060912) with ESMTP
	id <20081025142959.PGEV21638.aamtaout02-winn.ispmail.ntl.com@video1>
	for <linux-dvb@linuxtv.org>; Sat, 25 Oct 2008 15:29:59 +0100
Date: Sat, 25 Oct 2008 15:31:14 +0100
From: david may <david.may10@ntlworld.com>
Message-ID: <954863512.20081025153114@ntlworld.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <20081025170207.492f28bb@bk.ru>
References: <200810251101.11569@centrum.cz> <200810251102.1298@centrum.cz>
	<200810251103.27574@centrum.cz> <200810251103.16869@centrum.cz>
	<20081025103126.5524db0f@pedra.chehab.org>
	<20081025170207.492f28bb@bk.ru>
MIME-Version: 1.0
Subject: Re: [linux-dvb] S2API: Future support for DVB-T2
Reply-To: david may <david.may10@ntlworld.com>
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

Hello Goga777,

Saturday, October 25, 2008, 2:02:07 PM, you wrote:

>> > according to www.dvb.org: DVB-T2 standard was released.
>> > I want to ask there: is S2API ready for this standard? Or it needs some relative big chagnes?
>> 
>> S2API currently doesn't support DVB-T2. However, it were designed in a way that
>> it should be easy to extend to support any standard.

> I'm wondering where is dvb-t2 broadcasting ? is it in h264 ?

> Goga

see:
"http://www.tivocommunity.com/tivo-vb/showthread.php?s=aa1a55bd8c8ae60d668b4501352fea0b&p=6711180#post6711180

"Sneals2000 said: 09-25-2008, 06:07 AM

The BBC are currently running the first proper live tests of DVB-T2 from a real transmitter
(using BBC designed modulators and demodulators) in Guildford.

It is carrying 3x11Mbs H.264 1080/50i HD video streams (using a new Thompson encoder -
and delivering higher quality video than the 16.5Mbs BBC HD on DSat...)
in a 36Mbs DVB-T2 mux (32k carriers and 256QAM rather than 2k/8k carriers and 16/64QAM as
used by DVB-T)

"

its clear we need DVB-T2 ASAP or we in the UK cant see this T2 when
it soon moves off the limited Guildford transmitter and on to the
UK winterhill /NW transmitters later this year.

-- 
Best regards,
 david             


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
