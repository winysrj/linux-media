Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:35213 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbbJEK4l (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Oct 2015 06:56:41 -0400
Date: Mon, 5 Oct 2015 04:56:35 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-doc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: How to fix DocBook parsers for private fields inside #ifdefs
Message-ID: <20151005045635.455b20eb@lwn.net>
In-Reply-To: <20151001142107.5a0bf7b2@recife.lan>
References: <20151001142107.5a0bf7b2@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 1 Oct 2015 14:21:07 -0300
Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:

> They're all after a private comment:
> 	/* Private: internal use only */
> 
> So, according with Documentation/kernel-doc-nano-HOWTO.txt, they shold
> have been ignored.
> 
> Still, the scripts produce warnings for them:

Sorry, I've been away from the keyboard for a few days and am only now
catching up.

The problem is that kernel-doc is dumb...the test is case-sensitive, so
it needs to be "private:", not "Private:".  I'm sure there's a magic perl
regex parameter to make the test case-insensitive; when I get a chance
I'll figure it out and put it in there.

(Of course, once you fix that glitch, you'll get gripes about the fields
that are marked private but documented anyway.  Like I said, kernel-doc
is dumb.)

jon
