Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KRFU0-0004mO-Q2
	for linux-dvb@linuxtv.org; Fri, 08 Aug 2008 02:05:30 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	5388E1801D8C
	for <linux-dvb@linuxtv.org>; Fri,  8 Aug 2008 00:04:44 +0000 (GMT)
MIME-Version: 1.0
From: stev391@email.com
To: "Steven Toth" <stoth@linuxtv.org>
Date: Fri, 8 Aug 2008 10:04:43 +1000
Message-Id: <20080808000444.3358F1CE825@ws1-6.us4.outblaze.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO FusionHDTV
 DVB-T Dual Express
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0994044852=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0994044852==
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_12181538836480"

This is a multi-part message in MIME format.

--_----------=_12181538836480
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

  From: "Steven Toth"
  To: stev391@email.com
  Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO
  FusionHDTV DVB-T Dual Express
  Date: Thu, 07 Aug 2008 11:00:08 -0400


  stev391@email.com wrote:
  > Tim, David,
  >
  > I like top posting, then I don't have to scroll too far for the
  > main information.

  We have a convention on this mailing list, we don't top post.

  - Steve

----- End Original Message -----


I apologise, I was not aware of this convention.

I'm satisfied that this patch (as applied in Steven Toths, v4l-dvb
branch) does not break any of the current supported features of this
driver and have successfully tested it in varying conditions (different
receptions levels, different frequencies [uhf & vhf], in Australia).

Steve here is my reviewed by line, if you want to add it into the commit:
Add initial support for DViCO FusionHDTV DVB-T Dual Express
Reviewed-by: Stephen Backway <stev391@email.com>

Regards,

Stephen

--=20
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


--_----------=_12181538836480
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="iso-8859-1"


<div><blockquote style=3D"border-left: 2px solid rgb(16, 16, 255); margin-l=
eft: 5px; padding-left: 5px;">
From: "Steven Toth" <stoth@linuxtv.org><br>
To: stev391@email.com<br>
Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO FusionHDTV D=
VB-T Dual Express<br>
Date: Thu, 07 Aug 2008 11:00:08 -0400<br>
<br>

<br>
stev391@email.com wrote:<br>
&gt; Tim, David,<br>
&gt;<br>
&gt; I like top posting, then I don't have to scroll too far for the <br>
&gt; main information.<br>
<br>
We have a convention on this mailing list, we don't top post.<br>
<br>
- Steve<br>
</stoth@linuxtv.org></blockquote>----- End Original Message -----<br><br><b=
r>I apologise, I was not aware of this convention.<br><br>I'm satisfied tha=
t this patch (as applied in Steven Toths, v4l-dvb branch) does not break an=
y of the current supported features of this driver and have successfully te=
sted it in varying conditions (different receptions levels, different frequ=
encies [uhf &amp; vhf], in Australia).<br><br>Steve here is my reviewed by =
line, if you want to add it into the commit:<br>Add initial support for DVi=
CO FusionHDTV DVB-T Dual Express<br>Reviewed-by: Stephen Backway &lt;stev39=
1@email.com&gt;<br><br>Regards,<br><br>Stephen<br><br><br>
</div>
<BR>

--=20
<div> Be Yourself @ mail.com!<br>
Choose From 200+ Email Addresses<br>
Get a <b>Free</b> Account at <a href=3D"http://www.mail.com/Product.aspx" t=
arget=3D"_blank">www.mail.com</a>!</div>

--_----------=_12181538836480--



--===============0994044852==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0994044852==--
