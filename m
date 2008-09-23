Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.24])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1KiBEd-0006T5-4e
	for linux-dvb@linuxtv.org; Tue, 23 Sep 2008 18:59:37 +0200
Received: by ey-out-2122.google.com with SMTP id 25so593876eya.17
	for <linux-dvb@linuxtv.org>; Tue, 23 Sep 2008 09:59:31 -0700 (PDT)
Date: Tue, 23 Sep 2008 18:59:12 +0200 (CEST)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Hans Werner <HWerner4@gmx.de>
In-Reply-To: <20080923162757.282370@gmx.net>
Message-ID: <alpine.DEB.1.10.0809231848260.26459@ybpnyubfg.ybpnyqbznva>
References: <200809211905.34424.hftom@free.fr> <20080921235429.18440@gmx.net>
	<200809221201.26115.hftom@free.fr> <20080923162757.282370@gmx.net>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] hvr4000-s2api + QAM_AUTO
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

On Tue, 23 Sep 2008, Hans Werner wrote:

> My CPU (3ghz core 2 quad) is fast enough to show live HD video
> [...]   ARTE HD throws some errors and stutters a bit. 

A suggestion:  Write your arte-HD streams to disk, instead of
trying to decode them real-time.

If for some reason your CPU isn't quite fast enough, you can
later decode the arte-HD streams and see if the artifacts you
are observing are still present.

If there's some encoder parameter being used by arte-HD that is
not yet properly supported, then later you should be able to
decode that stream flawlessly (this is the case for me with ITV-HD
recorded before mplayer could properly de-interlace it).

Alternatively, I noticed myself that the occasional recordings I
made for the first couple days of the recent IFA EinsFestival 
showcase showed problems in `mplayer', while those recordings
made later were as flawless as those made half a year ago, so I
do not rule out tweaking of the encoders used...


barry bouwsma
(without access to the DVB-S2 arte-HD stream so far)

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
