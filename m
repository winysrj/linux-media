Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21441 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbcCCODW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2016 09:03:22 -0500
From: Jani Nikula <jani.nikula@intel.com>
To: Jonathan Corbet <corbet@lwn.net>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Keith Packard <keithp@keithp.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: Kernel docs: muddying the waters a bit
In-Reply-To: <20160213145317.247c63c7@lwn.net>
References: <20160213145317.247c63c7@lwn.net>
Date: Thu, 03 Mar 2016 16:03:14 +0200
Message-ID: <87y49zr74t.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 13 Feb 2016, Jonathan Corbet <corbet@lwn.net> wrote:
> So can we discuss?  I'm not saying we have to use Sphinx, but, should we
> choose not to, we should do so with open eyes and good reasons for the
> course we do take.  What do you all think?

This stalled a bit, but the waters are still muddy...

Is the Sphinx/reStructuredText table support adequate for media/v4l
documentation?

Are the Sphinx output formats adequate in general? Specifically, is the
lack of DocBook support, and the flexibility it provides, a blocker?

Otherwise, I think Sphinx is promising.

Jon, I think we need a roll of dice, err, a well-thought-out decision
from the maintainer to go with one or the other, so we can make some
real progress.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
