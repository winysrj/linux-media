Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.156])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <pvs.patel@gmail.com>) id 1JXdSM-0006Bz-Q8
	for linux-dvb@linuxtv.org; Fri, 07 Mar 2008 15:21:59 +0100
Received: by fg-out-1718.google.com with SMTP id 22so399352fge.25
	for <linux-dvb@linuxtv.org>; Fri, 07 Mar 2008 06:21:42 -0800 (PST)
Message-ID: <e57cc13a0803070621w5063a126o2e13f571660468b5@mail.gmail.com>
Date: Fri, 7 Mar 2008 14:21:42 +0000
From: "pankaj patel" <prost2736@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] Nova T-500 firmware download
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1076610904=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1076610904==
Content-Type: multipart/alternative;
	boundary="----=_Part_6139_13197428.1204899702339"

------=_Part_6139_13197428.1204899702339
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

    I wonder if anyone can help me - I have had a working NOVA T-500 setup
on Ubuntu Gutsy for some time now. However,
ever since updating the v4l-dvb drivers yesterday, the cards have stopped
working with "did not find the firmware file
(dvb-usb-dib0700-1.10.fw)". Now this file exists in /lib/firmware and I have
not been able to figure out why the dvb driver
cannot find the file. I have set the debug option and here is the output :-

[ 5245.800255] check for cold 10b8 1e14
[ 5245.800257] check for cold 10b8 1e78
[ 5245.800258] check for cold 2040 7050
[ 5245.800259] check for cold 2040 7060
[ 5245.800261] check for cold 7ca a807
[ 5245.800262] check for cold 7ca b808
[ 5245.800263] check for cold 185b 1e78
[ 5245.800264] check for cold 185b 1e80
[ 5245.800265] check for cold 1584 6003
[ 5245.800266] check for cold 413 6f00
[ 5245.800268] check for cold 7ca b568
[ 5245.800269] check for cold 1044 7001
[ 5245.800270] something went very wrong, device was not found in current
device list - let's see what comes next.
[ 5245.800272] check for cold 2040 9941
[ 5245.800273] check for cold 2040 9950
[ 5245.800794] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in cold
state, will try to load a firmware
[ 5265.793345] dvb-usb: did not find the firmware file. (
dvb-usb-dib0700-1.10.fw) Please see linux/Documentation/dvb/ for more
details on firmware-problems. (-2)

  I have reverted to previous version of v4l-dvb and I still get the above
error. Anyone have any tips on what else I should do ?


-- 
Best regards,
  Pankaj

------=_Part_6139_13197428.1204899702339
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,<br><br>&nbsp;&nbsp;&nbsp; I wonder if anyone can help me - I have had a working NOVA T-500 setup on Ubuntu Gutsy for some time now. However, <br>ever since updating the v4l-dvb drivers yesterday, the cards have stopped working with &quot;did not find the firmware file <br>

(dvb-usb-dib0700-1.10.fw)&quot;. Now this file exists in /lib/firmware and I have not been able to figure out why the dvb driver<br>cannot find the file. I have set the debug option and here is the output :-<br><br clear="all">

[ 5245.800255] check for cold 10b8 1e14<br>[ 5245.800257] check for cold 10b8 1e78<br>[ 5245.800258] check for cold 2040 7050<br>[ 5245.800259] check for cold 2040 7060<br>[ 5245.800261] check for cold 7ca a807<br>[ 5245.800262] check for cold 7ca b808<br>

[ 5245.800263] check for cold 185b 1e78<br>[ 5245.800264] check for cold 185b 1e80<br>[ 5245.800265] check for cold 1584 6003<br>[ 5245.800266] check for cold 413 6f00<br>[ 5245.800268] check for cold 7ca b568<br>[ 5245.800269] check for cold 1044 7001<br>

[ 5245.800270] something went very wrong, device was not found in current device list - let&#39;s see what comes next.<br>[ 5245.800272] check for cold 2040 9941<br>[ 5245.800273] check for cold 2040 9950<br>[ 5245.800794] dvb-usb: found a &#39;Hauppauge Nova-T 500 Dual DVB-T&#39; in cold state, will try to load a firmware<br>

[ 5265.793345] dvb-usb: did not find the firmware file.
(dvb-usb-dib0700-1.10.fw) Please see linux/Documentation/dvb/ for more
details on firmware-problems. (-2)<br><br>&nbsp;
I have reverted to previous version of v4l-dvb and I still get the
above error. Anyone have any tips on what else I should do ?<br>
<br clear="all"><br>-- <br>Best regards, <br>&nbsp;&nbsp;Pankaj

------=_Part_6139_13197428.1204899702339--


--===============1076610904==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1076610904==--
