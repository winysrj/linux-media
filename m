Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dsl-202-173-134-75.nsw.westnet.com.au ([202.173.134.75]
	helo=mail.lemonrind.net) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex@receptiveit.com.au>) id 1Krf8O-0006Ig-Aj
	for linux-dvb@linuxtv.org; Sun, 19 Oct 2008 22:44:23 +0200
Message-Id: <12A846AD-5D7A-4021-BE5B-063A7AEB70E9@receptiveit.com.au>
From: Alex Ferrara <alex@receptiveit.com.au>
To: Mark Callaghan <mark@lostcow.com>
In-Reply-To: <00023E2CD2444D05AFE501BA0439DCCF@marklaptop>
Mime-Version: 1.0 (Apple Message framework v929.2)
Date: Mon, 20 Oct 2008 07:43:39 +1100
References: <00023E2CD2444D05AFE501BA0439DCCF@marklaptop>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Dvico Dual Digital 4 rev 2 broken in October?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0257223908=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============0257223908==
Content-Type: multipart/alternative; boundary=Apple-Mail-8--818799807


--Apple-Mail-8--818799807
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit


On 19/10/2008, at 9:28 PM, Mark Callaghan wrote:

> I have been trying to install drivers for my DVICO Dual Digital 4  
> rev 2 on ubuntu 8.04 (2.6.24-21-generic), following the farly  
> consistent instructions here & there. e.g. https://help.ubuntu.com/community/DViCO_Dual_Digital_4 
>  . But with no success. The v4l_dvb system builds & installs OK, but  
> the card is not found on boot.
>
> I went back to the tip of Sept 28 - and had immediate success.
>
> Perhaps something has broken since then?
>
> Cheers,
> Mark
>
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


I have one of these cards in my system. The Ubuntu website asks you to  
download and install certain firmware files, and I believe this is  
where your problem is. The firmware files refer to Chris Pascoes  
original driver, and the new one uses an extracted firmware from a  
Hauppauge card.

Unfortunately I am writing this email in a hurry as I am late for  
work, but I would check your dmesg output to see if there are any  
messages relating to firmware. The script for extracting the current  
firmware has been put into the kernel source and written by Steve Toth  
I believe.

Regards
Alex Ferrara

Director
Receptive IT Solutions


--Apple-Mail-8--818799807
Content-Type: text/html;
	charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

<html><body style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; =
-webkit-line-break: after-white-space; "><br><div><div>On 19/10/2008, at =
9:28 PM, Mark Callaghan wrote:</div><br =
class=3D"Apple-interchange-newline"><blockquote type=3D"cite"><span =
class=3D"Apple-style-span" style=3D"border-collapse: separate; color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant: normal; font-weight: normal; letter-spacing: =
normal; line-height: normal; orphans: 2; text-align: auto; text-indent: =
0px; text-transform: none; white-space: normal; widows: 2; word-spacing: =
0px; -webkit-border-horizontal-spacing: 0px; =
-webkit-border-vertical-spacing: 0px; =
-webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0; "><div bgcolor=3D"#ffffff"><div><font =
face=3D"Arial" size=3D"2">I have been trying to install drivers for my =
DVICO Dual Digital 4 rev 2 on ubuntu 8.04 (2.6.24-21-generic), following =
the farly consistent instructions here &amp; there. e.g.<span =
class=3D"Apple-converted-space">&nbsp;</span><a =
href=3D"https://help.ubuntu.com/community/DViCO_Dual_Digital_4">https://he=
lp.ubuntu.com/community/DViCO_Dual_Digital_4</a>&nbsp;. But with no =
success. The v4l_dvb system builds &amp; installs OK, but the card is =
not found on boot.</font></div><div><font face=3D"Arial" =
size=3D"2"></font>&nbsp;</div><div><font face=3D"Arial" size=3D"2">I =
went back to the tip of Sept 28 - and had immediate =
success.</font></div><div><font face=3D"Arial" =
size=3D"2"></font>&nbsp;</div><div><font face=3D"Arial" size=3D"2">Perhaps=
 something has broken since then?</font></div><div><font face=3D"Arial" =
size=3D"2"></font>&nbsp;</div><div><font face=3D"Arial" =
size=3D"2">Cheers,</font></div><div><font face=3D"Arial" =
size=3D"2">Mark</font></div><div>&nbsp;</div><div><font face=3D"Arial" =
size=3D"2"></font>&nbsp;</div><div><font face=3D"Arial" =
size=3D"2"></font>&nbsp;</div>____________________________________________=
___<br>linux-dvb mailing list<br><a =
href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br><a =
href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://=
www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a></div></span></block=
quote></div><div><br></div>I have one of these cards in my system. The =
Ubuntu website asks you to download and install certain firmware files, =
and I believe this is where your problem is. The firmware files refer to =
Chris Pascoes original driver, and the new one uses an extracted =
firmware from a Hauppauge card.<div><br></div><div>Unfortunately I am =
writing this email in a hurry as I am late for work, but I would check =
your dmesg output to see if there are any messages relating to firmware. =
The script for extracting the current firmware has been put into the =
kernel source and written by Steve Toth I believe.</div><div><br><div> =
<span class=3D"Apple-style-span" style=3D"border-collapse: separate; =
color: rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; =
font-style: normal; font-variant: normal; font-weight: normal; =
letter-spacing: normal; line-height: normal; orphans: 2; text-align: =
auto; text-indent: 0px; text-transform: none; white-space: normal; =
widows: 2; word-spacing: 0px; -webkit-border-horizontal-spacing: 0px; =
-webkit-border-vertical-spacing: 0px; =
-webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0; "><div style=3D"word-wrap: =
break-word; -webkit-nbsp-mode: space; -webkit-line-break: =
after-white-space; "><div>Regards</div><div>Alex =
Ferrara</div><div><br></div><div>Director</div><div>Receptive IT =
Solutions</div></div></span> </div><br></div></body></html>=

--Apple-Mail-8--818799807--


--===============0257223908==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0257223908==--
