Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m48Al1XZ011443
	for <video4linux-list@redhat.com>; Thu, 8 May 2008 06:47:01 -0400
Received: from MTA006E.interbusiness.it (MTA006E.interbusiness.it [88.44.62.6])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m48Akj4R010449
	for <video4linux-list@redhat.com>; Thu, 8 May 2008 06:46:45 -0400
Message-ID: <4822DA0D.2040500@gmail.com>
Date: Thu, 08 May 2008 12:46:37 +0200
From: Mat <heavensdoor78@gmail.com>
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Empia em28xx - strange behavior
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


Hi all.
Again with an em28xx USB framegrabber (brand Digitus)...

I have my v4l2 app (based on capture_example from V4L2 specs) that 
starts on boot.
I get frames like this one:
  http://www.flickr.com/photos/17101105@N00/2471285296/

If I restart my app manually usually all goes well.
Like if... there's something wrong in the inizialization.

Does someone else got a similar problem?
Is there a good v4l2 user space library?
I'm trying to use libng (included in xawtv) but it doesn't seem easy to 
use actually (IMO).

Thank you in adavance.
Bye bye!
-Mat-

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
