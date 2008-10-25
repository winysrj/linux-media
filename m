Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.26])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <alex.betis@gmail.com>) id 1Ktr47-0005xq-Ua
	for linux-dvb@linuxtv.org; Sat, 25 Oct 2008 23:53:00 +0200
Received: by qw-out-2122.google.com with SMTP id 9so635178qwb.17
	for <linux-dvb@linuxtv.org>; Sat, 25 Oct 2008 14:52:55 -0700 (PDT)
Message-ID: <c74595dc0810251452s65154902td934e87560cad9f0@mail.gmail.com>
Date: Sat, 25 Oct 2008 23:52:54 +0200
From: "Alex Betis" <alex.betis@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] [ANNOUNCE] scan-s2 is available, please test
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1119210976=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1119210976==
Content-Type: multipart/alternative;
	boundary="----=_Part_83131_29233875.1224971574975"

------=_Part_83131_29233875.1224971574975
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello all,

I've setup the http://mercurial.intuxication.org/hg/scan-s2/ repository with
scan utility ported to work with Igor's S2API driver.
Driver is available here: http://mercurial.intuxication.org/hg/s2-liplianin/

Special thanks to Igor for his driver and for szap-s2 utility that I've used
as a reference for scan-s2.
Thanks also to someone from the net that posted his changes to scan utility
that allowed it to work with uncommitted diseqc.

Pay attention to parameters (see README as well), I've added some and
removed some that I don't think are needed.

Scan results gave me the same channels as with multiproto driver on all my
satellites, so that confirms also that Igor's driver is working well.

I didn't yet tested the output files with szap-s2 or with VDR, don't have
time right now.
Please test and let me know if changes are needed.

I have only Twinhan 1041 card (stb0899), so I can't test it with DVB-T,
DVB-C and ATSC standarts, but theoretically it should work.

Enjoy,
Alex.

------=_Part_83131_29233875.1224971574975
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr">Hello all,<br><br>I&#39;ve setup the <a href="http://mercurial.intuxication.org/hg/scan-s2/">http://mercurial.intuxication.org/hg/scan-s2/</a> repository with scan utility ported to work with Igor&#39;s S2API driver.<br>
Driver is available here: <a href="http://mercurial.intuxication.org/hg/s2-liplianin/">http://mercurial.intuxication.org/hg/s2-liplianin/</a><br><br>Special thanks to Igor for his driver and for szap-s2 utility that I&#39;ve used as a reference for scan-s2.<br>
Thanks also to someone from the net that posted his changes to scan utility that allowed it to work with uncommitted diseqc.<br><br>Pay attention to parameters (see README as well), I&#39;ve added some and removed some that I don&#39;t think are needed.<br>
<br>Scan results gave me the same channels as with multiproto driver on all my satellites, so that confirms also that Igor&#39;s driver is working well.<br><br>I didn&#39;t yet tested the output files with szap-s2 or with VDR, don&#39;t have time right now. <br>
Please test and let me know if changes are needed.<br><br>I have only Twinhan 1041 card (stb0899), so I can&#39;t test it with DVB-T, DVB-C and ATSC standarts, but theoretically it should work.<br><br>Enjoy,<br>Alex.<br><br>
</div>

------=_Part_83131_29233875.1224971574975--


--===============1119210976==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1119210976==--
