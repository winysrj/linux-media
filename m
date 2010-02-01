Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx05.extmail.prod.ext.phx2.redhat.com
	[10.5.110.9])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o11B47uD032642
	for <video4linux-list@redhat.com>; Mon, 1 Feb 2010 06:04:07 -0500
Received: from mail-px0-f185.google.com (mail-px0-f185.google.com
	[209.85.216.185])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o11B3pKG032190
	for <video4linux-list@redhat.com>; Mon, 1 Feb 2010 06:03:52 -0500
Received: by pxi15 with SMTP id 15so4065928pxi.23
	for <video4linux-list@redhat.com>; Mon, 01 Feb 2010 03:03:51 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 1 Feb 2010 12:03:51 +0100
Message-ID: <fe6fd5f61002010303y48f5d51m3f4c0e5f21698825@mail.gmail.com>
Subject: Problem of memory
From: Carlos Lavin <carlos.lavin@vista-silicon.com>
To: video4linux-list <video4linux-list@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

hello, I have a problem, I am developing a video driver for imx27 in version
2.6.30, I need to work in this version, I work with the soc-camera subsytem.
the problem is that I need to reserve memory for my buffers, but the
function DMA_ALLOC_COHERENT says error: ENOMEN. This problem is in that I
haven't enough memory to my buffers, then I am thinking that I can reserve
memory for this buffers in the __init of driver... but, how can I do it?
In my aplication, I call to mmap(), this function reserve memory for the
buffers and also calls soc_camera_mmap for to call at dma_alloc_coherent.
How can I do for that the driver reserve memory and the aplication knows
where is this memory? how can I resolver this problem?, also I have thought
that I could reserve memory without call to soc-camera subsytem in the mmap,
only in this function, is it possible? can someone help me? thanks.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
