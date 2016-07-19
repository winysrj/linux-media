Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:41615 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107AbcGSXa1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 19:30:27 -0400
Date: Tue, 19 Jul 2016 17:30:24 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>
Subject: Re: Troubles with kernel-doc and RST files
Message-ID: <20160719173024.5f98da1e@lwn.net>
In-Reply-To: <20160717100154.64823d99@recife.lan>
References: <20160717100154.64823d99@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 17 Jul 2016 10:01:54 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> 4) There are now several errors when parsing functions. Those seems to
> happen when an argument is a function pointer, like:
> 
> /devel/v4l/patchwork/Documentation/media/kapi/v4l2-core.rst:757: WARNING: Error when parsing function declaration.
> If the function has no return type:
>   Error in declarator or parameters and qualifiers
>   Invalid definition: Expected identifier in nested name, got keyword: int [error at 3]
>     int v4l2_ctrl_add_handler (struct v4l2_ctrl_handler * hdl, struct v4l2_ctrl_handler * add, bool (*filter) (const struct v4l2_ctrl *ctrl)
>     ---^

So I've been trying to reproduce this one, without success; it seems to
work for me.  As it should; the parsing code really should not have
changed at all.  Is there some particular context in which this happens
for you?

Thanks,

jon
