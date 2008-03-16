Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.157])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jon.the.wise.gdrive@gmail.com>) id 1JaqIi-0000Ho-Ot
	for linux-dvb@linuxtv.org; Sun, 16 Mar 2008 11:41:13 +0100
Received: by fg-out-1718.google.com with SMTP id 22so3835065fge.25
	for <linux-dvb@linuxtv.org>; Sun, 16 Mar 2008 03:41:09 -0700 (PDT)
Mime-Version: 1.0 (Apple Message framework v753)
To: linux-dvb@linuxtv.org
Message-Id: <7506F33A-1475-4D05-9562-885CAEA8C463@gmail.com>
From: Jon <jon.the.wise.gdrive@gmail.com>
Date: Sun, 16 Mar 2008 03:40:46 -0700
Subject: [linux-dvb] Pinnacle HDTV PCI issues
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0994157671=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============0994157671==
Content-Type: multipart/alternative; boundary=Apple-Mail-1--276419705


--Apple-Mail-1--276419705
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	delsp=yes;
	format=flowed

Hello,

I have a problem with my capture device.

First a little history. I'm running a openSUSE 10.3 system with  
mythtv and have had a frame-grabber (bt878) in it until recently. I  
just upgraded to a pair of pinnacle HDTV pci cards. I just downloaded  
the source and compiled it this afternoon, following the instructions  
on the wiki. I have a large antenna on the roof, and I get channels  
3, 6, 10, 13, 31, 40 and 58 all clearly with SD.

So, the problem is, I am trying to scan for HD channels using the  
following command:

scan /usr/share/dvb/atsc/us-ATSC-center-frequencies-8VSB > channels.conf

...and it starts scanning. It doesn't find any channels until it gets  
to 31.1, and then it says service is running, gives me the channel  
information, and then the thing freezes. I can't ctrl+C out of it,  
and I can't even kill the process from the root account.

This is my schedulesdirect lineup, so I have 2 questions: Why is my  
computer locking up when I scan channels? Interestingly, it isn't  
locking the computer up, just the console that the app is running in,  
and capture card it's connected to. The second question has to do  
with my channels. I have my antenna pointed right at the towers,  
they're all in the same general location, and as I said, the SD comes  
in clear.

Any help is appreciated.

Lineup (95633)

2 KTVN	
2-1KTVNDT	
2-2KTVNDT2	
3 KCRA	
3-1 KCRADT
3-2 KCRADT2	
4-1KRNVDT	
4-2KRNVDT2	
4-3KRNVDT3	
6 KVIE
6-1KVIEDT	
6-2KVIEDT2	
6-3KVIEDT3	
8 KOLO	
8-1KOLODT
8-2KOLODT2	
10 KXTV	
10-1KXTVDT	
10-2KXTVDT2	
11 KRXI
12 KHSL	
13 KOVR	
13-1KOVRDT	
13-2KOVRDT2	
19KUVS
19-1KUVSDT	
19-2KUVSDT2	
22 K22FR	
27 KREN	
27-1KRENDT
29 KSPX	
29-1KSPXDT	
29-2KSPXDT2	
29-3KSPXDT3	
29-4KSPXDT4
31KMAX	
31-1KMAXDT	
40 KTXL	
40-1KTXLDT	
40-2KTXLDT2
42 KTNC	
49 KSAOLP	
58 KQCA	
58-1KQCADT	
60 KSTVLP
64 KTFK
--Apple-Mail-1--276419705
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=ISO-8859-1

<html><body style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; =
-webkit-line-break: after-white-space; ">Hello,<div><br =
class=3D"webkit-block-placeholder"></div><div>I have a problem with my =
capture device.<br>
<div><br class=3D"webkit-block-placeholder"></div><div>First a little =
history. I'm running a openSUSE 10.3 system with mythtv and have had a =
frame-grabber (bt878) in it until recently. I just upgraded to a pair of =
pinnacle HDTV pci cards. I just downloaded the source and compiled it =
this afternoon, following the instructions on the wiki.=A0I have a large =
antenna on the roof, and I get channels 3, 6, 10, 13, 31, 40 and 58 all =
clearly with SD.=A0</div><div><br =
class=3D"webkit-block-placeholder"></div><div>So, the problem is,=A0I am =
trying to scan for HD channels using the following =
command:</div><div><br class=3D"webkit-block-placeholder"></div><div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; ">scan =
/usr/share/dvb/atsc/us-ATSC-center-frequencies-8VSB &gt; =
channels.conf</div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; "><br =
class=3D"webkit-block-placeholder"></div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; ">...and it =
starts scanning. It doesn't find any channels until it gets to 31.1, and =
then it says service is running, gives me the channel information, and =
then the thing freezes. I can't ctrl+C out of it, and I can't even kill =
the process from the root account.=A0</div><div style=3D"margin-top: =
0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; "><br =
class=3D"webkit-block-placeholder"></div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; ">This is my =
schedulesdirect lineup, so I have 2 questions: Why is my computer =
locking up when I scan channels? Interestingly, it isn't locking the =
computer up, just the console that the app is running in, and capture =
card it's connected to. The second question has to do with my channels. =
I have my antenna pointed right at the towers, they're all in the same =
general location, and as I said, the SD comes in clear.</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; "><br class=3D"webkit-block-placeholder"></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; ">Any help is appreciated.</div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; "><br class=3D"webkit-block-placeholder"></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; ">Lineup (95633)</div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; "><br =
class=3D"webkit-block-placeholder"></div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; "><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; "><font face=3D"Helvetica" size=3D"3" style=3D"font: =
12.0px Helvetica">2 KTVN<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span></font></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; "><font face=3D"Helvetica" size=3D"3" style=3D"font: =
12.0px Helvetica">2-1KTVNDT<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span></font></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; "><font face=3D"Helvetica" size=3D"3" style=3D"font: =
12.0px Helvetica">2-2KTVNDT2<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span></font></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; "><font face=3D"Helvetica" size=3D"3" style=3D"font: =
12.0px Helvetica">3 KCRA<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span></font></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; "><font face=3D"Helvetica" size=3D"3" style=3D"font: =
12.0px Helvetica">3-1 KCRADT</font></div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; "><font =
face=3D"Helvetica" size=3D"3" style=3D"font: 12.0px Helvetica">3-2 =
KCRADT2<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span></font></div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; "><font face=3D"Helvetica" =
size=3D"3" style=3D"font: 12.0px Helvetica">4-1KRNVDT<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span></font></div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; "><font face=3D"Helvetica" =
size=3D"3" style=3D"font: 12.0px Helvetica">4-2KRNVDT2<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span></font></div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; "><font face=3D"Helvetica" =
size=3D"3" style=3D"font: 12.0px Helvetica">4-3KRNVDT3<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span></font></div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; "><font face=3D"Helvetica" =
size=3D"3" style=3D"font: 12.0px Helvetica">6 KVIE</font></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; "><font face=3D"Helvetica" size=3D"3" style=3D"font: =
12.0px Helvetica">6-1KVIEDT<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span></font></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; "><font face=3D"Helvetica" size=3D"3" style=3D"font: =
12.0px Helvetica">6-2KVIEDT2<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span></font></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; "><font face=3D"Helvetica" size=3D"3" style=3D"font: =
12.0px Helvetica">6-3KVIEDT3<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span></font></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; "><font face=3D"Helvetica" size=3D"3" style=3D"font: =
12.0px Helvetica">8 KOLO<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span></font></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; "><font face=3D"Helvetica" size=3D"3" style=3D"font: =
12.0px Helvetica">8-1KOLODT</font></div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; "><font =
face=3D"Helvetica" size=3D"3" style=3D"font: 12.0px =
Helvetica">8-2KOLODT2<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span></font></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; "><font face=3D"Helvetica" size=3D"3" style=3D"font: =
12.0px Helvetica">10 KXTV<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span></font></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; "><font face=3D"Helvetica" size=3D"3" style=3D"font: =
12.0px Helvetica">10-1KXTVDT<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span></font></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; "><font face=3D"Helvetica" size=3D"3" style=3D"font: =
12.0px Helvetica">10-2KXTVDT2<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span></font></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; "><font face=3D"Helvetica" size=3D"3" style=3D"font: =
12.0px Helvetica">11 KRXI</font></div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; "><font =
face=3D"Helvetica" size=3D"3" style=3D"font: 12.0px Helvetica">12 =
KHSL<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span></font></div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; "><font face=3D"Helvetica" =
size=3D"3" style=3D"font: 12.0px Helvetica">13 KOVR<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span></font></div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; "><font face=3D"Helvetica" =
size=3D"3" style=3D"font: 12.0px Helvetica">13-1KOVRDT<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span></font></div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; "><font face=3D"Helvetica" =
size=3D"3" style=3D"font: 12.0px Helvetica">13-2KOVRDT2<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span></font></div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; "><font face=3D"Helvetica" =
size=3D"3" style=3D"font: 12.0px Helvetica">19KUVS</font></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; "><font face=3D"Helvetica" size=3D"3" style=3D"font: =
12.0px Helvetica">19-1KUVSDT<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span></font></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; "><font face=3D"Helvetica" size=3D"3" style=3D"font: =
12.0px Helvetica">19-2KUVSDT2<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span></font></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; "><font face=3D"Helvetica" size=3D"3" style=3D"font: =
12.0px Helvetica">22 K22FR<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span></font></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; "><font face=3D"Helvetica" size=3D"3" style=3D"font: =
12.0px Helvetica">27 KREN<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span></font></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; "><font face=3D"Helvetica" size=3D"3" style=3D"font: =
12.0px Helvetica">27-1KRENDT</font></div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; "><font =
face=3D"Helvetica" size=3D"3" style=3D"font: 12.0px Helvetica">29 =
KSPX<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span></font></div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; "><font face=3D"Helvetica" =
size=3D"3" style=3D"font: 12.0px Helvetica">29-1KSPXDT<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span></font></div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; "><font face=3D"Helvetica" =
size=3D"3" style=3D"font: 12.0px Helvetica">29-2KSPXDT2<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span></font></div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; "><font face=3D"Helvetica" =
size=3D"3" style=3D"font: 12.0px Helvetica">29-3KSPXDT3<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span></font></div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; "><font face=3D"Helvetica" =
size=3D"3" style=3D"font: 12.0px Helvetica">29-4KSPXDT4</font></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; "><font face=3D"Helvetica" size=3D"3" style=3D"font: =
12.0px Helvetica">31KMAX<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span></font></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; "><font face=3D"Helvetica" size=3D"3" style=3D"font: =
12.0px Helvetica">31-1KMAXDT<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span></font></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; "><font face=3D"Helvetica" size=3D"3" style=3D"font: =
12.0px Helvetica">40 KTXL<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span></font></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; "><font face=3D"Helvetica" size=3D"3" style=3D"font: =
12.0px Helvetica">40-1KTXLDT<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span></font></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; "><font face=3D"Helvetica" size=3D"3" style=3D"font: =
12.0px Helvetica">40-2KTXLDT2</font></div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; "><font =
face=3D"Helvetica" size=3D"3" style=3D"font: 12.0px Helvetica">42 =
KTNC<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span></font></div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; "><font face=3D"Helvetica" =
size=3D"3" style=3D"font: 12.0px Helvetica">49 KSAOLP<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span></font></div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; "><font face=3D"Helvetica" =
size=3D"3" style=3D"font: 12.0px Helvetica">58 KQCA<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span></font></div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; "><font face=3D"Helvetica" =
size=3D"3" style=3D"font: 12.0px Helvetica">58-1KQCADT<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span></font></div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; "><font face=3D"Helvetica" =
size=3D"3" style=3D"font: 12.0px Helvetica">60 KSTVLP</font></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; "><font face=3D"Helvetica" size=3D"3" style=3D"font: =
12.0px Helvetica">64 KTFK</font></div></div></div></div></body></html>=

--Apple-Mail-1--276419705--


--===============0994157671==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0994157671==--
