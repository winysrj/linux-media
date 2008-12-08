Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB8INrOF015026
	for <video4linux-list@redhat.com>; Mon, 8 Dec 2008 13:23:53 -0500
Received: from mail11e.verio-web.com (mail11e.verio-web.com [204.202.242.84])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id mB8INg7A029585
	for <video4linux-list@redhat.com>; Mon, 8 Dec 2008 13:23:42 -0500
Received: from mx78.stngva01.us.mxservers.net (204.202.242.149)
	by mail11e.verio-web.com (RS ver 1.0.95vs) with SMTP id 1-062737621
	for <video4linux-list@redhat.com>; Mon,  8 Dec 2008 13:23:42 -0500 (EST)
Message-ID: <493D662C.3030401@sensoray.com>
Date: Mon, 08 Dec 2008 10:23:40 -0800
From: dean <dean@sensoray.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Greg KH <greg@kroah.com>, dean <dean@sensoray.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: VIVI & S2255DRV driver problems
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

In non-blocking mode, the vivi driver and s2255drv drivers seem to 
require a poll or select call in order for VIDIOC_DQBUF to function 
correctly.  This seems like a bug in the drivers themselves or possibly 
in the API.  The workaround is to always call poll with a zero timeout 
before a VIDIOC_DQBUF call.  However, this should not necessarily be a 
requirement for non-blocking mode.

To reproduce, please see the code below replacing the mainloop function 
from the standard capture.c file:  Tested with v4l-dvb-291a596b7f34 from 
linuxtv.org mercurial and the 2.6.27 kernel.

standard capture.c file modification:

static void
mainloop                        (void)
{
	unsigned int count;
         count = 100;
         while (count-- > 0) {
                 for (;;) {
		  /* What if we don't want to use select or poll */
#if 0
                         fd_set fds;
                         struct timeval tv;
                         int r;
                         FD_ZERO (&fds);
                         FD_SET (fd, &fds);
                         /* Timeout. */
                         tv.tv_sec = 0;
                         tv.tv_usec = 1;
                         r = select (fd + 1, &fds, NULL, NULL, &tv);
                         if (-1 == r) {
                                 if (EINTR == errno)
                                         continue;
                                 errno_exit ("select");
                         }
                         if (0 == r) {
                                 fprintf (stderr, "select timeout\n");
				//                                exit (EXIT_FAILURE);
                         }
#endif
			if (read_frame ())
                     		break;
			/* EAGAIN - continue select loop. */
			/* If we aren't using select or poll, we should
			   be able to just sleep and try again. But with
			   the VIVI driver and possibly others,
			   DQBUF will always return
			   EAGAIN and we are stuck in this infinite loop.   select or poll 
seems to be required for			   non-blocking operation.
			*/
			//printf("eagain\n");
			usleep(25*1000);
                 }
         }
}

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
