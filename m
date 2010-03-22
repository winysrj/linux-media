Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx08.extmail.prod.ext.phx2.redhat.com
	[10.5.110.12])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o2MC6I6G029144
	for <video4linux-list@redhat.com>; Mon, 22 Mar 2010 08:06:19 -0400
Received: from mail.pillar.it (85-18-55-49.ip.fastwebnet.it [85.18.55.49])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2MC65Du014639
	for <video4linux-list@redhat.com>; Mon, 22 Mar 2010 08:06:06 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.pillar.it (Postfix) with ESMTP id 5394D107B83
	for <video4linux-list@redhat.com>; Mon, 22 Mar 2010 13:06:57 +0100 (CET)
Received: from mail.pillar.it ([127.0.0.1])
	by localhost (mail.pillar.it [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QX-w4dO35EiC for <video4linux-list@redhat.com>;
	Mon, 22 Mar 2010 13:06:57 +0100 (CET)
Received: from [192.168.1.134] (89-96-169-53.ip13.fastwebnet.it [89.96.169.53])
	by mail.pillar.it (Postfix) with ESMTPSA id 003C6107B82
	for <video4linux-list@redhat.com>; Mon, 22 Mar 2010 13:06:56 +0100 (CET)
Message-ID: <4BA75D27.10807@pillar.it>
Date: Mon, 22 Mar 2010 13:05:59 +0100
From: Sanfelici Claudio <sanfelici@pillar.it>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Subject: Set Frequency Problem
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hello all,
it's first time I write to this mailing list, so I'm sorry if this 
problem has been already discussed.
I'm writing an application in java tha use v4l2 through JNI layer (but I 
have the same problem in a C test program)

When I call the VIDIOC_S_FREQUENCY the driver change the frequency, but 
the video signal is 0 (according to the VIDIOC_G_TUNER) and the image is 
black. I've to call some times the VIDIOC_S_FREQUENCY to get the signal on

The driver I'm using is the SAA7130.

Any ideas?

Just another question: at this time I'm working with userpointer and 
read method to grab the images, but probably I will must use the video 
overlay. I've tried to start the overlay following the v4l 
documentation, but it doesn't work. I suspect that I must use the Xorg 
library to get some information (such as the frame buffer address). 
Could someone show me the way?

Thanks in advance

-- 
Pillar Engineering
di Sanfelici Claudio
Via Monza, 53
20063 Cernusco sul Naviglio - MI
P.Iva 05403820961
C.F. SNFCDP81D28C523E
Tel. 02.99.76.55.69
Fax. 02.99.76.55.70
Cell. +39 333.14.27.805
E-Mail info@pillar.it
Sito: www.pillar.it  

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
