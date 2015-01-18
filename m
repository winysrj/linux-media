Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <joolzg@btinternet.com>) id 1YCp4U-0004hc-6U
	for linux-dvb@linuxtv.org; Sun, 18 Jan 2015 13:35:14 +0100
Received: from nm6-vm3.access.bullet.mail.bf1.yahoo.com ([216.109.114.146])
	by mail.tu-berlin.de (exim-4.72/mailfrontend-8) with esmtps
	[TLSv1:RC4-SHA:128] for <linux-dvb@linuxtv.org>
	id 1YCp4S-0007Z7-jf; Sun, 18 Jan 2015 13:35:13 +0100
Message-ID: <1421584509.55421.YahooMailNeo@web87803.mail.ir2.yahoo.com>
Date: Sun, 18 Jan 2015 12:35:09 +0000
From: JULIAN GARDNER <joolzg@btinternet.com>
To: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Subject: [linux-dvb] atsc_epg.c segfaults
Reply-To: linux-media@vger.kernel.org, JULIAN GARDNER <joolzg@btinternet.com>
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1823926695=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1823926695==
Content-Type: multipart/alternative; boundary="-1780992897-866223016-1421584509=:55421"

---1780992897-866223016-1421584509=:55421
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

I have a problem which im trying to solve.atsc_epg segfaults=0Aatsc_epc.c=
=0Aline 683=0A=0Astruct atsc_channel_info *curr_info;=0A=0Aline 763=0Aeit_i=
nfo =3D &curr_info->eit[index];=0A=0ABUT=0AThere is no code in between thes=
e 2 lines which sets curr_info, now i changed the code around 712 to=0Afor(=
k =3D 0; k < guide.num_channels; k++) { if(source_id =3D=3D guide.ch[k].src=
_id) { curr_info =3D &guide.ch[k]; break; } } =0AThis removes the segfault,=
 BUT i get no data at all, just lots of nice dots=0A=0ASource is OffAir Los=
 Angeles=0Ajoolz=0A
---1780992897-866223016-1421584509=:55421
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><body><div style=3D"color:#000; background-color:#fff; font-family:ar=
ial, helvetica, sans-serif;font-size:12pt"><div class=3D"yiv825481949commen=
t-body yiv825481949markdown-body yiv825481949markdown-format yiv825481949js=
-comment-body">=0A          <div>I have a problem which im trying to solve.=
atsc_epg segfaults</div><div><br></div>atsc_epc.c<br>line 683<br><div>=0A  =
  struct atsc_channel_info *curr_info;</div>=0A=0A<div><br></div><div style=
=3D"color:rgb(0, 0, 0);font-size:16px;font-family:arial, helvetica, sans-se=
rif;background-color:transparent;font-style:normal;">line 763<br>=0A       =
     eit_info =3D &amp;curr_info-&gt;eit[index];</div>=0A=0A<div><br></div>=
<div style=3D"color:rgb(0, 0, 0);font-size:16px;font-family:arial, helvetic=
a, sans-serif;background-color:transparent;font-style:normal;">BUT</div><di=
v style=3D"color:rgb(0, 0, 0);font-size:16px;font-family:arial, helvetica, =
sans-serif;background-color:transparent;font-style:normal;">There is no cod=
e in between these 2 lines which sets curr_info, now i changed the code aro=
und 712 to</div>=0A=0A<pre><code>            for(k =3D 0; k &lt; guide.num_=
channels; k++) {=0A                if(source_id =3D=3D guide.ch[k].src_id) =
{=0A                    curr_info =3D &amp;guide.ch[k];=0A                 =
   break;=0A                }=0A            }=0A</code></pre>=0A=0A<div>Thi=
s removes the segfault, BUT i get no data at all, just lots of nice dots</d=
iv><div><br></div>=0A=0A<div>Source is OffAir Los Angeles</div>=0A      </d=
iv>=0A=0A    <br>joolz<br></div></body></html>
---1780992897-866223016-1421584509=:55421--


--===============1823926695==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1823926695==--
