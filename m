Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mu-out-0910.google.com ([209.85.134.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <msanders@fenza.com>) id 1KgYIG-0004SI-9M
	for linux-dvb@linuxtv.org; Fri, 19 Sep 2008 07:12:37 +0200
Received: by mu-out-0910.google.com with SMTP id g7so203455muf.1
	for <linux-dvb@linuxtv.org>; Thu, 18 Sep 2008 22:12:32 -0700 (PDT)
Message-ID: <5926395e0809182212k1454836dq1585f56048ae5404@mail.gmail.com>
Date: Fri, 19 Sep 2008 14:42:32 +0930
From: Michael <m72@fenza.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] DVB USB receiver stopped reporting correct USB ID
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1257282404=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1257282404==
Content-Type: multipart/alternative;
	boundary="----=_Part_17922_2256042.1221801152539"

------=_Part_17922_2256042.1221801152539
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I have a Kworld USB DVB-T receiver that used to work on Mythbuntu 8.04. The
driver loaded the firmware correctly (dvb-usb-adstech-usb2-02.fw) and
everything worked OK.

Suddenly, without me having made any config changes, it is not being found
anymore, presumably because it is now reporting a USB ID of 04b4:8613
[CY7C68013 EZ-USB FX2 USB 2.0 Development Kit].

When it worked, it used to report an ID of 06e1:a334 [ADS Technologies,
Inc]. I confirmed the same behavior is the same on another PC (also
mythbuntu 8.04)

I think it is not a linux driver problem - the device actually has a
CY7C68013 in it, so I'm guessing it has somehow "lost" its factory
configuration that tells it is should present an ID of 06e1:a334.

Does this mean it is dead or is there some way to reinitialise it?

------=_Part_17922_2256042.1221801152539
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Hi,<br><br>I have a Kworld USB DVB-T receiver that used to work on Mythbuntu 8.04. The driver loaded the firmware correctly (dvb-usb-adstech-usb2-02.fw) and everything worked OK.<br><br>Suddenly, without me having made any config changes, it is not being found anymore, presumably because it is now reporting a USB ID of 04b4:8613 [CY7C68013 EZ-USB FX2 USB 2.0 Development Kit]. <br>
<br>When it worked, it used to report an ID of  06e1:a334 [ADS Technologies, Inc]. I confirmed the same behavior is the same on another PC (also mythbuntu 8.04)<br>
<br>I think it is not a linux driver problem - the device actually has a CY7C68013 in it, so I&#39;m guessing it has somehow &quot;lost&quot; its factory configuration that tells it is should present an ID of  06e1:a334.<br>
<br>Does this mean it is dead or is there some way to reinitialise it?<br>
<br><br><br><br><br></div>

------=_Part_17922_2256042.1221801152539--


--===============1257282404==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1257282404==--
