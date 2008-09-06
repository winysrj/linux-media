Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m86AProJ028914
	for <video4linux-list@redhat.com>; Sat, 6 Sep 2008 06:25:53 -0400
Received: from smtp-vbr2.xs4all.nl (smtp-vbr2.xs4all.nl [194.109.24.22])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m86APd6b026455
	for <video4linux-list@redhat.com>; Sat, 6 Sep 2008 06:25:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Dmitry Podyachev <vdp@infomir.com.ua>
Date: Sat, 6 Sep 2008 12:25:33 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809061225.33284.hverkuil@xs4all.nl>
Cc: v4l <video4linux-list@redhat.com>
Subject: Fixed Compro H900 tuner audio
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

Hi Dmitry,

After trying it myself I could confirm that the audio from the tuner was 
indeed gone.

It turns out that earlier fixes to get proper stereo audio from the 
tuner broke it for the Compro H900. It's now fixed.

You can get the code from my tree:

http://www.linuxtv.org/hg/~hverkuil/v4l-dvb

I'll try to get it in 2.6.27 before it is released.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
