Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mariofutire@googlemail.com>) id 1JjUyB-0001rK-9E
	for linux-dvb@linuxtv.org; Wed, 09 Apr 2008 09:43:48 +0200
Received: by fk-out-0910.google.com with SMTP id z22so3345181fkz.1
	for <linux-dvb@linuxtv.org>; Wed, 09 Apr 2008 00:43:42 -0700 (PDT)
Message-ID: <47FC73AA.3090108@googlemail.com>
Date: Wed, 09 Apr 2008 08:43:38 +0100
From: Andrea <mariofutire@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Help: how to submit patches to dvb-core.
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

I've got 2 patches for dvb-core: bug fix for DMX_SET_BUFFER_SIZE for dvb and
implementation of the same ioctl for the dvr.

I've already sent those patches a few times with very little feedback.
I have not understood who is the maintainer of the common code in dvb-core.
Could someone please let me know if I am wasting my time and the patches are not good or irrelevant.

Here is (again) a brief description of the patches and where to find them.

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



I look forward to receiving some feedback.

Andrea

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
