Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m56BZbKi018752
	for <video4linux-list@redhat.com>; Fri, 6 Jun 2008 07:35:37 -0400
Received: from linos.es (centrodatos.linos.es [86.109.105.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m56BYcXI011647
	for <video4linux-list@redhat.com>; Fri, 6 Jun 2008 07:34:38 -0400
Message-ID: <484920B9.4010107@linos.es>
Date: Fri, 06 Jun 2008 13:34:17 +0200
From: Linos <info@linos.es>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: bttv driver problem last kernels
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

Hello all,
	i am using a bttv multicapture board and i have been having increasing problems in last kernels, i am using 
two programs to capture my video input for security reasons (helix producer and mp4live from mpeg4ip project) 
since the first versions of v4l2 in 2.4 patched kernel versions i can attach the two programs at the same time 
at the same video input, only loss framerate but i am using a low framerate to transmit by internet anyway, 
before 2.6.22 all have worked very well (i have not tested 2.6.21, the last kernel working ok i have tested is 
2.6.20) but after that bttv driver is getting worse and worse, from 2.6.22 to 2.6.24 i get this if i try to 
launch the second process in the same video input:

first mp4live works ok when i launch producer: Error: Could not set image size to 352x288 for color format 
I420 (15) (VIDIOCMCAPTURE: buffer 0)
first producer works ok when i launch mp4live: 12:59:59.333-mp4live: Failed to allocate video capture buffer 
for /dev/video0

and in 2.6.25 worse yet it has a deadlock, i have applied the patch listed here 
http://lkml.org/lkml/2008/5/17/139 but still doesnt works for capturing anything, before the patch it hangs 
the process after the patch it gives me other error about buffers different from the above in the first 
process attached to the video input so it is unusable.

Obviously my problem here it is that if i want to upgrade hardware i can have problems with sata, chipsets, 
audio or any other new hardware no supported in older kernels (apart from missing features). Should the 
situation with bttv drivers be better in future kernels or it is letting die for better support for new chips?

Regards,
Miguel Angel.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
