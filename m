Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819Ab2JKOFm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Oct 2012 10:05:42 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20121011093703.24b60232@infradead.org>
References: <20121011093703.24b60232@infradead.org> <30699.1349789424@warthog.procyon.org.uk> <20121009183908.1e402a43@infradead.org> <201210111023.51311.o.endriss@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: dhowells@redhat.com, Oliver Endriss <o.endriss@gmx.de>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [GIT PULL] Disintegrate UAPI for media
Date: Thu, 11 Oct 2012 15:05:31 +0100
Message-ID: <20566.1349964331@warthog.procyon.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> My understanding here is that, as the file location will change
> with this series, your original concern is now void, as userspace
> will require patches to use the new location. So, if we're willing
> to do it, let's put this one-driver-only obsolete API on a separate
> place.

As far as userspace is concerned, things will not change.  The header
installation step will copy the uapi/ headers to the place it used to copy the
non-uapi header.

David
