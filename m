Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344Ab0BVRtf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 12:49:35 -0500
Message-ID: <4B82C3A5.7070707@redhat.com>
Date: Mon, 22 Feb 2010 14:49:25 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Pawel Osciak <p.osciak@samsung.com>
CC: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl, m-karicheri2@ti.com
Subject: Re: [PATCH/RFC v1 0/4] Multi-plane video buffer support for V4L2
 API and videobuf
References: <1266855010-2198-1-git-send-email-p.osciak@samsung.com>
In-Reply-To: <1266855010-2198-1-git-send-email-p.osciak@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pawel Osciak wrote:
> Hello,
> 
> This is a preliminary implementation of multi-planar buffer support for V4L2
> and videobuf.
> 
> It is a rather big change so I wanted to put it up for discussion sooner rather
> than later, in case we decide to go in a completely different direction.
> 
> We are proposing backward compatible extensions to the V4L2 API

This seems to be the better way. Of course, tests are needed to be sure that no regression
will be introduced by it.

> and a redesign
> of memory handling in videobuf core and its memory type modules. The videobuf
> redesign should have a minimal impact on current drivers though. No videobuf
> high-level logic (queuing, etc.) has been changed.

Seems reasonable.

> Only streaming I/O has been tested, read/write might not work correctly.
> vivi has been adapted for testing and demonstration purposes, but other drivers
> will not compile. Tests have been made on vivi and on an another driver for an
> embedded device (those involved dma-contig and USERPTR as well). I am not
> attaching that driver, as I expect nobody would be able to compile/test it
> anyway.

It would be interesting if you could add userptr support for videobuf-vmalloc, and
test all supported modes with vivi. This helps to test the changes against existing
userspace applications before needing to touch on all drivers.

Cheers,
Mauro
