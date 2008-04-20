Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mu-out-0910.google.com ([209.85.134.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jonestejm@gmail.com>) id 1JnXc1-0002lm-GN
	for linux-dvb@linuxtv.org; Sun, 20 Apr 2008 13:21:42 +0200
Received: by mu-out-0910.google.com with SMTP id i10so990962mue.1
	for <linux-dvb@linuxtv.org>; Sun, 20 Apr 2008 04:21:32 -0700 (PDT)
Message-ID: <293e5e5c0804200421l600aff45n9cc7f67eee775735@mail.gmail.com>
Date: Sun, 20 Apr 2008 20:51:31 +0930
From: "Tom Jones" <jonestejm@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Trying to get a Leadtek Winfast USB dongle working
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1966525182=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1966525182==
Content-Type: multipart/alternative;
	boundary="----=_Part_6159_29130208.1208690491889"

------=_Part_6159_29130208.1208690491889
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello

I'm looking for assistance on my new Leadtek USB TV tuner and saw a post
from Keith Bannister that seemed to apply to my position  (
http://www.linuxtv.org/pipermail/linux-dvb/2007-December/022373.html)

I have two Leadtek Winfast 1000 DVB-T cards that worked with Ubuntu straight
from the box.  They needed to as I 'm very much a novice with Linux.
Unfortunately the motherboard now has no free pci slots so I purchase the
Leadtek usb tuner thinking that there would be no problems.  Unfortunately
it seems to be totally different

With the Leadtek cards I needed to add the following line to the
/etc/modprobe.d/options file (options cx88_dvb).

I'm now guessing that I need to add a line in the file for the usb tuner?

I've already add the file
dvb-usb-dib0700-1.10.fw<http://www.wi-bw.tfh-wildau.de/%7Epboettch/home/linux-dvb-firmware/dvb-usb-dib0700-1.10.fw>
into the firmware directory

Keith wrote

when I connected the stick.

I hopped onto the IRC channel and crope` (thanks mate) advised me to change
dvb-usb-ids.h to

#define USB_PID_WINFAST_DTV_DONGLE_STK7700P        0x6f01




Where and how is this done?

My log(?) message file looks different !!

Keith also wrote

root at oscar <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>:/home/keith/dvb#
lsusb -v -d 0413:6f01


My output is the same

Can anyone please help by advising what steps I'm missing (this old
grandfather is pulling out the last of his grey hair :-)

Regards

Tom Jones

------=_Part_6159_29130208.1208690491889
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello <br><br>I&#39;m looking for assistance on my new Leadtek USB TV tuner and saw a post from Keith Bannister that seemed to apply to my position&nbsp; (<a href="http://www.linuxtv.org/pipermail/linux-dvb/2007-December/022373.html" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">http://www.linuxtv.org/pipermail/linux-dvb/2007-December/022373.html</a>)<br>

<br>I have two Leadtek Winfast 1000 DVB-T cards that worked with Ubuntu
straight from the box.&nbsp; They needed to as I &#39;m very much a novice with
Linux.&nbsp; Unfortunately the motherboard now has no free pci slots so I purchase the
Leadtek usb tuner thinking that there would be no problems.&nbsp; Unfortunately it seems
to be totally different<br>
<br>With the Leadtek cards I needed to add the following line to the
/etc/modprobe.d/options file (options cx88_dvb).&nbsp; <br><br>I&#39;m now guessing that I
need to add a line in the file for the usb tuner?<br><br>I&#39;ve already add the file&nbsp;&nbsp; <a href="http://www.wi-bw.tfh-wildau.de/%7Epboettch/home/linux-dvb-firmware/dvb-usb-dib0700-1.10.fw" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">dvb-usb-dib0700-1.10.fw</a><br>

into the firmware directory<br><br>Keith wrote <br><br><pre>when I connected the stick.<br><br>I hopped onto the IRC channel and crope` (thanks mate) advised me to change<br>dvb-usb-ids.h to<br><br>#define USB_PID_WINFAST_DTV_DONGLE_STK7700P        0x6f01<br>
<br><br><span style="font-family: arial,sans-serif;"><br></span><br></pre>Where and how is this done?<br><br>My log(?) message file looks different !!<br><br>Keith also wrote<br><br><pre><a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">root at oscar</a>:/home/keith/dvb# lsusb -v -d 0413:6f01</pre>

<br>My output is the same<br><br>Can anyone please help by advising what steps I&#39;m missing (this old grandfather is pulling out the last of his grey hair :-)<br><br>Regards<br><span class="sg"><br>Tom Jones</span>

------=_Part_6159_29130208.1208690491889--


--===============1966525182==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1966525182==--
