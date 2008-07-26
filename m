Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 25.mail-out.ovh.net ([91.121.27.228])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <alain@satfans.be>) id 1KMgkz-00034s-UK
	for linux-dvb@linuxtv.org; Sat, 26 Jul 2008 12:12:11 +0200
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Date: Sat, 26 Jul 2008 12:12:05 +0200
From: <alain@satfans.be>
Message-ID: <79f0acaaea6b28d826d7adfc57913eff@localhost>
Subject: [linux-dvb] Fwd: Technotrend 3650 and Ubuntu Heron
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0993502814=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============0993502814==
Content-Type: multipart/alternative;
	boundary="=_815204511a03dbb397b9cb45f710e32c"


--=_815204511a03dbb397b9cb45f710e32c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit



 So I give it one more try, in the hope to find a solution.  
 -------- Original Message --------  
 		SUBJECT: 
 		Technotrend 3650 and Ubuntu Heron
 		DATE: 
 		Wed, 23 Jul 2008 10:27:58 +0200
 		FROM: 
 		TO: 
 		linux-dvb@linuxtv.org
 So thats where I am now.  

 Anyone a last tip before I give up Linux?  
 lsmod | grep dvb
 shows there are no modules running (that is what he asks you about)
 the drivers are compiled on:
 /home/alain/3650/multiproto/
 from there I do make install 
 and it seems to work..
  insmod dvb-core.ko    works....
 insmod dvb-pll.ko  doen't work (and with lsmod I have proved it is
not already loaded somehow)
 root@TELEVISION:~/3650/multiproto/v4l# insmod ./dvb-core.ko 
 root@TELEVISION:~/3650/multiproto/v4l# lsmod | grep dvb
 dvb_core               89212  0 
 root@TELEVISION:~/3650/multiproto/v4l# insmod ./dvb-pll.ko 
 insmod: error inserting './dvb-pll.ko': -1 Unknown symbol in module 

 -------- Original Message -------- SUBJECT: Technotrend

3650 and
Ubuntu Heron DATE: Sat, 19 Jul 2008 09:46:28 +020 Hi Daniel, thanks
for the good tip. I succeeded with the make but get stuck here now
alain@TELEVISION:~/3650/multiproto/v4l$ sudo insmod dvb-pll.ko [sudo]
password for alain: insmod: error inserting 'dvb-pll.ko': -1 Unknown
symbol in module Even editing the stbalgo.c didn't help. Applying the
patch with the include of the sound driver is done allready. Anyone
another idea or maybe the complied files? Thanks. Alain
-------------- next part -------------- An HTML attachment was
scrubbed... URL:
http://www.linuxtv.org/pipermail/linux-dvb/attachments/20080719/8cb40f8e/attachment-0001.htm
[1]  
 ------------------------------ Message: 5 Date: Fri, 18 Jul 2008
20:59:27 +0200 From:  Subject: Re: [linux-dvb] Technotrend TT3650 S2
USB and multiproto (Daniel Hellstr?m) To: linux-dvb@linuxtv.org [3]
Message-ID:  Content-Type: text/plain; charset="UTF-8" Tjanks Daniel.
So I succeeded with the make and I'm here now: On Fri, 18 Jul

2008
17:04:03 +0200, linux-dvb-request@linuxtv.org [4] wrote:   

 Send linux-dvb mailing list submissions to   

 linux-dvb@linuxtv.org [3]  

 To subscribe or unsubscribe via the World Wide Web, visit   

 http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb [5]  

 or, via email, send a message with subject or body 'help' to   

 linux-dvb-request@linuxtv.org [4]  

 You can reach the person managing the list at   

 linux-dvb-owner@linuxtv.org [6]   

 When replying, please edit your Subject line so it is more specific 
 

 than "Re: Contents of linux-dvb digest..."   

 ------------------------------   

 Message: 8   

 Date: Fri, 18 Jul 2008 14:22:39 +0000 (UTC)   

 From: Daniel Hellstr?m    

 Subject: Re: [linux-dvb] Technotrend TT3650 S2 USB and multiproto   

 To: linux-dvb@linuxtv.org [3]   

 Message-ID:   

 Content-Type: text/plain; charset=utf-8   

  satfans.be> writes:   

 Hi,   

 I'm trying to use my DVB S2 USB with Ubuntu8.04 and MyTheatre.   

 I found an

how to   


[url]http://www.linuxtv.org/wiki/index.php/TechnoTrend_TT-connect_S2-3650_CI
[9][/url]   

 But I get stuck with the fail of the make.   

 It claims about the audio driver?   

 [QUOTE]make[2]: Entering directory   

 `/usr/src/linux-headers-2.6.24-19-generic'   

 ? CC [M]? /home/alain/3650/multiproto/v4l/em28xx-audio.o   

 Just add the line "#include " above the line that says   

 "#include   

  in the em28xx-audio.c file and run make again and it   

 should   

 succed. It solved the problem for me on heron.   

   

Links:
------
[1]
http://www.linuxtv.org/pipermail/linux-dvb/attachments/20080719/8cb40f8e/attachment-0001.htm
[2] mailto:alain@satfans.be
[3] mailto:linux-dvb@linuxtv.org
[4] mailto:linux-dvb-request@linuxtv.org
[5] http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
[6] mailto:linux-dvb-owner@linuxtv.org
[7] mailto:dvenion@hotmail.com
[8]

mailto:loom.20080718T141911-959@post.gmane.org
[9]
http://www.linuxtv.org/wiki/index.php/TechnoTrend_TT-connect_S2-3650_CI

--=_815204511a03dbb397b9cb45f710e32c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<p>
So I give it one more try, in the hope to find a solution.
</p>
<p>
<br />
<br />
-------- Original Message --------
</p>
<table border=3D"0" cellspacing=3D"0" cellpadding=3D"0">
	<tbody>
		<tr>
			<th align=3D"right" valign=3D"baseline">Subject: </th>
			<td>Technotrend 3650 and Ubuntu Heron</td>
		</tr>
		<tr>
			<th align=3D"right" valign=3D"baseline">Date: </th>
			<td>Wed, 23 Jul 2008 10:27:58 +0200</td>
		</tr>
		<tr>
			<th align=3D"right" valign=3D"baseline">From: </th>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<th align=3D"right" valign=3D"baseline">To: </th>
			<td>linux-dvb@linuxtv.org</td>
		</tr>
	</tbody>
</table>
<br />
<!--[if gte mso 9]><xml>
<w:WordDocument>
<w:View>Normal</w:View>
<w:Zoom>0</w:Zoom>
<w:HyphenationZone>21</w:HyphenationZone>
<w:DoNotOptimizeForBrowser/>
</w:WordDocument>
</xml><![endif]-->
<!--
/* Font Definitions */
@font-face
{font-family:"Humanst521 BT";
panose-1:2 11 6 2 2 2 4 2 2 4;
mso-font-charset:0;
mso-generic-font-family:swiss;
mso-font-pitch:variable;
mso-font-signature:135 0 0 0 27 0;}
@font-face
{font-family:"Arial Unicode MS";
panose-1:2 11 6 4 2 2 2 2 2 4;
mso-font-charset:128;
mso-generic-font-family:swiss;
mso-font-pitch:variable;
mso-font-signature:-1 -369098753 63 0 4129279 0;}
@font-face
{font-family:"\@Arial Unicode MS";
panose-1:2 11 6 4 2 2 2 2 2 4;
mso-font-charset:128;
mso-generic-font-family:swiss;
mso-font-pitch:variable;
mso-font-signature:-1 -369098753 63 0 4129279 0;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
{mso-style-parent:"";
margin:0pt;
margin-bottom:.0001pt;
mso-pagination:widow-orphan;
font-size:11.0pt;
mso-bidi-font-size:12.0pt;
font-family:"Humanst521 BT";
mso-fareast-font-family:"Times New Roman";
mso-bidi-font-family:"Times New Roman";}
a:link, span.MsoHyperlink
{color:blue;
text-decoration:underline;
text-underline:single;}
a:visited, span.MsoHyperlinkFollowed
{color:purple;
text-decoration:underline;
text-underline:single;}
@page Section1
{size:595.3pt 841.9pt;
margin:70.85pt 70.85pt 70.85pt 70.85pt;
mso-header-margin:35.4pt;
mso-footer-margin:35.4pt;
mso-paper-source:0;}
div.Section1
{page:Section1;}
-->
<p class=3D"MsoNormal">
<span>So that&rsquo;s
where I am now.</span>
</p>
<p class=3D"MsoNormal">
<span>Anyone a
last tip before I give up Linux?</span>
</p>
<p class=3D"MsoNormal">
<span><!--[if !supportEmptyParas]-->&nbsp;<!--[endif]--></span>
</p>
<p class=3D"MsoNormal">
<span>lsmod |
grep dvb<br />
<br />
shows there are no modules running (that is what he asks you about)<br />
<br />
the drivers are compiled on:<br />
/home/alain/3650/multiproto/<br />
<br />
from there I do make install <br />
and it seems to work..<br />
<br />
&nbsp;insmod dvb-core.ko&nbsp;&nbsp;&nbsp; works....<br />
<br />
<br />
insmod dvb-pll.ko&nbsp; doen't work (and with lsmod I have proved it is not
already loaded somehow)<br />
<br />
root@TELEVISION:~/3650/multiproto/v4l# insmod ./dvb-core.ko <br />
root@TELEVISION:~/3650/multiproto/v4l# lsmod | grep dvb<br />
dvb_core&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;
89212&nbsp; 0 <br />
root@TELEVISION:~/3650/multiproto/v4l# insmod ./dvb-pll.ko <br />
insmod: error inserting './dvb-pll.ko': -1 Unknown symbol in module</span>
</p>
<p class=3D"MsoNormal">
<span><!--[if !supportEmptyParas]-->&nbsp;<!--[endif]--></span>
</p>
<p class=3D"MsoNormal">
<span>--------
Original Message -------- SUBJECT: Technotrend 3650 and Ubuntu Heron DATE: =
Sat,
19 Jul 2008 09:46:28 +020 Hi Daniel, thanks for the good tip. I succeeded w=
ith
the make but get stuck here now alain@TELEVISION:~/3650/multiproto/v4l$ sud=
o
insmod dvb-pll.ko [sudo] password for alain: insmod: error inserting
'dvb-pll.ko': -1 Unknown symbol in module Even editing the stbalgo.c didn't
help. Applying the patch with the include of the sound driver is done allre=
ady.
Anyone another idea or maybe the complied files? Thanks. Alain ------------=
--
next part -------------- An HTML attachment was scrubbed... </span>URL: <a =
href=3D"http://www.linuxtv.org/pipermail/linux-dvb/attachments/20080719/8cb=
40f8e/attachment-0001.htm" target=3D"_blank">http://www.linuxtv.org/piperma=
il/linux-dvb/attachments/20080719/8cb40f8e/attachment-0001.htm</a>
</p>
<p class=3D"MsoNormal">
<!--[if !supportEmptyParas]-->&nbsp;<!--[endif]-->
</p>
<p class=3D"MsoNormal">
<span>------------------------------
Message: 5 Date: Fri, 18 Jul 2008 20:59:27 +0200 From: &lt;</span><a href=
=3D"mailto:alain@satfans.be" onclick=3D"return rcmail.command('compose','al=
ain@satfans.be',this)"><span>alain@satfans.be</span></a><span>&gt; Subject:=
 Re: [linux-dvb]
Technotrend TT3650 S2 USB and multiproto (Daniel Hellstr?m) To: </span><a h=
ref=3D"mailto:linux-dvb@linuxtv.org" onclick=3D"return rcmail.command('comp=
ose','linux-dvb@linuxtv.org',this)"><span>linux-dvb@linuxtv.org</span></a><=
span> Message-ID:
&lt;1e5614ef18e9000783d66e7bbd9586fd@localhost&gt; Content-Type: text/plain=
;
charset=3D&quot;UTF-8&quot; Tjanks Daniel. So I succeeded with the make and=
 I'm
here now: On Fri, 18 Jul 2008 17:04:03 +0200, </span><a href=3D"mailto:linu=
x-dvb-request@linuxtv.org" onclick=3D"return rcmail.command('compose','linu=
x-dvb-request@linuxtv.org',this)"><span>linux-dvb-request@linuxtv.org</span=
></a><span> wrote: </span><span style=3D"font-size: 12pt; font-family: 'Ari=
al Unicode MS'"></span>
</p>
<p style=3D"margin-right: 36pt; margin-left: 36pt" class=3D"MsoNormal">
<span>Send linux-dvb mailing list submissions to </span>
</p>
<p style=3D"margin-right: 36pt; margin-left: 36pt" class=3D"MsoNormal">
<a href=3D"mailto:linux-dvb@linuxtv.org" onclick=3D"return rcmail.command('=
compose','linux-dvb@linuxtv.org',this)">linux-dvb@linuxtv.org</a>
</p>
<p style=3D"margin-right: 36pt; margin-left: 36pt" class=3D"MsoNormal">
<span>To subscribe or unsubscribe via the World Wide
Web, visit </span>
</p>
<p style=3D"margin-right: 36pt; margin-left: 36pt" class=3D"MsoNormal">
<a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" targe=
t=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a>
</p>
<p style=3D"margin-right: 36pt; margin-left: 36pt" class=3D"MsoNormal">
<span>or, via email, send a message with subject or
body 'help' to </span>
</p>
<p style=3D"margin-right: 36pt; margin-left: 36pt" class=3D"MsoNormal">
<a href=3D"mailto:linux-dvb-request@linuxtv.org" onclick=3D"return rcmail.c=
ommand('compose','linux-dvb-request@linuxtv.org',this)">linux-dvb-request@l=
inuxtv.org</a>
</p>
<p style=3D"margin-right: 36pt; margin-left: 36pt" class=3D"MsoNormal">
<span>You can reach the person managing the list at </span>
</p>
<p style=3D"margin-right: 36pt; margin-left: 36pt" class=3D"MsoNormal">
<a href=3D"mailto:linux-dvb-owner@linuxtv.org" onclick=3D"return rcmail.com=
mand('compose','linux-dvb-owner@linuxtv.org',this)"><span>linux-dvb-owner@l=
inuxtv.org</span></a><span> <span></span></span>
</p>
<p style=3D"margin-right: 36pt; margin-left: 36pt" class=3D"MsoNormal">
<span>When replying, please edit your Subject line so
it is more specific </span>
</p>
<p style=3D"margin-right: 36pt; margin-left: 36pt" class=3D"MsoNormal">
<span>than &quot;Re: Contents of linux-dvb
digest...&quot; </span>
</p>
<p style=3D"margin-right: 36pt; margin-left: 36pt" class=3D"MsoNormal">
------------------------------=20
</p>
<p style=3D"margin-right: 36pt; margin-left: 36pt" class=3D"MsoNormal">
<span>Message: 8 </span>
</p>
<p style=3D"margin-right: 36pt; margin-left: 36pt" class=3D"MsoNormal">
<span>Date: Fri, 18 Jul 2008 14:22:39 +0000 (UTC) </span>
</p>
<p style=3D"margin-right: 36pt; margin-left: 36pt" class=3D"MsoNormal">
<span>From: Daniel Hellstr?m &lt;</span><a href=3D"mailto:dvenion@hotmail.c=
om" onclick=3D"return rcmail.command('compose','dvenion@hotmail.com',this)"=
><span>dvenion@hotmail.com</span></a><span>&gt; </span>
</p>
<p style=3D"margin-right: 36pt; margin-left: 36pt" class=3D"MsoNormal">
<span>Subject: Re: [linux-dvb] Technotrend TT3650 S2
USB and multiproto </span>
</p>
<p style=3D"margin-right: 36pt; margin-left: 36pt" class=3D"MsoNormal">
<span>To: </span><a href=3D"mailto:linux-dvb@linuxtv.org" onclick=3D"return=
 rcmail.command('compose','linux-dvb@linuxtv.org',this)"><span>linux-dvb@li=
nuxtv.org</span></a><span> <span></span></span>
</p>
<p style=3D"margin-right: 36pt; margin-left: 36pt" class=3D"MsoNormal">
Message-ID: &lt;<a href=3D"mailto:loom.20080718T141911-959@post.gmane.org" =
onclick=3D"return rcmail.command('compose','loom.20080718T141911-959@post.g=
mane.org',this)">loom.20080718T141911-959@post.gmane.org</a>&gt;
</p>
<p style=3D"margin-right: 36pt; margin-left: 36pt" class=3D"MsoNormal">
<span>Content-Type: text/plain; charset=3Dutf-8 </span>
</p>
<p style=3D"margin-right: 36pt; margin-left: 36pt" class=3D"MsoNormal">
<span> satfans.be&gt; writes: </span>
</p>
<p style=3D"margin-right: 72pt; margin-left: 72pt" class=3D"MsoNormal">
<span>Hi, </span>
</p>
<p style=3D"margin-right: 72pt; margin-left: 72pt" class=3D"MsoNormal">
<span>I'm trying to use my DVB S2 USB with Ubuntu8.04
and MyTheatre. </span>
</p>
<p style=3D"margin-right: 72pt; margin-left: 72pt" class=3D"MsoNormal">
<span>I found an how to </span>
</p>
<p class=3D"MsoNormal">
<span>[url]</span><a href=3D"http://www.linuxtv.org/wiki/index.php/TechnoTr=
end_TT-connect_S2-3650_CI" target=3D"_blank"><span>http://www.linuxtv.org/w=
iki/index.php/TechnoTrend_TT-connect_S2-3650_CI</span></a><span>[/url] </sp=
an>
</p>
<p style=3D"margin-right: 72pt; margin-left: 72pt" class=3D"MsoNormal">
<span>But I get stuck with the fail of the make. </span>
</p>
<p style=3D"margin-right: 72pt; margin-left: 72pt" class=3D"MsoNormal">
<span>It claims about the audio driver? </span>
</p>
<p style=3D"margin-right: 72pt; margin-left: 72pt" class=3D"MsoNormal">
<span>[QUOTE]make[2]: Entering directory </span>
</p>
<p style=3D"margin-right: 36pt; margin-left: 36pt" class=3D"MsoNormal">
<span>`/usr/src/linux-headers-2.6.24-19-generic' </span>
</p>
<p style=3D"margin-right: 72pt; margin-left: 72pt" class=3D"MsoNormal">
<span>? CC [M]?
/home/alain/3650/multiproto/v4l/em28xx-audio.o </span>
</p>
<p style=3D"margin-right: 36pt; margin-left: 36pt" class=3D"MsoNormal">
<span>Just add the line &quot;#include
&quot; above the line that says </span>
</p>
<p style=3D"margin-right: 36pt; margin-left: 36pt" class=3D"MsoNormal">
<span>&quot;#include </span>
</p>
<p style=3D"margin-right: 36pt; margin-left: 36pt" class=3D"MsoNormal">
<span> in the em28xx-audio.c file
and run make again and it </span>
</p>
<p class=3D"MsoNormal">
<span>should </span>
</p>
<p style=3D"margin-right: 36pt; margin-left: 36pt" class=3D"MsoNormal">
<span>succed. It solved the problem for me on heron. </span>
</p>
<p class=3D"MsoNormal">
<span><!--[if !supportEmptyParas]-->&nbsp;<!--[endif]--></span>
</p>

--=_815204511a03dbb397b9cb45f710e32c--




--===============0993502814==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0993502814==--
