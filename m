Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:50478 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751034AbdHaORW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 10:17:22 -0400
Date: Thu, 31 Aug 2017 08:17:21 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] docs: kernel-doc comments are ASCII
Message-ID: <20170831081721.38be05ef@lwn.net>
In-Reply-To: <20170831105602.5607fe52@vento.lan>
References: <54c23e8e-89c0-5cea-0dcc-e938952c5642@infradead.org>
        <20170830152314.0486fafb@lwn.net>
        <3390facf-69ae-ba18-8abe-09b5695a6b31@infradead.org>
        <20170831064941.1fb18d20@vento.lan>
        <87h8wn98bv.fsf@intel.com>
        <20170831105602.5607fe52@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 31 Aug 2017 10:56:26 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> It should have something to do with python version and/or to some
> locale info at the system, as neither I or Jon can reproduce it.

I can't reproduce it here, but I have certainly seen situations where
Python 2 wants to run with the ascii codec by default.

Note that the exception happens in our Sphinx extension, not in Sphinx
itself.  We've had other non-ascii text in our docs, so I think Sphinx is
doing the right thing.  The problem is with our own code.  If I could
reproduce it, it shouldn't be too hard to track down - take out that
massive "except anything" block and see where it explodes.

Randy, which distribution are you running, and are you using their version
of Sphinx?

Thanks,

jon
