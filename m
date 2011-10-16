Return-Path: linux-dvb-bounces+mchehab=redhat.com@linuxtv.org
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <ariel.jolo@coso-ad.com>) id 1RFWqk-0002Ko-3d
	for linux-dvb@linuxtv.org; Sun, 16 Oct 2011 21:58:48 +0200
Received: from mail-iy0-f182.google.com ([209.85.210.182])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-1) with esmtps
	[TLSv1:RC4-SHA:128] for <linux-dvb@linuxtv.org>
	id 1RFWqj-0006Cm-Jp; Sun, 16 Oct 2011 21:58:21 +0200
Received: by iaky10 with SMTP id y10so6231905iak.41
	for <linux-dvb@linuxtv.org>; Sun, 16 Oct 2011 12:58:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACGoy5k=vu5Z9Rh6hkiMEKs4p=VN+3ALUbR=LP_hm1XJXTe=pw@mail.gmail.com>
References: <CACGoy5k=vu5Z9Rh6hkiMEKs4p=VN+3ALUbR=LP_hm1XJXTe=pw@mail.gmail.com>
Date: Sun, 16 Oct 2011 16:58:16 -0300
Message-ID: <CACGoy5mHBqUB=7G=_=GE658vTKfmpck_9QyQ09rVdJnr1Y_FGA@mail.gmail.com>
From: Ariel Jolo <ariel.jolo@coso-ad.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Fwd: support for tv tuner tda18211 in Iconbit U100
	analog stick
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1483198116=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=redhat.com@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1483198116==
Content-Type: multipart/alternative; boundary=90e6ba3fcc33499edb04af6fe9b0

--90e6ba3fcc33499edb04af6fe9b0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hey guys, I'm having the same issue here. I bought a MSI Digi VOX Mini II
Analog (whic was documented as having RTL2832 or AF9016 chips) but mine is:

Bus 001 Device 003: ID 1f4d:0237 G-Tek Electronics Group

Here's the syslog output when I plug it in:

http://pastebin.com/fWc7hM18


As Ling, I can't get a tuner to work nor does /dev/dvb get created.
I really need some help on this.

Thank you very much !


On 13 Oct 2011, Antti Palosaari wrote:
> From: Antti Palosaari <crope <at> iki.fi>
> Subject: Re: support for tv tuner tda18211 in Iconbit U100 analog stick
> Date: 2011-10-13 13:21:41 GMT
>
> CX23102 + TDA18211 (=3D=3D DVB-T only version of TDA18271)>
>
>Maybe someone have better knowledge about that as I am not any familiar
>with CX23102 nor analog TV side.
>
>Antti
>
>On 10/09/2011 03:56 AM, Ling Sequera wrote:
>> I try to post this at linux-media <at> vger.kernel.org
>> <mailto:linux-media <at> vger.kernel.org>, but the system rejects the
>> sending, Excuse me for send this to you, I have understood that you are
>> one of the developers of the tda18271 module.
>>
>> I have a "Mygica u719c usb analog tv stick", lsusb output identify this
>> device as: "ID 1f4d:0237 G-Tek Electronics Group". Googling, I found
>> that this device is the same "Iconbit Analog Stick U100 FM
>> <
http://translate.google.es/translate?sl=3Dru&tl=3Den&js=3Dn&prev=3D_t&hl=3D=
es&ie=3DUTF-8&layout=3D2&eotf=3D1&u=3Dhttp%3A%2F%2Fwww.f1cd.ru%2Ftuners%2Fr=
eviews%2Ficonbit_u100_fm_iconbit_u500_fm_page_1%2F
>",
>> which has support in the kernel since version 3.0 as shown here
>> <http://cateee.net/lkddb/web-lkddb/VIDEO_CX231XX.html>. I opened the
>> device to corfirm this information, and effectively, it has to chips,
>> the demod Conexan "CX23102" and the DVB-T tuner NPX "TDA-18211". I
>> installed the precompiled version of kernel 3.0.4, and the device was
>> reconized, but only works in the modes: composite and s-video. I check
>> the source code and I found that it don't support tv tuner mode
>> (.tuner_type=3DTUNER_ABSENT in 513 line of the cx231xx-cards.c
>> <
http://lxr.linux.no/#linux+v3.0.4/drivers/media/video/cx231xx/cx231xx-cards=
.c
>
>> source file), I want to add support for this. The TDA-18211 tuner has
>> support in the kernel in the module tda18271 according to the thread of
>> this mailing list
>> <http://www.mail-archive.com/linux-dvb <at> linuxtv.



--=20

 [image: Coso] <http://www.coso-ad.com>  *Ariel Jolo * Redactor*
*Tel:* +54 (11) 3965.6324
Morelos 450 2=B0 Of. B (C1406BQD)
Ciudad de Buenos Aires * Argentina
  [image: LinkedIn] <http://ar.linkedin.com/in/ajolo> [image:
Twitter]<http://twitter.com/ajolo>

--90e6ba3fcc33499edb04af6fe9b0
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_quote"><div>Hey guys, I&#39;m having the same issue her=
e. I bought a MSI Digi VOX Mini II Analog (whic was documented as having RT=
L2832 or=A0AF9016 chips) but mine is:</div><div><br></div><div><div>Bus 001=
 Device 003: ID 1f4d:0237 G-Tek Electronics Group=A0</div>

</div><div><br></div><div>Here&#39;s the syslog output when I plug it in:</=
div><div><br></div><div><a href=3D"http://pastebin.com/fWc7hM18" target=3D"=
_blank">http://pastebin.com/fWc7hM18</a></div><div><br></div><div><br></div=
>
<div>As Ling, I can&#39;t get a tuner to work nor does /dev/dvb get created=
.</div>
<div>I really need some help on this.</div><div><br></div><div>Thank you ve=
ry much !</div><div><br></div><div><br></div><div>On 13 Oct 2011,=A0Antti P=
alosaari=A0wrote:</div>
<div>&gt; From: Antti Palosaari &lt;crope &lt;at&gt; <a href=3D"http://iki.=
fi" target=3D"_blank">iki.fi</a>&gt;</div><div>&gt; Subject: Re: support fo=
r tv tuner tda18211 in Iconbit U100 analog stick</div>
<div>&gt; Date: 2011-10-13 13:21:41 GMT</div><div>&gt;</div><div>&gt; CX231=
02 + TDA18211 (=3D=3D DVB-T only version of TDA18271)&gt;</div><div>&gt;</d=
iv><div>&gt;Maybe someone have better knowledge about that as I am not any =
familiar=A0</div>

<div>&gt;with CX23102 nor analog TV side.</div><div>&gt;</div><div>&gt;Antt=
i</div><div>&gt;</div><div>&gt;On 10/09/2011 03:56 AM, Ling Sequera wrote:<=
/div><div>&gt;&gt; I try to post this at linux-media &lt;at&gt; <a href=3D"=
http://vger.kernel.org" target=3D"_blank">vger.kernel.org</a></div>

<div>&gt;&gt; &lt;mailto:<a href=3D"mailto:linux-media" target=3D"_blank">l=
inux-media</a> &lt;at&gt; <a href=3D"http://vger.kernel.org" target=3D"_bla=
nk">vger.kernel.org</a>&gt;, but the system rejects the</div><div>&gt;&gt; =
sending, Excuse me for send this to you, I have understood that you are</di=
v>

<div>&gt;&gt; one of the developers of the tda18271 module.</div><div>&gt;&=
gt;</div><div>&gt;&gt; I have a &quot;Mygica u719c usb analog tv stick&quot=
;, lsusb output identify this</div><div>&gt;&gt; device as: &quot;ID 1f4d:0=
237 G-Tek Electronics Group&quot;. Googling, I found</div>

<div>&gt;&gt; that this device is the same &quot;Iconbit Analog Stick U100 =
FM</div><div>&gt;&gt; &lt;<a href=3D"http://translate.google.es/translate?s=
l=3Dru&amp;tl=3Den&amp;js=3Dn&amp;prev=3D_t&amp;hl=3Des&amp;ie=3DUTF-8&amp;=
layout=3D2&amp;eotf=3D1&amp;u=3Dhttp%3A%2F%2Fwww.f1cd.ru%2Ftuners%2Freviews=
%2Ficonbit_u100_fm_iconbit_u500_fm_page_1%2F" target=3D"_blank">http://tran=
slate.google.es/translate?sl=3Dru&amp;tl=3Den&amp;js=3Dn&amp;prev=3D_t&amp;=
hl=3Des&amp;ie=3DUTF-8&amp;layout=3D2&amp;eotf=3D1&amp;u=3Dhttp%3A%2F%2Fwww=
.f1cd.ru%2Ftuners%2Freviews%2Ficonbit_u100_fm_iconbit_u500_fm_page_1%2F</a>=
&gt;&quot;,</div>

<div>&gt;&gt; which has support in the kernel since version 3.0 as shown he=
re</div><div>&gt;&gt; &lt;<a href=3D"http://cateee.net/lkddb/web-lkddb/VIDE=
O_CX231XX.html" target=3D"_blank">http://cateee.net/lkddb/web-lkddb/VIDEO_C=
X231XX.html</a>&gt;. I opened the</div>

<div>&gt;&gt; device to corfirm this information, and effectively, it has t=
o chips,</div><div>&gt;&gt; the demod Conexan &quot;CX23102&quot; and the D=
VB-T tuner NPX &quot;TDA-18211&quot;. I</div><div>&gt;&gt; installed the pr=
ecompiled version of kernel 3.0.4, and the device was</div>

<div>&gt;&gt; reconized, but only works in the modes: composite and s-video=
. I check</div><div>&gt;&gt; the source code and I found that it don&#39;t =
support tv tuner mode</div><div>&gt;&gt; (.tuner_type=3DTUNER_ABSENT in 513=
 line of the cx231xx-cards.c</div>

<div>&gt;&gt; &lt;<a href=3D"http://lxr.linux.no/#linux+v3.0.4/drivers/medi=
a/video/cx231xx/cx231xx-cards.c" target=3D"_blank">http://lxr.linux.no/#lin=
ux+v3.0.4/drivers/media/video/cx231xx/cx231xx-cards.c</a>&gt;</div><div>&gt=
;&gt; source file), I want to add support for this. The TDA-18211 tuner has=
</div>

<div>&gt;&gt; support in the kernel in the module tda18271 according to the=
 thread of</div><div>&gt;&gt; this mailing list</div><div>&gt;&gt; &lt;<a h=
ref=3D"http://www.mail-archive.com/linux-dvb" target=3D"_blank">http://www.=
mail-archive.com/linux-dvb</a> &lt;at&gt; linuxtv.</div>


</div><br><br clear=3D"all"><div><br></div>-- <br><br><div title=3D"signatu=
re"><table style=3D"margin:0px 0pt;font-family:Helvetica,Arial,sans-serif;f=
ont-size:12px;line-height:20px;color:#484848" border=3D"0">
<tbody>
<tr>
<td style=3D"border-bottom:1px solid #e5e5e5 padding-bottom"><a href=3D"htt=
p://www.coso-ad.com" target=3D"_blank"><img src=3D"http://www.coso-ad.com/s=
ignatures/images/coso.png" border=3D"0" alt=3D"Coso"></a></td>
</tr>
<tr>
<td style=3D"padding-top:5px;padding-bottom:3px;border-bottom:1px solid #e5=
e5e5"><strong>Ariel Jolo <span style=3D"color:#ed1556"> * Redactor</span></=
strong><br><strong>Tel:</strong> +54 (11) 3965.6324         <br>Morelos 450=
 2=B0 Of. B (C1406BQD)<br>
Ciudad de Buenos Aires * Argentina<br></td>
</tr>
<tr>
<td style=3D"padding-top:7px"><a title=3D"LinkedIn" href=3D"http://ar.linke=
din.com/in/ajolo" target=3D"_blank"> <img src=3D"http://www.coso-ad.com/sig=
natures/images/linkedin.gif" border=3D"0" alt=3D"LinkedIn"></a>=A0<a title=
=3D"@ajolo" href=3D"http://twitter.com/ajolo" target=3D"_blank"><img src=3D=
"http://www.coso-ad.com/signatures/images/twitter.gif" border=3D"0" alt=3D"=
Twitter"></a></td>

</tr>
</tbody>
</table></div><br>

--90e6ba3fcc33499edb04af6fe9b0--


--===============1483198116==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1483198116==--
