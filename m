Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt3.poste.it ([62.241.4.129])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Nicola.Sabbi@poste.it>) id 1KM05h-0001sB-SH
	for linux-dvb@linuxtv.org; Thu, 24 Jul 2008 14:38:43 +0200
Received: from nico2.od.loc (89.97.249.170) by relay-pt3.poste.it (7.3.122)
	(authenticated as Nicola.Sabbi@poste.it)
	id 4887B87100003FAE for linux-dvb@linuxtv.org;
	Thu, 24 Jul 2008 14:38:38 +0200
From: Nico Sabbi <Nicola.Sabbi@poste.it>
To: linux-dvb@linuxtv.org
Date: Thu, 24 Jul 2008 14:38:34 +0200
References: <488860FE.5020500@iinet.net.au>
	<200807241326.07492.Nicola.Sabbi@poste.it>
	<48886F49.8030206@iinet.net.au>
In-Reply-To: <48886F49.8030206@iinet.net.au>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807241438.34330.Nicola.Sabbi@poste.it>
Subject: Re: [linux-dvb] dvb mpeg2?
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

On Thursday 24 July 2008 14:02:17 you wrote:

>
> Hi Nico,
> I was a huge fan of avidemux until about 2 hours ago when I
> discovered that editing a file caused all sorts of grief with a/v
> sync. Its doc's tell me to send the file through Projectx first,
> etc

avidemux is still the way to go: in order to fix the synchrony just
run mplayer on the file beforehand taking notice of the value of
"rc" on the status line when the delay between audio and video
drops to 0, then insert that value in the delay field of avidemux
(-N)

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
