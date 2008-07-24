Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt1.poste.it ([62.241.4.164])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Nicola.Sabbi@poste.it>) id 1KM1Nf-0006lN-05
	for linux-dvb@linuxtv.org; Thu, 24 Jul 2008 16:01:19 +0200
Received: from nico2.od.loc (89.97.249.170) by relay-pt1.poste.it (7.3.122)
	(authenticated as Nicola.Sabbi@poste.it)
	id 4887C68100005B19 for linux-dvb@linuxtv.org;
	Thu, 24 Jul 2008 16:01:15 +0200
From: Nico Sabbi <Nicola.Sabbi@poste.it>
To: linux-dvb@linuxtv.org
Date: Thu, 24 Jul 2008 16:01:14 +0200
References: <48888700.6030105@iinet.net.au>
	<200807241557.06705.Nicola.Sabbi@poste.it>
In-Reply-To: <200807241557.06705.Nicola.Sabbi@poste.it>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807241601.14850.Nicola.Sabbi@poste.it>
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

On Thursday 24 July 2008 15:57:06 Nico Sabbi wrote:

>
> be aware that demuxing the TS in its elementary streams implicitly
> drops all timestamps (that are recorded in the PES headers), thus
> recombining the audio and video streams will produce a
> desynchronized output, unless you are lucky.
> There simply aren't enough informations to keep synchrony without
> timestamps. With your method if a stream is corrupt
> you will likely see a desynchronization from the first breakage
> onward, while working on the TS the muxer has a chance to recover
>

BTW, although mencoder is broken in countless respects,
generating an mpeg-ps is quite safe:

$ mencoder -demuxer lavf -of mpeg -mpegopts format=dvd -oac copy -ovc 
copy -o output.mpg input.ts 

eventually dropping -demuxer lavf if it doesn't work (lavf's demuxer
isn't nearly as permissive as my native TS demuxer (the default one)
but it has an advantage: strictly correct timestamps on all frames)

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
