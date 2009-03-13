Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2D3oG1p030622
	for <video4linux-list@redhat.com>; Thu, 12 Mar 2009 23:50:16 -0400
Received: from smtp.day-one.co.nz (203-109-203-198.static.ihug.net
	[203.109.203.198])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n2D3ntv9013462
	for <video4linux-list@redhat.com>; Thu, 12 Mar 2009 23:49:57 -0400
Message-ID: <49B9D7D0.2000001@day-one.com>
Date: Fri, 13 Mar 2009 16:49:36 +1300
From: Mike Wilson <michael@day-one.com>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Single card using video0 and video1 at the same time
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

After upgrading from 2.6.27 to 2.6.28 we have found that a single bt8xx 
or cx88 card creates two device nodes (video0 and video1) when 
installing the device driver.
After trying various kernels from 2.6.27.14 to 2.6.28 the problem 
appeared in the changes between 2.7.27.19 and 2.6.28 .
The distro in question is Slackware.
Udev is deliberately disabled.

We we wondering if it was something to do with this patch.

patch number 9327
[linuxtv-commits] [hg:v4l-dvb] v4l: use video_device.num instead of minor in video%d

Any help appreciated
Thanks 
MikeW

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
