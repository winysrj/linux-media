Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m55EQmV3001795
	for <video4linux-list@redhat.com>; Thu, 5 Jun 2008 10:26:48 -0400
Received: from smtp166.iad.emailsrvr.com (smtp166.iad.emailsrvr.com
	[207.97.245.166])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m55EQO7M001789
	for <video4linux-list@redhat.com>; Thu, 5 Jun 2008 10:26:25 -0400
Received: from relay6.relay.iad.emailsrvr.com (localhost [127.0.0.1])
	by relay6.relay.iad.emailsrvr.com (SMTP Server) with ESMTP id
	4074476DF14
	for <video4linux-list@redhat.com>; Thu,  5 Jun 2008 10:26:18 -0400 (EDT)
Received: by relay6.relay.iad.emailsrvr.com (Authenticated sender:
	jon.dufresne-AT-infinitevideocorporation.com) with ESMTP id
	2ECCB76F0F4
	for <video4linux-list@redhat.com>; Thu,  5 Jun 2008 10:26:18 -0400 (EDT)
From: Jon Dufresne <jon.dufresne@infinitevideocorporation.com>
To: video4linux-list@redhat.com
Content-Type: text/plain
Date: Thu, 05 Jun 2008 10:26:17 -0400
Message-Id: <1212675977.16563.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Writing first v4l2 driver
Reply-To: jon.dufresne@infinitevideocorporation.com
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

I'm in the process of writing my first v4l2 linux driver. I have written
drivers in the past but this is my first time with a video device. I
have read as much documentation as I could get my hands on.

My device is a pci capture device and I am trying to use streaming
mmaped buffers. Right now I am trying to integrate the video-buf helper
functions to do the actual frame grabbing. I am quite confused as how
this all fits together. 

Is there a good guide on using video-buf for video dma transfer? I did
quite a few google searches but I didn't find anything.

What is the simplest example of a capture device using video-buf for a
streaming device in the source tree to use as an example? I've looked at
a few, but I want to look at the simplest one.

Thanks for any help,
Jon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
