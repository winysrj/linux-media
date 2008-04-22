Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3M2N3xW017612
	for <video4linux-list@redhat.com>; Mon, 21 Apr 2008 22:23:03 -0400
Received: from rn-out-0910.google.com (rn-out-0910.google.com [64.233.170.185])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3M2MWnb028811
	for <video4linux-list@redhat.com>; Mon, 21 Apr 2008 22:22:32 -0400
Received: by rn-out-0910.google.com with SMTP id e11so700180rng.7
	for <video4linux-list@redhat.com>; Mon, 21 Apr 2008 19:22:32 -0700 (PDT)
Date: Mon, 21 Apr 2008 19:22:21 -0700
From: Brandon Philips <brandon@ifup.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20080422022221.GE7392@plankton.ifup.org>
References: <op.t3hn72busxcvug@mrubli-nb.am.logitech.com>
	<20080213231244.GA15895@plankton.ifup.org>
	<20080415004416.GA11071@plankton.ifup.org>
	<20080415001932.52039d0f@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415001932.52039d0f@gaivota>
Cc: linux1@rubli.info, Martin Rubli <v4l2-lists@rubli.info>,
	Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: [PATCH] Support for write-only controls
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

On 00:19 Tue 15 Apr 2008, Mauro Carvalho Chehab wrote:
> Brandon, Could you please add this on one of your trees, together with those
> pending V4L2 API patches for UVC? I want to merge those changes together with the
> in-kernel driver that firstly requires such changes.

I have a tree with the change sets.  Please don't pull from the tip
though: hg pull -r 4ca1ed646f89 http://ifup.org/hg/v4l-uvc

The tip of that tree has UVC and all of the Kconfig/Makefile bits too.

The patch set for the tree: http://ifup.org/hg/uvc-v4l-patches

If Laurent wants to add his sign off to that last patch (based on r204)
we can commit that too :D

Cheers,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
