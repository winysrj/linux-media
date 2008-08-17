Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.172])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <johan.vanderkolk@gmail.com>) id 1KUmfs-0003yn-HS
	for linux-dvb@linuxtv.org; Sun, 17 Aug 2008 20:08:21 +0200
Received: by wf-out-1314.google.com with SMTP id 27so1669070wfd.17
	for <linux-dvb@linuxtv.org>; Sun, 17 Aug 2008 11:08:15 -0700 (PDT)
Message-ID: <57030da00808171108x41547032i20f59bd88ee5bc44@mail.gmail.com>
Date: Sun, 17 Aug 2008 20:08:15 +0200
From: "Johan van der Kolk" <johan.vanderkolk@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] dvb-ttpci errors only on certain satellite channels
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2059643195=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============2059643195==
Content-Type: multipart/alternative;
	boundary="----=_Part_100045_31993214.1218996495292"

------=_Part_100045_31993214.1218996495292
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi

I am getting this error, only when watching or recording certain
(unfortunately most of the dutch) satellite channels.

The receiver card is a FF 2.1 Hauppauge (Nexus-s)

 dmesg |tail
[ 8683.364276] dvb-ttpci: StartHWFilter error  buf 0b07 0010 08cf b96a
ret 0  handle ffff
[ 8684.401584] dvb-ttpci: StartHWFilter error  buf 0b07 0010 08d4 b96a
ret 0  handle ffff
[ 8685.436105] dvb-ttpci: StartHWFilter error  buf 0b07 0010 08d5 b96a
ret 0  handle ffff
[ 8686.470599] dvb-ttpci: StartHWFilter error  buf 0b07 0010 08d6 b96a
ret 0  handle ffff
[ 8687.506259] dvb-ttpci: StartHWFilter error  buf 0b07 0010 08de b96a
ret 0  handle ffff
[ 8688.547456] dvb-ttpci: StartHWFilter error  buf 0b07 0010 08df b96a
ret 0  handle ffff
[ 8689.581923] dvb-ttpci: StartHWFilter error  buf 0b07 0010 08e0 b96a
ret 0  handle ffff
[ 8690.621384] dvb-ttpci: StartHWFilter error  buf 0b07 0010 08e8 b96a
ret 0  handle ffff
[ 8691.662852] dvb-ttpci: StartHWFilter error  buf 0b07 0010 08ed b96a
ret 0  handle ffff
[ 8692.697318] dvb-ttpci: StartHWFilter error  buf 0b07 0010 08f7 b96a
ret 0  handle ffff


I tried to eliminate common factors between working and erroneous
channels.
So far I think I ruled out....Symbol rate, FEC, frequency, transponder,
provider.

In most cases the sequence repeats itself, sometimes after 2 errors,
sometimes
after more errors. Judging from the display quality, also the
signalstrength is good. (except from a thin horizontal line where the screen
seems to split)
I tried firmware versions d and f and use the latest v4l-dvb drivers

dvb_core               81404  2 stv0299,dvb_ttpci
saa7146_vv             50304  1 dvb_ttpci
saa7146                20360  2 dvb_ttpci,saa7146_vv

Since this happens every second, its filling up my logs quite well...I
cant even troubleshoot something else..

Any help is greatly appreciated, even a suggestion for a good replacement
receiver card, if this is a problem with my card. It has to support 2 CI
interfaces though.

Johan

------=_Part_100045_31993214.1218996495292
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Hi<br>
<br>
I am getting this error, only when watching or recording certain<br>
(unfortunately most of the dutch) satellite channels.<br>
<br>
The receiver card is a FF 2.1 Hauppauge (Nexus-s)<br>
<br>
&nbsp;dmesg |tail<br>
[ 8683.364276] dvb-ttpci: StartHWFilter error &nbsp;buf 0b07 0010 08cf b96a<br>
ret 0 &nbsp;handle ffff<br>
[ 8684.401584] dvb-ttpci: StartHWFilter error &nbsp;buf 0b07 0010 08d4 b96a<br>
ret 0 &nbsp;handle ffff<br>
[ 8685.436105] dvb-ttpci: StartHWFilter error &nbsp;buf 0b07 0010 08d5 b96a<br>
ret 0 &nbsp;handle ffff<br>
[ 8686.470599] dvb-ttpci: StartHWFilter error &nbsp;buf 0b07 0010 08d6 b96a<br>
ret 0 &nbsp;handle ffff<br>
[ 8687.506259] dvb-ttpci: StartHWFilter error &nbsp;buf 0b07 0010 08de b96a<br>
ret 0 &nbsp;handle ffff<br>
[ 8688.547456] dvb-ttpci: StartHWFilter error &nbsp;buf 0b07 0010 08df b96a<br>
ret 0 &nbsp;handle ffff<br>
[ 8689.581923] dvb-ttpci: StartHWFilter error &nbsp;buf 0b07 0010 08e0 b96a<br>
ret 0 &nbsp;handle ffff<br>
[ 8690.621384] dvb-ttpci: StartHWFilter error &nbsp;buf 0b07 0010 08e8 b96a<br>
ret 0 &nbsp;handle ffff<br>
[ 8691.662852] dvb-ttpci: StartHWFilter error &nbsp;buf 0b07 0010 08ed b96a<br>
ret 0 &nbsp;handle ffff<br>
[ 8692.697318] dvb-ttpci: StartHWFilter error &nbsp;buf 0b07 0010 08f7 b96a<br>
ret 0 &nbsp;handle ffff<br>
<br>
<br>
I tried to eliminate common factors between working and erroneous<br>
channels.<br>
So far I think I ruled out....Symbol rate, FEC, frequency, transponder,<br>
provider.<br>
<br>
In most cases the sequence repeats itself, sometimes after 2 errors, sometimes<br>
after more errors. Judging from the display quality, also the<br>
signalstrength is good. (except from a thin horizontal line where the screen seems to split)<br>
I tried firmware versions d and f and use the latest v4l-dvb drivers<br>
<br>
dvb_core &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 81404 &nbsp;2 stv0299,dvb_ttpci<br>
saa7146_vv &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 50304 &nbsp;1 dvb_ttpci<br>
saa7146 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;20360 &nbsp;2 dvb_ttpci,saa7146_vv<br>
<br>
Since this happens every second, its filling up my logs quite well...I<br>
cant even troubleshoot something else..<br>
<br>
Any help is greatly appreciated, even a suggestion for a good replacement receiver card, if this is a problem with my card. It has to support 2 CI interfaces though.<br>
<br>
Johan</div>

------=_Part_100045_31993214.1218996495292--


--===============2059643195==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2059643195==--
