Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0910.google.com ([209.85.198.191])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1JUIWV-0003gE-Hr
	for linux-dvb@linuxtv.org; Wed, 27 Feb 2008 10:24:25 +0100
Received: by rv-out-0910.google.com with SMTP id b22so2075973rvf.41
	for <linux-dvb@linuxtv.org>; Wed, 27 Feb 2008 01:24:16 -0800 (PST)
Message-ID: <617be8890802270124q55872b13n5819914996312c53@mail.gmail.com>
Date: Wed, 27 Feb 2008 10:24:15 +0100
From: "Eduard Huguet" <eduardhc@gmail.com>
To: linux-dvb@linuxtv.org, "Matthias Schwarzott" <zzam@gentoo.org>
MIME-Version: 1.0
Subject: [linux-dvb] Any improvements on the Avermedia DVB-S Pro (A700)?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0996443092=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0996443092==
Content-Type: multipart/alternative;
	boundary="----=_Part_14141_16721748.1204104255546"

------=_Part_14141_16721748.1204104255546
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi, Matthias
    I've seen that you have new patches for the card on the folder
referenced in the wiki. Unfortunately none of them seems to work with my
card. I'm startint to think that I'm doing something fundamentally wrong...
But anyway, neither Kaffeine nor dvbscan seems to be able to lock to the
satellite signal coming from the antennae (Windows can, though...).

So far I've tried all the available patches, both using use_frontend=0 and
use_frontend=1 options in saa7134-dvb module. In neither case the card can't
lock...

Did you received my message posting the GPIO status and data from Windows
driver? Apparently is different from what you entered in the wiki, I don't
know why. Anyway, I tried to use my values saa7134 initialisation with no
difference...

Regards,
  Eduard

------=_Part_14141_16721748.1204104255546
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi, Matthias<br>&nbsp;&nbsp;&nbsp; I&#39;ve seen that you have new patches for the card on the folder referenced in the wiki. Unfortunately none of them seems to work with my card. I&#39;m startint to think that I&#39;m doing something fundamentally wrong... But anyway, neither Kaffeine nor dvbscan seems to be able to lock to the satellite signal coming from the antennae (Windows can, though...).<br>
<br>So far I&#39;ve tried all the available patches, both using use_frontend=0 and use_frontend=1 options in saa7134-dvb module. In neither case the card can&#39;t lock...<br><br>Did you received my message posting the GPIO status and data from Windows driver? Apparently is different from what you entered in the wiki, I don&#39;t know why. Anyway, I tried to use my values saa7134 initialisation with no difference...<br>
<br>Regards, <br>&nbsp; Eduard<br><br><br><br>&nbsp;&nbsp;&nbsp; <br>

------=_Part_14141_16721748.1204104255546--


--===============0996443092==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0996443092==--
