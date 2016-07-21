Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:52640 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481AbcGUQ7G (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 12:59:06 -0400
Date: Thu, 21 Jul 2016 10:59:04 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>
Subject: Re: [PATCH 00/18] Complete moving media documentation to ReST
 format
Message-ID: <20160721105904.55733f6e@lwn.net>
In-Reply-To: <A1987523-8798-4744-81B3-8DA678651634@darmarit.de>
References: <cover.1468865380.git.mchehab@s-opensource.com>
	<578DF08F.8080701@xs4all.nl>
	<20160719081259.482a8c04@recife.lan>
	<6702C6D4-929F-420D-9CF9-911CA753B0A7@darmarit.de>
	<20160719115319.316349a7@recife.lan>
	<20160719164916.3ebb1c74@lwn.net>
	<20160719210023.2f8280ac@recife.lan>
	<E8A50DCE-D40B-4C4C-B899-E48F3C0C9CDA@darmarit.de>
	<20160720172858.6659275d@lwn.net>
	<A1987523-8798-4744-81B3-8DA678651634@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 21 Jul 2016 16:41:53 +0200
Markus Heiser <markus.heiser@darmarit.de> wrote:

> Am 21.07.2016 um 01:28 schrieb Jonathan Corbet <corbet@lwn.net>:
>
> > I would hope that most people wouldn't have to worry about it, and would
> > be able to just use what their distribution provides - that's the reason
> > for the 1.2 compatibility requirement in the first place.  
> 
> Yes, but this is not what I mean ;) ... if someone use a distro 
> with a version > 1.2 and he use features not in 1.2, you -- the
> maintainer -- will get into trouble. 

Well, that's what we keep maintainers around.  The same holds for any
maintainer if somebody adds a dependency on a too-new version of some other
tool.  Such things happen, we simply fix them when they do.

> IMHO contributors need a reference documentation (e.g. at kernel.org)
> and a reference build environment (like you, see below).

Reference documentation, yes.  But I don't think every developer needs a
Sphinx 1.2 installation, just like they don't need to have gcc 3.2 around.
It's enough that somebody has it and will catch problems.

jon
