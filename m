Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0910.google.com ([209.85.198.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <anluoma@gmail.com>) id 1JbODK-0008G3-FE
	for linux-dvb@linuxtv.org; Mon, 17 Mar 2008 23:53:55 +0100
Received: by rv-out-0910.google.com with SMTP id b22so4037544rvf.41
	for <linux-dvb@linuxtv.org>; Mon, 17 Mar 2008 15:53:47 -0700 (PDT)
Message-ID: <754a11be0803171553p63ac231aicbaeaee4c91b2a2d@mail.gmail.com>
Date: Tue, 18 Mar 2008 00:53:46 +0200
From: "Antti Luoma" <anluoma@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] TNT Pinnacle PCTV DVB-T 72e
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1196347195=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1196347195==
Content-Type: multipart/alternative;
	boundary="----=_Part_9613_17534495.1205794427286"

------=_Part_9613_17534495.1205794427286
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I have trying to get Solo Stick (72e) to work for couple of days, but with
no luck. So what's the current status of this driver?

I did download latest drivers from mercurial today, added PCI_ids for card,
modified dib0700_devices.c (in stk7070p_frontend_attach), added device to
struct dvb_usb_device_properties dib0700_devices[] where
stk7070p_frontend_attach was called.

After that it looked promising:

 usb 6-4: new high speed USB device using ehci_hcd and address 30
[ 6722.607546] usb 6-4: configuration #1 chosen from 1 choice
[ 6722.607622] dvb-usb: found a 'Pinnacle PCTV 72e DVB-T' in warm state.
[ 6722.607648] dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
[ 6722.607724] DVB: registering new adapter (Pinnacle PCTV 72e DVB-T)
[ 6722.731734] dvb_register_frontend
[ 6722.731742] DVB: registering frontend 0 (DiBcom 7000PC)...
[ 6722.811550] DiB0070: successfully identified
[ 6722.811557] dvb-usb: Pinnacle PCTV 72e DVB-T successfully initialized and
connected.


BUT if I do a scan I don't get channels (i checked that I have correct
frequencies):

 #scan -o vdr  fi-Eurajoki
scanning fi-Eurajoki
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 610000000 0 2 9 3 1 2 0
initial transponder 666000000 0 2 9 3 1 2 0
initial transponder 722000000 0 2 9 3 1 2 0
>>> tune to: 610000:I999B8C23D999M64T8G8Y0:T:27500:
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
>>> tune to: 666000:I999B8C23D999M64T8G8Y0:T:27500:
__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: 19 No
such device
>>> tune to: 666000:I999B8C23D999M64T8G8Y0:T:27500:
__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: 19 No
such device
>>> tune to: 722000:I999B8C23D999M64T8G8Y0:T:27500:
__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: 19 No
such device
>>> tune to: 722000:I999B8C23D999M64T8G8Y0:T:27500:
__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: 19 No
such device
dumping lists (0 services)
Done.

Any thoughts??

-- 
-Antti-

------=_Part_9613_17534495.1205794427286
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,<br><br>I have trying to get Solo Stick (72e) to work for couple of days, but with no luck. So what&#39;s the current status of this driver?<br><br>I did download latest drivers from mercurial today, added PCI_ids for card, modified dib0700_devices.c (in stk7070p_frontend_attach), added device to struct dvb_usb_device_properties dib0700_devices[] where stk7070p_frontend_attach was called. <br>
<br>After that it looked promising:<br><br>&nbsp;usb 6-4: new high speed USB device using ehci_hcd and address 30<br>[ 6722.607546] usb 6-4: configuration #1 chosen from 1 choice<br>[ 6722.607622] dvb-usb: found a &#39;Pinnacle PCTV 72e DVB-T&#39; in warm state.<br>
[ 6722.607648] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.<br>[ 6722.607724] DVB: registering new adapter (Pinnacle PCTV 72e DVB-T)<br>[ 6722.731734] dvb_register_frontend<br>[ 6722.731742] DVB: registering frontend 0 (DiBcom 7000PC)...<br>
[ 6722.811550] DiB0070: successfully identified<br>[ 6722.811557] dvb-usb: Pinnacle PCTV 72e DVB-T successfully initialized and connected.<br><br><br>BUT if I do a scan I don&#39;t get channels (i checked that I have correct frequencies):<br>
<br>&nbsp;#scan -o vdr&nbsp; fi-Eurajoki <br>scanning fi-Eurajoki<br>using &#39;/dev/dvb/adapter0/frontend0&#39; and &#39;/dev/dvb/adapter0/demux0&#39;<br>initial transponder 610000000 0 2 9 3 1 2 0<br>initial transponder 666000000 0 2 9 3 1 2 0<br>
initial transponder 722000000 0 2 9 3 1 2 0<br>&gt;&gt;&gt; tune to: 610000:I999B8C23D999M64T8G8Y0:T:27500:<br>WARNING: filter timeout pid 0x0011<br>WARNING: filter timeout pid 0x0000<br>WARNING: filter timeout pid 0x0010<br>
&gt;&gt;&gt; tune to: 666000:I999B8C23D999M64T8G8Y0:T:27500:<br>__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: 19 No such device<br>&gt;&gt;&gt; tune to: 666000:I999B8C23D999M64T8G8Y0:T:27500:<br>__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: 19 No such device<br>
&gt;&gt;&gt; tune to: 722000:I999B8C23D999M64T8G8Y0:T:27500:<br>__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: 19 No such device<br>&gt;&gt;&gt; tune to: 722000:I999B8C23D999M64T8G8Y0:T:27500:<br>__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: 19 No such device<br>
dumping lists (0 services)<br>Done.<br><br>Any thoughts??<br clear="all"><br>-- <br>-Antti-

------=_Part_9613_17534495.1205794427286--


--===============1196347195==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1196347195==--
