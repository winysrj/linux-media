Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <takacsk2004@yahoo.com>) id 1WwYQx-0000hW-DP
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2014 17:02:56 +0200
Received: from nm27.bullet.mail.ne1.yahoo.com ([98.138.90.90])
	by mail.tu-berlin.de (exim-4.72/mailfrontend-5) with esmtps
	[TLSv1:AES256-SHA:256] for <linux-dvb@linuxtv.org>
	id 1WwYQv-0003Mz-7N; Mon, 16 Jun 2014 17:02:55 +0200
References: <mailman.1.1402912801.19751.linux-dvb@linuxtv.org>
	<539EFE93.1050009@msw.it>
Message-ID: <1402930970.82399.YahooMailNeo@web120702.mail.ne1.yahoo.com>
Date: Mon, 16 Jun 2014 08:02:50 -0700
From: Kalman Takacs <takacsk2004@yahoo.com>
To: "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
In-Reply-To: <539EFE93.1050009@msw.it>
MIME-Version: 1.0
Subject: Re: [linux-dvb] Usb-dvb Pinnacle PCTV 200e
Reply-To: linux-media@vger.kernel.org, Kalman Takacs <takacsk2004@yahoo.com>
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1405989266=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1405989266==
Content-Type: multipart/alternative; boundary="-74892456-1393894076-1402930970=:82399"

---74892456-1393894076-1402930970=:82399
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Check dkms.conf, Makefile and the patch for errors. First apply patch, then=
 "dkms add" and after that "dkms build" and "dkms install".=0A=0A=0A=0AOn M=
onday, June 16, 2014 4:26 PM, Davide Marchi <danjde@msw.it> wrote:=0A =0A=
=0A=0Alinux-dvb-request@linuxtv.org ha scritto:=0A> linux-dvb-request@linux=
tv.org=A0 ha scritto:=0A>> >If drivers are still not in the kernel, you wil=
l have to build those modules. Here you can find a guide for that:=0A>> >ht=
tp://ubuntuforums.org/showthread.php?t=3D1301793=0A> Thanks Kalman Takacs,=
=0AHi Kalman Takacs,=0AI've followed the post steps, but obtain some errors=
 on build process.=0A=0AHere the output, could you give me any suggestion? =
:-)=0A=0Athanks!=0A=0A=0Asudo dkms build -m pctv200e -v 20080520=0A=0AKerne=
l preparation unnecessary for this kernel.=A0 Skipping...=0A=0ABuilding mod=
ule:=0Acleaning build area....=0Amake KERNELRELEASE=3D3.13.0-24-generic -C =
/lib/modules/3.13.0-24-generic/build M=3D/var/lib/dkms/pctv200e/20080520/bu=
ild....(bad exit status: 2)=0AERROR (dkms apport): binary package for pctv2=
00e: 20080520 not found=0AError! Bad return status for module build on kern=
el: 3.13.0-24-generic (i686)=0AConsult /var/lib/dkms/pctv200e/20080520/buil=
d/make.log for more information.=0A=0A#cat=A0 /var/lib/dkms/pctv200e/200805=
20/build/make.log=0A=0ADKMS make.log for pctv200e-20080520 for kernel 3.13.=
0-24-generic (i686)=0Alun 16 giu 2014, 16.18.36, CEST=0Amake: ingresso nell=
a directory "/usr/src/linux-headers-3.13.0-24-generic"=0A=A0  LD=A0 =A0 =A0=
 /var/lib/dkms/pctv200e/20080520/build/built-in.o=0A=A0  CC [M]=A0 /var/lib=
/dkms/pctv200e/20080520/build/pctv200e.o=0Agcc: fatal error: no input files=
=0Acompilation terminated.=0Amake[1]: *** [/var/lib/dkms/pctv200e/20080520/=
build/pctv200e.o] Errore 4=0Amake: *** [_module_/var/lib/dkms/pctv200e/2008=
0520/build] Errore 2=0Amake: uscita dalla directory "/usr/src/linux-headers=
-3.13.0-24-generic"=0A/var/lib/dkms/pctv200e/20080520/build/make.log (END)=
=0A=0Aciao!=0A=A0 =0A=0A-- =0Afirma=0A=0AcosmogoniA <http://www.cosmogonia.=
org/>=0Anoprovarenofareononfarenonc'=E8provare=0A=0A_______________________=
________________________=0Alinux-dvb users mailing list=0AFor V4L/DVB devel=
opment, please use instead linux-media@vger.kernel.org=0Alinux-dvb@linuxtv.=
org=0Ahttp://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
---74892456-1393894076-1402930970=:82399
Content-Type: text/html; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

<html><body><div style=3D"color:#000; background-color:#fff; font-family:He=
lveticaNeue, Helvetica Neue, Helvetica, Arial, Lucida Grande, sans-serif;fo=
nt-size:12pt"><div><span>Check dkms.conf, Makefile and the patch for errors=
. First apply patch, then "dkms add" and after that "dkms build" and "dkms =
install".<br></span></div> <div class=3D"qtdSeparateBR"><br><br></div><div =
style=3D"display: block;" class=3D"yahoo_quoted"> <div style=3D"font-family=
: HelveticaNeue, Helvetica Neue, Helvetica, Arial, Lucida Grande, sans-seri=
f; font-size: 12pt;"> <div style=3D"font-family: HelveticaNeue, Helvetica N=
eue, Helvetica, Arial, Lucida Grande, sans-serif; font-size: 12pt;"> <div d=
ir=3D"ltr"> <font face=3D"Arial" size=3D"2"> On Monday, June 16, 2014 4:26 =
PM, Davide Marchi &lt;danjde@msw.it&gt; wrote:<br> </font> </div>  <br><br>=
 <div class=3D"y_msg_container"><a ymailto=3D"mailto:linux-dvb-request@linu=
xtv.org" href=3D"mailto:linux-dvb-request@linuxtv.org">linux-dvb-request@li=
nuxtv.org</a> ha
 scritto:<br>&gt; <a ymailto=3D"mailto:linux-dvb-request@linuxtv.org" href=
=3D"mailto:linux-dvb-request@linuxtv.org">linux-dvb-request@linuxtv.org</a>=
&nbsp; ha scritto:<br>&gt;&gt; &gt;If drivers are still not in the kernel, =
you will have to build those modules. Here you can find a guide for that:<b=
r>&gt;&gt; &gt;<a href=3D"http://ubuntuforums.org/showthread.php?t=3D130179=
3" target=3D"_blank">http://ubuntuforums.org/showthread.php?t=3D1301793</a>=
<br>&gt; Thanks Kalman Takacs,<br>Hi Kalman Takacs,<br>I've followed the po=
st steps, but obtain some errors on build process.<br><br>Here the output, =
could you give me any suggestion? :-)<br><br>thanks!<br><br><br>sudo dkms b=
uild -m pctv200e -v 20080520<br><br>Kernel preparation unnecessary for this=
 kernel.&nbsp; Skipping...<br><br>Building module:<br>cleaning build area..=
..<br>make KERNELRELEASE=3D3.13.0-24-generic -C /lib/modules/3.13.0-24-gene=
ric/build M=3D/var/lib/dkms/pctv200e/20080520/build....(bad exit status: 2)=
<br>ERROR
 (dkms apport): binary package for pctv200e: 20080520 not found<br>Error! B=
ad return status for module build on kernel: 3.13.0-24-generic (i686)<br>Co=
nsult /var/lib/dkms/pctv200e/20080520/build/make.log for more information.<=
br><br>#cat&nbsp; /var/lib/dkms/pctv200e/20080520/build/make.log<br><br>DKM=
S make.log for pctv200e-20080520 for kernel 3.13.0-24-generic (i686)<br>lun=
 16 giu 2014, 16.18.36, CEST<br>make: ingresso nella directory "/usr/src/li=
nux-headers-3.13.0-24-generic"<br>&nbsp;  LD&nbsp; &nbsp; &nbsp; /var/lib/d=
kms/pctv200e/20080520/build/built-in.o<br>&nbsp;  CC [M]&nbsp; /var/lib/dkm=
s/pctv200e/20080520/build/pctv200e.o<br>gcc: fatal error: no input files<br=
>compilation terminated.<br>make[1]: *** [/var/lib/dkms/pctv200e/20080520/b=
uild/pctv200e.o] Errore 4<br>make: *** [_module_/var/lib/dkms/pctv200e/2008=
0520/build] Errore 2<br>make: uscita dalla directory
 "/usr/src/linux-headers-3.13.0-24-generic"<br>/var/lib/dkms/pctv200e/20080=
520/build/make.log (END)<br><br>ciao!<br>&nbsp; <br><br>-- <br>firma<br><br=
>cosmogoniA &lt;<a href=3D"http://www.cosmogonia.org/" target=3D"_blank">ht=
tp://www.cosmogonia.org/</a>&gt;<br>noprovarenofareononfarenonc'=E8provare<=
br><br>_______________________________________________<br>linux-dvb users m=
ailing list<br>For V4L/DVB development, please use instead <a ymailto=3D"ma=
ilto:linux-media@vger.kernel.org" href=3D"mailto:linux-media@vger.kernel.or=
g">linux-media@vger.kernel.org</a><br><a ymailto=3D"mailto:linux-dvb@linuxt=
v.org" href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br><=
a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target=
=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><b=
r><br></div>  </div> </div>  </div> </div></body></html>
---74892456-1393894076-1402930970=:82399--


--===============1405989266==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1405989266==--
