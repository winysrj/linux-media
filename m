Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <andywhite@gmail.com>) id 1Jqp9j-0003cO-Ub
	for linux-dvb@linuxtv.org; Tue, 29 Apr 2008 14:42:00 +0200
Received: by yw-out-2324.google.com with SMTP id 9so1417043ywe.41
	for <linux-dvb@linuxtv.org>; Tue, 29 Apr 2008 05:41:55 -0700 (PDT)
Message-ID: <d350e5180804290541q6455c0b3s63aafbbc17e424e2@mail.gmail.com>
Date: Tue, 29 Apr 2008 13:41:55 +0100
From: andy <andy.white@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] hauppauge HVR 900H
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0303959809=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0303959809==
Content-Type: multipart/alternative;
	boundary="----=_Part_4834_23766767.1209472915107"

------=_Part_4834_23766767.1209472915107
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,  I got one of these at the weekend, not noticing it's a 'H' version, and
isn't currently supported, an it looks like supplies of the non H version
are low from the usual suppliers.

>From posts, It looks like this is tm6000 based, that I should add the usb id
( 0x2040, 0x6600 )  to tm6000-cards.c and extract the firmware from
emBDA.sys (taken from driver CD).

I am stalled at the firmware extraction, extract_xc3028.pl  doesn't
recognize this and gives a hash error :-), and am confused to there being a
single firmware if there are two chipsets (tm6000 and em28xx) covered in the
one emBDA.sys ?

I tried hvr 12x0 firmware and got
 7377.869117] xc2028 0-0061: Loading 80 firmware images from
tm6000-xc3028.fw, type: xc2028 firmware, ver 2.7
[ 7377.869226] xc2028 0-0061: Firmware type SCODE (60000000), id 0 is
corrupted (size=6704, expected 12586192)

I also tried to compile firmware-tool, but it has problems compiling.

Before I sink many more hours into this, has any made any progress with this
card or can point me in the right direction ?

------=_Part_4834_23766767.1209472915107
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,&nbsp; I got one of these at the weekend, not noticing it&#39;s a &#39;H&#39;
version, and isn&#39;t currently supported, an it looks like supplies of
the non H version are low from the usual suppliers.<br><br>From posts,
It looks like this is tm6000 based, that I should add the usb id (
0x2040, 0x6600 )&nbsp; to tm6000-cards.c and extract the firmware from
emBDA.sys (taken from driver CD).<br>
<br>I am stalled at the firmware extraction, extract_xc3028.pl&nbsp; doesn&#39;t
recognize this and gives a hash error :-), and am confused to there
being a single firmware if there are two chipsets (tm6000 and em28xx)
covered in the one emBDA.sys ?<br>
<br>I tried hvr 12x0 firmware and got<br>&nbsp;7377.869117] xc2028 0-0061: Loading 80 firmware images from tm6000-xc3028.fw, type: xc2028 firmware, ver 2.7<br>[ 7377.869226] xc2028 0-0061: Firmware type SCODE (60000000), id 0 is corrupted (size=6704, expected 12586192)<br>

<br>I also tried to compile firmware-tool, but it has problems compiling.<br><br>Before I sink many more hours into this, has any made any progress with this card or can point me in the right direction ?

------=_Part_4834_23766767.1209472915107--


--===============0303959809==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0303959809==--
