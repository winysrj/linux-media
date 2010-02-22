Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <issa.leb@gmail.com>) id 1NjRKT-0002BR-9F
	for linux-dvb@linuxtv.org; Mon, 22 Feb 2010 06:59:37 +0100
Received: from mail-bw0-f209.google.com ([209.85.218.209])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-c) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1NjRKS-00008p-Gr; Mon, 22 Feb 2010 06:59:36 +0100
Received: by bwz1 with SMTP id 1so1328550bwz.1
	for <linux-dvb@linuxtv.org>; Sun, 21 Feb 2010 21:59:35 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 22 Feb 2010 08:59:35 +0300
Message-ID: <33c8ba441002212159x6671ccedjd951dcf1453e1f2@mail.gmail.com>
From: Ahmad Issa <issa.leb@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] TechnoTrend S1500 DVBs / CI can not read Irdeto Cam
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1442097408=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1442097408==
Content-Type: multipart/alternative; boundary=0022154017a23ed26404802a2369

--0022154017a23ed26404802a2369
Content-Type: text/plain; charset=ISO-8859-1

Hi,



I am testing TechnoTrend DVBS 1500 with CI. Everything is working fine when
i use KeyFly Cam, but when i use Irdeto Cam im getting the below error:



error: cannot write to CAM device (Input/output error)

error: en50221_Init: couldn't send TPDU on slot 0

debug: en50221_Poll: resetting slot 0



i testing the card using DVBLast and also when i use VLC i get same results



i have installed the latest DVB driver from www.linuxtv.org



#lspci

0f:04.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)





# lsmod | grep dvb

dvb_ttpci             125216  0

saa7146_vv             59560  1 dvb_ttpci

saa7146                22800  4 budget_ci,budget_core,dvb_ttpci,saa7146_vv

ttpci_eeprom            2792  2 budget_core,dvb_ttpci

dvb_core              120724  5
stv0299,budget_ci,budget_core,dvb_ttpci,b2c2_flexcop



Any Help?



Thanks Alot





Ahmad

--0022154017a23ed26404802a2369
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><meta http-equiv=3D"Content-Type" content=3D"text/html; ch=
arset=3Dutf-8"><meta name=3D"ProgId" content=3D"Word.Document"><meta name=
=3D"Generator" content=3D"Microsoft Word 12"><meta name=3D"Originator" cont=
ent=3D"Microsoft Word 12"><link rel=3D"File-List" href=3D"file:///C:%5CUser=
s%5Caissa%5CAppData%5CLocal%5CTemp%5Cmsohtmlclip1%5C01%5Cclip_filelist.xml"=
><link rel=3D"themeData" href=3D"file:///C:%5CUsers%5Caissa%5CAppData%5CLoc=
al%5CTemp%5Cmsohtmlclip1%5C01%5Cclip_themedata.thmx"><link rel=3D"colorSche=
meMapping" href=3D"file:///C:%5CUsers%5Caissa%5CAppData%5CLocal%5CTemp%5Cms=
ohtmlclip1%5C01%5Cclip_colorschememapping.xml"><style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;
	mso-font-charset:1;
	mso-generic-font-family:roman;
	mso-font-format:other;
	mso-font-pitch:variable;
	mso-font-signature:0 0 0 0 0 0;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;
	mso-font-charset:0;
	mso-generic-font-family:swiss;
	mso-font-pitch:variable;
	mso-font-signature:-520092929 1073786111 9 0 415 0;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{mso-style-unhide:no;
	mso-style-qformat:yes;
	mso-style-parent:"";
	margin:0cm;
	margin-bottom:.0001pt;
	mso-pagination:widow-orphan;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";
	mso-fareast-font-family:Calibri;
	mso-fareast-theme-font:minor-latin;}
a:link, span.MsoHyperlink
	{mso-style-noshow:yes;
	mso-style-priority:99;
	color:blue;
	text-decoration:underline;
	text-underline:single;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-noshow:yes;
	mso-style-priority:99;
	color:purple;
	mso-themecolor:followedhyperlink;
	text-decoration:underline;
	text-underline:single;}
.MsoChpDefault
	{mso-style-type:export-only;
	mso-default-props:yes;
	font-size:10.0pt;
	mso-ansi-font-size:10.0pt;
	mso-bidi-font-size:10.0pt;}
@page Section1
	{size:612.0pt 792.0pt;
	margin:72.0pt 72.0pt 72.0pt 72.0pt;
	mso-header-margin:36.0pt;
	mso-footer-margin:36.0pt;
	mso-paper-source:0;}
div.Section1
	{page:Section1;}
-->
</style>

<p class=3D"MsoNormal">Hi,</p>

<p class=3D"MsoNormal">=A0</p>

<p class=3D"MsoNormal">I am testing TechnoTrend DVBS 1500 with CI. Everythi=
ng is
working fine when i use KeyFly Cam, but when i use Irdeto Cam im getting th=
e
below error:</p>

<p class=3D"MsoNormal">=A0</p>

<p class=3D"MsoNormal">error: cannot write to CAM device (Input/output erro=
r)</p>

<p class=3D"MsoNormal">error: en50221_Init: couldn&#39;t send TPDU on slot =
0</p>

<p class=3D"MsoNormal">debug: en50221_Poll: resetting slot 0</p>

<p class=3D"MsoNormal">=A0</p>

<p class=3D"MsoNormal">i testing the card using DVBLast and also when i use=
 VLC i
get same results</p>

<p class=3D"MsoNormal">=A0</p>

<p class=3D"MsoNormal">i have installed the latest DVB driver from <a href=
=3D"http://www.linuxtv.org/">www.linuxtv.org</a> </p>

<p class=3D"MsoNormal">=A0</p>

<p class=3D"MsoNormal">#lspci</p>

<p class=3D"MsoNormal">0f:04.0 Multimedia controller: Philips Semiconductor=
s
SAA7146 (rev 01)</p>

<p class=3D"MsoNormal">=A0</p>

<p class=3D"MsoNormal">=A0</p>

<p class=3D"MsoNormal"># lsmod | grep dvb</p>

<p class=3D"MsoNormal">dvb_ttpci=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
125216=A0 0</p>

<p class=3D"MsoNormal">saa7146_vv=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
59560=A0 1 dvb_ttpci</p>

<p class=3D"MsoNormal">saa7146=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
22800=A0 4 budget_ci,budget_core,dvb_ttpci,saa7146_vv</p>

<p class=3D"MsoNormal">ttpci_eeprom=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
2792=A0 2 budget_core,dvb_ttpci</p>

<p class=3D"MsoNormal">dvb_core=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
120724=A0 5 stv0299,budget_ci,budget_core,dvb_ttpci,b2c2_flexcop</p>

<p class=3D"MsoNormal">=A0</p>

<p class=3D"MsoNormal">Any Help?</p>

<p class=3D"MsoNormal">=A0</p>

<p class=3D"MsoNormal">Thanks Alot</p>

<p class=3D"MsoNormal">=A0</p>

<p class=3D"MsoNormal">=A0</p>

<p class=3D"MsoNormal">Ahmad</p>

<p class=3D"MsoNormal">=A0</p>

<p class=3D"MsoNormal">=A0</p>

</div>

--0022154017a23ed26404802a2369--


--===============1442097408==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1442097408==--
