Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx08.extmail.prod.ext.phx2.redhat.com
	[10.5.110.12])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n8UD6IvO014579
	for <video4linux-list@redhat.com>; Wed, 30 Sep 2009 09:06:18 -0400
Received: from newton.esaturnus.com (newton.esaturnus.com [213.163.82.75])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8UD66ds011296
	for <video4linux-list@redhat.com>; Wed, 30 Sep 2009 09:06:07 -0400
Received: from localhost (localhost [127.0.0.1])
	by newton.esaturnus.com (Postfix) with ESMTP id D3B1A1761B
	for <video4linux-list@redhat.com>;
	Wed, 30 Sep 2009 15:06:04 +0200 (CEST)
Received: from newton.esaturnus.com ([127.0.0.1])
	by localhost (newton.esaturnus.com [127.0.0.1]) (amavisd-new,
	port 10024)
	with ESMTP id SJ6GJG0jaCaz for <video4linux-list@redhat.com>;
	Wed, 30 Sep 2009 15:05:53 +0200 (CEST)
Received: from caesar.localnet (140.7-243-81.adsl-static.isp.belgacom.be
	[81.243.7.140]) (Authenticated sender: joris.guisson@esaturnus.com)
	by newton.esaturnus.com (Postfix) with ESMTPA id 17B871761A
	for <video4linux-list@redhat.com>;
	Wed, 30 Sep 2009 15:05:53 +0200 (CEST)
From: Joris Guisson <joris.guisson@esaturnus.com>
To: video4linux-list@redhat.com
Date: Wed, 30 Sep 2009 15:05:52 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909301505.52789.joris.guisson@esaturnus.com>
Subject: BTTV driver strange behavior
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hello,

I'm using a sensoray 311 card and the bttv driver to do video capture. This is 
the dmesg output :

bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
bttv0: Bt878 (rev 17) at 0000:01:06.0, irq: 18, latency: 64, mmio: 0xdeaff000
bttv0: detected: Sensoray 311 [card=73], PCI subsystem ID is 6000:0311
bttv0: using: Sensoray 311 [card=73,autodetected]
bttv0: gpio: en=00000000, out=00000000 in=007fffff [init]
bttv0: tuner absent
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: PLL: 28636363 => 35468950 ..<6>hdd: max request size: 128KiB


And have been experiencing some problems with the bttv driver. The first 
problem we came across was occasional slower framerates when the S-VIDEO cable 
was unplugged and plugged in again (they usually go away when you do that 
again). 

So upon investigating this, I discovered that apparently we were a frame 
behind (there was more then one buffer to dequeue) and that the select call 
doesn't immediately return when this happens. So we would only dequeue one 
buffer, and then select would wait for quite a while (more then 100 ms), before 
returning again. After that the second buffer was dequeued and the next select 
call would only take a few ms but again only one of the two available would be 
read and then you would get the long delay again. And this significantly 
reduced the framerate.

To solve this, I decided that after a buffer was dequeued, I would check all of 
our buffers with VIDIOC_QUERYBUF and dequeue them if the V4L2_BUF_FLAG_DONE was 
set (and enqueue them again, so the driver could reuse them). This however 
lead a very weird bug, the next time select returned on the bttv device and we 
did a VIDIOC_DQBUF it blocked forever. The process was stuck, and the only 
thing I could do was kill it.

I managed to solve this by opening the device with O_NONBLOCK. This solution 
works, the VIDIOC_DQBUF call would return an error instead of blocking 
forever, and we could get on with capturing video.

This leaves me with two questions :
- Why does the select call on bttv driver not immediately return when there is 
another buffer ready to be dequeued ? 
- Why does VIDIOC_DQBUF block forever when select returns and indicates that 
there is something to be dequeued ?


Joris,

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
