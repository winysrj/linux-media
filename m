Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt3.poste.it ([62.241.4.129])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Nicola.Sabbi@poste.it>) id 1KM1Jf-00067x-73
	for linux-dvb@linuxtv.org; Thu, 24 Jul 2008 15:57:12 +0200
Received: from nico2.od.loc (89.97.249.170) by relay-pt3.poste.it (7.3.122)
	(authenticated as Nicola.Sabbi@poste.it)
	id 4887B871000048E0 for linux-dvb@linuxtv.org;
	Thu, 24 Jul 2008 15:57:07 +0200
From: Nico Sabbi <Nicola.Sabbi@poste.it>
To: linux-dvb@linuxtv.org
Date: Thu, 24 Jul 2008 15:57:06 +0200
References: <48888700.6030105@iinet.net.au>
In-Reply-To: <48888700.6030105@iinet.net.au>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807241557.06705.Nicola.Sabbi@poste.it>
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

On Thursday 24 July 2008 15:43:28 Tim Farrington wrote:
> Hi all,
>
> Got there:
>
> Filetype is MPEG2-TS (generic PES Container)
>
> Need to use mplayer, projectx to ascertain this.
>
> This is what I have just done to achieve an a/v sync perfect,
> edited, recorded dvb file:
>
> 1. Run file through project-x; divides files into *.mp2 (MPEG audio
> stream), *.m2v (video stream),
>    (plus for HDTV *.ac3 (for Dolby Digital aka AC3 stream))
> projectx rec-file.mpeg => rec-file.m2v rec-file.mp2
>
> 2. Run *.mp2 *.m2v through mplex to recombine into PS format
> mplex -f 8 -o rec-file-a.mpeg rec-file.m2v rec-file.mp2 =>
> rec-file-a.mpeg
>
> 3. Edit resultant file with avidemux on I-Frames while retaining
> a/v sync => rec-file-a-a.mpeg
>
> And it produces a perfect new file!
>
> My huge thanks to you all for your assistance.
>
> Regards,
> Tim Farrington


be aware that demuxing the TS in its elementary streams implicitly
drops all timestamps (that are recorded in the PES headers), thus
recombining the audio and video streams will produce a desynchronized
output, unless you are lucky.
There simply aren't enough informations to keep synchrony without
timestamps. With your method if a stream is corrupt
you will likely see a desynchronization from the first breakage
onward, while working on the TS the muxer has a chance to recover

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
