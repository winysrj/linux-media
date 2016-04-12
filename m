Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:47192 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965870AbcDLPqW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2016 11:46:22 -0400
Date: Tue, 12 Apr 2016 09:46:20 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Dan Allen <dan@opendevise.io>,
	Russel Winder <russel@winder.org.uk>,
	Keith Packard <keithp@keithp.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org linux-media"
	<linux-media@vger.kernel.org>,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: Kernel docs: muddying the waters a bit
Message-ID: <20160412094620.4fbf05c0@lwn.net>
In-Reply-To: <8992F589-5B66-4BDB-807A-79AC8644F006@darmarit.de>
References: <20160213145317.247c63c7@lwn.net>
	<87y49zr74t.fsf@intel.com>
	<20160303071305.247e30b1@lwn.net>
	<20160303155037.705f33dd@recife.lan>
	<86egbrm9hw.fsf@hiro.keithp.com>
	<1457076530.13171.13.camel@winder.org.uk>
	<CAKeHnO6sSV1x2xh_HgbD5ddZ8rp+SVvbdjVhczhudc9iv_-UCQ@mail.gmail.com>
	<87a8m9qoy8.fsf@intel.com>
	<20160308082948.4e2e0f82@recife.lan>
	<CAKeHnO7R25knFH07+3trdi0ZotsrEE+5ZzDZXdx33+DUW=q2Ug@mail.gmail.com>
	<20160308103922.48d87d9d@recife.lan>
	<20160308123921.6f2248ab@recife.lan>
	<20160309182709.7ab1e5db@recife.lan>
	<87fuvypr2h.fsf@intel.com>
	<20160310122101.2fca3d79@recife.lan>
	<AA8C4658-5361-4BE1-8A67-EB1C5F17C6B4@darmarit.de>
	<8992F589-5B66-4BDB-807A-79AC8644F006@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 8 Apr 2016 17:12:27 +0200
Markus Heiser <markus.heiser@darmarit.de> wrote:

> motivated by this MT, I implemented a toolchain to migrate the kernel’s 
> DocBook XML documentation to reST markup. 
> 
> It converts 99% of the docs well ... to gain an impression how 
> kernel-docs could benefit from, visit my sphkerneldoc project page
> on github:
> 
>   http://return42.github.io/sphkerneldoc/

So I've obviously been pretty quiet on this recently.  Apologies...I've
been dealing with an extended death-in-the-family experience, and there is
still a fair amount of cleanup to be done.

Looking quickly at this work, it seems similar to the results I got.  But
there's a lot of code there that came from somewhere?  I'd put together a
fairly simple conversion using pandoc and a couple of short sed scripts;
is there a reason for a more complex solution?

Thanks for looking into this, anyway; I hope to be able to focus more on
it shortly.

jon
