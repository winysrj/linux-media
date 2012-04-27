Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:38437 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535Ab2D0QEA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 12:04:00 -0400
Date: Fri, 27 Apr 2012 10:03:58 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Chris Ball <cjb@laptop.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] marvell-cam: Build fix: missing "select
 VIDEOBUF2_VMALLOC"
Message-ID: <20120427100358.4f5c2be7@lwn.net>
In-Reply-To: <87d36u9rzc.fsf@laptop.org>
References: <87d36u9rzc.fsf@laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 26 Apr 2012 16:07:51 -0400
Chris Ball <cjb@laptop.org> wrote:

> drivers/built-in.o: In function `mcam_v4l_open':
> /drivers/media/video/marvell-ccic/mcam-core.c:1565: undefined reference to `vb2_vmalloc_memops'

This one is very strange.  If you look at mcam-core.h, you'll see it
shouldn't be trying to do anything with vmalloc unless the videobuf2 option
is already configured in.  I don't get this particular error, and I can't
quite see how you do...?

jon
