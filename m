Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <takacsk2004@yahoo.com>) id 1Wezyr-0004oE-KJ
	for linux-dvb@linuxtv.org; Tue, 29 Apr 2014 06:49:22 +0200
Received: from nm11-vm5.bullet.mail.ne1.yahoo.com ([98.138.91.233])
	by mail.tu-berlin.de (exim-4.72/mailfrontend-7) with esmtps
	[TLSv1:AES256-SHA:256] for <linux-dvb@linuxtv.org>
	id 1Wezyp-0004qC-1G; Tue, 29 Apr 2014 06:49:21 +0200
References: <CAGSY5EKPPRC_O6FTfCfxO+5SJki0Vp9RP4uZCzQmtyMJOuBPmQ@mail.gmail.com>
Message-ID: <1398746956.55489.YahooMailNeo@web120705.mail.ne1.yahoo.com>
Date: Mon, 28 Apr 2014 21:49:16 -0700 (PDT)
From: Kalman Takacs <takacsk2004@yahoo.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
In-Reply-To: <CAGSY5EKPPRC_O6FTfCfxO+5SJki0Vp9RP4uZCzQmtyMJOuBPmQ@mail.gmail.com>
MIME-Version: 1.0
Subject: Re: [linux-dvb] Problem with dvb drivers on KitKat
Reply-To: linux-media@vger.kernel.org, Kalman Takacs <takacsk2004@yahoo.com>
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0599671360=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0599671360==
Content-Type: multipart/alternative; boundary="1929490892-1000148765-1398746956=:55489"

--1929490892-1000148765-1398746956=:55489
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Check DTV_ENUM_DELSYS http://linuxtv.org/downloads/v4l-dvb-apis/FE_GET_SET_=
PROPERTY.html=0A=0A=C2=A0=C2=A0=0A=0AOn Tuesday, April 29, 2014 5:05 AM, Da=
ng Quang Huy <huydq5000@gmail.com> wrote:=0A =0AHi,=0A=0AI'm working with K=
itKat (gcc 4.7, 3.10 kernel, baytrail 64bit), after enable DVB features via=
 make menuconfig, I can see the device nodes (frontend, demux, dvr) up, but=
 It always returns ENOTTY when I use ioctl to send FE_GET_PROPERTY to front=
end node (It works with FE_GET_INFO).=0A=0AIf anyone has any expericence ab=
out it, please support.=0A=0AThanks,=0A=0A-- =0A=C4=90=E1=BA=B7ng Quang Huy=
=0A=0A_______________________________________________=0Alinux-dvb users mai=
ling list=0AFor V4L/DVB development, please use instead linux-media@vger.ke=
rnel.org=0Alinux-dvb@linuxtv.org=0Ahttp://www.linuxtv.org/cgi-bin/mailman/l=
istinfo/linux-dvb
--1929490892-1000148765-1398746956=:55489
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><body><div style=3D"color:#000; background-color:#fff; font-family:He=
lveticaNeue, Helvetica Neue, Helvetica, Arial, Lucida Grande, sans-serif;fo=
nt-size:12pt"><h4 style=3D"" class=3D""><code style=3D"" class=3D"">Check D=
TV_ENUM_DELSYS <a style=3D"" class=3D"" href=3D"http://linuxtv.org/download=
s/v4l-dvb-apis/FE_GET_SET_PROPERTY.html">http://linuxtv.org/downloads/v4l-d=
vb-apis/FE_GET_SET_PROPERTY.html</a><br style=3D"" class=3D""></code><div> =
&nbsp;</div><code style=3D"" class=3D"">&nbsp;</code></h4><div style=3D"" c=
lass=3D""><span style=3D"" class=3D""><br style=3D"" class=3D""></span></di=
v><div style=3D"display: block;" class=3D"yahoo_quoted"> <div class=3D"" st=
yle=3D"font-family: HelveticaNeue, Helvetica Neue, Helvetica, Arial, Lucida=
 Grande, sans-serif; font-size: 12pt"> <div class=3D"" style=3D"font-family=
: HelveticaNeue, Helvetica Neue, Helvetica, Arial, Lucida Grande, sans-seri=
f; font-size: 12pt"> <div style=3D"" class=3D"" dir=3D"ltr"> <font style=3D=
"" class=3D"" size=3D"2" face=3D"Arial"> On Tuesday,
 April 29, 2014 5:05 AM, Dang Quang Huy &lt;huydq5000@gmail.com&gt; wrote:<=
br style=3D"" class=3D""> </font> </div>  <div style=3D"" class=3D""><div s=
tyle=3D"" class=3D"" id=3D"yiv5592528874"><div style=3D"" class=3D"" dir=3D=
"ltr">Hi,<div style=3D"" class=3D""><br style=3D"" class=3D""></div><div st=
yle=3D"" class=3D"">I'm working with KitKat (gcc 4.7, 3.10 kernel, baytrail=
 64bit), after enable DVB features via make menuconfig, I can see the devic=
e nodes (frontend, demux, dvr) up, but It always returns ENOTTY when I use =
ioctl to send FE_GET_PROPERTY to frontend node (It works with FE_GET_INFO).=
</div>=0A<div style=3D"" class=3D""><br style=3D"" class=3D""></div><div st=
yle=3D"" class=3D"">If anyone has any expericence about it, please support.=
</div><div style=3D"" class=3D""><br style=3D"" class=3D""></div><div style=
=3D"" class=3D"">Thanks,<br style=3D"" class=3D"" clear=3D"all"><div style=
=3D"" class=3D""><br style=3D"" class=3D""></div>-- <br style=3D"" class=3D=
"">=C4=90=E1=BA=B7ng Quang Huy<br style=3D"" class=3D"">=0A</div></div></di=
v><br style=3D"" class=3D"">_______________________________________________=
<br style=3D"" class=3D"">linux-dvb users mailing list<br style=3D"" class=
=3D"">For V4L/DVB development, please use instead <a style=3D"" class=3D"" =
ymailto=3D"mailto:linux-media@vger.kernel.org" href=3D"mailto:linux-media@v=
ger.kernel.org">linux-media@vger.kernel.org</a><br style=3D"" class=3D""><a=
 style=3D"" class=3D"" ymailto=3D"mailto:linux-dvb@linuxtv.org" href=3D"mai=
lto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br style=3D"" class=3D=
""><a style=3D"" class=3D"" href=3D"http://www.linuxtv.org/cgi-bin/mailman/=
listinfo/linux-dvb" target=3D"_blank">http://www.linuxtv.org/cgi-bin/mailma=
n/listinfo/linux-dvb</a><br style=3D"" class=3D""><br style=3D"" class=3D""=
></div>  </div> </div>  </div> </div></body></html>
--1929490892-1000148765-1398746956=:55489--


--===============0599671360==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0599671360==--
