Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2AG5eBS004405
	for <video4linux-list@redhat.com>; Tue, 10 Mar 2009 12:05:40 -0400
Received: from web54504.mail.re2.yahoo.com (web54504.mail.re2.yahoo.com
	[206.190.49.154])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n2AG4sSr017061
	for <video4linux-list@redhat.com>; Tue, 10 Mar 2009 12:04:54 -0400
Message-ID: <504280.69749.qm@web54504.mail.re2.yahoo.com>
Date: Tue, 10 Mar 2009 09:04:54 -0700 (PDT)
From: Chris Camacho <chris_camacho@yahoo.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: firewire v4l2 bridge
Reply-To: chris_camacho@yahoo.com
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


I currently use corrianda and vloopback to provide video
to my own application and also work I do using open-cv
(alas its v4l v1 :o )

Using the firewire libs I've managed to make my camera unresponsive a
number of times and this way round although not ideal is very stable

What I'd love to see is a deamon that took configuration from a file and provided a v4l2 interface. (ideally without needing vloopback)

I'd be quite happy even if the deamon reported that the v4l2 device could only do the mode it was started up with
(24bit RBG 640x480 15fps I can live with...)

Has anyone seen anything like this for firewire webcams?

Thanks
Chris



      

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
