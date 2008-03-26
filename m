Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2QAdfos024562
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 06:39:41 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m2QAdRc1018961
	for <video4linux-list@redhat.com>; Wed, 26 Mar 2008 06:39:27 -0400
Date: Wed, 26 Mar 2008 11:38:54 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Matthew Wang <wangsu820@163.com>
Message-ID: <20080326103853.GA21053@stinkie>
References: <3358587.1081301206517482981.JavaMail.coremail@bj163app87.163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3358587.1081301206517482981.JavaMail.coremail@bj163app87.163.com>
Cc: video4linux-list@redhat.com
Subject: Re: ask about kernel video4linux module
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

On 26 Mar 08 15:44, Matthew Wang wrote:
> I enter the linux kernel (version is 2.6.8.1) and wanna get the videodev module,unfortunately I only got videodev.h or some other .h files, also I browsed the Makefile and Kconfig files but didn't get any code of v4l!

Sounds like you installed only the kernel headers and not the kernel sourcecode.
Your distribution should have a package for the sources.

The latest stable kernel sources are in
ftp://ftp.kernel.org/pub/linux/kernel/v2.6
The current development branch of v4l can be downloaded at
http://linuxtv.org/hg/v4l-dvb

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
