Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:36414 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751110AbdH3Wbl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Aug 2017 18:31:41 -0400
Date: Wed, 30 Aug 2017 16:31:39 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] docs: kernel-doc comments are ASCII
Message-ID: <20170830163139.1abf9baa@lwn.net>
In-Reply-To: <20170830191553.179a79d6@vento.lan>
References: <54c23e8e-89c0-5cea-0dcc-e938952c5642@infradead.org>
        <20170830152314.0486fafb@lwn.net>
        <3390facf-69ae-ba18-8abe-09b5695a6b31@infradead.org>
        <20170830191553.179a79d6@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 30 Aug 2017 19:15:53 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> I suspect that the problem is not related to the version, but to
> what you might have set on LANG.
> 
> Maybe if we add something like:
> 	LANG=C.utf-8
> 
> to the Documentation/Makefile 

That's worth a try; Randy, can you give it a quick go?

> or adding:
> 
> 	.. -*- coding: utf-8; mode: rst -*-
> 
> as the first line on the *.rst file that include the kernel-doc 
> directive would solve the issue.

I guess I don't see how that would help, instead.  Emacs reads that line,
but it's not involved in the problem.

I wish I could reproduce this, then we could see what in that massive
try..except block in kerneldoc.py is throwing the exception.  Putting in
an explicit decode call might be enough to make the problem go away.

Thanks,

jon
