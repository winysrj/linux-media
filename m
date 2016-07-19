Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:41593 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbcGSXQh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 19:16:37 -0400
Date: Tue, 19 Jul 2016 17:16:35 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>
Subject: Re: Troubles with kernel-doc and RST files
Message-ID: <20160719171635.56d16034@lwn.net>
In-Reply-To: <20160717100154.64823d99@recife.lan>
References: <20160717100154.64823d99@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 17 Jul 2016 10:01:54 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> 3) When there's an asterisk inside the source code, for example, to
> document a pointer, or when something else fails when parsing a
> header file, kernel-doc handler just outputs:
> 	/devel/v4l/patchwork/Documentation/media/kapi/mc-core.rst:137: WARNING: Inline emphasis start-string without end-string.
> 	/devel/v4l/patchwork/Documentation/media/kapi/mc-core.rst:470: WARNING: Explicit markup ends without a blank line; unexpected unindent.
> 
> pointing to a fake line at the rst file, instead of pointing to the
> line inside the parsed header where the issue was detected, making
> really hard to identify what's the error.
> 
> In this specific case, mc-core.rst has only 260 lines at the time I got
> such error.

This sounds like the same warning issue that Daniel was dealing with.
Hopefully his config change will at least make these easier to deal with.

I wonder, though, if we could make kernel-doc a little smarter about
these things so that the Right Thing happens for this sort of inadvertent
markup?  If we could just recognize and escape a singleton *, that would
make a lot of things work.

jon
