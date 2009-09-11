Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:48313 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbZIKDP5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 23:15:57 -0400
Received: from epmmp1 (mailout2.samsung.com [203.254.224.25])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KPS005UJDXKTZ@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 11 Sep 2009 12:05:45 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KPS00H00DXKF3@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 11 Sep 2009 12:05:44 +0900 (KST)
Date: Fri, 11 Sep 2009 12:05:44 +0900
From: "Dongsoo, Nathaniel Kim" <dongsoo45.kim@samsung.com>
Subject: RE: v4l2 driver seems to be capturing frames too slow!
In-reply-to: <fa40cc720909101816k358c0975je636458788175f7@mail.gmail.com>
To: 'Guilherme Raymo Longo' <grlongo.ireland@gmail.com>
Cc: linux-media@vger.kernel.org
Message-id: <000b01ca328c$c10215b0$43064110$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-language: ko
Content-transfer-encoding: 7BIT
References: <fa40cc720909101816k358c0975je636458788175f7@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guilherme,

(I'm removing the old mailing list and add CC the current one)

-----Original Message-----
From: video4linux-list-bounces@redhat.com
[mailto:video4linux-list-bounces@redhat.com] On Behalf Of Guilherme Raymo
Longo
Sent: Friday, September 11, 2009 10:17 AM
To: video4linux-list@redhat.com
Subject: v4l2 driver seems to be capturing frames too slow!

Hi mates.

Plz, could I get some help from here. This is my first attempt of creating a
v4l2 app and I am a bit confused about few things even after reading the
WIKI.

1 - I am using mmap to map the memory in the device. In the example I have,
there is only 1 QBUF and 1 DQBUF, so I presume that all the 4 buffers are
been queued and dequeued when those functions are called. Am I committing a
mistake here or that is correct?

Here you can see the code: http://pastebin.com/m367448b8


Yes, I suppose you are getting right.


2 - If you notice, right after the buffers been dequeued the program calls a
function  "process_image (buffers[buf.index].start);" that I also presume
been all the 4 buffers "buffer[start] to buffer[3]". Each buffer is 8byte
long so I have 64bits of memory mapped. The compression I am using is RGB32
that stores each RGBA pixels in 4 bytes (1 for each color + 1 for alpha): If
this is true and I am capturing a image 640x480 I am gonna have 307.200
pixel and a necessary space of 1.228.8 bytes to store each frame. What means
approximately 1.23MB per frame.

   Is that correct or I am calculating it improperly


Correct, and you can get the actual data size value from bytesused in
v4l2_buffer on DQBUF.



3 - And the last question is, that function I mentioned earlier
process_image (buffers[buf.index].start) prints approximately 6 dots per
second wich means (taking in account
that each buffer has 8bytes and I have them all filled with data) 6 x 8bytes
read to process the image. Not even close to be a complete frame.

the full program can be seen here: http://pastebin.com/m43801a5e



I recognize that code. Similar thing can be found in v4l2 spec document.
But I prefer to use memcpy() the image data to frame buffer rather than
printing every single pixel at a time.
Try to figure out to copy the whole single image frame to the frame buffer.
It should be faster.
You can copy exact amount of data based on bytesused value :)

Cheers,

Nate


=
DongSoo, Nathaniel Kim 
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com 
          dongsoo45.kim@samsung.com




