Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [213.161.191.158] (helo=patton.snap.tv)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sigmund@snap.tv>) id 1K3u73-00045l-95
	for linux-dvb@linuxtv.org; Wed, 04 Jun 2008 16:37:17 +0200
From: Sigmund Augdal <sigmund@snap.tv>
To: Antti Palosaari <crope@iki.fi>
In-Reply-To: <48469F71.1070904@iki.fi>
References: <1212585271.32385.41.camel@pascal>  <48469F71.1070904@iki.fi>
Date: Wed, 04 Jun 2008 16:37:13 +0200
Message-Id: <1212590233.15236.11.camel@rommel.snap.tv>
Mime-Version: 1.0
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH] experimental support for C-1501
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

ons, 04.06.2008 kl. 16.58 +0300, skrev Antti Palosaari:
> Sigmund Augdal wrote:
> > The following experimental patch adds support for the technotrend budget
> > C-1501 dvb-c card. The parameters used to configure the tda10023 demod
> > chip are largely determined experimentally, but works quite for me in my
> > initial tests.
> 
> You finally found correct values :) I see that it uses same clock 
> settings than Anysee. Also deltaf could be correct because I remember 
> from my tests that it cannot set wrong otherwise it will not work at 
> all. How did you find defltaf?
I guessed the clock settings based on how the same tuner is used by a
different demod. The deltaf value was found by trial and error (helped
by some scripting). deltaf values slightly off will also work, but
tuning will be very slow. I also think the deltaf value will depend on
the bandwidth of the transponder tuned. All transponders I've tested
with are 8MHz, but I think other values are possible, and these will
most likely not work. I submitted the patch anyway in the hope that some
broader testing might help uncover any remaining problems.
> 
> Your patch has at least coding style issues, please run make checkpatch 
> fix errors and resend patch.
I was trying to follow the guidelines, but I guess I wasn't doing that
good enough. Will try to clean that up and resend soon.

regards
Sigmund
> 
> regards
> Antti
> 
> > 
> > Signed-Off-By: Sigmund Augdal <sigmund@snap.tv>
> > 
> > 
> > ------------------------------------------------------------------------
> > 
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
