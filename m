Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.239])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bqproductions@gmail.com>) id 1JnbaS-00030w-Iu
	for linux-dvb@linuxtv.org; Sun, 20 Apr 2008 17:36:18 +0200
Received: by wx-out-0506.google.com with SMTP id s11so1037845wxc.17
	for <linux-dvb@linuxtv.org>; Sun, 20 Apr 2008 08:36:11 -0700 (PDT)
Message-ID: <3064975c0804200836g22e3f5fcg80f386e598ac5142@mail.gmail.com>
Date: Sun, 20 Apr 2008 10:36:10 -0500
From: "Bob Quincy" <bqproductions@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] kworld 340u
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1819571728=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1819571728==
Content-Type: multipart/alternative;
	boundary="----=_Part_14530_1565471.1208705770552"

------=_Part_14530_1565471.1208705770552
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I have a kworld 340u ATSC USB tuner.

These are the major (or only) chips on the board

tda18271 (tuner)
lgdt3304 (vsb/qam?)
em2870 (usb video bridge)

And I see there are modules for these in the v4l source.

I modified the em28xx-cards source to recognize the card as an unknown.

If i specifiy the 950 card, it seems to pick up the lgt3304 and the em2870
chip.

However, I can't seem to get it recognize the tuner. I changed to the 950
definition (at least I think) to include the TDA_8290

It still seems like its loading the old tuner modules.

Any one get this card working?

Any clues on places to modify?

------=_Part_14530_1565471.1208705770552
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I have a kworld 340u ATSC USB tuner.<br><br>These are the major (or only) chips on the board<br><br>tda18271 (tuner)<br>lgdt3304 (vsb/qam?)<br>em2870 (usb video bridge)<br><br>And I see there are modules for these in the v4l source. <br>
<br>I modified the em28xx-cards source to recognize the card as an unknown.<br><br>If i specifiy the 950 card, it seems to pick up the lgt3304 and the em2870 chip. <br><br>However, I can&#39;t seem to get it recognize the tuner. I changed to the 950 definition (at least I think) to include the TDA_8290 <br>
<br>It still seems like its loading the old tuner modules.<br><br>Any one get this card working? <br><br>Any clues on places to modify?<br><br><br><br><br>

------=_Part_14530_1565471.1208705770552--


--===============1819571728==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1819571728==--
