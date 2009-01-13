Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0D8rNPP018231
	for <video4linux-list@redhat.com>; Tue, 13 Jan 2009 03:53:23 -0500
Received: from comal.ext.ti.com (comal.ext.ti.com [198.47.26.152])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0D8r79f017922
	for <video4linux-list@redhat.com>; Tue, 13 Jan 2009 03:53:07 -0500
Received: from dlep95.itg.ti.com ([157.170.170.107])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id n0D8r1FR015231
	for <video4linux-list@redhat.com>; Tue, 13 Jan 2009 02:53:06 -0600
Received: from dlee73.ent.ti.com (localhost [127.0.0.1])
	by dlep95.itg.ti.com (8.13.8/8.13.8) with ESMTP id n0D8r1VC013618
	for <video4linux-list@redhat.com>; Tue, 13 Jan 2009 02:53:01 -0600 (CST)
From: "Curran, Dominic" <dcurran@ti.com>
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Date: Tue, 13 Jan 2009 02:51:07 -0600
Message-ID: <96DA7A230D3B2F42BA3EF203A7A1B3B5011DA52650@dlee07.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Questions about V4L2_CID_FOCUS_RELATIVE ?
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
As I understand there are basically two types of lens driver.
 
To get/set the lens position they use either:
V4L2_CID_FOCUS_ABSOLUTE
Or
V4L2_CID_FOCUS_RELATIVE
 
Does anyone have an example of a lens driver that uses V4L2_CID_FOCUS_RELATIVE ?
 
I am having difficulty understanding how this ioctl ID is used...
 
- I assume that the VIDIO_G_CTRL ioctl does not make sense for an id=V4L2_CID_FOCUS_RELATIVE. Correct ?
 
- When using VIDIO_S_CTRL ioctl with id= V4L2_CID_FOCUS_RELATIVE.
  I assume that the 'value' field passed down in struct v4l2_control is used to determine the direction the lens should move:
i.e. +ve value = move 'value' steps in infinity direction
     -ve value = move 'value' steps in macro direction
  Does this seem correct ?
 
Thanks
dom

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
