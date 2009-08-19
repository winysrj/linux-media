Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.moviquity.com ([213.134.42.80])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <mcm@moviquity.com>) id 1MdihU-0006Gu-15
	for linux-dvb@linuxtv.org; Wed, 19 Aug 2009 12:47:28 +0200
Received: from [192.168.3.64] (80.Red-80-38-94.staticIP.rima-tde.net
	[80.38.94.80]) (Authenticated sender: mcm)
	by mail.moviquity.com (Postfix) with ESMTPSA id 0B71B520203
	for <linux-dvb@linuxtv.org>; Wed, 19 Aug 2009 12:46:50 +0200 (CEST)
From: Miguel <mcm@moviquity.com>
To: linux-dvb@linuxtv.org
Date: Wed, 19 Aug 2009 12:45:07 +0200
Message-Id: <1250678707.14727.12.camel@McM>
Mime-Version: 1.0
Subject: [linux-dvb] USB Wintv HVR-900 Hauppauge
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0058816796=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============0058816796==
Content-Type: multipart/alternative; boundary="=-xlJvuyNlv9c46ZdEeI68"


--=-xlJvuyNlv9c46ZdEeI68
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


Hello,

I am trying to set up the dvb-t device in my ubuntu 9.04.
As far as i can see , this device has tm6000 chipset but I don't get it
works. I have followed the guide of tvlinux.org:
http://www.linuxtv.org/wiki/index.php/Trident_TM6000#TM6000_based_Devices

I have compile v4l-dvb, make, and make install and it seems that the
modules are loaded:


em28xx                 90668  0 
ir_common              57732  1 em28xx
v4l2_common            25600  1 em28xx
videobuf_vmalloc       14724  1 em28xx
videobuf_core          26244  2 em28xx,videobuf_vmalloc
tveeprom               20228  1 em28xx
videodev               44832  3 em28xx,v4l2_common,uvcvideo


But by the moment, I don't know which driver  I should you. Actually,
when I switch the usb wintv on , my so doesn't recognize it:

[11107.449900] usb 1-3: new high speed USB device using ehci_hcd and
address 8
[11107.593094] usb 1-3: configuration #1 chosen from 1 choice


how can I get this device run?

thank you in advance.

Miguel


--=-xlJvuyNlv9c46ZdEeI68
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 TRANSITIONAL//EN">
<HTML>
<HEAD>
  <META HTTP-EQUIV="Content-Type" CONTENT="text/html; CHARSET=UTF-8">
  <META NAME="GENERATOR" CONTENT="GtkHTML/3.26.0">
</HEAD>
<BODY>
<BR>
Hello,<BR>
<BR>
I am trying to set up the dvb-t device in my ubuntu 9.04.<BR>
As far as i can see , this device has tm6000 chipset but I don't get it works. I have followed the guide of tvlinux.org: <A HREF="http://www.linuxtv.org/wiki/index.php/Trident_TM6000#TM6000_based_Devices">http://www.linuxtv.org/wiki/index.php/Trident_TM6000#TM6000_based_Devices</A><BR>
<BR>
I have compile v4l-dvb, make, and make install and it seems that the modules are loaded:<BR>
<BR>
<BR>
em28xx&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 90668&nbsp; 0 <BR>
ir_common&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 57732&nbsp; 1 em28xx<BR>
v4l2_common&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 25600&nbsp; 1 em28xx<BR>
videobuf_vmalloc&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 14724&nbsp; 1 em28xx<BR>
videobuf_core&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 26244&nbsp; 2 em28xx,videobuf_vmalloc<BR>
tveeprom&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 20228&nbsp; 1 em28xx<BR>
videodev&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 44832&nbsp; 3 em28xx,v4l2_common,uvcvideo<BR>
<BR>
<BR>
But by the moment, I don't know which driver&nbsp; I should you. Actually, when I switch the usb wintv on , my so doesn't recognize it:<BR>
<BR>
[11107.449900] usb 1-3: new high speed USB device using ehci_hcd and address 8<BR>
[11107.593094] usb 1-3: configuration #1 chosen from 1 choice<BR>
<BR>
<BR>
how can I get this device run?<BR>
<BR>
thank you in advance.<BR>
<BR>
Miguel<BR>
<BR>
</BODY>
</HTML>

--=-xlJvuyNlv9c46ZdEeI68--



--===============0058816796==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0058816796==--
