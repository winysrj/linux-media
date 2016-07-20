Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:45945 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619AbcGTX3B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 19:29:01 -0400
Date: Wed, 20 Jul 2016 17:28:58 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>
Subject: Re: [PATCH 00/18] Complete moving media documentation to ReST
 format
Message-ID: <20160720172858.6659275d@lwn.net>
In-Reply-To: <E8A50DCE-D40B-4C4C-B899-E48F3C0C9CDA@darmarit.de>
References: <cover.1468865380.git.mchehab@s-opensource.com>
	<578DF08F.8080701@xs4all.nl>
	<20160719081259.482a8c04@recife.lan>
	<6702C6D4-929F-420D-9CF9-911CA753B0A7@darmarit.de>
	<20160719115319.316349a7@recife.lan>
	<20160719164916.3ebb1c74@lwn.net>
	<20160719210023.2f8280ac@recife.lan>
	<E8A50DCE-D40B-4C4C-B899-E48F3C0C9CDA@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 20 Jul 2016 08:07:54 +0200
Markus Heiser <markus.heiser@darmarit.de> wrote:

> Jon, what do you think ... could we serve this 1.2 doc 
> on https://www.kernel.org/doc/ as reference?

Seems like a good idea.  I don't really know who controls that directory,
though; I can ping Konstantin and see what can be done there.  Failing
that, I'd be more than happy to put it up on lwn, of course.

> And whats about those who have 1.3 (or any version >1.2) as default 
> in the linux distro? Should they install a virtualenv?  ... it is
> a dilemma.

I would hope that most people wouldn't have to worry about it, and would
be able to just use what their distribution provides - that's the reason
for the 1.2 compatibility requirement in the first place.  I'll make a
point of having a 1.2 installation around that I can test things with;
that should suffice to catch any problems that sneak in.

Thanks,

jon
