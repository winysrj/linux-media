Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp.ddnet.es ([88.87.135.16])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mcm@moviquity.com>) id 1M2Ma5-0001Hh-7t
	for linux-dvb@linuxtv.org; Fri, 08 May 2009 11:41:25 +0200
From: Miguel <mcm@moviquity.com>
To: linux-dvb@linuxtv.org
Date: Fri, 08 May 2009 11:39:21 +0200
Message-Id: <1241775561.7996.8.camel@McM>
Mime-Version: 1.0
Subject: [linux-dvb] DVB-T USB stick  azurewave AD-TU200
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1363280394=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============1363280394==
Content-Type: multipart/alternative; boundary="=-HDh1Xr+e/mNUOXQSBqLT"


--=-HDh1Xr+e/mNUOXQSBqLT
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi all,

I am searching information about how to get my dvb-t usb stick works
with my machine.

I currently using a ubuntu intrepid os. I have installed the rtl2831u
drivers as it is recommended.

TwinHan/AzureWave AD-TU200 (7047) DVB-T 
Uses a Realtek RTL2831U decoder chip and MaxLinear MXL5003S tuner. USB
ID is 13d3:3216. It seems to work with the realtek experimental driver
(see freecom v4 above)

The problems I have found:

The found device  has not frontend:

mcm@McM:/usr/share/doc/dvb-utils$ tree /dev/dvb/adapter0/
/dev/dvb/adapter0/
|-- demux0
|-- dvr0
`-- net0

So when scanning it fails
scanning /usr/share/doc/dvb-utils/examples/scan/dvb-s/Astra-19.2E
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
main:2247: FATAL: failed to open '/dev/dvb/adapter0/frontend0': 2 No
such file or directory


Other problem I found, which GUI is recommended to be used?

thank you in advance,

Miguel






--=-HDh1Xr+e/mNUOXQSBqLT
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 TRANSITIONAL//EN">
<HTML>
<HEAD>
  <META HTTP-EQUIV="Content-Type" CONTENT="text/html; CHARSET=UTF-8">
  <META NAME="GENERATOR" CONTENT="GtkHTML/3.24.1.1">
</HEAD>
<BODY>
Hi all,<BR>
<BR>
I am searching information about how to get my dvb-t usb stick works with my machine.<BR>
<BR>
I currently using a ubuntu intrepid os. I have installed the rtl2831u drivers as it is recommended.<BR>
<BR>
<B><FONT SIZE="4"><A HREF="http://www.twinhan.com/product_AD-TU200.asp">TwinHan/AzureWave AD-TU200 (7047) DVB-T</A> </FONT></B><BR>
Uses a Realtek RTL2831U decoder chip and <A HREF="http://www.linuxtv.org/wiki/index.php?title=MaxLinear&amp;action=edit">MaxLinear</A> <A HREF="http://www.linuxtv.org/wiki/index.php/MXL5003S">MXL5003S</A> tuner. USB ID is 13d3:3216. It seems to work with the realtek experimental driver (see freecom v4 above)<BR>
<BR>
The problems I have found:<BR>
<BR>
The found device&nbsp; has not frontend:<BR>
<BR>
mcm@McM:/usr/share/doc/dvb-utils$ tree /dev/dvb/adapter0/<BR>
/dev/dvb/adapter0/<BR>
|-- demux0<BR>
|-- dvr0<BR>
`-- net0<BR>
<BR>
So when scanning it fails<BR>
scanning /usr/share/doc/dvb-utils/examples/scan/dvb-s/Astra-19.2E<BR>
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'<BR>
main:2247: FATAL: failed to open '/dev/dvb/adapter0/frontend0': 2 No such file or directory<BR>
<BR>
<BR>
Other problem I found, which GUI is recommended to be used?<BR>
<BR>
thank you in advance,<BR>
<BR>
Miguel<BR>
<BR>
<BR>
<BR>
<BR>
<BR>
</BODY>
</HTML>

--=-HDh1Xr+e/mNUOXQSBqLT--



--===============1363280394==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1363280394==--
