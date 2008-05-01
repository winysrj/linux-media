Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.231])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <f.peder@gmail.com>) id 1JrTnw-0003ue-DL
	for linux-dvb@linuxtv.org; Thu, 01 May 2008 10:06:15 +0200
Received: by rv-out-0506.google.com with SMTP id b25so538130rvf.41
	for <linux-dvb@linuxtv.org>; Thu, 01 May 2008 01:06:07 -0700 (PDT)
Message-ID: <53b66b650805010106m45e02255r1c821b494471c38a@mail.gmail.com>
Date: Thu, 1 May 2008 10:06:06 +0200
From: "Fabrizio Pedersoli" <f.peder@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] wintv nova-td tuning fail
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0231967159=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0231967159==
Content-Type: multipart/alternative;
	boundary="----=_Part_2939_1410837.1209629167030"

------=_Part_2939_1410837.1209629167030
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all,

I can't get working the nova-td under debian lenny... when i try to scan
both with roof antenna or 2 antennas i always get :

-----

scan /usr/share/doc/dvb-utils/examples/scan/dvb-t/it-Milano 1>channel.conf

scanning /usr/share/doc/dvb-utils/examples/scan/dvb-t/it-Milano
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 818000000 0 2 1 3 1 0 0
initial transponder 482000000 0 2 1 3 1 0 0
initial transponder 842000000 0 2 1 3 1 0 0
initial transponder 506000000 0 2 1 3 1 0 0
initial transponder 706000000 0 2 1 3 1 0 0
initial transponder 538000000 0 2 1 3 1 0 0
>>> tune to:
818000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to:
818000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
(tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to:
482000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to:
482000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
(tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to:
842000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
>>> tune to:
506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
>>> tune to:
706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
>>> tune to:
538000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to:
538000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
(tuning failed)
WARNING: >>> tuning failed!!!
dumping lists (0 services)
Done.

----


thanks.

------=_Part_2939_1410837.1209629167030
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all,<br><br>I can&#39;t get working the nova-td under debian lenny... when i try to scan both with roof antenna or 2 antennas i always get :<br><br>-----<br><br>scan /usr/share/doc/dvb-utils/examples/scan/dvb-t/it-Milano 1&gt;channel.conf<br>
<br>scanning /usr/share/doc/dvb-utils/examples/scan/dvb-t/it-Milano<br>using &#39;/dev/dvb/adapter0/frontend0&#39; and &#39;/dev/dvb/adapter0/demux0&#39;<br>initial transponder 818000000 0 2 1 3 1 0 0<br>initial transponder 482000000 0 2 1 3 1 0 0<br>
initial transponder 842000000 0 2 1 3 1 0 0<br>initial transponder 506000000 0 2 1 3 1 0 0<br>initial transponder 706000000 0 2 1 3 1 0 0<br>initial transponder 538000000 0 2 1 3 1 0 0<br>&gt;&gt;&gt; tune to: 818000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE<br>
WARNING: &gt;&gt;&gt; tuning failed!!!<br>&gt;&gt;&gt; tune to: 818000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)<br>WARNING: &gt;&gt;&gt; tuning failed!!!<br>
&gt;&gt;&gt; tune to: 482000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE<br>WARNING: &gt;&gt;&gt; tuning failed!!!<br>&gt;&gt;&gt; tune to: 482000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)<br>
WARNING: &gt;&gt;&gt; tuning failed!!!<br>&gt;&gt;&gt; tune to: 842000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE<br>WARNING: filter timeout pid 0x0011<br>
WARNING: filter timeout pid 0x0000<br>WARNING: filter timeout pid 0x0010<br>&gt;&gt;&gt; tune to: 506000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE<br>
WARNING: filter timeout pid 0x0011<br>WARNING: filter timeout pid 0x0000<br>WARNING: filter timeout pid 0x0010<br>&gt;&gt;&gt; tune to: 706000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE<br>
WARNING: filter timeout pid 0x0011<br>WARNING: filter timeout pid 0x0000<br>WARNING: filter timeout pid 0x0010<br>&gt;&gt;&gt; tune to: 538000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE<br>
WARNING: &gt;&gt;&gt; tuning failed!!!<br>&gt;&gt;&gt; tune to: 538000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)<br>WARNING: &gt;&gt;&gt; tuning failed!!!<br>
dumping lists (0 services)<br>Done.<br><br>----<br><br><br>thanks.<br><br><br>

------=_Part_2939_1410837.1209629167030--


--===============0231967159==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0231967159==--
