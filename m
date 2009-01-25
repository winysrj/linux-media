Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.157])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <user.vdr@gmail.com>) id 1LRBDa-0004io-5P
	for linux-dvb@linuxtv.org; Sun, 25 Jan 2009 21:04:30 +0100
Received: by fg-out-1718.google.com with SMTP id e21so3322072fga.25
	for <linux-dvb@linuxtv.org>; Sun, 25 Jan 2009 12:04:26 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 25 Jan 2009 12:04:26 -0800
Message-ID: <a3ef07920901251204o78b9d3ecg1e237ffd6f3be73a@mail.gmail.com>
From: "user.vdr" <user.vdr@gmail.com>
To: "mailing list: linux-dvb" <linux-dvb@linuxtv.org>
Subject: [linux-dvb] v4l2-ctl is broken
Reply-To: linux-media@vger.kernel.org
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

I'm trying to set NTSC on my nexus-s and it no longer works with a v4l
tree from today.

vdr:~$ v4l2-ctl -d 0 -s ntsc
VIDIOC_S_STD: failed: Invalid argument

Does anyone know how to fix this?

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
