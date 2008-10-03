Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m93BDlIK015754
	for <video4linux-list@redhat.com>; Fri, 3 Oct 2008 07:13:47 -0400
Received: from smtp-vbr14.xs4all.nl (smtp-vbr14.xs4all.nl [194.109.24.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m93BDbjn001581
	for <video4linux-list@redhat.com>; Fri, 3 Oct 2008 07:13:37 -0400
Received: from tschai.lan (cm-84.208.85.194.getinternet.no [84.208.85.194])
	(authenticated bits=0)
	by smtp-vbr14.xs4all.nl (8.13.8/8.13.8) with ESMTP id m93BDbKe017370
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <video4linux-list@redhat.com>; Fri, 3 Oct 2008 13:13:37 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l <video4linux-list@redhat.com>
Date: Fri, 3 Oct 2008 13:13:36 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810031313.36607.hverkuil@xs4all.nl>
Subject: RFC: move zoran/core/i2c drivers to separate directories
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

It looks like 2.6.27 is nearing completion, so this is a good time to 
reorganize the video tree. IMHO it's getting rather messy in the 
media/video directory and I propose to make the following changes:

1) the zoran driver sources are moved into a video/zoran directory.
2) the v4l core sources (v4l* and videobuf*) are moved into a video/core 
directory. Since I'll be adding more v4l core sources in the near 
future this would keep everything together nicely.
3) the i2c drivers are moved to either media/video/i2c or media/i2c (I 
have no preference). This should make it easier to see what is the 
actual v4l driver and what is a supporting i2c driver. It's rather 
mixed up right now.

There are probably some sources where it is not clear where they should 
go (e.g. ir-kbd-i2c.c), when in doubt I prefer to keep them where they 
are now, they can always be moved later.

Are there any objections? Suggestions?

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
