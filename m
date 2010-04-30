Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <tutuyu@usc.edu>) id 1O7yyd-0002ii-Mb
	for linux-dvb@linuxtv.org; Sat, 01 May 2010 00:46:32 +0200
Received: from mail-iw0-f193.google.com ([209.85.223.193])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-b) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1O7yyd-0002bT-6i; Sat, 01 May 2010 00:46:31 +0200
Received: by iwn31 with SMTP id 31so370926iwn.27
	for <linux-dvb@linuxtv.org>; Fri, 30 Apr 2010 15:46:27 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 30 Apr 2010 15:46:27 -0700
Message-ID: <i2zcae4ceb1004301546y524e19dcl876fbd1f1d7f1175@mail.gmail.com>
From: Tu-Tu Yu <tutuyu@usc.edu>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Question about v4l-dvb/v4l/Makefile oss symbolic link
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1796192093=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1796192093==
Content-Type: multipart/alternative; boundary=0016e64808527c3f9604857c036c

--0016e64808527c3f9604857c036c
Content-Type: text/plain; charset=ISO-8859-1

Hi Everyone:

The Makefile in zodiac/v4l-dvb/v4l creates a "looped" symbolic
infinitely link. By using
oss:
ln -sf  oss .

I would like to know is it something that is needed to be changed?
Audrey

--0016e64808527c3f9604857c036c
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Hi Everyone:</div>
<div>=A0</div>
<div><span lang=3D"EN">The Makefile in zodiac/v4l-dvb/v4l creates a &quot;l=
ooped&quot; symbolic infinitely=A0link. By using</span></div>
<div><span lang=3D"EN">oss:=A0</span></div>
<div><span lang=3D"EN">ln -sf=A0 oss .</span></div>
<div><span lang=3D"EN"></span>=A0</div>
<div><span lang=3D"EN">I would like to know is it something that is needed =
to be changed? </span></div>
<div><span lang=3D"EN">Audrey </span></div>
<p>=A0</p>

--0016e64808527c3f9604857c036c--


--===============1796192093==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1796192093==--
