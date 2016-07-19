Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:41466 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbcGSWtS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 18:49:18 -0400
Date: Tue, 19 Jul 2016 16:49:16 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>
Subject: Re: [PATCH 00/18] Complete moving media documentation to ReST
 format
Message-ID: <20160719164916.3ebb1c74@lwn.net>
In-Reply-To: <20160719115319.316349a7@recife.lan>
References: <cover.1468865380.git.mchehab@s-opensource.com>
	<578DF08F.8080701@xs4all.nl>
	<20160719081259.482a8c04@recife.lan>
	<6702C6D4-929F-420D-9CF9-911CA753B0A7@darmarit.de>
	<20160719115319.316349a7@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 19 Jul 2016 11:53:19 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> So, I guess we should set the minimal requirement to 1.2.x.

*sigh*.

I hate to do that; things are happening quickly enough with Sphinx that
it would be nice to be able to count on a newer version.  That said, one
of my goals in this whole thing was to make it *easier* for developers to
generate the docs; the DocBook toolchain has always been notoriously
difficult in that regard.  Forcing people to install a newer sphinx by
hand is not the way to get there.

So I guess we need to make sure things work with 1.2 for now.  I'd hope
we could push that to at least 1.3 before too long, though, once the
community distributions are there.  I think we can be a *bit* more
aggressive with the docs than with the kernel as a whole.

jon
