Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mu-out-0910.google.com ([209.85.134.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zeno.zoli@gmail.com>) id 1K9TTh-0007oC-Eh
	for linux-dvb@linuxtv.org; Fri, 20 Jun 2008 01:23:42 +0200
Received: by mu-out-0910.google.com with SMTP id w8so394699mue.1
	for <linux-dvb@linuxtv.org>; Thu, 19 Jun 2008 16:23:37 -0700 (PDT)
Message-ID: <45e226e50806191623x2972857fx6683e28830f24f11@mail.gmail.com>
Date: Fri, 20 Jun 2008 01:23:37 +0200
From: "Zeno Zoli" <zeno.zoli@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Twinhan VP-1041 FE_HAS_LOCK Problems DVB-S2 8PSK
	-Horizontal FEC 3/4
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0224763292=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0224763292==
Content-Type: multipart/alternative;
	boundary="----=_Part_3200_7632889.1213917817201"

------=_Part_3200_7632889.1213917817201
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

./szap2 -t2 -a 1 -r -l UNIVERSAL -c /root/.szap/channels.conf "TV 2 Sport HD
1"



excerpt of typical Lock status

status 0a | signal 05aa | snr 002a | ber 103d9399 | unc fffffffe |
status 0a | signal 05aa | snr 002b | ber 103d9399 | unc fffffffe |
status 1a | signal 05aa | snr 002c | ber 0a42b611 | unc fffffffe |
FE_HAS_LOCK
status 0a | signal 05aa | snr 002b | ber 0662ec55 | unc fffffffe |
status 0a | signal 05aa | snr 002b | ber 0662ec55 | unc fffffffe |
status 0a | signal 05aa | snr 002c | ber 0662ec55 | unc fffffffe |
status 1a | signal 05aa | snr 002b | ber 08278033 | unc fffffffe |
FE_HAS_LOCK
status 0a | signal 05aa | snr 002b | ber 08830db3 | unc fffffffe |
status 0a | signal 05aa | snr 002b | ber 00000000 | unc fffffffe |
status 0a | signal 05aa | snr 002b | ber 00000000 | unc fffffffe |

Few problems with non-HD channels regarding lock.

mysetup - mantis
http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_S2_PCI_HD_CI


Anyone got a clue to why my setup has problem getting lock on DVB-S2
transponders on FEC 3/4?


I also get the following error when trying to play MPEG4 eg. Silver HD,
Discovery HD, Nat Geo HD. FEC 7/8 (all vertical)
VIDEO MPEG2(pid=513) AUDIO MPA(pid=644) NO SUBS (yet)!  PROGRAM N. 0
MPEG: FATAL: EOF while searching for sequence header.
Video: Cannot read properties.

PS .I tried the -p switch. Didn't help


Bottom line. Horizontal DVB-S2 no lock. Vertical -. MPEG FATAL. I just love
"Experimental"

------=_Part_3200_7632889.1213917817201
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

./szap2 -t2 -a 1 -r -l UNIVERSAL -c /root/.szap/channels.conf &quot;TV 2 Sport HD 1&quot;<br><br><br><br>excerpt of typical Lock status<br><br>status 0a | signal 05aa | snr 002a | ber 103d9399 | unc fffffffe | <br>status 0a | signal 05aa | snr 002b | ber 103d9399 | unc fffffffe | <br>
status 1a | signal 05aa | snr 002c | ber 0a42b611 | unc fffffffe | FE_HAS_LOCK<br>status 0a | signal 05aa | snr 002b | ber 0662ec55 | unc fffffffe | <br>status 0a | signal 05aa | snr 002b | ber 0662ec55 | unc fffffffe | <br>
status 0a | signal 05aa | snr 002c | ber 0662ec55 | unc fffffffe | <br>status 1a | signal 05aa | snr 002b | ber 08278033 | unc fffffffe | FE_HAS_LOCK<br>status 0a | signal 05aa | snr 002b | ber 08830db3 | unc fffffffe | <br>
status 0a | signal 05aa | snr 002b | ber 00000000 | unc fffffffe | <br>status 0a | signal 05aa | snr 002b | ber 00000000 | unc fffffffe | <br><br>Few problems with non-HD channels regarding lock. <br><br>mysetup - mantis <br>
<a href="http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_S2_PCI_HD_CI">http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_S2_PCI_HD_CI</a><br><br><br>Anyone got a clue to why my setup has problem getting lock on DVB-S2 transponders on FEC 3/4? <br>
<br><br>I also get the following error when trying to play MPEG4 eg. Silver HD, Discovery HD, Nat Geo HD. FEC 7/8 (all vertical)<br>VIDEO MPEG2(pid=513) AUDIO MPA(pid=644) NO SUBS (yet)!&nbsp; PROGRAM N. 0<br>MPEG: FATAL: EOF while searching for sequence header.<br>
Video: Cannot read properties.<br><br>PS .I tried the -p switch. Didn&#39;t help<br><br><br>Bottom line. Horizontal DVB-S2 no lock. Vertical -. MPEG FATAL. I just love &quot;Experimental&quot;<br><br>

------=_Part_3200_7632889.1213917817201--


--===============0224763292==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0224763292==--
