Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.168])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alihmh@gmail.com>) id 1JPfbn-0004Fz-9E
	for linux-dvb@linuxtv.org; Thu, 14 Feb 2008 16:02:43 +0100
Received: by ug-out-1314.google.com with SMTP id o29so2039379ugd.20
	for <linux-dvb@linuxtv.org>; Thu, 14 Feb 2008 07:02:42 -0800 (PST)
Message-ID: <66caf1560802140702p47d8555ckaba79e39f50ad50a@mail.gmail.com>
Date: Thu, 14 Feb 2008 18:32:40 +0330
From: "Ali H.M. Hoseini" <alihmh@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] SkyStar rev 2.8A driver?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1924608003=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1924608003==
Content-Type: multipart/alternative;
	boundary="----=_Part_3067_14337683.1203001360202"

------=_Part_3067_14337683.1203001360202
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I searched linuxtv.org mailing list archive about SkyStar2 rev2.8A driver,
or any suggestion, but I found nothing.

The 2.6.22 kernel initialize B2C2 chip itself, but it could not identify the
frontend for card. The chips used in this card for frontend are conexant
cx24123  and cx24113 .
I tried to load cx24123 module exists in the kernel, but later I found it is
not defined for b2c2-flexcop module to use it, and hence it is not useful.

Could anybody help me?

j. Jikman

------=_Part_3067_14337683.1203001360202
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div>Hi,</div>
<div>&nbsp;</div>
<div>I searched <a href="http://linuxtv.org/">linuxtv.org</a> mailing list archive about SkyStar2 rev2.8A driver, or any suggestion, but I found nothing.<br><br>The 2.6.22 kernel initialize B2C2 chip itself, but it could not identify the frontend for card. The chips used in this card for frontend are conexant cx24123&nbsp; and cx24113 .<br>
I tried to load cx24123 module exists in the kernel, but later I found it is not defined for b2c2-flexcop module to use it, and hence it is not useful.<br><br>Could anybody help me?<br><br>j. Jikman</div>

------=_Part_3067_14337683.1203001360202--


--===============1924608003==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1924608003==--
