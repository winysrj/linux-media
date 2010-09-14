Return-path: <mchehab@pedra>
Received: from mail44.e.nsc.no ([193.213.115.44]:34554 "EHLO mail44.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009Ab0INUdR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Sep 2010 16:33:17 -0400
Received: from [192.168.0.100] (51.131.189.109.customer.cdi.no [109.189.131.51])
	by mail44.nsc.no (8.14.3/8.14.3) with ESMTP id o8EJcUCp010331
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-media@vger.kernel.org>; Tue, 14 Sep 2010 21:38:33 +0200 (MEST)
Subject: Trouble building v4l-dvb
From: "Ole W. Saastad" <olewsaa@online.no>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Sep 2010 21:38:29 +0200
Message-ID: <1284493110.1801.57.camel@sofia>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Trouble building v4l-dvb
Asus eee netbook, running EasyPeasy.

ole@ole-eee:~$ cat /etc/issue
Ubuntu 9.04 \n \l
ole@ole-eee:~$ uname -a
Linux ole-eee 2.6.30.5-ep0 #10 SMP PREEMPT Thu Aug 27 19:45:06 CEST 2009
i686 GNU/Linux

Rationale for building from source: 
I have bought a USB TV with mpg4 support from Sandberg, Mini DVB-T
dongle. I also received an archive with driver routines for this from
Sandberg. These should be copied into the v4l-dvd three and just rebuild
with make. 

I have installed the kernel headers:
apt-get install mercurial linux-headers-$(uname -r) build-essential

Then I have downloaded the v4l-dvb source (assuming this is a stable
release): hg clone http://linuxtv.org/hg/v4l-dvb


I wanted to try to build before applying the patch from Sandberg. 
Issuing make yield the following :

LIRC: Requires at least kernel 2.6.36
IR_LIRC_CODEC: Requires at least kernel 2.6.36
IR_IMON: Requires at least kernel 2.6.36
IR_MCEUSB: Requires at least kernel 2.6.36
VIDEOBUF_DMA_CONTIG: Requires at least kernel 2.6.31
V4L2_MEM2MEM_DEV: Requires at least kernel 2.6.33
and a few more lines....

Ignoring these and just continuing :

  CC [M]  /home/ole/work/v4l-dvb/v4l/firedtv-dvb.o
  CC [M]  /home/ole/work/v4l-dvb/v4l/firedtv-fe.o
  CC [M]  /home/ole/work/v4l-dvb/v4l/firedtv-1394.o
/home/ole/work/v4l-dvb/v4l/firedtv-1394.c:22:17: error: dma.h: No such
file or directory
/home/ole/work/v4l-dvb/v4l/firedtv-1394.c:23:21: error: csr1212.h: No
such file or directory
/home/ole/work/v4l-dvb/v4l/firedtv-1394.c:24:23: error: highlevel.h: No
such file or directory
and many many more similar errors.

After some time the make bails out.


I assume this have some connection with the 9.04 being too old. 


Hints ?



Regards,
Ole W. Saastad




