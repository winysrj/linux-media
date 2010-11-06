Return-path: <mchehab@gaivota>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <dehqan65@gmail.com>) id 1PEo9J-0001es-4Q
	for linux-dvb@linuxtv.org; Sat, 06 Nov 2010 20:10:01 +0100
Received: from mail-qw0-f54.google.com ([209.85.216.54])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-a) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1PEo9I-0005rc-BX; Sat, 06 Nov 2010 20:10:00 +0100
Received: by qwg8 with SMTP id 8so4085972qwg.41
	for <linux-dvb@linuxtv.org>; Sat, 06 Nov 2010 12:09:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTim9kkFuORZHwtC+Wd2BN8HJRxCtEr+2zP5P9cx3@mail.gmail.com>
References: <AANLkTim9kkFuORZHwtC+Wd2BN8HJRxCtEr+2zP5P9cx3@mail.gmail.com>
Date: Sat, 6 Nov 2010 22:39:55 +0330
Message-ID: <AANLkTi=a63M3KasUOAb69UxHivgPxRLy8GJC+Nnp=UDx@mail.gmail.com>
From: dehqan65 <dehqan65@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
Subject: [linux-dvb] Fwd: Analog TV shoow has not sound
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: Mauro Carvalho Chehab <mchehab@gaivota>
List-ID: <linux-dvb@linuxtv.org>

---------- Forwarded message ----------
From: dehqan65 <dehqan65@gmail.com>
Date: Sat, 6 Nov 2010 22:34:44 +0330
Subject: Analog TV shoow has not sound
To: linux-media <linux-media@vger.kernel.org>

In The Name Of God The compassionate merciful


Hello ;
Good day
i-humble have bought a usb hybrid dongel with tlg2300 chipset.
dvb-t works fine with vlc .
 .
1-but analog TV has not sound .(while there is no susppend and hibrenate before)
these 2 ways both have not sound with tv show:

mplayer -tv chanlist=us-bcast tv://

OR

vlc v4l2:///dev/video0  :input-slave=alsa://hw:1,0 :v4l2-standard=1
:v4l2-tuner-frequency=495250

audio codec of analog tv is :PCM S16LE (araw)
what is the problem , how to solve it ?
maybe you need this http://pastebin.com/dYwAQFxq

Regards dehqan

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
