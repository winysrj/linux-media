Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1KJDdy-00048Y-PB
	for linux-dvb@linuxtv.org; Wed, 16 Jul 2008 22:30:35 +0200
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KJDdt-0003RR-2j
	for linux-dvb@linuxtv.org; Wed, 16 Jul 2008 20:30:29 +0000
Received: from 77-103-126-124.cable.ubr10.dals.blueyonder.co.uk
	([77.103.126.124]) by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Wed, 16 Jul 2008 20:30:29 +0000
Received: from mariofutire by 77-103-126-124.cable.ubr10.dals.blueyonder.co.uk
	with local (Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Wed, 16 Jul 2008 20:30:29 +0000
To: linux-dvb@linuxtv.org
From: Andrea <mariofutire@googlemail.com>
Date: Wed, 16 Jul 2008 21:28:33 +0100
Message-ID: <g5llos$b75$1@ger.gmane.org>
Mime-Version: 1.0
Subject: [linux-dvb] [PATCH] 2 patches for dvb-apps gnutv
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

Hi,

I would like to repost 2 patches for gnutv, part of dvb-apps.

http://www.linuxtv.org/pipermail/linux-dvb/2008-July/027177.html

They both try to make gnutv more robust when the system/destination file system are temporary slow.

1) http://www.linuxtv.org/pipermail/linux-dvb/2008-July/027176.html
Once the dvb ringbuffer overflows, it is pointless to stop gnutv. I think it should continue and get 
the rest of the signal.
What has been lost has been lost, let's not loose the future stream

2) http://www.linuxtv.org/pipermail/linux-dvb/2008-July/027177.html
Allow to set a bigger (than default = 2MB) dvb ringbuffer to cope with temporary bottlenecks.

Is anybody interested in reviewing them?

Andrea


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
