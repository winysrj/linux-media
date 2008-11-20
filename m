Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1L3BF0-00009h-ML
	for linux-dvb@linuxtv.org; Thu, 20 Nov 2008 16:14:47 +0100
Received: by ey-out-2122.google.com with SMTP id 25so201793eya.17
	for <linux-dvb@linuxtv.org>; Thu, 20 Nov 2008 07:14:43 -0800 (PST)
Message-ID: <412bdbff0811200714j5fcd3d62nb2cd46e49a350ce0@mail.gmail.com>
Date: Thu, 20 Nov 2008 10:14:43 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: Linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] dib0700 remote control support fixed
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

After seeing some recent edits to the LinuxTV DVB wiki, I think it is
probably worth a more general announcement:

http://www.linuxtv.org/wiki/index.php?title=Template:Firmware:dvb-usb-dib0700&curid=3008&diff=17297&oldid=17296

The dib0700 remote control problem that people were seeing with
firmware 1.20 has been fixed.  It was checked in at hg 9640, and will
work "out of the box" with no need to play with modprobe options.

Those of you still having problems should update to the latest v4l-dvb
code.  If you still have issues, please feel free to email me and I
will investigate.

Thank you,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
