Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46579 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab0CVNtN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Mar 2010 09:49:13 -0400
Message-ID: <4BA77552.8080908@infradead.org>
Date: Mon, 22 Mar 2010 10:49:06 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: RFC: Phase 2/3: Move the compat code into v4l1-compat. Convert
 apps.
References: <201003201021.05426.hverkuil@xs4all.nl> <4BA556D1.1090602@redhat.com> <201003220911.36035.hverkuil@xs4all.nl>
In-Reply-To: <201003220911.36035.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> On Sunday 21 March 2010 00:14:25 Hans de Goede wrote:

>> Yes it can, this for example already happens when using v4l1 apps with
>> uvcvideo (which is not possible without libv4l1).
> 
> In what way does libv4l1 still depend on the kernel's v4l1 compat layer? And
> what is needed to remove that dependency?
> 
> Because I think that that is the best approach.

Agreed. After being sure that it will properly work with all types of app
(e. g. radio/vbi/tv/stream/record/..), we can add a features removal patch
announcing that the backport got moved to userspace and it will be removed
from kernel.
>  
>>> The third phase that can be done in parallel is to convert V4L1-only apps.
>>> I strongly suspect that any apps that are V4L1-only are also unmaintained.
>>> We have discussed before that we should set up git repositories for such
>>> tools (xawtv being one of the more prominent apps since it contains several
>>> v4l1-only console apps). Once we have maintainership, then we can convert
>>> these tools to v4l2 and distros and other interested parties have a place
>>> to send patches to.
>>>
>> As said before I wouldn't mind maintaining an xawtv git tree @ linuxtv,
>> assuming this tree were to be based on the 3.95 release.
> 
> Mauro, do you have any objection to hosting xawtv on linuxtv? We may need
> another tree later as well if we decide to split off the xawtv console tools
> into a separate tree. But perhaps they would fit under v4l-utils as well,
> we'll have to see.

Not at all. Feel free to add a git tree to all applications you want. If you have
problems, please ping me. After creating the tree(s), just send me an email with
the name of the maintainer(s) and I'll move them to the right place, enabling the
announcement hooks if needed. If possible, please get the old maintainer's ack.

With respect to the announcements, we're currently using the same mailing list
(linuxtv-commits@linuxtv.org) for all sorts of announcement: dvb-apps, v4l-utils, 
v4l-dvb.git, fixes.git v4l-dvb(hg).

If we're starting to populate the server with other trees, it may be a good idea to
split the ML into groups, or eventually into per-tree list.

Comments?


-- 

Cheers,
Mauro
