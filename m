Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.29])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <arianus@gmail.com>) id 1Kvpwp-00036b-7n
	for linux-dvb@linuxtv.org; Fri, 31 Oct 2008 10:05:39 +0100
Received: by yw-out-2324.google.com with SMTP id 3so446866ywj.41
	for <linux-dvb@linuxtv.org>; Fri, 31 Oct 2008 02:05:35 -0700 (PDT)
Message-ID: <fca40140810310205n574ac1baje639411e8395dbd2@mail.gmail.com>
Date: Fri, 31 Oct 2008 11:05:35 +0200
From: "Bunyamin VICIL" <bvicil@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <fca40140810310204u12c38827w237bf6a060702b72@mail.gmail.com>
MIME-Version: 1.0
References: <fca40140810310204u12c38827w237bf6a060702b72@mail.gmail.com>
Subject: [linux-dvb] tm6000 compling issues
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1313012823=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1313012823==
Content-Type: multipart/alternative;
	boundary="----=_Part_19087_21710554.1225443935261"

------=_Part_19087_21710554.1225443935261
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

hi there, i am new member of this list. my friend bring me a usb tvbox that
has trident tv master 5600 chipset. i am using Pardus Linux. when i search
how can i install it to my operating system i found linuxtv.org wiki
message[1]. i make all of these but when i give "make" command, the making
process fails and give me an error. then i found linuxtv.org maillist
message[2]. i made changes but now there is an another error message
appears.

"
~/setups/v4l-dvb/v4l/tm6000.c: In function 'probe':
~/setups/v4l-dvb/v4l/tm6000.c:2005: error: 'adapter_nums' undeclared (first
use in this function)
~/setups/v4l-dvb/v4l/tm6000.c:2005: error: (Each undeclared identifier is
reported only once
~/setups/v4l-dvb/v4l/tm6000.c:2005: error: for each function it appears in.)
~/setups/v4l-dvb/v4l/tm6000.c:2059: warning: label 'err' defined but not
used
"

i googled but have no search results. what must i do to fix this?

thanks lot


[1] http://linuxtv.org/v4lwiki/index.php/Trident_TM6000#TM6000_based_Devices
[2] http://www.linuxtv.org/pipermail/linux-dvb/2008-April/025687.html

------=_Part_19087_21710554.1225443935261
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div class="gmail_quote">hi there, i am new member of this list. my friend bring me a usb tvbox that has trident tv master 5600 chipset. i am using Pardus Linux. when i search how can i install it to my operating system i found <a href="http://linuxtv.org" target="_blank">linuxtv.org</a> wiki message[1]. i make all of these but when i give &quot;make&quot; command, the making process fails and give me an error. then i found <a href="http://linuxtv.org" target="_blank">linuxtv.org</a> maillist message[2]. i made changes but now there is an another error message appears. <br>

<br>&quot;<br>~/setups/v4l-dvb/v4l/tm6000.c: In function &#39;probe&#39;:<br>~/setups/v4l-dvb/v4l/tm6000.c:2005: error: &#39;adapter_nums&#39; undeclared (first use in this function)<br>~/setups/v4l-dvb/v4l/tm6000.c:2005: error: (Each undeclared identifier is reported only once<br>

~/setups/v4l-dvb/v4l/tm6000.c:2005: error: for each function it appears in.)<br>~/setups/v4l-dvb/v4l/tm6000.c:2059: warning: label &#39;err&#39; defined but not used<br>&quot;<br><br>i googled but have no search results. what must i do to fix this?<br>

<br>thanks lot<br><br><br>[1] <a href="http://linuxtv.org/v4lwiki/index.php/Trident_TM6000#TM6000_based_Devices" target="_blank">http://linuxtv.org/v4lwiki/index.php/Trident_TM6000#TM6000_based_Devices</a><br>[2] <a href="http://www.linuxtv.org/pipermail/linux-dvb/2008-April/025687.html" target="_blank">http://www.linuxtv.org/pipermail/linux-dvb/2008-April/025687.html</a><br>

</div><br>

------=_Part_19087_21710554.1225443935261--


--===============1313012823==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1313012823==--
