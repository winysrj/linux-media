Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [211.144.200.87] (helo=mail.magima.com.cn)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <shenyue@magima.com.cn>) id 1KqkW7-0006cD-RF
	for linux-dvb@linuxtv.org; Fri, 17 Oct 2008 10:17:04 +0200
Message-ID: <000d01c93030$e7fd4b30$61016b0a@ex.magima.com>
From: "karma shen" <shenyue@magima.com.cn>
To: <linux-dvb@linuxtv.org>
Date: Fri, 17 Oct 2008 16:18:13 +0800
MIME-Version: 1.0
Subject: [linux-dvb] hardware section filter support in dvb-usb
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0140937677=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0140937677==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_000A_01C93073.F449A850"

This is a multi-part message in MIME format.

------=_NextPart_000_000A_01C93073.F449A850
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: quoted-printable

hello everyone,

I'm a newbie in linux dvb. Now I'm developing driver for our own dvb-usb =
chip, which has hardware section filter. But I found no interface in =
linux dvb-usb that I can use to control hardware section filter, only =
software section filter is provided in dvb-usb code.

So is there any hardware section filter support in dvb-usb? If no, is =
there any plan to add support for hardware section filter in dvb-usb?

The second question is, why DMX_MAX_FILTER_SIZE is 18? not 14 or any =
other length?

thanks a lot.

karma
------=_NextPart_000_000A_01C93073.F449A850
Content-Type: text/html;
	charset="gb2312"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; charset=3Dgb2312">
<META content=3D"MSHTML 6.00.2900.3429" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT face=3DArial size=3D2>hello everyone,</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>I'm a newbie in linux dvb. Now I'm =
developing=20
driver for our own dvb-usb chip, which has hardware section filter. But =
I found=20
no interface in linux dvb-usb that I can use to control hardware section =
filter,=20
only software section filter is provided in dvb-usb code.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>So is there any hardware section filter =
support in=20
dvb-usb? If no, is there any plan to add support for hardware section =
filter in=20
dvb-usb?</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>The second question is, why =
DMX_MAX_FILTER_SIZE is=20
18? not 14 or any other length?</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>thanks a lot.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>karma</FONT></DIV></BODY></HTML>

------=_NextPart_000_000A_01C93073.F449A850--



--===============0140937677==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0140937677==--
