Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9LJnv3F003532
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 15:49:57 -0400
Received: from mailrelay007.isp.belgacom.be (mailrelay007.isp.belgacom.be
	[195.238.6.173])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9LJnknh031626
	for <video4linux-list@redhat.com>; Tue, 21 Oct 2008 15:49:46 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Tue, 21 Oct 2008 21:49:57 +0200
References: <200810211916.47434.hverkuil@xs4all.nl>
In-Reply-To: <200810211916.47434.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810212149.58105.laurent.pinchart@skynet.be>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Proposal to rename compat_ioctl32.c to v4l2-compat-ioctl32.c
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

On Tuesday 21 October 2008, Hans Verkuil wrote:
> Hi Mauro,
>
> The compat_ioctl32.c is the only v4l2 core source whose name does not
> begin with v4l2-. Because of that it is often overlooked (I certainly
> did in the past!) when adding new ioctls.
>
> I propose to rename it to v4l2-compat-ioctl32.c. What I'm not sure of is
> whether it is OK to rename the module as well to
> v4l2_compat_ioctl32.ko? Or should that remain compat_ioctl32.ko?
>
> Personally I think it would be nice if this rename could go into 2.6.28.
> This file is rarely touched so the chances of merge conflicts seem
> remote to me.
>
> Note that I'm abroad from tomorrow until Sunday, so if you agree then
> it's probably quicker if you make the change rather than waiting for me
> to return. It's trivial anyway.

I'm in favour of the change. Renaming the module should not be an issue as it 
should be pulled in by modprobe as a dependency anyway.

Regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
