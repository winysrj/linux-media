Return-Path: linux-dvb-bounces+mchehab=redhat.com@linuxtv.org
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <RHeidelberg@pctvsystems.com>) id 1SXpeP-0001XH-1V
	for linux-dvb@linuxtv.org; Fri, 25 May 2012 10:13:33 +0200
Received: from mx1.pctvsystems.com ([213.252.189.134])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-4) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1SXpeO-0001yS-Bc; Fri, 25 May 2012 10:13:32 +0200
MIME-Version: 1.0
Content-class: urn:content-classes:message
Date: Fri, 25 May 2012 10:13:34 +0200
Message-ID: <101260B451BFC64699575BAC372B3DEE017BD33D@mx1.pctvsystems.com>
In-Reply-To: <4FBF3E6A.5010501@pctvsystems.com>
References: <4FBF3E6A.5010501@pctvsystems.com>
From: "Ralph Heidelberg" <RHeidelberg@pctvsystems.com>
To: <linux-dvb@linuxtv.org>
Cc: Mike Krufky <mkrufky@hauppauge.com>
Subject: Re: [linux-dvb] S2API: Problem with 64/32bit compatibility
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0011320058=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=redhat.com@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0011320058==
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01CD3A4E.462767A3"
Content-class: urn:content-classes:message

This is a multi-part message in MIME format.

------_=_NextPart_001_01CD3A4E.462767A3
Content-Type: text/plain;
	charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable


	Hi guys.
=09
	I would like to revoke this issue.
	http://linuxtv.org/pipermail/linux-dvb/2009-January/031436.html
=09
	Are there any plans to fix this?
	A possible solution would be:
=09
=09
	struct dtv_property2 {
		__u32 cmd;
		__u32 reserved[3];
		union {
			__u32 data;
			struct {
				__u8 data[32];
				__u32 len;
				__u32 reserved1[3];
				__u32 reserved2;
			} buffer;
		} u;
		__s32 result;
	}
=09
	struct dtv_properties2 {
	        __u32 num;
	        struct dtv_property2 props[64];
	};
=09
	#define FE_SET_PROPERTY2   _IOW('o', 92, struct dtv_properties2)
	#define FE_GET_PROPERTY2   _IOR('o', 93, struct dtv_properties2)
	=20
	What do you think?
=09
	Best regards,
	Ralph Heidelberg
	Senior Software Engineer
	PCTV Systems S.a.r.l.
	(a division of Hauppauge)
=09
=09
________________________________

	Original message:
=09
	Hi!
	  I would like to report a problem with S2API. It looks that it doesn't
	maintain 64/32bit compatibility.
	  It began with my attempt to run the SVN version of kaffeine on =
linux-2.6.28.
	  My system is a 64bit GNU/Linux, but, for historical reasons, I'm =
still using
	32bit KDE 3.5.10, so kaffeine has been compiled as a 32bit binary.
	  I've found that I cannot play DVB on this combination. It's because =
the
	FE_SET_PROPERTY ioctl is not properly handled in the kernel.
	  After a lot of analysis of both kaffeine and kernel source code, I've =
found
	that the core of the problem is in =
/usr/src/linux/include/linux/dvb/frontend.h,
	where the ioctl is declared. There, a struct dtv_properties is =
declared:
=09
	struct dtv_properties {
	        __u32 num;
	        struct dtv_property *props;
	};
=09
	  This struct is then used as a data entry in the FE_SET_PROPERTY =
ioctl.
	  The problem is, that the pointer has different sizes on 32 and 64bit
	architectures, so the whole struct differs in size too. And because the =
size
	is passed as a part of the ioctl command code, the FE_SET_PROPERTY (and
	FE_GET_PROPERTY too) command codes differ for 32/64 bit compilation of =
the
	same include file! For example, for FE_SET_PROPERTY, its 0x40106f52 on =
64bit,
	but 0x40086f52 on 32bit. So, the kernel (having the 64bit code inside) =
cannot
	recognize the 32bit code of the cmd and fails to handle it correctly.
	  The second part is that these ioctls are not yet added to the=20
	/usr/src/linux/fs/compat_ioctl.c file, maybe just because of the =
problem above.
=09
	  Are there plans to fix this problem ? I think that 64/32bit =
compatibility
	should be fully maintained, I think that my case is not so rare yet.
=09
	  With regards, Pavel Troller  =20
=09



------_=_NextPart_001_01CD3A4E.462767A3
Content-Type: text/html;
	charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

<html>
  <head>
   =20
  </head>
  <body bgcolor=3D"#FFFFFF" text=3D"#000000">
    <br>
    <blockquote cite=3D"mid:4FBF3E6A.5010501@pctvsystems.com" =
type=3D"cite">
     =20
      Hi guys.<br>
      <br>
      I would like to revoke this issue.<br>
      <a moz-do-not-send=3D"true"
        =
href=3D"http://linuxtv.org/pipermail/linux-dvb/2009-January/031436.html">=
http://linuxtv.org/pipermail/linux-dvb/2009-January/031436.html</a><br>
      <br>
      Are there any plans to fix this?<br>
      A possible solution would be:<br>
      <br>
      <pre style=3D"color: rgb(0, 0, 0); font-style: normal; =
font-variant: normal; font-weight: normal; letter-spacing: normal; =
line-height: normal; orphans: 2; text-align: -webkit-auto; text-indent: =
0px; text-transform: none; widows: 2; word-spacing: 0px; =
-webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px; ">struct =
dtv_property2 {
	__u32 cmd;
	__u32 reserved[3];
	union {
		__u32 data;
		struct {
			__u8 data[32];
			__u32 len;
			__u32 reserved1[3];
<b>			__u32 reserved2;
</b>		} buffer;
	} u;
<b>	__s32 result;
</b>}

struct dtv_properties2 {
        __u32 num;
<b>        struct dtv_property2 props[64];
</b>};

#define FE_SET_PROPERTY2   _IOW('o', 92, struct dtv_properties2)
#define FE_GET_PROPERTY2   _IOR('o', 93, struct dtv_properties2)
=A0
</pre>
      What do you think?<br>
      <br>
      Best regards,<br>
      Ralph Heidelberg<br>
      <small><small>Senior Software Engineer<br>
          PCTV Systems S.a.r.l.<br>
          (a division of Hauppauge)<br>
        </small></small><br>
      <hr size=3D"2" width=3D"100%">Original message:<br>
      <pre style=3D"color: rgb(0, 0, 0); font-style: normal; =
font-variant: normal; font-weight: normal; letter-spacing: normal; =
line-height: normal; orphans: 2; text-align: -webkit-auto; text-indent: =
0px; text-transform: none; widows: 2; word-spacing: 0px; =
-webkit-text-size-adjust: auto; -webkit-text-stroke-width: 0px; ">Hi!
  I would like to report a problem with S2API. It looks that it doesn't
maintain 64/32bit compatibility.
  It began with my attempt to run the SVN version of kaffeine on =
linux-2.6.28.
  My system is a 64bit GNU/Linux, but, for historical reasons, I'm still =
using
32bit KDE 3.5.10, so kaffeine has been compiled as a 32bit binary.
  I've found that I cannot play DVB on this combination. It's because =
the
FE_SET_PROPERTY ioctl is not properly handled in the kernel.
  After a lot of analysis of both kaffeine and kernel source code, I've =
found
that the core of the problem is in =
/usr/src/linux/include/linux/dvb/frontend.h,
where the ioctl is declared. There, a struct dtv_properties is declared:

struct dtv_properties {
        __u32 num;
        struct dtv_property *props;
};

  This struct is then used as a data entry in the FE_SET_PROPERTY ioctl.
  The problem is, that the pointer has different sizes on 32 and 64bit
architectures, so the whole struct differs in size too. And because the =
size
is passed as a part of the ioctl command code, the FE_SET_PROPERTY (and
FE_GET_PROPERTY too) command codes differ for 32/64 bit compilation of =
the
same include file! For example, for FE_SET_PROPERTY, its 0x40106f52 on =
64bit,
but 0x40086f52 on 32bit. So, the kernel (having the 64bit code inside) =
cannot
recognize the 32bit code of the cmd and fails to handle it correctly.
  The second part is that these ioctls are not yet added to the=20
/usr/src/linux/fs/compat_ioctl.c file, maybe just because of the problem =
above.

  Are there plans to fix this problem ? I think that 64/32bit =
compatibility
should be fully maintained, I think that my case is not so rare yet.

  With regards, Pavel Troller  =20

</pre>
      <br>
    </blockquote>
  </body>
</html>

------_=_NextPart_001_01CD3A4E.462767A3--


--===============0011320058==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0011320058==--
