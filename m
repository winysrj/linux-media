Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:43501 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481Ab2HPRLI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 13:11:08 -0400
Date: Thu, 16 Aug 2012 11:11:26 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Chris Ball <cjb@laptop.org>, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] marvell-cam: Build fix: missing "select
 VIDEOBUF2_VMALLOC"
Message-ID: <20120816111126.60443d36@lwn.net>
In-Reply-To: <50298248.2000609@redhat.com>
References: <87d36u9rzc.fsf@laptop.org>
	<20120427100358.4f5c2be7@lwn.net>
	<87fwbp86py.fsf@laptop.org>
	<50298248.2000609@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 13 Aug 2012 19:40:08 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> Ping?
> 
> Is this patch needed or not?

Sorry, I have dropped vast numbers of balls over the last six months and
am far from having picked them all up.

Reviewing the conversation, I still must confess that I don't understand
the problem.  Why is having the VB2 vmalloc support built as a module a
problem?  

> Another alternative would be to change the Kconfig stuff to explicitly select
> the type of videobuf2 that would be used by those drivers, something like the
> enclosed (untested) patch.

The current Kconfig already has specific select lines for the supported
modes.  

When I get a chance, I'll go in and try to reproduce the problem, but it
may be a little bit, sorry...

jon
