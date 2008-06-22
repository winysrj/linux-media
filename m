Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hond.eatserver.nl ([195.20.9.5])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <joep@groovytunes.nl>) id 1KAN7k-0003zg-SO
	for linux-dvb@linuxtv.org; Sun, 22 Jun 2008 12:48:56 +0200
Received: from test (82-171-18-31.ip.telfort.nl [82.171.18.31])
	(authenticated bits=0)
	by hond.eatserver.nl (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id
	m5MAmeLe017518
	for <linux-dvb@linuxtv.org>; Sun, 22 Jun 2008 12:48:40 +0200
From: joep <joep@groovytunes.nl>
To: linux-dvb@linuxtv.org
Date: Sun, 22 Jun 2008 12:52:47 +0200
References: <18643.82.95.219.165.1214055480.squirrel@webmail.xs4all.nl>
In-Reply-To: <18643.82.95.219.165.1214055480.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Message-Id: <200806221252.47503.joep@groovytunes.nl>
Subject: Re: [linux-dvb] s2-3200 fec problem?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0560024332=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0560024332==
Content-Type: multipart/alternative;
  boundary="Boundary-01=_/7iXI/gTl4x8dmC"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_/7iXI/gTl4x8dmC
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Op Saturday 21 June 2008 15:38:00 schreef Niels Wagenaar:
> > -- SNIP --
> >
> > Thats great news!
> > I did patch mythtv-0.21 with this patch:
> > http://svn.mythtv.org/trac/ticket/5403
> > I don't have problems with the dvb-s2 channels from astra19,2 with
> > mythtv.
>
> I know the following (Swedish, but we all speak code!) guide seems to work:
>
> http://www.minhembio.com/forum/index.php?s=344f35e74353fb173446a5c7d3250854
>&showtopic=172770&st=30&start=30
>
> > However mythtv and even szap didn't tune to the transponder on astra 23.5
> > I have to go to a festival today so I will try multiproto_plus and vdr on
> > sunday.
>
> If you do, be sure to follow this guide (it's for Ubuntu but you get the
> information on how to get it working)
>
> http://www.kipdola.com/skerit/?language=nl
>
> > Do you know what the differece is betweed the normal multiproto and the
> > plus version?
>
> It's a combine of multiproto and the mantis or v4l tree if I've got it
> right. The last revisions of multiproto didn't seem to work for me (a lot
> of lock problems on DVB-S2 transponders with H264 channles). I have to use
> the revisions from March to get it working.

Can you give me the exact version or date of the revision which you are using?
Just to be shure I do my tests on the same version as you are.
--Boundary-01=_/7iXI/gTl4x8dmC
Content-Type: text/html;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

<html><head><meta name="qrichtext" content="1" /></head><body style="font-size:10pt;font-family:Sans Serif">
<p>Op Saturday 21 June 2008 15:38:00 schreef Niels Wagenaar:</p>
<p><span style="color:#007000">&gt; &gt; -- SNIP --</span></p>
<p><span style="color:#007000">&gt; &gt;</span></p>
<p><span style="color:#007000">&gt; &gt; Thats great news!</span></p>
<p><span style="color:#007000">&gt; &gt; I did patch mythtv-0.21 with this patch:</span></p>
<p><span style="color:#007000">&gt; &gt; http://svn.mythtv.org/trac/ticket/5403</span></p>
<p><span style="color:#007000">&gt; &gt; I don't have problems with the dvb-s2 channels from astra19,2 with</span></p>
<p><span style="color:#007000">&gt; &gt; mythtv.</span></p>
<p><span style="color:#008000">&gt;</span></p>
<p><span style="color:#008000">&gt; I know the following (Swedish, but we all speak code!) guide seems to work:</span></p>
<p><span style="color:#008000">&gt;</span></p>
<p><span style="color:#008000">&gt; http://www.minhembio.com/forum/index.php?s=344f35e74353fb173446a5c7d3250854</span></p>
<p><span style="color:#008000">&gt;&amp;showtopic=172770&amp;st=30&amp;start=30</span></p>
<p><span style="color:#008000">&gt;</span></p>
<p><span style="color:#007000">&gt; &gt; However mythtv and even szap didn't tune to the transponder on astra 23.5</span></p>
<p><span style="color:#007000">&gt; &gt; I have to go to a festival today so I will try multiproto_plus and vdr on</span></p>
<p><span style="color:#007000">&gt; &gt; sunday.</span></p>
<p><span style="color:#008000">&gt;</span></p>
<p><span style="color:#008000">&gt; If you do, be sure to follow this guide (it's for Ubuntu but you get the</span></p>
<p><span style="color:#008000">&gt; information on how to get it working)</span></p>
<p><span style="color:#008000">&gt;</span></p>
<p><span style="color:#008000">&gt; http://www.kipdola.com/skerit/?language=nl</span></p>
<p><span style="color:#008000">&gt;</span></p>
<p><span style="color:#007000">&gt; &gt; Do you know what the differece is betweed the normal multiproto and the</span></p>
<p><span style="color:#007000">&gt; &gt; plus version?</span></p>
<p><span style="color:#008000">&gt;</span></p>
<p><span style="color:#008000">&gt; It's a combine of multiproto and the mantis or v4l tree if I've got it</span></p>
<p><span style="color:#008000">&gt; right. The last revisions of multiproto didn't seem to work for me (a lot</span></p>
<p><span style="color:#008000">&gt; of lock problems on DVB-S2 transponders with H264 channles). I have to use</span></p>
<p><span style="color:#008000">&gt; the revisions from March to get it working.</span></p>
<p></p>
<p>Can you give me the exact version or date of the revision which you are using?</p>
<p>Just to be shure I do my tests on the same version as you are.</p>
</body></html>
--Boundary-01=_/7iXI/gTl4x8dmC--


--===============0560024332==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0560024332==--
