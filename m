Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ayden.softclick-it.de ([217.160.202.102])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tobi@to-st.de>) id 1KLz0W-0002jg-4y
	for linux-dvb@linuxtv.org; Thu, 24 Jul 2008 13:29:16 +0200
Message-ID: <48886795.9020105@to-st.de>
Date: Thu, 24 Jul 2008 13:29:25 +0200
From: Tobias Stoeber <tobi@to-st.de>
MIME-Version: 1.0
To: Nico Sabbi <Nicola.Sabbi@poste.it>
References: <488860FE.5020500@iinet.net.au>
	<4888623F.5000108@to-st.de>	<488863EF.8000402@iinet.net.au>
	<200807241326.07492.Nicola.Sabbi@poste.it>
In-Reply-To: <200807241326.07492.Nicola.Sabbi@poste.it>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dvb mpeg2?
Reply-To: tobi@to-st.de
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

Just a short correction to my last mail ...

mplayer -identify -vo null -ao null -frames 0 file.mpg

should be better ;) Doesn't try to display any frames.

Cheers.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
