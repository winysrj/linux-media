Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9KDuF0x015960
	for <video4linux-list@redhat.com>; Mon, 20 Oct 2008 09:56:15 -0400
Received: from linos.es (centrodatos.linos.es [86.109.105.97])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9KDu3m0019222
	for <video4linux-list@redhat.com>; Mon, 20 Oct 2008 09:56:04 -0400
Message-ID: <48FC8DF1.8010807@linos.es>
Date: Mon, 20 Oct 2008 15:56:01 +0200
From: Linos <info@linos.es>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: bttv 2.6.26 problem
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

Hello, i have upgraded a debian machine from kernel 2.6.24 to 2.6.26 and now i 
have this error when try to launch helix producer on the capture input.

producer -vc /dev/video0 -ad 128k -vp "0" -dt -vm sharp -o /tmp/test.rm
Helix DNA(TM) Producer 11.0 Build number: 11.0.0.2013
Info: Starting encode
Error: Could not set image size to 352x288 for color format I420 (15) 
(VIDIOCMCAPTURE: buffer 0)
Warning: Capture Buffer is empty at 445090329ms for last 61 times
Warning: Capture Buffer is empty at 445091549ms for last 61 times

exactly the same producer version with the same command line works ok in 2.6.24, 
previously i have saw this error when i was trying to use from 2 different 
capture programs the same video input but this is not the case, it is the only 
program using /dev/video0, what can be happening?

Regards,
Miguel Angel.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
