Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4FFIV0a008983
	for <video4linux-list@redhat.com>; Thu, 15 May 2008 11:18:31 -0400
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.229])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4FFIJ8p006879
	for <video4linux-list@redhat.com>; Thu, 15 May 2008 11:18:20 -0400
Received: by wr-out-0506.google.com with SMTP id c57so191320wra.9
	for <video4linux-list@redhat.com>; Thu, 15 May 2008 08:18:19 -0700 (PDT)
Message-ID: <8bf247760805150818j308bc74fsf7755f03f9fa8503@mail.gmail.com>
Date: Thu, 15 May 2008 20:48:19 +0530
From: Ram <vshrirama@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: Sakari Ailus <sakari.ailus@nokia.com>
Subject: Query menu ioctl support?
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
I am looking at the structure "struct v4l2_int_ioctl_desc".
There is no ioctls for query menu which existed in earlier V4L2 versions.

I have ioctls that are of type V4L2_CTRL_TYPE_MENU.

am i missing something here?


Regards,
sriram

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
