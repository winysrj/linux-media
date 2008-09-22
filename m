Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8M0lJ26004131
	for <video4linux-list@redhat.com>; Sun, 21 Sep 2008 20:47:19 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8M0l7o6024483
	for <video4linux-list@redhat.com>; Sun, 21 Sep 2008 20:47:07 -0400
From: Andy Walls <awalls@radix.net>
To: Video4Linux <video4linux-list@redhat.com>
Content-Type: text/plain
Date: Sun, 21 Sep 2008 20:45:52 -0400
Message-Id: <1222044352.10079.42.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Annoying problem with minors and video_register_device()
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

Description:

I have machine with a CX23416 (ivtv) and CX23418 (cx18) based card.  The
following commands yield the video device node names as I'd prefer to
see them:

# modprobe cx18 cx18_first_minor=1
# modprobe ivtv ivtv_first_minor=0
# ls -al /dev/video*
lrwxrwxrwx  1 root root      6 2008-09-21 19:37 /dev/video -> video0
crw-rw----+ 1 root root 81,  0 2008-09-21 19:37 /dev/video0
crw-rw----+ 1 root root 81,  1 2008-09-21 19:37 /dev/video1
crw-rw----+ 1 root root 81, 24 2008-09-21 19:37 /dev/video24
crw-rw----+ 1 root root 81, 25 2008-09-21 19:37 /dev/video25
crw-rw----+ 1 root root 81, 32 2008-09-21 19:37 /dev/video32
crw-rw----+ 1 root root 81, 33 2008-09-21 19:37 /dev/video33


If I leave off the module options, I get this:

# modprobe cx18
# modprobe ivtv
# ls -al /dev/video*
lrwxrwxrwx  1 root root      6 2008-09-21 19:43 /dev/video -> video0
crw-rw----+ 1 root root 81,  0 2008-09-21 19:43 /dev/video0
crw-rw----+ 1 root root 81,  1 2008-09-21 19:44 /dev/video1
crw-rw----+ 1 root root 81,  2 2008-09-21 19:44 /dev/video2
crw-rw----+ 1 root root 81, 24 2008-09-21 19:43 /dev/video24
crw-rw----+ 1 root root 81,  3 2008-09-21 19:44 /dev/video3
crw-rw----+ 1 root root 81, 32 2008-09-21 19:43 /dev/video32

/dev/video2 and /dev/video3 aren't following the convention.


The problem is video_register_device() either gives you the minor for
which the driver asked or it can auto assign the first available but
only starting at an offset 0.

Perhaps video_register_device() could be modified so that the 3rd
argument, nr, if less than 0, could be interpreted as -(offset+1).
Offset would be the offset from the base at which auto assignment of a
minor could start.  The case of nr being passed in as -1 is then a
backwards compatible case.  In the case of nr greater than or equal to
0, nothing different would be done so things remain backward compatible.

So near the middle/bottom of video_register_device_index() one would
have:

        if (nr >= 0 && nr < end-base) {
                /* use the one the driver asked for */
                i = base + nr;
                if (NULL != video_device[i]) {
                        mutex_unlock(&videodev_lock);
                        return -ENFILE;
                }
        } else {
-               /* use first free */
-               for (i = base; i < end; i++)
+               if (nr >= 0)
+                       nr = -1;
+               /* use first free from offset -nr - 1 */
+               for (i = base - nr - 1; i < end; i++)
                        if (NULL == video_device[i])
                                break;
-               if (i == end) {
+               if (i >= end) {
                        mutex_unlock(&videodev_lock);
                        return -ENFILE;
                }
        }


Of course the drivers (ivtv and cx18 in my case) would have to be
modified to use this.

Any comments?  Is it not worth solving such a rare case when a
workaround with a module parameter exists?

Regards,
Andy

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
