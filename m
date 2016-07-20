Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47065
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbcGTATN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 20:19:13 -0400
Date: Tue, 19 Jul 2016 21:19:08 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>
Subject: Re: Troubles with kernel-doc and RST files
Message-ID: <20160719211908.0178aade@recife.lan>
In-Reply-To: <20160719173024.5f98da1e@lwn.net>
References: <20160717100154.64823d99@recife.lan>
	<20160719173024.5f98da1e@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 19 Jul 2016 17:30:24 -0600
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Sun, 17 Jul 2016 10:01:54 -0300
> Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> 
> > 4) There are now several errors when parsing functions. Those seems to
> > happen when an argument is a function pointer, like:
> > 
> > /devel/v4l/patchwork/Documentation/media/kapi/v4l2-core.rst:757: WARNING: Error when parsing function declaration.
> > If the function has no return type:
> >   Error in declarator or parameters and qualifiers
> >   Invalid definition: Expected identifier in nested name, got keyword: int [error at 3]
> >     int v4l2_ctrl_add_handler (struct v4l2_ctrl_handler * hdl, struct v4l2_ctrl_handler * add, bool (*filter) (const struct v4l2_ctrl *ctrl)
> >     ---^  
> 
> So I've been trying to reproduce this one, without success; it seems to
> work for me.  As it should; the parsing code really should not have
> changed at all.  Is there some particular context in which this happens
> for you?

You could pull from my tree and see it yourself:
	git://linuxtv.org/media_tree.git docs-next

What I'm noticing is a series of problems when parsing some
function declarations. The number of warnings varies, depending
on the Sphinx version.

Basically, on all versions, it doesn't recognize arguments like:
	bool (*filter) (const struct v4l2_ctrl *ctrl)

(this comes from kernel-doc)

Sphinx itself doesn't even recognize arguments with "enum"
on versions 1.3.x or older. With enums, it will still add it to
the book. Just the cross-reference at the index won't appear.


Thanks,
Mauro
