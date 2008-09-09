Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web31108.mail.mud.yahoo.com ([68.142.200.41])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <bsdskin@yahoo.com>) id 1KdAzX-00079P-Io
	for linux-dvb@linuxtv.org; Tue, 09 Sep 2008 23:43:21 +0200
Date: Tue, 9 Sep 2008 14:42:44 -0700 (PDT)
From: William Austin <bsdskin@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <273704.19765.qm@web31108.mail.mud.yahoo.com>
Subject: [linux-dvb] Hauppauge HVR-1950 with Ubuntu Intrepid
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2098564949=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============2098564949==
Content-Type: multipart/alternative; boundary="0-1665358916-1220996564=:19765"

--0-1665358916-1220996564=:19765
Content-Type: text/plain; charset=us-ascii

I have a Hauppauge WinTV HVR-1950 USB box on a box running Ubuntu Intrepid.  Although I should expect problems from a testing distro, I've tried getting this box working on stable, Live-CD versions of Ubuntu, Open Suse, and Mandriva as well (because they were what I had around the house.)

First, there is a kernel problem in Ubuntu Intrepid where, if the 1950 is plugged into USB, the system will hang on boot.  Yet, if I boot without it and plug it in after boot, the drivers (pvrusb2 et al) seem to load, but no device nodes are created.  I have downloaded the firmware, renamed it properly, and placed it in /lib/firmware.  So I'm at a loss on how to troubleshoot.  Here's the relevant information on plug-in the box in after the system has been booted.

dmesg says:
usbcore: registered new interface driver pvrusb2
pvrusb2: Hauppauge WinTV-PVR-USB2 MPEG2 Encoder/Tuner : V4L in-tree version
pvrusb2: Debug mask is 31 (0x1f)

lsmod (edit):
usbcore
pvrusb2
i2c_core
v4l2_common
tveeprom
dvb_core
cx2341x
videodev
v4l1_compat

/proc/devices lists DVB as a character device.

Now, I'm assuming I'm missing some chip drivers.  I think I should have at least three, if memory serves, but only cx2341x is loading on plug-in.  Unfortunately (and I assume this is another Ubuntu problem) I can't unload pvrusb2 once loaded.  It hangs the terminal.  It makes playing around with it a tedious endeavor.

If anyone has had the same problems or could give some advice, I appreciate it in advance.

Will



      
--0-1665358916-1220996564=:19765
Content-Type: text/html; charset=us-ascii

<html><head><style type="text/css"><!-- DIV {margin:0px;} --></style></head><body><div style="font-family:times new roman, new york, times, serif;font-size:12pt">I have a Hauppauge WinTV HVR-1950 USB box on a box running Ubuntu Intrepid.&nbsp; Although I should expect problems from a testing distro, I've tried getting this box working on stable, Live-CD versions of Ubuntu, Open Suse, and Mandriva as well (because they were what I had around the house.)<br><br>First, there is a kernel problem in Ubuntu Intrepid where, if the 1950 is plugged into USB, the system will hang on boot.&nbsp; Yet, if I boot without it and plug it in after boot, the drivers (pvrusb2 et al) seem to load, but no device nodes are created.&nbsp; I have downloaded the firmware, renamed it properly, and placed it in /lib/firmware.&nbsp; So I'm at a loss on how to troubleshoot.&nbsp; Here's the relevant information on plug-in the box in after the system has been booted.<br><br>dmesg
 says:<br>usbcore: registered new interface driver pvrusb2<br>pvrusb2: Hauppauge WinTV-PVR-USB2 MPEG2 Encoder/Tuner : V4L in-tree version<br>pvrusb2: Debug mask is 31 (0x1f)<br><br>lsmod (edit):<br>usbcore<br>pvrusb2<br>i2c_core<br>v4l2_common<br>tveeprom<br>dvb_core<br>cx2341x<br>videodev<br>v4l1_compat<br><br>/proc/devices lists DVB as a character device.<br><br>Now, I'm assuming I'm missing some chip drivers.&nbsp; I think I should have at least three, if memory serves, but only cx2341x is loading on plug-in.&nbsp; Unfortunately (and I assume this is another Ubuntu problem) I can't unload pvrusb2 once loaded.&nbsp; It hangs the terminal.&nbsp; It makes playing around with it a tedious endeavor.<br><br>If anyone has had the same problems or could give some advice, I appreciate it in advance.<br><br>Will<br></div><br>

      </body></html>
--0-1665358916-1220996564=:19765--


--===============2098564949==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2098564949==--
