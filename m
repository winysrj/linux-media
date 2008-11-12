Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from out5.smtp.messagingengine.com ([66.111.4.29])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <heldal@eml.cc>) id 1L0Cr7-0003mU-9Y
	for linux-dvb@linuxtv.org; Wed, 12 Nov 2008 11:21:50 +0100
From: Per Heldal <heldal@eml.cc>
To: Goga777 <goga777@bk.ru>
In-Reply-To: <E1L09Ud-000GW2-00.goga777-bk-ru@f149.mail.ru>
References: <20081112023112.94740@gmx.net>
	<E1L09Ud-000GW2-00.goga777-bk-ru@f149.mail.ru>
Date: Wed, 12 Nov 2008 11:21:35 +0100
Message-Id: <1226485295.19990.28.camel@obelix>
Mime-Version: 1.0
Cc: Hans Werner <HWerner4@gmx.de>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] scan-s2: fixes and diseqc rotor support
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

On Wed, 2008-11-12 at 09:46 +0300, Goga777 wrote:
> thanks for your patch.
> 
> btw - could you scan dvb-s2 (qpsk & 8psk) channels with scan-s2 and
> hvr4000 ? with which drivers ?
> 

I seem to be able to scan some transponders, but not all, using current
code from the repos at http://linuxtv.org/hg/v4l-dvb/ and
http://mercurial.intuxication.org/hg/scan-s2 

I run scan-s2 on the following list of HD-transponders on 0.8w :

S 11938000 H 25000000 3/4 35 8PSK
S 12015000 H 30000000 3/4 35 8PSK
S 12130000 H 30000000 3/4 35 8PSK
S 12188000 V 25000000 3/4 35 8PSK

(a selection of transponders from
http://lyngsat.com/packages/canaldigital.html)

With rolloff set to AUTO scan-s2 will not lock to any transponder.
Instead it will appear to repeatedly re-scan sources on any transponder
the tuner previously was tuned to.

With rolloff set to 35 as above scan-s2 will lock and find channels on
both transponders with SR=25000000, but for the 2 in the middle with
SR=30000000 it simply repeats the channel-list of the previous
transponder. I've been playing with alternatives for rolloff and
modulation with no result.



-- 


Per Heldal - http://heldal.eml.cc/


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
