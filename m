Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.180])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gavermer@gmail.com>) id 1JSaX9-0004h5-Fb
	for linux-dvb@linuxtv.org; Fri, 22 Feb 2008 17:13:59 +0100
Received: by wa-out-1112.google.com with SMTP id m28so475254wag.13
	for <linux-dvb@linuxtv.org>; Fri, 22 Feb 2008 08:13:53 -0800 (PST)
Message-ID: <468e5d620802220813q4b39c4ecpb9297db74884547d@mail.gmail.com>
Date: Fri, 22 Feb 2008 17:13:52 +0100
From: "ga ver" <gavermer@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] HVR 4000 firmware not loaded?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1071036087=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1071036087==
Content-Type: multipart/alternative;
	boundary="----=_Part_818_20107939.1203696832949"

------=_Part_818_20107939.1203696832949
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello

In Ubuntu 7.10 with kernel 2.6.22-14.47 I installed a Hauppauge HVR 4000.
>From http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-4000
I made a driver update and a firmware update.
In dmesg the card is recognized.
In dvbsnoop are the current parameters not found

 dvbsnoop -s feinfo -pd 9
dvbsnoop V1.4.00 -- http://dvbsnoop.sourceforge.net/
   DEMUX : /dev/dvb/adapter0/demux0
   DVR   : /dev/dvb/adapter0/dvr0
   FRONTEND: /dev/dvb/adapter0/frontend0

---------------------------------------------------------
FrontEnd Info...
---------------------------------------------------------

Device: /dev/dvb/adapter0/frontend0

Basic capabilities:
    Name: "Conexant CX24116/CX24118"
    Frontend-type:       QPSK (DVB-S)
    Frequency (min):     950.000 MHz
    Frequency (max):     2150.000 MHz
    Frequency stepsiz:   1.011 MHz
    Frequency tolerance: 5000
    Symbol rate (min):     1.000000 MSym/s
    Symbol rate (max):     45.000000 MSym/s
    Symbol rate tolerance: 0 ppm
    Notifier delay: 0 ms
    Frontend capabilities:
        auto inversion
        FEC 1/2
        FEC 2/3
        FEC 3/4
        FEC 4/5
        FEC 5/6
        FEC 6/7
        FEC 7/8
        FEC AUTO
        QPSK

Current parameters:
Error(95): frontend ioctl: Operation not supported

following dmesg is the firmware not loaded

Is the update procedure from
http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-4000
correct?

Thanks in advance

------=_Part_818_20107939.1203696832949
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello<br><br>In Ubuntu 7.10 with kernel 2.6.22-14.47 I installed a Hauppauge HVR 4000.<br>From <a href="http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-4000">http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-4000</a> <br>
I made a driver update and a firmware update.<br>In dmesg the card is recognized.<br>In dvbsnoop are the current parameters not found<br><br>&nbsp;dvbsnoop -s feinfo -pd 9<br>dvbsnoop V1.4.00 -- <a href="http://dvbsnoop.sourceforge.net/">http://dvbsnoop.sourceforge.net/</a> <br>
&nbsp;&nbsp; DEMUX : /dev/dvb/adapter0/demux0<br>&nbsp;&nbsp; DVR&nbsp;&nbsp; : /dev/dvb/adapter0/dvr0<br>&nbsp;&nbsp; FRONTEND: /dev/dvb/adapter0/frontend0<br><br>---------------------------------------------------------<br>FrontEnd Info...<br>---------------------------------------------------------<br>
<br>Device: /dev/dvb/adapter0/frontend0<br><br>Basic capabilities:<br>&nbsp;&nbsp;&nbsp; Name: &quot;Conexant CX24116/CX24118&quot;<br>&nbsp;&nbsp;&nbsp; Frontend-type:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; QPSK (DVB-S)<br>&nbsp;&nbsp;&nbsp; Frequency (min):&nbsp;&nbsp;&nbsp;&nbsp; 950.000 MHz<br>&nbsp;&nbsp;&nbsp; Frequency (max):&nbsp;&nbsp;&nbsp;&nbsp; 2150.000 MHz<br>
&nbsp;&nbsp;&nbsp; Frequency stepsiz:&nbsp;&nbsp; 1.011 MHz<br>&nbsp;&nbsp;&nbsp; Frequency tolerance: 5000<br>&nbsp;&nbsp;&nbsp; Symbol rate (min):&nbsp;&nbsp;&nbsp;&nbsp; 1.000000 MSym/s<br>&nbsp;&nbsp;&nbsp; Symbol rate (max):&nbsp;&nbsp;&nbsp;&nbsp; 45.000000 MSym/s<br>&nbsp;&nbsp;&nbsp; Symbol rate tolerance: 0 ppm<br>&nbsp;&nbsp;&nbsp; Notifier delay: 0 ms<br>
&nbsp;&nbsp;&nbsp; Frontend capabilities:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; auto inversion<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FEC 1/2<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FEC 2/3<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FEC 3/4<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FEC 4/5<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FEC 5/6<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FEC 6/7<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FEC 7/8<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FEC AUTO<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; QPSK<br>
<br>Current parameters:<br>Error(95): frontend ioctl: Operation not supported<br><br>following dmesg is the firmware not loaded<br><br>Is the update procedure from <a href="http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-4000">http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-4000</a><br>
correct?<br><br>Thanks in advance<br><br><br>&nbsp;<br>

------=_Part_818_20107939.1203696832949--


--===============1071036087==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1071036087==--
