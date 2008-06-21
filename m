Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hond.eatserver.nl ([195.20.9.5])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <joep@groovytunes.nl>) id 1K9z5u-0001Vb-QP
	for linux-dvb@linuxtv.org; Sat, 21 Jun 2008 11:09:17 +0200
Received: from test (82-171-18-31.ip.telfort.nl [82.171.18.31])
	(authenticated bits=0)
	by hond.eatserver.nl (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id
	m5L997Le008929
	for <linux-dvb@linuxtv.org>; Sat, 21 Jun 2008 11:09:08 +0200
From: joep <joep@groovytunes.nl>
To: linux-dvb@linuxtv.org
Date: Sat, 21 Jun 2008 11:13:12 +0200
References: <22711.82.95.219.165.1214001445.squirrel@webmail.xs4all.nl>
In-Reply-To: <22711.82.95.219.165.1214001445.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Message-Id: <200806211113.12675.joep@groovytunes.nl>
Subject: Re: [linux-dvb] s2-3200 fec problem?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1450198460=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1450198460==
Content-Type: multipart/alternative;
  boundary="Boundary-01=_oYMXIRJO5aXU1io"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_oYMXIRJO5aXU1io
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Op Saturday 21 June 2008 00:37:25 schreef Niels Wagenaar:
> > Hello all,
>
> Good evening :)
>
> > -- SNIP --
> > The main issue that I have at the moment is that I can't watch the dutch
> > hdtv
> > channels.
> > astra 23.5, 11778 V 27500 9/10
> > After some testing I did notice that I did not get one channel with fec
> > 9/10
> > to lock.
> > Has anyone got a working transponder with fec 9/10?
>
> I use the S2-3200 myself with the latest multiproto_plus revision
> (compiled it yesterday) in combination with VDR 1.7.0 + HDTV patch. In
> short, I don't have the problems you encounter with the Dutch HDTV
> Channels.
>
> Here's a snip from my channels.conf:
> :->0235-11778__by Linowsat
>
> Discovery
> HD;CANALDIGITAAL:11778:vC910M2O35S1:S23.5E:27500:512:0;80=dut:0:100:7010:3:
>3204:0 NGC
> HD;CANALDIGITAAL:11778:vC910M2O35S1:S23.5E:27500:513:82=dut;83=dut:0:100:70
>15:3:3204:0 VOOM
> HD;CANALDIGITAAL:11778:vC910M2O35S1:S23.5E:27500:514:84=dut:0:100:7020:3:32
>04:0
> BravaHDTV;CANALDIGITAAL:11778:vC910M2O35S1:S23.5E:27500:515:86=dut:0:100:70
>25:3:3204:0 NL1
> HD;CANALDIGITAAL:11778:vC910M2O35S1:S23.5E:27500:516:88=dut:0:100:7030:3:32
>04:0
>
> I know it works for a fact since I watch soccer on NL1 HD ;)
>
> You did patch MythTV for usage with Multiproto, right? I read somewhere
> that you need the SVN-sources of MythTV for getting it working.

Thats great news!
I did patch mythtv-0.21 with this patch:
http://svn.mythtv.org/trac/ticket/5403
I don't have problems with the dvb-s2 channels from astra19,2 with mythtv.

However mythtv and even szap didn't tune to the transponder on astra 23.5
I have to go to a festival today so I will try multiproto_plus and vdr on sunday.
Do you know what the differece is betweed the normal multiproto and the plus version?

Thanks for your reply,
Joep Admiraal

--Boundary-01=_oYMXIRJO5aXU1io
Content-Type: text/html;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

<html><head><meta name="qrichtext" content="1" /></head><body style="font-size:10pt;font-family:Sans Serif">
<p>Op Saturday 21 June 2008 00:37:25 schreef Niels Wagenaar:</p>
<p>&gt; &gt; Hello all,</p>
<p>&gt;</p>
<p>&gt; Good evening :)</p>
<p>&gt;</p>
<p>&gt; &gt; -- SNIP --</p>
<p>&gt; &gt; The main issue that I have at the moment is that I can't watch the dutch</p>
<p>&gt; &gt; hdtv</p>
<p>&gt; &gt; channels.</p>
<p>&gt; &gt; astra 23.5, 11778 V 27500 9/10</p>
<p>&gt; &gt; After some testing I did notice that I did not get one channel with fec</p>
<p>&gt; &gt; 9/10</p>
<p>&gt; &gt; to lock.</p>
<p>&gt; &gt; Has anyone got a working transponder with fec 9/10?</p>
<p>&gt;</p>
<p>&gt; I use the S2-3200 myself with the latest multiproto_plus revision</p>
<p>&gt; (compiled it yesterday) in combination with VDR 1.7.0 + HDTV patch. In</p>
<p>&gt; short, I don't have the problems you encounter with the Dutch HDTV</p>
<p>&gt; Channels.</p>
<p>&gt;</p>
<p>&gt; Here's a snip from my channels.conf:</p>
<p>&gt; :-&gt;0235-11778__by Linowsat</p>
<p>&gt;</p>
<p>&gt; Discovery</p>
<p>&gt; HD;CANALDIGITAAL:11778:vC910M2O35S1:S23.5E:27500:512:0;80=dut:0:100:7010:3:</p>
<p>&gt;3204:0 NGC</p>
<p>&gt; HD;CANALDIGITAAL:11778:vC910M2O35S1:S23.5E:27500:513:82=dut;83=dut:0:100:70</p>
<p>&gt;15:3:3204:0 VOOM</p>
<p>&gt; HD;CANALDIGITAAL:11778:vC910M2O35S1:S23.5E:27500:514:84=dut:0:100:7020:3:32</p>
<p>&gt;04:0</p>
<p>&gt; BravaHDTV;CANALDIGITAAL:11778:vC910M2O35S1:S23.5E:27500:515:86=dut:0:100:70</p>
<p>&gt;25:3:3204:0 NL1</p>
<p>&gt; HD;CANALDIGITAAL:11778:vC910M2O35S1:S23.5E:27500:516:88=dut:0:100:7030:3:32</p>
<p>&gt;04:0</p>
<p>&gt;</p>
<p>&gt; I know it works for a fact since I watch soccer on NL1 HD ;)</p>
<p>&gt;</p>
<p>&gt; You did patch MythTV for usage with Multiproto, right? I read somewhere</p>
<p>&gt; that you need the SVN-sources of MythTV for getting it working.</p>
<p></p>
<p>Thats great news!</p>
<p>I did patch mythtv-0.21 with this patch:</p>
<p>http://svn.mythtv.org/trac/ticket/5403</p>
<p>I don't have problems with the dvb-s2 channels from astra19,2 with mythtv.</p>
<p></p>
<p>However mythtv and even szap didn't tune to the transponder on astra 23.5</p>
<p>I have to go to a festival today so I will try multiproto_plus and vdr on sunday.</p>
<p>Do you know what the differece is betweed the normal multiproto and the plus version?</p>
<p></p>
<p>Thanks for your reply,</p>
<p>Joep Admiraal</p>
<p></p>
</body></html>
--Boundary-01=_oYMXIRJO5aXU1io--


--===============1450198460==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1450198460==--
