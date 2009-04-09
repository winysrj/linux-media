Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.228])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bainorama@gmail.com>) id 1LroLu-00043v-KJ
	for linux-dvb@linuxtv.org; Thu, 09 Apr 2009 09:07:11 +0200
Received: by rv-out-0506.google.com with SMTP id k40so416392rvb.41
	for <linux-dvb@linuxtv.org>; Thu, 09 Apr 2009 00:07:05 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 9 Apr 2009 19:07:05 +1200
Message-ID: <8de7a23f0904090007x3905ee7dp817efe67044b8223@mail.gmail.com>
From: Alastair Bain <bainorama@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] HVR-1700 - can't open or scan
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1841264767=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1841264767==
Content-Type: multipart/alternative; boundary=000e0cd20a4a44796c046719e5b7

--000e0cd20a4a44796c046719e5b7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I'm trying to get the Hauppauge HVR-1700 working on a Mythbuntu 9.04 b
install. Looks like the modules are all loading, firmware is being loaded,
device appears in /dev etc, but I can't seem to do anything with it. dvbscan
fails around ln 315,

dvbfe_get_info(fe, DVBFE_INFO_LOCKSTATUS, &feinfo,
                                DVBFE_INFO_QUERYTYPE_IMMEDIATE, 0)
returns DVBFE_INFO_QUERYTYPE_LOCKCHANGE

Anyone have any clues as to what I can do to fix this? Kernel trace is at
http://pastebin.com/m7671e816.

Kind Regards,
Alastair

--000e0cd20a4a44796c046719e5b7
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I&#39;m trying to get the Hauppauge HVR-1700 working on a Mythbuntu 9.04 b =
install. Looks like the modules are all loading, firmware is being loaded, =
device appears in /dev etc, but I can&#39;t seem to do anything with it. dv=
bscan fails around ln 315,<br>
<br>dvbfe_get_info(fe, DVBFE_INFO_LOCKSTATUS, &amp;feinfo,<br>=A0=A0=A0 =A0=
=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 DVBFE_IN=
FO_QUERYTYPE_IMMEDIATE, 0)<br>returns DVBFE_INFO_QUERYTYPE_LOCKCHANGE<br><b=
r>Anyone have any clues as to what I can do to fix this? Kernel trace is at=
 <a href=3D"http://pastebin.com/m7671e816">http://pastebin.com/m7671e816</a=
>.<br>
<br>Kind Regards,<br>Alastair<br><br>

--000e0cd20a4a44796c046719e5b7--


--===============1841264767==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1841264767==--
