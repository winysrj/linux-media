Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx10.extmail.prod.ext.phx2.redhat.com
	[10.5.110.14])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o3ID1Qta031386
	for <video4linux-list@redhat.com>; Sun, 18 Apr 2010 09:01:26 -0400
Received: from mail-pv0-f174.google.com (mail-pv0-f174.google.com
	[74.125.83.174])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o3ID0dpB001111
	for <video4linux-list@redhat.com>; Sun, 18 Apr 2010 09:01:15 -0400
Received: by mail-pv0-f174.google.com with SMTP id 18so2522369pva.33
	for <video4linux-list@redhat.com>; Sun, 18 Apr 2010 06:01:15 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 18 Apr 2010 22:34:58 +1000
Message-ID: <x2ha64f67eb1004180534u17079d45lcb224fb3940a27ca@mail.gmail.com>
Subject: Need Info
From: linux newbie <linux.newbie79@gmail.com>
To: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

On my embedded PXA255 platform, we have working USB module. ISP1362 is the
controller. Recently we want to integrate Microsoft Lifecam Cinema webcam
and want to take still images.

Linux kernel is 2.6.26.3 and we enabled V4L2 and UVC class drivers. On
plugging the Cam and querying the proc and sys file system, I can able to
view cam details.

I want to capture the frame (preferably in jpeg) and write to a file. Is
there any example code for that? I went through the below web page
http://v4l2spec.bytesex.org/spec/capture-example.html, but if you can
suggest some more example, it will be of great help to me.

Thanks
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
