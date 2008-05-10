Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1JukEl-0005ZJ-Bq
	for linux-dvb@linuxtv.org; Sat, 10 May 2008 10:15:24 +0200
Received: from wfilter.us4.outblaze.com.int (wfilter.us4.outblaze.com.int
	[192.168.9.180])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	A6015180013C
	for <linux-dvb@linuxtv.org>; Sat, 10 May 2008 08:14:24 +0000 (GMT)
MIME-Version: 1.0
From: stev391@email.com
To: sonofzev@iinet.net.au, linux-dvb@linuxtv.org
Date: Sat, 10 May 2008 18:14:24 +1000
Message-Id: <20080510081424.8288B1CE7C0@ws1-6.us4.outblaze.com>
Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express - When will it
	be
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0719818765=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0719818765==
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_121040726411225"

This is a multi-part message in MIME format.

--_----------=_121040726411225
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

 Allan,

It was tested with in two different machines against the cx23885 version
of the card.  However the next day I built another machine with this card
and I ran into errors in my dmesg stating that the firmware version
doesn't match.  I haven't had enough time to find out why this has
happened, but I think the tuner is not being reset properly.

What are your results of running this patch?

Regards,

Stephen

  ----- Original Message -----
  From: "sonofzev@iinet.net.au"
  To: linux-dvb@linuxtv.org, stev391@email.com
  Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express - When
  will it be
  Date: Thu, 08 May 2008 18:02:00 +0800


  Hi Stephen,

  Has this been tested with the newer cx23885 version of the card or
  only the older cx88 version.
  I have had no success with my cx23885 version.

  cheers

  Allan


  On Tue May 6 11:39 , stev391@email.com sent:

    G'day,

    I was just wondering when Chris Pascoe's code for the DViCO
    Fusion HDTV Dual Express will be merged into the v4l-dvb tree, as
    there have been some minor updates that increase the stability of
    the card that are not in his tree.

    Attached is a patch for merging the relevant sections back into
    the v4l-dvb tree (and including updating Kconfig).  This has been
    successfully tested on two different PCs with this card (working
    with gxine and mythtv, in Melbourne, Australia).

    Regards,
    Stephen.

    -- See Exclusive Video: 10th Annual Young Hollywood Awards

--=20
See Exclusive Video: 10th Annual Young Hollywood Awards
http://www.hollywoodlife.net/younghollywoodawards2008/


--_----------=_121040726411225
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="iso-8859-1"


<div>
Allan,<br><br>It was tested with in two different machines against the cx23=
885 version of the card.&nbsp; However the next day I built another machine=
 with this card and I ran into errors in my dmesg stating that the firmware=
 version doesn't match.&nbsp; I haven't had enough time to find out why thi=
s has happened, but I think the tuner is not being reset properly. <br><br>=
What are your results of running this patch?<br><br>Regards,<br><br>Stephen=
<br>
<br>
<blockquote style=3D"border-left: 2px solid rgb(16, 16, 255); margin-left: =
5px; padding-left: 5px;">----- Original Message -----<br>
From: "sonofzev@iinet.net.au" <sonofzev@iinet.net.au><br>
To: linux-dvb@linuxtv.org, stev391@email.com<br>
Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express - When will i=
t be<br>
Date: Thu, 08 May 2008 18:02:00 +0800<br>
<br>


<br>
Hi Stephen, <br>
<br>
Has this been tested with the newer cx23885 version of the card or only the=
 older cx88 version. <br>
I have had no success with my cx23885 version. <br>
<br>
cheers<br>
<br>
Allan<br>
 <br>
<br>
<span style=3D"font-weight: bold;">On Tue May  6 11:39 , stev391@email.com =
sent:<br>
<br>
</span></sonofzev@iinet.net.au><blockquote style=3D"border-left: 2px solid =
rgb(245, 245, 245); margin-left: 5px; margin-right: 0px; padding-left: 5px;=
 padding-right: 0px;">
<div>

G'day,<br>
<br>
I was just wondering when Chris Pascoe's code for the DViCO Fusion HDTV Dua=
l Express will be merged into the v4l-dvb tree, as there have been some min=
or updates that increase the stability of the card that are not in his tree=
.<br>
<br>
Attached is a patch for merging the relevant sections back into the v4l-dvb=
 tree (and including updating Kconfig).&nbsp; This has been successfully te=
sted on two different PCs with this card (working with gxine and mythtv, in=
 Melbourne, Australia).<br>
<br>
Regards,<br>
Stephen.<br>

<div>

</div>


</div>
<br>


--=20
<div> See Exclusive Video: <a href=3D"http://www.hollywoodlife.net/younghol=
lywoodawards2008/" target=3D"_blank"> <span style=3D"font-weight: bold;"> 1=
0th Annual Young Hollywood Awards</span></a><br>
</div>
</blockquote><br>
</blockquote>
</div>
<BR>

--=20
<div> See Exclusive Video: <a href=3D "http://www.hollywoodlife.net/youngho=
llywoodawards2008/" target=3D"_blank"> <b> 10th Annual Young Hollywood Awar=
ds</b></a><br></div>

--_----------=_121040726411225--



--===============0719818765==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0719818765==--
