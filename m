Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx05.extmail.prod.ext.phx2.redhat.com
	[10.5.110.9])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n8B1H1JK013505
	for <video4linux-list@redhat.com>; Thu, 10 Sep 2009 21:17:01 -0400
Received: from mail-fx0-f209.google.com (mail-fx0-f209.google.com
	[209.85.220.209])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8B1GlZ6019220
	for <video4linux-list@redhat.com>; Thu, 10 Sep 2009 21:16:48 -0400
Received: by fxm5 with SMTP id 5so503180fxm.3
	for <video4linux-list@redhat.com>; Thu, 10 Sep 2009 18:16:46 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 10 Sep 2009 22:16:46 -0300
Message-ID: <fa40cc720909101816k358c0975je636458788175f7@mail.gmail.com>
From: Guilherme Raymo Longo <grlongo.ireland@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Subject: v4l2 driver seems to be capturing frames too slow!
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

Hi mates.

Plz, could I get some help from here. This is my first attempt of creating a
v4l2 app and I am a bit confused about few things even after reading the
WIKI.

1 - I am using mmap to map the memory in the device. In the example I have,
there is only 1 QBUF and 1 DQBUF, so I presume that all the 4 buffers are
been queued and dequeued when those functions are called. Am I committing a
mistake here or that is correct?

Here you can see the code: http://pastebin.com/m367448b8

2 - If you notice, right after the buffers been dequeued the program calls a
function  "process_image (buffers[buf.index].start);" that I also presume
been all the 4 buffers "buffer[start] to buffer[3]". Each buffer is 8byte
long so I have 64bits of memory mapped. The compression I am using is RGB32
that stores each RGBA pixels in 4 bytes (1 for each color + 1 for alpha): If
this is true and I am capturing a image 640x480 I am gonna have 307.200
pixel and a necessary space of 1.228.8 bytes to store each frame. What means
approximately 1.23MB per frame.

   Is that correct or I am calculating it improperly

3 - And the last question is, that function I mentioned earlier
process_image (buffers[buf.index].start) prints approximately 6 dots per
second wich means (taking in account
that each buffer has 8bytes and I have them all filled with data) 6 x 8bytes
read to process the image. Not even close to be a complete frame.

the full program can be seen here: http://pastebin.com/m43801a5e

Please, I read the whole v4l2 spec and it seems a bit confusing for a newb
like me.
Thanks for all ur attention.
Guilherme Longo
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
