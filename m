Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.245])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1KRR8u-0001MB-8w
	for linux-dvb@linuxtv.org; Fri, 08 Aug 2008 14:32:29 +0200
Received: by an-out-0708.google.com with SMTP id c18so260106anc.125
	for <linux-dvb@linuxtv.org>; Fri, 08 Aug 2008 05:32:23 -0700 (PDT)
Message-ID: <ea4209750808080532h950d84fud047c135551e1ff1@mail.gmail.com>
Date: Fri, 8 Aug 2008 14:32:23 +0200
From: "Albert Comerma" <albert.comerma@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>, zeph7r@gmail.com
MIME-Version: 1.0
Subject: Re: [linux-dvb] Support for Asus My-Cinema U3000Hybrid?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0890769439=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0890769439==
Content-Type: multipart/alternative;
	boundary="----=_Part_58884_18426377.1218198743605"

------=_Part_58884_18426377.1218198743605
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Just to clarify things...

Xceive chips are just tunners, RF chips, mostly analogue with some digital
interface, they don't do anything with usb or comunication with the
computer, for this reason you need the dibcom chip, it's a usb bridge +
decoder + something else...
To start to develop something you must first be sure of what chips it's
using.
If not you can try blindly if modifying the code for the U3000-Mini works or
Pinnacle 320cx (dibcom 7700 + xceive2028) work (you just need to add your
device usb id's).

Albert

------=_Part_58884_18426377.1218198743605
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Just to clarify things...<br><br>Xceive chips are just tunners, RF chips, mostly analogue with some digital interface, they don&#39;t do anything with usb or comunication with the computer, for this reason you need the dibcom chip, it&#39;s a usb bridge + decoder + something else... <br>
To start to develop something you must first be sure of what chips it&#39;s using. <br>If not you can try blindly if modifying the code for the U3000-Mini works or Pinnacle 320cx (dibcom 7700 + xceive2028) work (you just need to add your device usb id&#39;s).<br>
<br>Albert<br></div>

------=_Part_58884_18426377.1218198743605--


--===============0890769439==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0890769439==--
