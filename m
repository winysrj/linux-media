Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KQL6C-00019R-BG
	for linux-dvb@linuxtv.org; Tue, 05 Aug 2008 13:53:10 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	2C73E180439A
	for <linux-dvb@linuxtv.org>; Tue,  5 Aug 2008 11:52:34 +0000 (GMT)
MIME-Version: 1.0
From: stev391@email.com
To: "Steven Toth" <stoth@linuxtv.org>
Date: Tue, 5 Aug 2008 21:52:33 +1000
Message-Id: <20080805115233.F395B11581F@ws1-7.us4.outblaze.com>
Cc: linux-dvb@linuxtv.org, linuxdvb@itee.uq.edu.au
Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO FusionHDTV
 DVB-T Dual Express
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1743171618=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============1743171618==
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_1217937153241280"

This is a multi-part message in MIME format.

--_----------=_1217937153241280
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

 Steve,

I have successfully run this branch on my dev machine and tried various
conditions to see if I can make it break.

Just one question regarding the new tuner callback.  Why is the mdelay
now set at 200 for the reset?  In the callback I was using for this card
previously this was set at 5. This hasn't caused any performance issues
that I have noticed, but why wait that extra 195milliseconds?

I have just applied this branch to my HTPC and will see how it performs
over the next couple of days and will get back to you with a sign off for
you to include, if you like.

Regards,

Stephen

  ----- Original Message -----
  From: "Steven Toth"
  To: stev391@email.com
  Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO
  FusionHDTV DVB-T Dual Express
  Date: Mon, 04 Aug 2008 21:25:56 -0400


  stev391@email.com wrote:
  > Anton,
  >
  > Thankyou for cleaning this code up (and you as well Steven).
  >
  > I have been meaning to do some more work on this lately, but you
  > have taken it to were I was hoping to go.
  >
  > Steven, I can test your cleaned up code as well, just drop me an
  > email and I will run it on my machines (I have several that I
  > have access to with these cards in them, with various other
  > cards).

  Stephen / Anton,

  http://linuxtv.org/hg/~stoth/v4l-dvb

  This has Anton's patches and a subsequent cleanup patch to merge
  the single tune callback functions into a single entity. A much
  better solution all-round.

  I've tested with the HVR1500Q (xc5000 based) and I'm happy with the
  results. Can you both try the DViCO board?

  Thanks,

  Steve

--=20
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


--_----------=_1217937153241280
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="iso-8859-1"


<div>
Steve,<br><br>I have successfully run this branch on my dev machine and tri=
ed various conditions to see if I can make it break.<br><br>Just one questi=
on regarding the new tuner callback.&nbsp; Why is the mdelay now set at 200=
 for the reset?&nbsp; In the callback I was using for this card previously =
this was set at 5. This hasn't caused any performance issues that I have no=
ticed, but why wait that extra 195milliseconds?<br><br>I have just applied =
this branch to my HTPC and will see how it performs over the next couple of=
 days and will get back to you with a sign off for you to include, if you l=
ike.<br><br>Regards,<br><br>Stephen<br>
<br>
<blockquote style=3D"border-left: 2px solid rgb(16, 16, 255); margin-left: =
5px; padding-left: 5px;">----- Original Message -----<br>
From: "Steven Toth" <stoth@linuxtv.org><br>
To: stev391@email.com<br>
Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO FusionHDTV D=
VB-T Dual Express<br>
Date: Mon, 04 Aug 2008 21:25:56 -0400<br>
<br>

<br>
stev391@email.com wrote:<br>
&gt; Anton,<br>
&gt;<br>
&gt; Thankyou for cleaning this code up (and you as well Steven).<br>
&gt;<br>
&gt; I have been meaning to do some more work on this lately, but you <br>
&gt; have taken it to were I was hoping to go.<br>
&gt;<br>
&gt; Steven, I can test your cleaned up code as well, just drop me an <br>
&gt; email and I will run it on my machines (I have several that I <br>
&gt; have access to with these cards in them, with various other <br>
&gt; cards).<br>
<br>
Stephen / Anton,<br>
<br>
http://linuxtv.org/hg/~stoth/v4l-dvb<br>
<br>
This has Anton's patches and a subsequent cleanup patch to merge <br>
the single tune callback functions into a single entity. A much <br>
better solution all-round.<br>
<br>
I've tested with the HVR1500Q (xc5000 based) and I'm happy with the <br>
results. Can you both try the DViCO board?<br>
<br>
Thanks,<br>
<br>
Steve<br>
</stoth@linuxtv.org></blockquote>
</div>
<BR>

--=20
<div> Be Yourself @ mail.com!<br>
Choose From 200+ Email Addresses<br>
Get a <b>Free</b> Account at <a href=3D"http://www.mail.com/Product.aspx" t=
arget=3D"_blank">www.mail.com</a>!</div>

--_----------=_1217937153241280--



--===============1743171618==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1743171618==--
