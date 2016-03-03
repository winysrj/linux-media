Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:34322 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756914AbcCCPps (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 10:45:48 -0500
Received: by mail-ob0-f182.google.com with SMTP id ts10so23677101obc.1
        for <linux-media@vger.kernel.org>; Thu, 03 Mar 2016 07:45:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160303081709.5907bcd8@lwn.net>
References: <20160213145317.247c63c7@lwn.net>
	<87y49zr74t.fsf@intel.com>
	<20160303071305.247e30b1@lwn.net>
	<20160303143425.2361dea2@lxorguk.ukuu.org.uk>
	<20160303081709.5907bcd8@lwn.net>
Date: Thu, 3 Mar 2016 16:45:45 +0100
Message-ID: <CAKMK7uHTav0MF-aqbdoW-nn+1tTi9-ZJyDWahDjTTVAuUUNfSg@mail.gmail.com>
Subject: Re: Kernel docs: muddying the waters a bit
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Jonathan Corbet <corbet@lwn.net>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
	Jani Nikula <jani.nikula@intel.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Keith Packard <keithp@keithp.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Graham Whaley <graham.whaley@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 3, 2016 at 4:17 PM, Jonathan Corbet <corbet@lwn.net> wrote:
> I assume you're referring to gtk-doc?  It's web page
> (http://www.gtk.org/gtk-doc/) starts by noting that it's "a bit awkward to
> setup and use"; they recommend looking at Doxygen instead.  So I guess I'm
> not really sure what it offers that merits throwing another option into
> the mix now?  What am I missing?

We use gtk-doc for the i915 testcase and tooling repo in userspace
(intel-gpu-tools). The setup is somewhat arcane (some build-fu that is
fumbly, and xml files to tie everything together). But it looks pretty
and works well otherwise. It should be at
https://01.org/linuxgraphics/gfx-docs/igt/ but our autobuilder seems
to be screwed up right now.

Of course I considered it as an option, but like doxygen it has it's
own strong opinion about how in-code comments should look like, and
those differ from kerneldoc syntax. Beyond that I don't really see
benefits over any of the solutions proposed here already (either
sphinx or rst or horror! even the hackfest I still carry around in
drm-intel.git branches).

Btw for igt we went with gtkdoc over docygen because a few people on
our team had "doxygen only over my corpse" level kind of strong
opinions. Everyone just loves their own color choice for this bikeshed
;-)
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
