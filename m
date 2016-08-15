Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:46284 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbcHOVjO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 17:39:14 -0400
Date: Mon, 15 Aug 2016 15:39:12 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jani Nikula <jani.nikula@intel.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH 0/7] doc-rst: sphinx sub-folders & parseheaders
 directive
Message-ID: <20160815153912.10156aee@lwn.net>
In-Reply-To: <DCB8AFBC-2E5E-4CD0-97A0-9325686CE17F@darmarit.de>
References: <1471097568-25990-1-git-send-email-markus.heiser@darmarit.de>
	<20160814120920.62098dae@lwn.net>
	<DCB8AFBC-2E5E-4CD0-97A0-9325686CE17F@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 15 Aug 2016 10:21:07 +0200
Markus Heiser <markus.heiser@darmarit.de> wrote:

> Jonathan, we had this already, I gave you the links to "python community
> norms" and tools, please read/use them.
> 
> * https://www.python.org/dev/peps/pep-0008/
> * https://www.pylint.org/
> 
> Some of these norms might be unusual for C developers.

Markus, please.  I'm pretty well familiar with the Python language, have
read and written quite a bit of Python code, and understand the
conventions.  I don't need to be talked down to here.

I just reviewed PEP8.  Nothing I mentioned is sanctioned there; indeed, it
says to limit lines to 79 characters and no space before commas.

Please remember that, when you put code into the kernel, that code is no
longer in your own personal sandbox.  Other developers will have to look
at and understand it, and the community will have to maintain it long
after you have moved on to other things.  We should do everything we can
to make that code accessible to kernel folks, and that includes, IMO, not
flying in the face of the kernel's coding conventions.  

Happily, normal Python conventions don't actually look all that strange to
developers used to the kernel's style - at least to those who understand
Python!  There's no reason why we can't create Python code that looks fine
to Python programmers without putting off kernel developers.  It's not a
matter of "eye candy," it's a real maintenance issue, so could you please
humor me on this?

Thanks,

jon
