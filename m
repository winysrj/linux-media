Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <benoitpaquindk@gmail.com>) id 1JixoH-00011k-CH
	for linux-dvb@linuxtv.org; Mon, 07 Apr 2008 22:19:26 +0200
Received: by nf-out-0910.google.com with SMTP id d21so666058nfb.11
	for <linux-dvb@linuxtv.org>; Mon, 07 Apr 2008 13:19:17 -0700 (PDT)
Message-ID: <7dd90a210804071319p76ad7d94pd12174b6a5838c4@mail.gmail.com>
Date: Mon, 7 Apr 2008 22:19:16 +0200
From: "Benoit Paquin" <benoitpaquindk@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Sandberg DigiTV DVB-T USB stick(AF9015) now working
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0675895862=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0675895862==
Content-Type: multipart/alternative;
	boundary="----=_Part_14673_1971075.1207599556900"

------=_Part_14673_1971075.1207599556900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I would like to report that the latest driver for the AF9015 based Sandberg
DigiTV stick works (for USB 2.0).
Many thanks to Antti Palosaari for the driver.

/benoit

For the idiots, like me, that do not know much, I did:
hg clone http://linuxtv.org/hg/~anttip/af9015/<http://linuxtv.org/hg/%7Eanttip/af9015/>
cd af9015
make
sudo make install
(add the line dvb-usb-af9015 in /etc/modules)
reboot
plug stick
check dmesg

------=_Part_14673_1971075.1207599556900
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I would like to report that the latest driver for the AF9015 based Sandberg DigiTV stick works (for USB 2.0). <br>Many thanks to Antti Palosaari for the driver.<br><br>/benoit<br><br>For the idiots, like me, that do not know much, I did:<br>
hg clone <a href="http://linuxtv.org/hg/%7Eanttip/af9015/" target="_blank" onclick="return top.js.OpenExtLink(window,event,this)">http://linuxtv.org/hg/~anttip/af9015/</a><br>
cd af9015<br>make<br>sudo make install<br>(add the line dvb-usb-af9015 in /etc/modules)<br>reboot<br>plug stick<br>check dmesg<br>

------=_Part_14673_1971075.1207599556900--


--===============0675895862==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0675895862==--
