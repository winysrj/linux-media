Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.154])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ariken@gmail.com>) id 1Kskgk-0006N8-Df
	for linux-dvb@linuxtv.org; Wed, 22 Oct 2008 22:52:18 +0200
Received: by fg-out-1718.google.com with SMTP id e21so429820fga.25
	for <linux-dvb@linuxtv.org>; Wed, 22 Oct 2008 13:52:15 -0700 (PDT)
Message-ID: <8d4787ed0810221352g66a4daa0n288db633777998f0@mail.gmail.com>
Date: Wed, 22 Oct 2008 22:52:14 +0200
From: Ariken <ariken@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] mantis and stb6100 RACK failed solved
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1569496837=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1569496837==
Content-Type: multipart/alternative;
	boundary="----=_Part_2655_7151360.1224708734863"

------=_Part_2655_7151360.1224708734863
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This is a patch for http://mercurial.intuxication.org/hg/s2-liplianin

mantis:
added SKYSTAR HD2 with 0x03 device id.
02:0d.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI
Bridge Controller [Ver 1.0] (rev 01)
        Subsystem: Device 1ae4:0003

stb6100:
*mantis_ack_wait* (*0*): *Slave RACK Fail*
The I2C Repeater must enabled to communicate with the stb6100 via 0x60.


Andrea

------=_Part_2655_7151360.1224708734863
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This is a patch for <a href="http://mercurial.intuxication.org/hg/s2-liplianin">http://mercurial.intuxication.org/hg/s2-liplianin</a><br><br>mantis: <br>added SKYSTAR HD2 with 0x03 device id.<br>02:0d.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI Bridge Controller [Ver 1.0] (rev 01)<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Subsystem: Device 1ae4:0003<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <br>stb6100:<br><em>mantis_ack_wait</em> (<em>0</em>): <em>Slave RACK Fail</em> <br>The I2C Repeater must enabled to communicate with the stb6100 via 0x60.<br><br><br>Andrea<br>


------=_Part_2655_7151360.1224708734863--


--===============1569496837==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1569496837==--
