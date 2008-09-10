Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8AC87oj001082
	for <video4linux-list@redhat.com>; Wed, 10 Sep 2008 08:08:07 -0400
Received: from mail-gx0-f15.google.com (mail-gx0-f15.google.com
	[209.85.217.15])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8AC81N8028056
	for <video4linux-list@redhat.com>; Wed, 10 Sep 2008 08:08:01 -0400
Received: by gxk8 with SMTP id 8so6431845gxk.3
	for <video4linux-list@redhat.com>; Wed, 10 Sep 2008 05:08:01 -0700 (PDT)
Message-ID: <3192d3cd0809100508v7da001d1oacd8fe076be5db5@mail.gmail.com>
Date: Wed, 10 Sep 2008 12:08:01 +0000
From: "Christian Gmeiner" <christian.gmeiner@gmail.com>
To: "Linux and Kernel Video" <video4linux-list@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Extending current adv717x drivers
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

Hi all,

I am one of the supporters of the dxr3 drivers for Linux [0]. The big
goal is it to get the driver ready
for the mainline kernel. As this needs lot of work to be done, I will
start with one of the top items
of my todo list. Extending current adv717x drivers with new functionality.

As you can see here [1] and [2] the adv717x driver offers some more
functions, which are needed
for the dxr3 driver - e.g. switching pixel port between 8-bit
multiplexed YCrCb and 16 bit YCrCb.

The current drivers used v4l1 include and so I had a look at the v4l2
api but I am not sure how such
a driver can be switched to v4l2. If this is not the case, whats the
best way to "merge" dxr3s driver
with the in-kernel driver?

[0] http://dxr3.sf.net
[1] http://dxr3.sourceforge.net/hg/em8300-nboullis/file/37328a436d49/modules/adv717x.c
[2] http://dxr3.sourceforge.net/hg/em8300-nboullis/file/37328a436d49/modules/adv717x.h


Thanks for your help,
-- 
BSc, Christian Gmeiner

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
