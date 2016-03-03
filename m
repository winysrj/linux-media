Return-path: <linux-media-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49450 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757788AbcCCOeu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 09:34:50 -0500
Date: Thu, 3 Mar 2016 14:34:25 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Jani Nikula <jani.nikula@intel.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Keith Packard <keithp@keithp.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: Kernel docs: muddying the waters a bit
Message-ID: <20160303143425.2361dea2@lxorguk.ukuu.org.uk>
In-Reply-To: <20160303071305.247e30b1@lwn.net>
References: <20160213145317.247c63c7@lwn.net>
	<87y49zr74t.fsf@intel.com>
	<20160303071305.247e30b1@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> DocBook is a means to an end; nobody really wants DocBook itself as far
> as I can tell. 

We only have docbook because it was the tool of choice rather a lot of
years ago to then get useful output formats. It was just inherited when
borrowed the original scripts from Gnome/Gtk. It's still the most
effective way IMHO of building big structured documents out of the kernel.

The Gtk people long ago rewrote the original document script into a real
tool so they have some different and maintained tools that are close to
equivalent and already have some markdown support. Before we go off and
re-invent the wheel it might be worth just borrowing their wheel and
tweaking it as needed ? In particular they can generate help indexes so
that the entire output becomes nicely browsable with an HTML based help
browser.

Alan
