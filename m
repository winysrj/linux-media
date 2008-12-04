Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.191])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <leo.thealmighty@gmail.com>) id 1L847K-0005RV-RV
	for linux-dvb@linuxtv.org; Thu, 04 Dec 2008 03:39:03 +0100
Received: by ti-out-0910.google.com with SMTP id w7so3387100tib.13
	for <linux-dvb@linuxtv.org>; Wed, 03 Dec 2008 18:38:55 -0800 (PST)
Message-ID: <401cfcb70812031838r613d8182wa12f2bed5041a999@mail.gmail.com>
Date: Thu, 4 Dec 2008 08:08:55 +0530
From: "leo theGreat" <leo.thealmighty@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] tm6010 - Compiles All Drivers, but not tm6010 Strange!
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0665792670=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0665792670==
Content-Type: multipart/alternative;
	boundary="----=_Part_1994_33276285.1228358335588"

------=_Part_1994_33276285.1228358335588
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Everbody,

I tried to compile the drivers from
'http://linuxtv.org/hg/~mchehab/tm6010/<http://linuxtv.org/hg/%7Emchehab/tm6010/>
'.

I tried 4 days ago archive..... 5 weeks old and 7 months old... all the same
results.

All drivers compile fine... but not tm6000. Compilation runs fine. It
produces around 200+ drivers but not any tm6000 driver. Although tm6000
folder is present in all of these archives. But it remains as source file
only ( like .c, .h etc ) and doesnt get compiled into the driver like other
drivers. As the compilation goes fine without any errors. I am wondering If
I am doing something wrong or is there a different way to do it.

I use 'make' or sometimes 'make all' and then 'make install'.

According to Mark Breddemann's ( on this Mailing List ) post he has
successfully compiled these drivers. Kindly guide me the way also. I know
these drivers are still in the development. But analog support is working.
And i need only that. My Chipset is Trident TV Master  5600 AI.
Kindly help me out! Hope to get a reply soon. :)

Regards,
Sanjeev

------=_Part_1994_33276285.1228358335588
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Everbody,<br><br>I tried to compile the drivers from &#39;<a href="http://linuxtv.org/hg/%7Emchehab/tm6010/" target="_blank">http://linuxtv.org/hg/~mchehab/tm6010/</a>&#39;.<br><br>I tried 4 days ago archive..... 5 weeks old and 7 months old... all the same results.<br>

<br>All drivers compile fine... but not tm6000. Compilation runs fine.
It produces around 200+ drivers but not any tm6000 driver. Although
tm6000 folder is present in all of these archives. But it remains as
source file only ( like .c, .h etc ) and doesnt get compiled into the
driver like other drivers. As the compilation goes fine without any
errors. I am wondering If I am doing something wrong or is there a
different way to do it.<br>
<br>I use &#39;make&#39; or sometimes &#39;make all&#39; and then &#39;make install&#39;.<br><br>
<h1 style="font-weight: normal;" class="YfMhcb"><font size="2"><span id=":6u" class="VrHWId">A</span>ccording to <font size="2"><span id=":6u" class="VrHWId">Mark Breddemann&#39;s ( on this Mailing List ) </span></font>post he has successfully compiled these
drivers. Kindly guide me the way also. I know these drivers are still
in the development. But analog support is working. And i need only
that. My Chipset is Trident TV Master&nbsp; 5600 AI.</font><br></h1>
Kindly help me out! Hope to get a reply soon. :)<br><br>Regards,<br>Sanjeev

------=_Part_1994_33276285.1228358335588--


--===============0665792670==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0665792670==--
