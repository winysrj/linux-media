Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <jwllmjohnson@gmail.com>) id 1XF8fw-0006yX-Fs
	for linux-dvb@linuxtv.org; Wed, 06 Aug 2014 23:23:13 +0200
Received: from mail-oi0-f45.google.com ([209.85.218.45])
	by mail.tu-berlin.de (exim-4.72/mailfrontend-5) with esmtps
	[TLSv1:RC4-SHA:128] for <linux-dvb@linuxtv.org>
	id 1XF8fu-0006yc-9I; Wed, 06 Aug 2014 23:23:12 +0200
Received: by mail-oi0-f45.google.com with SMTP id e131so2087136oig.18
	for <linux-dvb@linuxtv.org>; Wed, 06 Aug 2014 14:23:08 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 6 Aug 2014 14:23:07 -0700
Message-ID: <CAFCG5rJddi_XLyKTjuoUejZ05QPi7StT5-nrupvbyFXg6C1VBw@mail.gmail.com>
From: Jordan Johnson <jwllmjohnson@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Opencaster / ATSC event_information issue
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2088925029=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============2088925029==
Content-Type: multipart/alternative; boundary=001a11c2150013bbf704fffc94b7

--001a11c2150013bbf704fffc94b7
Content-Type: text/plain; charset=UTF-8

Hello all, I am attempting to implement the *event_information_table* for
ATSC in *Opencaster 3.2.2*
<http://www.avalpa.com/the-key-values/15-free-software/33-opencaster>, and
have run in to some difficulties. I am fairly certain my configuration is
correct, but it gives the following odd error:

*AttributeError: 'list' object has no attribute 'pack'*

(Full traceback here <http://pastebin.com/KUG7MMni>)

My full configuration is here. <http://pastebin.com/wBjGGUCK> --
*area of interest starsts at line 95.*
Any help here would be greatly appreciated.

- Jordan.

--001a11c2150013bbf704fffc94b7
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div>Hello all, I am attempting to implement the=
 <i>event_information_table</i> for ATSC in <a href=3D"http://www.avalpa.co=
m/the-key-values/15-free-software/33-opencaster"><b>Opencaster 3.2.2</b></a=
>, and have run in to some difficulties. I am fairly certain my configurati=
on is correct, but it gives the following odd error:<br>
<br><i>AttributeError: &#39;list&#39; object has no attribute &#39;pack&#39=
;</i><br><br></div>(<a href=3D"http://pastebin.com/KUG7MMni">Full traceback=
 here</a>)<br><br></div>My full <a href=3D"http://pastebin.com/wBjGGUCK">co=
nfiguration is here.</a> -- <i>area of interest starsts at line 95.<br>
</i><br>Any help here would be greatly appreciated. <br><br></div>- Jordan.=
<br></div>

--001a11c2150013bbf704fffc94b7--


--===============2088925029==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2088925029==--
