Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KQ7P0-0007tL-Ak
	for linux-dvb@linuxtv.org; Mon, 04 Aug 2008 23:15:40 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	DCB8A180369E
	for <linux-dvb@linuxtv.org>; Mon,  4 Aug 2008 21:15:02 +0000 (GMT)
MIME-Version: 1.0
From: stev391@email.com
To: "Steven Toth" <stoth@linuxtv.org>
Date: Tue, 5 Aug 2008 07:15:01 +1000
Message-Id: <20080804211502.6FD061158CC@ws1-7.us4.outblaze.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200
 H - DVB Only support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0805111412=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0805111412==
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_121788450184894"

This is a multi-part message in MIME format.

--_----------=_121788450184894
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

 Steve,

That must have slipped in from my effort to get the analog support for
the card.  I will remove that when I go through and redo the callback.

Thanks for your comments.

Regards,
Stephen.

  ----- Original Message -----
  From: "Steven Toth"
  To: stev391@email.com
  Subject: Re: [linux-dvb] [PATCH-TESTERS-REQUIRED] Leadtek Winfast
  PxDVR 3200 H - DVB Only support
  Date: Mon, 04 Aug 2008 10:35:20 -0400


  > case CX23885_BOARD_HAUPPAUGE_HVR1800:
  > case CX23885_BOARD_HAUPPAUGE_HVR1800lp:
  > case CX23885_BOARD_HAUPPAUGE_HVR1700:
  > + case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
  > request_module("cx25840");
  > break;
  > }

  Steve, thanks for look at this.

  I took a quick look at your patch. Obviously the callback stuff
  you're planning to re-work will be based Antons patch, which I plan
  to push tonight after more testing.... So I'm ignoring this.

  Minor nitpick... Don't request module cx25840 above unless you plan
  to use it. If you are planning to add analog support, make this a
  second patch after the digital stuff gets merged.

  Other than that, it will be great to have another product supported
  in the tree.

  Regards,

  - Steve

--=20
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


--_----------=_121788450184894
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="iso-8859-1"


<div>
Steve,<br><br>That must have slipped in from my effort to get the analog su=
pport for the card.&nbsp; I will remove that when I go through and redo the=
 callback.<br><br>Thanks for your comments.<br><br>Regards,<br>Stephen.<br>
<br>
<blockquote style=3D"border-left: 2px solid rgb(16, 16, 255); margin-left: =
5px; padding-left: 5px;">----- Original Message -----<br>
From: "Steven Toth" <stoth@linuxtv.org><br>
To: stev391@email.com<br>
Subject: Re: [linux-dvb] [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 320=
0 H - DVB Only support<br>
Date: Mon, 04 Aug 2008 10:35:20 -0400<br>
<br>

<br>
&gt;      case CX23885_BOARD_HAUPPAUGE_HVR1800:<br>
&gt;      case CX23885_BOARD_HAUPPAUGE_HVR1800lp:<br>
&gt;      case CX23885_BOARD_HAUPPAUGE_HVR1700:<br>
&gt; +    case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:<br>
&gt;          request_module("cx25840");<br>
&gt;          break;<br>
&gt;      }<br>
<br>
Steve, thanks for look at this.<br>
<br>
I took a quick look at your patch. Obviously the callback stuff <br>
you're planning to re-work will be based Antons patch, which I plan <br>
to push tonight after more testing.... So I'm ignoring this.<br>
<br>
Minor nitpick... Don't request module cx25840 above unless you plan <br>
to use it. If you are planning to add analog support, make this a <br>
second patch after the digital stuff gets merged.<br>
<br>
Other than that, it will be great to have another product supported <br>
in the tree.<br>
<br>
Regards,<br>
<br>
- Steve<br>
</stoth@linuxtv.org></blockquote>
</div>
<BR>

--=20
<div> Be Yourself @ mail.com!<br>
Choose From 200+ Email Addresses<br>
Get a <b>Free</b> Account at <a href=3D"http://www.mail.com/Product.aspx" t=
arget=3D"_blank">www.mail.com</a>!</div>

--_----------=_121788450184894--



--===============0805111412==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0805111412==--
