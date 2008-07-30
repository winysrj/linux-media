Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6UNHLk3007289
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 19:17:21 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.229])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6UNHA9E017114
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 19:17:10 -0400
Received: by rv-out-0506.google.com with SMTP id f6so371979rvb.51
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 16:17:10 -0700 (PDT)
Message-ID: <dbc6d8cc0807301617o30f7b87es44b2fae8a878a942@mail.gmail.com>
Date: Wed, 30 Jul 2008 18:17:09 -0500
From: "Chien-Yu Chen" <torus0@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: documentation for manipulating /dev/video
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

hi
   I need some simple program to set the norm, freq, and all that good stuff
so that I can use a tuner card as input for ffmpeg.

I took a look at v4lctl, which has too much un-wanted stuff.  and I am
cross-compiling for a diskless system. so don't really want to compile the
whole xawtv package.  please direct me to documentations, or if you know
such simple program exist.  thanks

-- 
Any MicroSoft extension file will directly go to trash without any warning
and regret.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
