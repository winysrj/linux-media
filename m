Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6GCuDiM032590
	for <video4linux-list@redhat.com>; Wed, 16 Jul 2008 08:56:13 -0400
Received: from jem.yoyo.org (jem.yoyo.org [193.110.91.2])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6GCtufN011232
	for <video4linux-list@redhat.com>; Wed, 16 Jul 2008 08:55:57 -0400
Received: from anthony by jem.yoyo.org with local (Exim 4.69)
	(envelope-from <anthony@yoyo.org>) id 1KJ6Y0-0003EU-9Y
	for video4linux-list@redhat.com; Wed, 16 Jul 2008 13:55:56 +0100
Date: Wed, 16 Jul 2008 13:55:56 +0100
From: Anthony Edwards <anthony@yoyo.org>
To: video4linux-list@redhat.com
Message-ID: <20080716125556.GA9609@yoyo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: smscoreapi.c:689: error: 'uintptr_t' undeclared
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

This appears to be an issue affecting a number of users, for example:

http://forum.linuxmce.org/index.php?action=profile;u=41878;sa=showPosts

I have experienced it too today after attempting to recompile drivers
for my Hauppauge Nova-T USB TV tuner following an Ubuntu kernel update.

After obtaining the latest source code using hg clone, I have found
that it will not successfully compile.  I am seeing the same make
errors as the poster in the posting referenced above.

Unfortunately, I lack the necessary programming knowledge to hack the
source code in order to make it work.

Is a fix in the pipeline?

-- 
Anthony Edwards
anthony@yoyo.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
