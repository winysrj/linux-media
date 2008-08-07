Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m77HhR1T027414
	for <video4linux-list@redhat.com>; Thu, 7 Aug 2008 13:43:27 -0400
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.191])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m77HhFig019607
	for <video4linux-list@redhat.com>; Thu, 7 Aug 2008 13:43:15 -0400
Received: by nf-out-0910.google.com with SMTP id d3so241273nfc.21
	for <video4linux-list@redhat.com>; Thu, 07 Aug 2008 10:43:14 -0700 (PDT)
Message-ID: <489B342E.50506@lfarkas.org>
Date: Thu, 07 Aug 2008 19:43:10 +0200
From: Farkas Levente <lfarkas@lfarkas.org>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: how to discover that a device is v4l or v4l2?
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

hi,
how can i discover whether a video device /dev/video0 is support v4l or 
v4l2? currently if i try to use the wrong type in gstreamer it's hang 
forever and only a hard kill can help.
is there any way where can i find out the type?
thanks.

-- 
   Levente                               "Si vis pacem para bellum!"

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
