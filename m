Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]
	helo=sasl.smtp.pobox.com) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <torgeir@pobox.com>) id 1Khjlt-0001x8-Vj
	for linux-dvb@linuxtv.org; Mon, 22 Sep 2008 13:40:08 +0200
Message-Id: <C581EFB1-475B-466C-9B6A-AC8FDD6C0183@pobox.com>
From: Torgeir Veimo <torgeir@pobox.com>
To: Darron Broad <darron@kewl.org>, linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <7755.1222066749@kewl.org>
Mime-Version: 1.0 (Apple Message framework v929.2)
Date: Mon, 22 Sep 2008 21:39:35 +1000
References: <C8AA13C7-C91C-457F-A53D-386F74787902@pobox.com>
	<7755.1222066749@kewl.org>
Subject: Re: [linux-dvb] skystar 2 usb IR receiver with other remotes
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0130581378=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============0130581378==
Content-Type: multipart/alternative; boundary=Apple-Mail-5--1036759889


--Apple-Mail-5--1036759889
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit


On 22 Sep 2008, at 16:59, Darron Broad wrote:

> In message <C8AA13C7-C91C-457F-A53D-386F74787902@pobox.com>, Torgeir  
> Veimo wrote:
>
> lo
>
>> I'm looking for information about how to use a skystar 2 usb IR  
>> remote
>> sensor, type USB IR receiver 0900/3704, with other remotes than the
>> originally supplied Technisat TTS35AI remote.

> Some presses on a hauppauge remote:
>> cat /dev/hidraw5
> "5"5"5"5111222
>
> cya


Nice! But which driver is the one to use with lirc? I tried using a  
few different ones, and I always get

kernel:hidraw: unsupported ioctl() 5401

- when I start irw.

-- 
Torgeir Veimo
torgeir@pobox.com





--Apple-Mail-5--1036759889
Content-Type: text/html;
	charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

<html><body style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; =
-webkit-line-break: after-white-space; "><br>On 22 Sep 2008, at 16:59, =
Darron Broad wrote:<br><br><blockquote type=3D"cite">In message &lt;<a =
href=3D"mailto:C8AA13C7-C91C-457F-A53D-386F74787902@pobox.com">C8AA13C7-C9=
1C-457F-A53D-386F74787902@pobox.com</a>>, Torgeir Veimo =
wrote:<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote =
type=3D"cite">lo<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite"><blockquote =
type=3D"cite">I'm looking for information about how to use a skystar 2 =
usb IR remote<br></blockquote></blockquote><blockquote =
type=3D"cite"><blockquote type=3D"cite">sensor, type USB IR receiver =
0900/3704, with other remotes than =
the<br></blockquote></blockquote><blockquote type=3D"cite"><blockquote =
type=3D"cite">originally supplied Technisat TTS35AI =
remote.<br></blockquote></blockquote><br><blockquote type=3D"cite">Some =
presses on a hauppauge remote:<br></blockquote><blockquote =
type=3D"cite"><blockquote type=3D"cite">cat =
/dev/hidraw5<br></blockquote></blockquote><blockquote =
type=3D"cite">"5"5"5"5111222<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote =
type=3D"cite">cya<br></blockquote><br><br>Nice! But which driver is the =
one to use with lirc? I tried using a few different ones, and I always =
get<br><br>kernel:hidraw: unsupported ioctl() 5401<br><br>- when I start =
irw.<br><br><div apple-content-edited=3D"true"> <span =
class=3D"Apple-style-span" style=3D"border-collapse: separate; color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant: normal; font-weight: normal; letter-spacing: =
normal; line-height: normal; orphans: 2; text-align: auto; text-indent: =
0px; text-transform: none; white-space: normal; widows: 2; word-spacing: =
0px; -webkit-border-horizontal-spacing: 0px; =
-webkit-border-vertical-spacing: 0px; =
-webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0; "><div style=3D"word-wrap: =
break-word; -webkit-nbsp-mode: space; -webkit-line-break: =
after-white-space; "><span class=3D"Apple-style-span" =
style=3D"border-collapse: separate; color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant: normal; =
font-weight: normal; letter-spacing: normal; line-height: normal; =
orphans: 2; text-indent: 0px; text-transform: none; white-space: normal; =
widows: 2; word-spacing: 0px; -webkit-border-horizontal-spacing: 0px; =
-webkit-border-vertical-spacing: 0px; =
-webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px; "><div style=3D"word-wrap: =
break-word; -webkit-nbsp-mode: space; -webkit-line-break: =
after-white-space; "><div>--&nbsp;</div><div>Torgeir Veimo</div><div><a =
href=3D"mailto:torgeir@pobox.com">torgeir@pobox.com</a></div><div><br></di=
v></div></span><br class=3D"Apple-interchange-newline"></div></span><br =
class=3D"Apple-interchange-newline"> </div><br></body></html>=

--Apple-Mail-5--1036759889--


--===============0130581378==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0130581378==--
