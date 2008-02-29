Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1TL1Mq9023476
	for <video4linux-list@redhat.com>; Fri, 29 Feb 2008 16:01:23 -0500
Received: from QMTA01.westchester.pa.mail.comcast.net
	(qmta01.westchester.pa.mail.comcast.net [76.96.62.16])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1TL0nqH023472
	for <video4linux-list@redhat.com>; Fri, 29 Feb 2008 16:00:49 -0500
Message-ID: <47C87277.2020007@personnelware.com>
Date: Fri, 29 Feb 2008 15:00:39 -0600
From: Carl Karsten <carl@personnelware.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: registered as /dev/video%d for all
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

I want to patch vivi.c to identify what /dev it attaches itself to.

Current:

1342 	        if (ret < 0) {
1343 	                vivi_release();
1344 	                printk(KERN_INFO "Error %d while loading vivi driver\n", ret);
1345 	        } else
1346 	                printk(KERN_INFO "Video Technology Magazine Virtual Video "
1347 	                                 "Capture Board successfully loaded.\n");
1348 	        return ret;

http://www.video4linux.org/browser/linux/drivers/media/video/vivi.c#L1342


In looking at the other drivers, I see each has it's own "module loaded" code. 
  Would it make sense to make a generic bit of code that can be included in 
every driver?

w9968cf.c seems to have the most detail and might be good for use on all others:

  * USB probe and V4L registration, disconnect and id_table[] definition     *
...

w9968cf.c DBG(2, "V4L device registered as /dev/video%d", cam->v4ldev->minor)

http://www.video4linux.org/browser/linux/drivers/media/video/w9968cf.c#L3577

Or does each driver really need it's own?

Carl K

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
