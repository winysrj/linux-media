Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx02.extmail.prod.ext.phx2.redhat.com
	[10.5.110.6])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n9C7XKev021569
	for <video4linux-list@redhat.com>; Mon, 12 Oct 2009 03:33:20 -0400
Received: from web23105.mail.ird.yahoo.com (web23105.mail.ird.yahoo.com
	[217.146.189.45])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n9C7X2j7009140
	for <video4linux-list@redhat.com>; Mon, 12 Oct 2009 03:33:03 -0400
Message-ID: <164184.43566.qm@web23105.mail.ird.yahoo.com>
Date: Mon, 12 Oct 2009 07:33:02 +0000 (GMT)
From: Mattias Persson <d98mp@yahoo.se>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Subject: How to store the latest image without modifying videobuf-core.c
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

Hi, 

I am developing a driver for a camera. As an example I am using the vivi driver (2.6.28) and the first major difference between my ISR and thread_tick() is that my driver will always attempt to store the latest image, even if nobody is waiting for a new image. 

In my driver, when all queued buffers are used any new images will be stored in the oldest frame which has already been captured (state == VIDEOBUF_DONE) and here is where my problems start. (If this is wrong, what shall I do to always keep the latest captured image?)

In the function videobuf_dqbuf in videobuf-core.c, if a new image is returned by stream_next_buffer and the ISR kicks in before videobuf_dqbuf can set buf->state to VIDEOBUF_IDLE, my driver will modify the image presented to userspace and that is not acceptable. 

The only solution I can find is to use the spinlock in videobuf_queue when the userspace application is requesting a new image (DQBUF/poll) to check for a new image and set some flag indicating that the buffer can't be overwritten by the ISR. However, this approach would require changes to videobuf-core.c and that doesn't seem right. Can someone please give me some guidance on this? 

Regards, 
Mattias



      __________________________________________________________
Ta semester! - sök efter resor hos Kelkoo.
Jämför pris på flygbiljetter och hotellrum här:
http://www.kelkoo.se/c-169901-resor-biljetter.html?partnerId=96914052

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
