Return-path: <video4linux-list-bounces@redhat.com>
Message-Id: <20080328093944.278994792@ifup.org>
Date: Fri, 28 Mar 2008 02:39:44 -0700
From: brandon@ifup.org
To: mchehab@infradead.org
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org
Subject: [patch 0/9] videobuf fixes 2.6.25
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

Hello-

The following set fixes problems I discovered while tracking down bugs in both
vivi and videobuf.  Hopefully most of these can make it into 2.6.25 since they
all seem pretty critical.

Please take a good look at the set and test if possible.  Particularly:
  [RFC] videobuf: Avoid deadlock with QBUF

Also, is anyone using videobuf-vmalloc besides vivi?  The current videobuf API
feels over extended trying to take on the task of a second backend type. 

Thanks,

	Brandon

-- 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
