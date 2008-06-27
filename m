Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ik-out-1112.google.com ([66.249.90.177])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <coolvijet@gmail.com>) id 1KC6Gl-0004xq-A6
	for linux-dvb@linuxtv.org; Fri, 27 Jun 2008 07:13:13 +0200
Received: by ik-out-1112.google.com with SMTP id c21so171887ika.1
	for <linux-dvb@linuxtv.org>; Thu, 26 Jun 2008 22:13:07 -0700 (PDT)
Message-ID: <f29eff0e0806262213t106898dajb62deebb24b4306@mail.gmail.com>
Date: Fri, 27 Jun 2008 10:43:07 +0530
From: "vijet m" <coolvijet@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] scan not working
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2066485558=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============2066485558==
Content-Type: multipart/alternative;
	boundary="----=_Part_8566_24356613.1214543587220"

------=_Part_8566_24356613.1214543587220
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all,
I'm a newbie to this forum and to DVB-T as well.
I'm working on getting DVB-T live player on OMAP processor.
I'm currently using a Pinnacle 2001e Dual Diversity Stick.
I have cross compiled dvb-apps package for OMAP processor.
The linux kernel version I'm using is 2.6.23.
The problem I'm facing is scan is not working on the OMAP board.
I tried w_scan too but it gives the following output.


[root@OMAP3EVM util]# ./w_scan

w_scan version 20080105

Info: using DVB adapter auto detection.

   Found DVB-T frontend. Using adapter /dev/dvb/adapter0/frontend0

-_-_-_-_ Getting frontend capabilities-_-_-_-_

frontend DiBcom 7000PC supports

INVERSION_AUTO

QAM_AUTO

TRANSMISSION_MODE_AUTO

GUARD_INTERVAL_AUTO

HIERARCHY_AUTO

FEC_AUTO

-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_

177500:

184500:

191500:

198500:

205500:

212500:

219500:

226500:

474000:

482000:

490000:

498000:

506000:

514000:

522000:

530000:

538000:

546000:

554000:

562000:

570000:

578000:

586000:

594000:

602000:

610000:

618000:

626000:

634000:

642000:

650000:

658000:

666000:

674000:

682000:

690000:

698000:

706000:

714000:

722000:

730000:

738000:

746000:

754000:

762000:

770000:

778000:

786000:

794000:

802000:

810000:

818000:

826000:

834000:

842000:

850000:

858000:

ERROR: Sorry - i couldn't get any working frequency/transponder

 Nothing to scan!!

dumping lists (0 services)

Done.



Is there any hardware limitation for scan to work?

The OMAP board has 128 MB RAM. Does it pose any limitation on working of
scan and other utilities?



Thanks in advance,

       Vijet M

------=_Part_8566_24356613.1214543587220
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div>Hi all,</div>
<div>I&#39;m a newbie to this forum and to DVB-T as well.</div>
<div>I&#39;m working on getting DVB-T live player on OMAP processor.</div>
<div>I&#39;m currently using a Pinnacle 2001e Dual Diversity Stick.</div>
<div>I have cross compiled dvb-apps package for OMAP processor.</div>
<div>The linux kernel version I&#39;m using is <a href="http://2.6.23.">2.6.23.</a></div>
<div>The problem I&#39;m facing is scan is not working on the OMAP board.</div>
<div>I tried w_scan too but it gives the following output.</div>
<div>&nbsp;</div>
<div>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">[root@OMAP3EVM util]# ./w_scan</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">w_scan version 20080105</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">Info: using DVB adapter auto detection.</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;"><span style="mso-spacerun: yes">&nbsp;&nbsp; </span>Found DVB-T frontend. Using adapter /dev/dvb/adapter0/frontend0</span></p>

<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">-_-_-_-_ Getting frontend capabilities-_-_-_-_</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">frontend DiBcom 7000PC supports</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">INVERSION_AUTO</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">QAM_AUTO</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">TRANSMISSION_MODE_AUTO</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">GUARD_INTERVAL_AUTO</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">HIERARCHY_AUTO</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">FEC_AUTO</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">177500:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">184500:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">191500:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">198500:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">205500:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">212500:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">219500:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">226500:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">474000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">482000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">490000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">498000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">506000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">514000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">522000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">530000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">538000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">546000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">554000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">562000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">570000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">578000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">586000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">594000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">602000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">610000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">618000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">626000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">634000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">642000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">650000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">658000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">666000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">674000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">682000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">690000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">698000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">706000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">714000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">722000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">730000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">738000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">746000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">754000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">762000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">770000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">778000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">786000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">794000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">802000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">810000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">818000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">826000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">834000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">842000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">850000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">858000:</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">ERROR: Sorry - i couldn&#39;t get any working frequency/transponder</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;"><span style="mso-spacerun: yes">&nbsp;</span>Nothing to scan!!</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">dumping lists (0 services)</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">Done.</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;"></span>&nbsp;</p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">Is there any hardware limitation for scan to work?</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">The OMAP board has 128 MB RAM. Does it pose any limitation on working of scan and other utilities?</span></p>

<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;"></span>&nbsp;</p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">Thanks in advance,</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Vijet M</span></p>
<p class="MsoPlainText" style="MARGIN: 0in 0in 0pt"><span style="FONT-FAMILY: &#39;Arial&#39;,&#39;sans-serif&#39;"></span>&nbsp;</p></div>

------=_Part_8566_24356613.1214543587220--


--===============2066485558==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2066485558==--
