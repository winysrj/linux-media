Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dsl-202-173-134-75.nsw.westnet.com.au ([202.173.134.75]
	helo=mail.lemonrind.net) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex@receptiveit.com.au>) id 1Ksc7M-0002rB-MT
	for linux-dvb@linuxtv.org; Wed, 22 Oct 2008 13:43:15 +0200
Message-Id: <8A7DC3C9-BE07-4E5D-9069-C409F990853A@receptiveit.com.au>
From: Alex Ferrara <alex@receptiveit.com.au>
To: "Mark Callaghan" <mark@lostcow.com>
In-Reply-To: <452AD5616A1D4A2EB6BB6329DEF41E58@marklaptop>
Mime-Version: 1.0 (Apple Message framework v929.2)
Date: Wed, 22 Oct 2008 22:42:32 +1100
References: <00023E2CD2444D05AFE501BA0439DCCF@marklaptop>
	<12A846AD-5D7A-4021-BE5B-063A7AEB70E9@receptiveit.com.au>
	<452AD5616A1D4A2EB6BB6329DEF41E58@marklaptop>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Dvico Dual Digital 4 rev 2 broken in October?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0548781388=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============0548781388==
Content-Type: multipart/alternative; boundary=Apple-Mail-12--592067384


--Apple-Mail-12--592067384
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

On 22/10/2008, at 9:43 PM, Mark Callaghan wrote:

> Thanks Alex. I deleted one of the firmware files (Chris's) and my  
> rev2 is good now. (I had a few fw files in place.)
>
> But I have been having other problems - only one of the two tuners  
> would work, the other reporting "partial lock". Various searches and  
> much digging turned up a suggestion to disable EIT scanning. I  
> disabled the EIT scan in the backend setup (video sources, I  
> think?). But this had no effect. I then went into the database with  
> phpmyadmin, and disabled dvb_eitscan in the capturecard table. And  
> now I get both tuners.
>
> So there is something strange happening, but I'm happy.
>
> Cheers,
> Mark
>


I'm not sure if I mentioned it, but I am running kernel 2.6.27 from  
Ubuntu Intrepid

Good to see that you are having some joy.

Regards
Alex Ferrara

Director
Receptive IT Solutions


--Apple-Mail-12--592067384
Content-Type: text/html;
	charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

<html><body style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; =
-webkit-line-break: after-white-space; "><div><div><div>On 22/10/2008, =
at 9:43 PM, Mark Callaghan wrote:</div><br =
class=3D"Apple-interchange-newline"><blockquote type=3D"cite"><span =
class=3D"Apple-style-span" style=3D"border-collapse: separate; color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant: normal; font-weight: normal; letter-spacing: =
normal; line-height: normal; orphans: 2; text-align: auto; text-indent: =
0px; text-transform: none; white-space: normal; widows: 2; word-spacing: =
0px; -webkit-border-horizontal-spacing: 0px; =
-webkit-border-vertical-spacing: 0px; =
-webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0; "><div bgcolor=3D"#ffffff" =
style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; =
-webkit-line-break: after-white-space; "><div><font face=3D"Arial" =
size=3D"2">Thanks Alex. I deleted one of the firmware files (Chris's) =
and my rev2 is good now. (I had a few fw files in =
place.)</font></div><div><font face=3D"Arial" =
size=3D"2"></font>&nbsp;</div><div><font face=3D"Arial" size=3D"2">But I =
have been having other problems - only one of the two tuners would work, =
the other reporting "partial lock". Various searches and much digging =
turned up a suggestion to disable EIT scanning. I disabled the EIT scan =
in the backend setup (video sources, I think?). But this had no effect. =
I then went into the database with phpmyadmin, and disabled dvb_eitscan =
in the capturecard table. And now I get both =
tuners.</font></div><div><font face=3D"Arial" =
size=3D"2"></font>&nbsp;</div><div><font face=3D"Arial" size=3D"2">So =
there is something strange happening, but I'm =
happy.</font></div><div><font face=3D"Arial" =
size=3D"2"></font>&nbsp;</div><div><font face=3D"Arial" =
size=3D"2">Cheers,</font></div><div><font face=3D"Arial" =
size=3D"2">Mark</font></div><div><font face=3D"Arial" =
size=3D"2"></font>&nbsp;</div></div></span></blockquote></div><div><br></d=
iv>I'm not sure if I mentioned it, but I am running kernel 2.6.27 from =
Ubuntu Intrepid<div><br></div><div>Good to see that you are having some =
joy.</div><div><br></div><div>Regards</div><div =
apple-content-edited=3D"true"><span class=3D"Apple-style-span" =
style=3D"border-collapse: separate; color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant: normal; =
font-weight: normal; letter-spacing: normal; line-height: normal; =
orphans: 2; text-align: auto; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-border-horizontal-spacing: 0px; -webkit-border-vertical-spacing: =
0px; -webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0; "><div style=3D"word-wrap: =
break-word; -webkit-nbsp-mode: space; -webkit-line-break: =
after-white-space; "><div>Alex =
Ferrara</div><div><br></div><div>Director</div><div>Receptive IT =
Solutions</div></div></span> </div><br></div></body></html>=

--Apple-Mail-12--592067384--


--===============0548781388==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0548781388==--
