Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mariofutire@googlemail.com>) id 1JgnwM-0003ni-Et
	for linux-dvb@linuxtv.org; Tue, 01 Apr 2008 23:22:47 +0200
Received: by nf-out-0910.google.com with SMTP id d21so927111nfb.11
	for <linux-dvb@linuxtv.org>; Tue, 01 Apr 2008 14:22:37 -0700 (PDT)
Message-ID: <47F2A798.1070009@googlemail.com>
Date: Tue, 01 Apr 2008 22:22:32 +0100
From: Andrea <mariofutire@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] [PATCH] SET_BUFFER_SIZE demux and dvr: awaiting
	feedbacks
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

I was just wondering if anybody had time to check the 2 patches I posted a couple of weeks ago.

Both patches are about DMX_SET_BUFFER_SIZE

1) Patch number 1 is to fix a bug when shrinking the demux buffer. This bug causes the kernel to
crash completely

http://www.linuxtv.org/pipermail/linux-dvb/2008-March/024828.html
http://www.linuxtv.org/pipermail/linux-dvb/2008-March/024833.html
http://www.linuxtv.org/pipermail/linux-dvb/2008-March/024839.html

2) The second patch is about the implementation of the ioctl DMX_SET_BUFFER_SIZE for the dvr.
The ioctl call is currently available but not implemented.
Currently the default is 192522 which lasts only about 1 sec when saving the whole TS.

http://www.linuxtv.org/pipermail/linux-dvb/2008-March/024829.html
http://www.linuxtv.org/pipermail/linux-dvb/2008-March/024834.html
http://www.linuxtv.org/pipermail/linux-dvb/2008-March/024840.html

Is it possible for the maintainers of the dvb-core (btw, who are they exactly?) to check them?

Looking forward to receiving feedbacks.

Andrea

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
