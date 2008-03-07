Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rn-out-0910.google.com ([64.233.170.191])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rpooser@gmail.com>) id 1JXdRz-00061I-Do
	for linux-dvb@linuxtv.org; Fri, 07 Mar 2008 15:21:34 +0100
Received: by rn-out-0910.google.com with SMTP id e11so660146rng.17
	for <linux-dvb@linuxtv.org>; Fri, 07 Mar 2008 06:21:26 -0800 (PST)
Message-ID: <47D14F62.90406@gmail.com>
Date: Fri, 07 Mar 2008 09:21:22 -0500
From: Raphael <rpooser@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] HVR-1250: v4l-dvb need help compiling
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

Hello folks,
I'm new to the list, and I subscribed mainly because I'm having a
problem compiling the v4l-dvb drivers.
I have a pinnacle PCTV HD Pro Stick and that is working fine using the 
em28xx drivers from mcentral.de.
Currently, I'm trying to get a Hauppage HVR-1250 working. At first when 
I tried compiling v4l-dvb, I got errors about tea575x-tuner.c, and so 
using make menuconfig, I disabled all AM/FM tuners.
Howver, after that I still get an error during make, this time in
videodev.c.
The first error is "unknown field 'dev_attrs' specified in initializer"
on line 491.

Has anyone seen this, or could I be doing something wrong when I removed
the webcam drivers?

Thanks a lot in advance.

Raphael

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
