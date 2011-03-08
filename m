Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:57484 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151Ab1CHSEP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Mar 2011 13:04:15 -0500
Date: Tue, 8 Mar 2011 11:04:12 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linaro-dev@lists.linaro.org, linux-media@vger.kernel.org,
	Jonghun Han <jonghun.han@samsung.com>,
	Hugh Dickins <hughd@google.com>
Subject: Re: Yet another memory provider: can linaro organize a meeting?
Message-ID: <20110308110412.73ea8be9@bike.lwn.net>
In-Reply-To: <201103080913.59231.hverkuil@xs4all.nl>
References: <201103080913.59231.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 8 Mar 2011 09:13:59 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> All these memory-related modules have the same purpose: make it possible to
> allocate/reserve large amounts of memory and share it between different
> subsystems (primarily framebuffer, GPU and V4L).
> 
> It really shouldn't be that hard to get everyone involved together and settle
> on a single solution (either based on an existing proposal or create a 'the
> best of' vendor-neutral solution).

There is a memory management summit at the LF Collaboration Summit next
month.  Perhaps this would be a good topic to raise there?  I've added
Hugh to the Cc list in case he has any thoughts on the matter - and
besides, he doesn't have enough to do...:)

jon
