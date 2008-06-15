Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.178])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rpooser@gmail.com>) id 1K7woB-0000wj-KF
	for linux-dvb@linuxtv.org; Sun, 15 Jun 2008 20:18:32 +0200
Received: by wa-out-1112.google.com with SMTP id n7so3699259wag.13
	for <linux-dvb@linuxtv.org>; Sun, 15 Jun 2008 11:18:10 -0700 (PDT)
Message-ID: <48555CB0.7060606@gmail.com>
Date: Sun, 15 Jun 2008 14:17:20 -0400
From: Raphael <rpooser@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] em28xx analog audio problems
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

Hi all,
I'm using one of the more recent hg pulls of the v4l-dvb tree, and I 
have a HVR-950 and pinnacle HD pro stick both working under the em28x 
drivers recording ATSC.

For analog I can't seem to get audio working, even though the video 
plays fine. I've read around that the device is supposed to register its 
own /dev/dsp interface, but I only have one /dev/dsp, and no /dev/dsp1, 
etc. Does anyone have a quick way to get analog sound working on this 
card? I mainly use mythtv for recording.

Cheers,
Raphy

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
