Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gateway11.websitewelcome.com ([69.93.154.25])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <skerit@kipdola.com>) id 1JzIyH-0003jA-ET
	for linux-dvb@linuxtv.org; Fri, 23 May 2008 00:09:14 +0200
Received: from [77.109.107.89] (port=35736 helo=[192.168.1.3])
	by gator143.hostgator.com with esmtpa (Exim 4.68)
	(envelope-from <skerit@kipdola.com>) id 1JzIy7-00076E-0X
	for linux-dvb@linuxtv.org; Thu, 22 May 2008 17:09:03 -0500
Message-ID: <4835EF00.2030306@kipdola.com>
Date: Fri, 23 May 2008 00:09:04 +0200
From: Jelle De Loecker <skerit@kipdola.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Multiproto annoying compilation error
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0100898949=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--===============0100898949==
Content-Type: multipart/alternative;
 boundary="------------080406050604010801080507"

This is a multi-part message in MIME format.
--------------080406050604010801080507
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi again,

I've recently declared success on installing the multiproto drivers on 
LinuxMCE 0710 (kubuntu 7.10)
After a lot of hard work, I created a guide which did it like a charm ( 
http://skerit.kipdola.com/?p=5&language=en )

My guide instructs you to use the older multiproto version, which makes 
scan work and all.

Now, I reinstalled linuxmce again, but I mistakenly installed the newer 
multiproto_plus version, like previously, nothing loaded:

    [   76.128799] saa7146: register extension 'budget_ci dvb'.
    [   76.238955] Linux video capture interface: v2.00
    [   76.671737] saa7146: register extension 'dvb'.


No bad, I expected it to load nothing.
So I remove all the modules, I delete every bit of source code, I try to 
use my own guide and I get *absolutely nothing*!

    [  192.299179] saa7146: register extension 'budget_ci dvb'.


I've rebooted so many times I've lost count! I've removed all the 
drivers again, rebooted, reinstalled, it just won't load again!

I refuse to reinstall linuxmce just so I can install the right drivers 
from the beginning.

Does anyone have *any* idea as to why it's not working? I'm really 
getting desperate.


--------------080406050604010801080507
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
</head>
<body bgcolor="#ffffff" text="#000000">
Hi again,<br>
<br>
I've recently declared success on installing the multiproto drivers on
LinuxMCE 0710 (kubuntu 7.10)<br>
After a lot of hard work, I created a guide which did it like a charm (
<a class="moz-txt-link-freetext" href="http://skerit.kipdola.com/?p=5&language=en">http://skerit.kipdola.com/?p=5&amp;language=en</a> )<br>
<br>
My guide instructs you to use the older multiproto version, which makes
scan work and all.<br>
<br>
Now, I reinstalled linuxmce again, but I mistakenly installed the newer
multiproto_plus version, like previously, nothing loaded:<br>
<br>
<blockquote>[&nbsp;&nbsp; 76.128799] saa7146: register extension 'budget_ci dvb'.<br>
[&nbsp;&nbsp; 76.238955] Linux video capture interface: v2.00<br>
[&nbsp;&nbsp; 76.671737] saa7146: register extension 'dvb'.<br>
</blockquote>
<br>
No bad, I expected it to load nothing.<br>
So I remove all the modules, I delete every bit of source code, I try
to use my own guide and I get *absolutely nothing*! <br>
<br>
<blockquote>[&nbsp; 192.299179] saa7146: register extension 'budget_ci dvb'.<br>
</blockquote>
<br>
I've rebooted so many times I've lost count! I've removed all the
drivers again, rebooted, reinstalled, it just won't load again! <br>
<br>
I refuse to reinstall linuxmce just so I can install the right drivers
from the beginning.<br>
<br>
Does anyone have *any* idea as to why it's not working? I'm really
getting desperate.<br>
<br>
</body>
</html>

--------------080406050604010801080507--


--===============0100898949==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0100898949==--
