Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1K0EQ1-00019T-55
	for linux-dvb@linuxtv.org; Sun, 25 May 2008 13:29:46 +0200
Received: from wfilter.us4.outblaze.com.int (wfilter.us4.outblaze.com.int
	[192.168.9.180])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	430A218001A3
	for <linux-dvb@linuxtv.org>; Sun, 25 May 2008 11:28:20 +0000 (GMT)
MIME-Version: 1.0
From: stev391@email.com
To: "Hans-Frieder Vogt" <hfvogt@gmx.net>,
	"jochen s" <bumkunjo@gmx.de>
Date: Sun, 25 May 2008 21:28:20 +1000
Message-Id: <20080525112820.374AC104F0@ws1-3.us4.outblaze.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express [PATCH]
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0898116694=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0898116694==
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_1211714900170810"

This is a multi-part message in MIME format.

--_----------=_1211714900170810
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

 Hans-Frieder,

Thanks, for this patch.  I have tested it on 1 of 3 machines that I have
access to with this DVB card. No issues (Now loads 80 firmwares, instead
of 3)

It doesn't break Chris Pascoe's xc-test branch with the DViCO Fusion HDTV
DVB-T Dual Express.

It also makes my patch, to get support into the v4l-dvb head, (newer
version then posted here) work a lot more reliably (Perfectly on this
test machine, I will run it on my mythbox for a week or so before I post
it).

I think you should email Chris Pascoe and petition him to include it in
his branch.  As this will definitely help alot of people out.

Thanks again,

Stephen.

  ----- Original Message -----
  From: "Hans-Frieder Vogt"
  To: "jochen s" , stev391@email.com
  Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express [PATCH]
  Date: Fri, 23 May 2008 21:46:58 +0200


  Jochen,

  you are indeed missing firmwares. The xc-test branch from Chris
  Pascoe uses the special collection of firmwares
  xc3028-dvico-au-01.fw which only contains firmwares for 7MHz
  bandwidth (just try to tune a channel in the 7MHz band to confirm
  this). To make the card work also for other bandwidths please apply
  the following patch and put the standard firmware for xc3028
  (xc3028-v27.fw) in the usual place (e.g. /lib/firmware).

  This approach should also work for australia, because the standard
  firmware also contains those firmwares in xc3028-dvico-au-01.fw.

  Stephen, can you confirm this?

  Cheers,
  Hans-Frieder

  --- xc-test.orig/linux/drivers/media/video/cx23885/cx23885-dvb.c
  2008-04-26 23:40:52.000000000 +0200
  +++ xc-test/linux/drivers/media/video/cx23885/cx23885-dvb.c
  2008-05-19 23:15:08.000000000 +0200
  @@ -217,9 +217,9 @@ static int dvb_register(struct cx23885_t
  .callback =3D cx23885_dvico_xc2028_callback,
  };
  static struct xc2028_ctrl ctl =3D {
  - .fname =3D "xc3028-dvico-au-01.fw",
  + .fname =3D "xc3028-v27.fw",
  .max_len =3D 64,
  - .scode_table =3D ZARLINK456,
  + .demod =3D XC3028_FE_ZARLINK456,
  };

  fe =3D dvb_attach(xc2028_attach, port->dvb.frontend,

--=20
See Exclusive Video: 10th Annual Young Hollywood Awards
http://www.hollywoodlife.net/younghollywoodawards2008/


--_----------=_1211714900170810
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="iso-8859-1"


<div>
Hans-Frieder,<br><br>Thanks, for this patch.&nbsp; I have tested it on 1 of=
 3 machines that I have access to with this DVB card. No issues (Now loads =
80 firmwares, instead of 3)<br><br>It doesn't break Chris Pascoe's xc-test =
branch with the DViCO Fusion HDTV DVB-T Dual Express.<br><br>It also makes =
my patch, to get support into the v4l-dvb head, (newer version then posted =
here) work a lot more reliably (Perfectly on this test machine, I will run =
it on my mythbox for a week or so before I post it).<br><br>I think you sho=
uld email Chris Pascoe and petition him to include it in his branch.&nbsp; =
As this will definitely help alot of people out.<br><br>Thanks again,<br><b=
r>Stephen.<br>
<br>
<blockquote style=3D"border-left: 2px solid rgb(16, 16, 255); margin-left: =
5px; padding-left: 5px;">----- Original Message -----<br>
From: "Hans-Frieder Vogt" <hfvogt@gmx.net><br>
To: "jochen s" <bumkunjo@gmx.de>, stev391@email.com<br>
Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express [PATCH]<br>
Date: Fri, 23 May 2008 21:46:58 +0200<br>
<br>

<br>
Jochen,<br>
<br>
you are indeed missing firmwares. The xc-test branch from Chris <br>
Pascoe uses the special collection of firmwares <br>
xc3028-dvico-au-01.fw which only contains firmwares for 7MHz <br>
bandwidth (just try to tune a channel in the 7MHz band to confirm <br>
this). To make the card work also for other bandwidths please apply <br>
the following patch and put the standard firmware for xc3028 <br>
(xc3028-v27.fw) in the usual place (e.g. /lib/firmware).<br>
<br>
This approach should also work for australia, because the standard <br>
firmware also contains those firmwares in xc3028-dvico-au-01.fw.<br>
<br>
Stephen, can you confirm this?<br>
<br>
Cheers,<br>
Hans-Frieder<br>
<br>
--- xc-test.orig/linux/drivers/media/video/cx23885/cx23885-dvb.c    <br>
     2008-04-26 23:40:52.000000000 +0200<br>
+++ xc-test/linux/drivers/media/video/cx23885/cx23885-dvb.c  <br>
2008-05-19 23:15:08.000000000 +0200<br>
@@ -217,9 +217,9 @@ static int dvb_register(struct cx23885_t<br>
                                 .callback  =3D cx23885_dvico_xc2028_callba=
ck,<br>
                         };<br>
                         static struct xc2028_ctrl ctl =3D {<br>
-                               .fname       =3D "xc3028-dvico-au-01.fw",<b=
r>
+                               .fname       =3D "xc3028-v27.fw",<br>
                                 .max_len     =3D 64,<br>
-                               .scode_table =3D ZARLINK456,<br>
+                               .demod       =3D XC3028_FE_ZARLINK456,<br>
                         };<br>
<br>
                         fe =3D dvb_attach(xc2028_attach, port-&gt;dvb.fron=
tend,<br>
<br>
<br>
<bumkunjo@gmx.de><br>
</bumkunjo@gmx.de></bumkunjo@gmx.de></hfvogt@gmx.net></blockquote>
</div>
<BR>

--=20
<div> See Exclusive Video: <a href=3D "http://www.hollywoodlife.net/youngho=
llywoodawards2008/" target=3D"_blank"> <b> 10th Annual Young Hollywood Awar=
ds</b></a><br></div>

--_----------=_1211714900170810--



--===============0898116694==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0898116694==--
