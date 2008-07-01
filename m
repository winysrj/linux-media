Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m61BQMsf010117
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 07:26:22 -0400
Received: from smtp1-g19.free.fr (smtp1-g19.free.fr [212.27.42.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m61BQAVn004879
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 07:26:11 -0400
Received: from smtp1-g19.free.fr (localhost.localdomain [127.0.0.1])
	by smtp1-g19.free.fr (Postfix) with ESMTP id 54E321AB2DC
	for <video4linux-list@redhat.com>;
	Tue,  1 Jul 2008 13:26:10 +0200 (CEST)
Received: from [192.168.0.13] (lns-bzn-57-82-249-4-9.adsl.proxad.net
	[82.249.4.9])
	by smtp1-g19.free.fr (Postfix) with ESMTP id 15A681AB2CA
	for <video4linux-list@redhat.com>;
	Tue,  1 Jul 2008 13:26:09 +0200 (CEST)
From: Jean-Francois Moine <moinejf@free.fr>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Date: Tue, 01 Jul 2008 13:21:36 +0200
Message-Id: <1214911296.1699.18.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: compilation errors
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

There should be something I missed in the linuxtv documents.

When I do a simple 'make', in v4l, it generates almost all the .ko files
of the modules of the first level. But I cannot find, for example, any
v4l2-common.ko, nor tuner-simple.ko.

Then, I linked by hand the tree to my kernel (2.6.26-rc8). I thought
some links only were needed, so I linked:
	drivers/media
	include/media
	include/linux/videodev2.h
A 'make' in the kernel tree stops with many warnings and errors, mainly:
	warning: "LINUX_VERSION_CODE" is not defined

Any hint? Thank you.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
