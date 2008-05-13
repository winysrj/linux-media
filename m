Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1Jw4Lg-0001Ng-G0
	for linux-dvb@linuxtv.org; Wed, 14 May 2008 01:56:02 +0200
Received: from wfilter.us4.outblaze.com.int (wfilter.us4.outblaze.com.int
	[192.168.9.180])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	7112E18001A6
	for <linux-dvb@linuxtv.org>; Tue, 13 May 2008 23:55:26 +0000 (GMT)
MIME-Version: 1.0
From: stev391@email.com
To: "allan k" <sonofzev@iinet.net.au>
Date: Wed, 14 May 2008 09:55:26 +1000
Message-Id: <20080513235526.5A85ABE4079@ws1-9.us4.outblaze.com>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express - When will it
	be
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0828457285=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0828457285==
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_121072292632380"

This is a multi-part message in MIME format.

--_----------=_121072292632380
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

 Allan,

lirc support for the remote is not one of priorities as I'm using an iMon
VFD display that includes a remote control that has patches available
against the lirc CVS.

However I can glance at it if I have time and see if I can implement an
appropriate solution.

Stephen

  ----- Original Message -----
  From: "allan k"
  To: stev391@email.com
  Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express - When
  will it be
  Date: Wed, 14 May 2008 09:37:44 +1000


  Also, just wondering if anyone was planning to look at building lirc
  based remote support for the packaged remote (not ir-tty as I don't
  want
  to remap the shortcut keys)
  On Tue, 2008-05-13 at 18:57 +1000, stev391@email.com wrote:
  > Allan,
  >
  > If you have used the v4l-dvb hg drivers and my patch the card
  should
  > auto detect, however if you want to force it, the number should be
  10.
  >
  > If you are using Chris Pascoe's xc-test branch then 5 is the
  correct
  > card number, but again it should auto detect.
  >
  > Please advise which driver source you have been using.
  >
  > Regards Stephen.
  >
  > ----- Original Message -----
  > From: "allan k" To: stev391@email.com
  > Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express
  > - When will it be
  > Date: Tue, 13 May 2008 18:19:27 +1000
  >
  >
  > Hi Steve
  > I had the wrong card number selected. I have changed to card=3D5
  > and the
  > tuner is now working correctly.
  >
  > I haven't restarted the machine, but will do so later and
  > confirm
  > whether I am getting the same problem as you saw on one of
  > your boxes.
  >
  > cheers
  >
  > Allan
  >
  >
  >
  >
  >
  >
  >
  >
  > On Sat, 2008-05-10 at 18:14 +1000, stev391@email.com wrote:
  > > Allan,
  > >
  > > It was tested with in two different machines against the
  > cx23885
  > > version of the card. However the next day I built another
  > machine
  > > with this card and I ran into errors in my dmesg stating
  > that the
  > > firmware version doesn't match. I haven't had enough time to
  > find out
  > > why this has happened, but I think the tuner is not being
  > reset
  > > properly. What are your results of running this patch?
  > >
  > > Regards,
  > >
  > > Stephen
  > >
  > > ----- Original Message -----
  > > From: "sonofzev@iinet.net.au" To: >
  > linux-dvb@linuxtv.org, stev391@email.com
  > > Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual
  > Express
  > > - When will it be
  > > Date: Thu, 08 May 2008 18:02:00 +0800
  > >
  > >
  > > Hi Stephen, Has this been tested with the >
  > newer cx23885 version of the
  > > card or only the older cx88 version. I have had
  > > no success with my cx23885 version. cheers
  > >
  > > Allan
  > >
  > >
  > > On Tue May 6 11:39 , stev391@email.com sent:
  > >
  > > G'day,
  > >
  > > I was just wondering when Chris Pascoe's code for the
  > > DViCO Fusion HDTV Dual Express will be merged into the
  > > v4l-dvb tree, as there have been some minor updates
  > > that increase the stability of the card that are not
  > > in his tree.
  > >
  > > Attached is a patch for merging the relevant sections
  > > back into the v4l-dvb tree (and including updating
  > > Kconfig). This has been successfully tested on two
  > > different PCs with this card (working with gxine and
  > > mythtv, in Melbourne, Australia).
  > >
  > > Regards,
  > > Stephen.
  > >
  > >
  > > -- See Exclusive Video: 10th > Annual Young Hollywood
  > > Awards
  > >
  > >
  > >
  > > -- See Exclusive Video: 10th Annual Young Hollywood Awards
  > >
  >
  > -- See Exclusive Video: 10th Annual Young Hollywood Awards
  >

--=20
See Exclusive Video: 10th Annual Young Hollywood Awards
http://www.hollywoodlife.net/younghollywoodawards2008/


--_----------=_121072292632380
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="iso-8859-1"


<div>
Allan,<br><br>lirc support for the remote is not one of priorities as I'm u=
sing an iMon VFD display that includes a remote control that has patches av=
ailable against the lirc CVS.<br><br>However I can glance at it if I have t=
ime and see if I can implement an appropriate solution.<br><br>Stephen<br>
<br>
<blockquote style=3D"border-left: 2px solid rgb(16, 16, 255); margin-left: =
5px; padding-left: 5px;">----- Original Message -----<br>
From: "allan k" <sonofzev@iinet.net.au><br>
To: stev391@email.com<br>
Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express - When will	i=
t be<br>
Date: Wed, 14 May 2008 09:37:44 +1000<br>
<br>
<br>
Also, just wondering if anyone was planning to look at building lirc<br>
based remote support for the packaged remote (not ir-tty as I don't want<br>
to remap the shortcut keys)<br>
On Tue, 2008-05-13 at 18:57 +1000, stev391@email.com wrote:<br>
&gt; Allan,<br>
&gt;<br>
&gt; If you have used the v4l-dvb hg drivers and my patch the card should<b=
r>
&gt; auto detect, however if you want to force it, the number should be 10.=
<br>
&gt;<br>
&gt; If you are using Chris Pascoe's xc-test branch then 5 is the correct<b=
r>
&gt; card number, but again it should auto detect.<br>
&gt;<br>
&gt; Please advise which driver source you have been using.<br>
&gt;<br>
&gt; Regards Stephen.<br>
&gt;<br>
&gt;         ----- Original Message -----<br>
&gt;         From: "allan k"         To: stev391@email.com<br>
&gt;         Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express<=
br>
&gt;         - When will it be<br>
&gt;         Date: Tue, 13 May 2008 18:19:27 +1000<br>
&gt;<br>
&gt;<br>
&gt;         Hi Steve<br>
&gt;         I had the wrong card number selected. I have changed to card=
=3D5<br>
&gt;         and the<br>
&gt;         tuner is now working correctly.<br>
&gt;<br>
&gt;         I haven't restarted the machine, but will do so later and<br>
&gt;         confirm<br>
&gt;         whether I am getting the same problem as you saw on one of<br>
&gt;         your boxes.<br>
&gt;<br>
&gt;         cheers<br>
&gt;<br>
&gt;         Allan<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;         On Sat, 2008-05-10 at 18:14 +1000, stev391@email.com wrote:<br>
&gt;         &gt; Allan,<br>
&gt;         &gt;<br>
&gt;         &gt; It was tested with in two different machines against the<=
br>
&gt;         cx23885<br>
&gt;         &gt; version of the card. However the next day I built another=
<br>
&gt;         machine<br>
&gt;         &gt; with this card and I ran into errors in my dmesg stating<=
br>
&gt;         that the<br>
&gt;         &gt; firmware version doesn't match. I haven't had enough time=
 to<br>
&gt;         find out<br>
&gt;         &gt; why this has happened, but I think the tuner is not being=
<br>
&gt;         reset<br>
&gt;         &gt; properly. What are your results of running this patch?<br>
&gt;         &gt;<br>
&gt;         &gt; Regards,<br>
&gt;         &gt;<br>
&gt;         &gt; Stephen<br>
&gt;         &gt;<br>
&gt;         &gt; ----- Original Message -----<br>
&gt;         &gt; From: "sonofzev@iinet.net.au" To:         &gt; <br>
&gt; linux-dvb@linuxtv.org, stev391@email.com<br>
&gt;         &gt; Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual<br>
&gt;         Express<br>
&gt;         &gt; - When will it be<br>
&gt;         &gt; Date: Thu, 08 May 2008 18:02:00 +0800<br>
&gt;         &gt;<br>
&gt;         &gt;<br>
&gt;         &gt; Hi Stephen, Has this been tested with the         &gt; <b=
r>
&gt; newer cx23885 version of the<br>
&gt;         &gt; card or only the older cx88 version. I have had         <=
br>
&gt; &gt; no success with my cx23885 version. cheers<br>
&gt;         &gt;<br>
&gt;         &gt; Allan<br>
&gt;         &gt;<br>
&gt;         &gt;<br>
&gt;         &gt; On Tue May 6 11:39 , stev391@email.com sent:<br>
&gt;         &gt;<br>
&gt;         &gt; G'day,<br>
&gt;         &gt;<br>
&gt;         &gt; I was just wondering when Chris Pascoe's code for the<br>
&gt;         &gt; DViCO Fusion HDTV Dual Express will be merged into the<br>
&gt;         &gt; v4l-dvb tree, as there have been some minor updates<br>
&gt;         &gt; that increase the stability of the card that are not<br>
&gt;         &gt; in his tree.<br>
&gt;         &gt;<br>
&gt;         &gt; Attached is a patch for merging the relevant sections<br>
&gt;         &gt; back into the v4l-dvb tree (and including updating<br>
&gt;         &gt; Kconfig). This has been successfully tested on two<br>
&gt;         &gt; different PCs with this card (working with gxine and<br>
&gt;         &gt; mythtv, in Melbourne, Australia).<br>
&gt;         &gt;<br>
&gt;         &gt; Regards,<br>
&gt;         &gt; Stephen.<br>
&gt;         &gt;<br>
&gt;         &gt;<br>
&gt;         &gt; -- See Exclusive Video: 10th         &gt; Annual Young Ho=
llywood<br>
&gt;         &gt; Awards<br>
&gt;         &gt;<br>
&gt;         &gt;<br>
&gt;         &gt;<br>
&gt;         &gt; -- See Exclusive Video: 10th Annual Young Hollywood Award=
s<br>
&gt;         &gt;<br>
&gt;<br>
&gt; -- See Exclusive Video: 10th Annual Young Hollywood Awards<br>
&gt;<br>
</sonofzev@iinet.net.au></blockquote>
</div>
<BR>

--=20
<div> See Exclusive Video: <a href=3D "http://www.hollywoodlife.net/youngho=
llywoodawards2008/" target=3D"_blank"> <b> 10th Annual Young Hollywood Awar=
ds</b></a><br></div>

--_----------=_121072292632380--



--===============0828457285==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0828457285==--
