Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5C9qb66014555
	for <video4linux-list@redhat.com>; Thu, 12 Jun 2008 05:52:37 -0400
Received: from scing.com (scing.com [217.160.110.58])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5C9qMAU022203
	for <video4linux-list@redhat.com>; Thu, 12 Jun 2008 05:52:23 -0400
From: Janne Grunau <janne-dvb@grunau.be>
To: video4linux-list@redhat.com
Date: Thu, 12 Jun 2008 11:52:55 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806121152.55574.janne-dvb@grunau.be>
Subject: Hauppauge HD PVR linux driver, first release
Reply-To: Janne Grunau <j@jannau.net>
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

I'm pleased to announce the immediately available of a mercurial 
repository for the Haupauge HD PVR.

The repository is at http://hg.jannau.net/hdpvr/. Follow the howto at 
http://linuxtv.org/repo/ but use hg clone http://hg.jannau.net/hdpvr/ 
instead of http://linuxtv.org/hg/v4l-dvb.

The driver is currently at most alpha quality and tested only with 
v4l2-ctl and cat /dev/video0. Other applications might fail in 
interesting ways.

I've compiled the driver only with kernel 2.6.24 and 2.6.25. A tester 
reported success on 2.6.22.

TODO:
-extend V4L MPEG encoding api (atm only add mpeg4 AVC and AAC
 as formats)
-test IR support and merge it into the official repo
-improve buffer management, especially make it fault-tolerant
-add missing device options (iirc only sharpness and
 chroma/luma filters)
-test with other v4l application and fix issues

Support for MythTV is already worked on.

I've probably missed a couple of things so feel free to reply or join 
the development irc channel #hdpvr on freenode.net.

Janne

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
