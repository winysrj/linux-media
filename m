Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:33860 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbcGRChW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 22:37:22 -0400
Date: Sun, 17 Jul 2016 20:37:19 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>
Subject: Re: Troubles with kernel-doc and RST files
Message-ID: <20160717203719.6471fe03@lwn.net>
In-Reply-To: <20160717100154.64823d99@recife.lan>
References: <20160717100154.64823d99@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[Back home and trying to get going on stuff for real.  I'll look at the
issues listed in this message one at a time.]

On Sun, 17 Jul 2016 10:01:54 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> 1) We now need to include each header file with documentation twice,
> one to get the enums, structs, typedefs, ... and another one for the
> functions:
> 
> 	.. kernel-doc:: include/media/media-device.h
> 
> 	.. kernel-doc:: include/media/media-entity.h
> 	   :export: drivers/media/media-entity.c

So I'm a little confused here; you're including from two different header
files here.  Did you want media-entity.h in both directives?

If I do a simple test with a single line:

	.. kernel-doc:: include/media/media-entity.h

I get everything - structs, functions, etc. - as I would expect.  Are you
seeing something different?

It probably would be nice to have an option for "data structures, doc
sections, and exported functions only" at some point.

Thanks,

jon
