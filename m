Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt3.poste.it ([62.241.4.129])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Nicola.Sabbi@poste.it>) id 1KM1ie-0000CZ-B9
	for linux-dvb@linuxtv.org; Thu, 24 Jul 2008 16:23:06 +0200
Received: from nico2.od.loc (89.97.249.170) by relay-pt3.poste.it (7.3.122)
	(authenticated as Nicola.Sabbi@poste.it)
	id 4887B87100004BD5 for linux-dvb@linuxtv.org;
	Thu, 24 Jul 2008 16:22:26 +0200
From: Nico Sabbi <Nicola.Sabbi@poste.it>
To: linux-dvb@linuxtv.org
Date: Thu, 24 Jul 2008 16:22:25 +0200
References: <48888700.6030105@iinet.net.au>
	<200807241601.14850.Nicola.Sabbi@poste.it>
	<48888E02.60009@iinet.net.au>
In-Reply-To: <48888E02.60009@iinet.net.au>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807241622.25951.Nicola.Sabbi@poste.it>
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

On Thursday 24 July 2008 16:13:22 Tim Farrington wrote:

> Hi Nico,
> Yes I wondered about corrupt streams, so I watched projectx in
> action carefully.
> I need to understand it a bit more, but it found many corrupt
> timestamps while demuxing, and repaired on the run. Time will tell,
> however I have some progress,
> and I can't fault the process yet!
>
> I intend to try all of everybody's suggestions. One question - with
> mencoder why format=dvd?
>
> Regards,
> Timf

because the default is mpeg2, with too many restrictions on the
 muxrate and because sooner or later you will want to burn to dvd.
The muxrate is a bit higher, but who cares? :)
Otherwise you can use -of mpeg -mpegopts format=mpeg2:muxrate=10800
or something like that

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
