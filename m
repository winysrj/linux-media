Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47058
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbcGTAJr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 20:09:47 -0400
Date: Tue, 19 Jul 2016 21:09:42 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>
Subject: Re: Troubles with kernel-doc and RST files
Message-ID: <20160719210942.3ecf2697@recife.lan>
In-Reply-To: <20160719171635.56d16034@lwn.net>
References: <20160717100154.64823d99@recife.lan>
	<20160719171635.56d16034@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 19 Jul 2016 17:16:35 -0600
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Sun, 17 Jul 2016 10:01:54 -0300
> Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> 
> > 3) When there's an asterisk inside the source code, for example, to
> > document a pointer, or when something else fails when parsing a
> > header file, kernel-doc handler just outputs:
> > 	/devel/v4l/patchwork/Documentation/media/kapi/mc-core.rst:137: WARNING: Inline emphasis start-string without end-string.
> > 	/devel/v4l/patchwork/Documentation/media/kapi/mc-core.rst:470: WARNING: Explicit markup ends without a blank line; unexpected unindent.
> > 
> > pointing to a fake line at the rst file, instead of pointing to the
> > line inside the parsed header where the issue was detected, making
> > really hard to identify what's the error.
> > 
> > In this specific case, mc-core.rst has only 260 lines at the time I got
> > such error.  
> 
> This sounds like the same warning issue that Daniel was dealing with.
> Hopefully his config change will at least make these easier to deal with.
> 
> I wonder, though, if we could make kernel-doc a little smarter about
> these things so that the Right Thing happens for this sort of inadvertent
> markup?  If we could just recognize and escape a singleton *, that would
> make a lot of things work.

Yeah, that would be the best, but still, if some error happens, we need
the real line were it occurred, as it doesn't make sense to point to
a line that doesn't exist.


Thanks,
Mauro
